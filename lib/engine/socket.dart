import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:logging/logging.dart';
import 'package:min_tcp/engine/tcp_transport.dart';
import 'package:min_tcp/engine/transport.dart';
import '../proto/abridged.pb.dart';
import '../proto/abridged.pbenum.dart';
import 'operator.dart';

final Logger _logger = Logger('min_tcp:engine.Socket');

///
/// Socket constructor.
///
/// @param {String|Object} uri or options
/// @param {Object} options
/// @api public
///
class Socket extends EventEmitter {
  Map opts;
  bool secure;
  String hostname;
  int port;
  String timestampParam;
  var timestampRequests;

  String readyState;
  List writeBuffer;
  int prevBufferLen;
  var binaryType;
  String id;
  int pingInterval;
  int pingTimeout;
  Timer pingIntervalTimer;
  Timer pingTimeoutTimer;
  int requestTimeout;
  Transport transport;
  bool supportsBinary;

  Socket(this.hostname,this.port, this.opts) {
    open();
  }

  /// Creates transport of the given type.
  ///
  /// @param {String} transport name
  /// @return {Transport}
  /// @api private
  Transport createTransport(name) {
    _logger.fine('creating transport "$name"');
    // per-transport options

    Transport transport = new TcpTransport({
      "hostname": this.hostname,
      "port": this.port,
    });

    return transport;
  }

  ///
  /// Initializes transport to use and starts probe.
  ///
  /// @api private
  void open() {
    Transport transport;
    readyState = 'opening';
    transport = createTransport("tcp");
    transport.open();
    setTransport(transport);
  }

  ///
  /// Sets the current transport. Disables the existing one (if any).
  ///
  /// @api private
  void setTransport(transport) {
    _logger.fine('setting transport ${transport?.name}');

    if (this.transport != null) {
      _logger.fine('clearing existing transport ${this.transport?.name}');
      this.transport.clearListeners();
    }

    // set up transport
    this.transport = transport;

    // set up transport listeners
    transport
      ..on(OP.drain, (_) => onDrain())
      ..on(OP.packet, (packet) => onPacket(packet))
      ..on(OP.error, (e) => onError(e))
      ..on(OP.close, (_) => onClose('transport close'));
  }
  ///
  /// Called on `drain` event
  ///
  /// @api private
  void onDrain() {
    writeBuffer.removeRange(0, prevBufferLen);

    // setting prevBufferLen = 0 is very important
    // for example, when upgrading, upgrade packet is sent over,
    // and a nonzero prevBufferLen could cause problems on `drain`
    prevBufferLen = 0;

    if (writeBuffer.isEmpty) {
      emit(OP.drain);
    } else {
      flush();
    }
  }

  ///
  /// Called when connection is deemed open.
  ///
  /// @api public
  void onOpen() {
    _logger.fine('socket open');
    readyState = 'open';
    emit(OP.open);
    flush();
  }

  /// Handles a packet.
  void onPacket(Map packet) {
    if ('opening' == readyState ||
        'open' == readyState ||
        'closing' == readyState) {
      var type = packet['type'];
      var data = packet['data'];
      _logger.fine('socket receive: type "$type", data "$data"');

      emit(OP.packet, packet);

      // Socket is live - any packet counts
      emit(OP.heartbeat);

      switch (type) {
        case OP.open:
          onHandshake(json.decode(data ?? 'null'));
          break;

        case OP.pong:
          setPing();
          emit(OP.pong);
          break;

        case OP.error:
          onError({'error': 'server error', 'code': data});
          break;

        case OP.message:
          emit(OP.data, data);
          emit(OP.message, data);
          break;
      }
    } else {
      _logger.fine('packet received with socket readyState "$readyState"');
    }
  }

  ///
  /// Called upon handshake completion.
  ///
  /// @param {Object} handshake obj
  /// @api private
  void onHandshake(Map data) {
    emit(OP.handshake, data);
    id = data['sid'];
    pingInterval = data['pingInterval'];
    pingTimeout = data['pingTimeout'];
    onOpen();
    // In case open handler closes socket
    if ('closed' == readyState) return;
    setPing();

    // Prolong liveness of socket on heartbeat
    off(OP.heartbeat, onHeartbeat);
    on(OP.heartbeat, onHeartbeat);
  }

  ///
  /// Resets ping timeout.
  ///
  /// @api private
  void onHeartbeat(timeout) {
    pingTimeoutTimer?.cancel();
    pingTimeoutTimer = Timer(
        Duration(milliseconds: timeout ?? (pingInterval + pingTimeout)), () {
      if ('closed' == readyState) return;
      onClose('ping timeout');
    });
  }

  ///
  /// Pings server every `this.pingInterval` and expects response
  /// within `this.pingTimeout` or closes connection.
  ///
  /// @api private
  void setPing() {
    pingIntervalTimer?.cancel();
    pingIntervalTimer = Timer(Duration(milliseconds: pingInterval), () {
      _logger
          .fine('writing ping packet - expecting pong within ${pingTimeout}ms');
      ping();
      onHeartbeat(pingTimeout);
    });
  }

  ///
  /// Sends a ping packet.
  ///
  /// @api private
  void ping() {
    Proto p = new Proto();
    p.op = OP.ping;
    sendPacket(p: p, callback: (_) => emit(OP.ping));
  }


  ///
  /// Flush write buffers.
  ///
  /// @api private
  void flush() {
    if ('closed' != readyState &&
        transport.writable == true &&
        writeBuffer.isNotEmpty) {
      _logger.fine('flushing ${writeBuffer.length} packets in socket');
      transport.send(writeBuffer);
      // keep track of current length of writeBuffer
      // splice writeBuffer and callbackBuffer on `drain`
      prevBufferLen = writeBuffer.length;
      emit(OP.flush);
    }
  }

  ///
  /// Sends a message.
  ///
  /// @param {String} message.
  /// @param {Function} callback function.
  /// @param {Object} options.
  /// @return {Socket} for chaining.
  /// @api public
  Socket write(msg, options, [EventHandler fn]) => send(msg, options, fn);

  Socket send(msg, options, [EventHandler fn]) {
    Proto p = new Proto();
    //
    sendPacket(p: p, callback: fn);
    return this;
  }

  ///
  /// Sends a packet.
  ///
  /// @param {String} packet type.
  /// @param {String} data.
  /// @param {Object} options.
  /// @param {Function} callback function.
  /// @api private
  void sendPacket({Proto p, EventHandler callback}) {
    if ('closing' == readyState || 'closed' == readyState) {
      return;
    }
    Uint8List dataByte = p.writeToBuffer();
    ByteData lengthSizeBuf = new ByteData(4);
    lengthSizeBuf.setUint32(0, dataByte.lengthInBytes); // 数据长度
    // 转化为[]byte发送
    List data = lengthSizeBuf.buffer.asUint8List() + dataByte.buffer.asUint8List();

    emit(OP.packetCreate, data);
    writeBuffer.add(data);
    if (callback != null) once(OP.flush, callback);
    flush();
  }

  ///
  /// Closes the connection.
  ///
  /// @api private
  Socket close() {
    var close = () {
      onClose('forced close');
      _logger.fine('socket closing - telling transport to close');
      transport.close();
    };
    return this;
  }

  ///
  /// Called upon transport error
  ///
  /// @api private
  void onError(err) {
    _logger.fine('socket error $err');
    emit(OP.error, err);
    onClose('transport error', err);
  }

  ///
  /// Called upon transport close.
  ///
  /// @api private
  void onClose(reason, [desc]) {
    if ('opening' == readyState ||
        'open' == readyState ||
        'closing' == readyState) {
      _logger.fine('socket close with reason: "$reason"');

      // clear timers
      pingIntervalTimer?.cancel();
      pingTimeoutTimer?.cancel();

      // stop event from firing again for transport
      transport.off(OP.close);

      // ensure transport won't stay open
      transport.close();

      // ignore further transport communication
      transport.clearListeners();

      // set ready state
      readyState = 'closed';

      // clear session id
      id = null;

      // emit close event
      emit(OP.close, {'reason': reason, 'desc': desc});

      // clean buffers after, so users can still
      // grab the buffers on `close` event
      writeBuffer = [];
      prevBufferLen = 0;
    }
  }
}
