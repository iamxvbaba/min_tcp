import 'package:logging/logging.dart';
import 'package:min_tcp/proto/abridged.pb.dart';
import 'package:min_tcp/proto/abridged.pbenum.dart';

import 'engine/operator.dart';
import './on.dart' as util;
import 'manager.dart';
///
/// Internal events (blacklisted).
/// These events can't be emitted by the user.
///
/// @api private
///

const List EVENTS = [
  OP.connect,
  OP.connect_error,
  OP.connect_timeout,
  OP.connecting,
  OP.disconnect,
  OP.error,
  OP.reconnect,
  OP.reconnect_attempt,
  OP.reconnect_failed,
  OP.reconnect_error,
  OP.reconnecting,
  OP.ping,
  OP.pong
];

final Logger _logger = Logger('min_tcp:Socket');

///
/// `Socket` constructor.
///
/// @api public
class Socket extends EventEmitter {
  String hostname;
  int port;
  Map opts;

  Manager io;
  Socket json;
  num ids;
  Map acks;
  bool connected;
  bool disconnected;
  List sendBuffer;
  List receiveBuffer;
  String query;
  List subs;
  Map flags;
  String id;

  Socket(this.io, this.hostname,this.port, this.opts) {
    json = this; // compat
    ids = 0;
    acks = {};
    receiveBuffer = [];
    sendBuffer = [];
    connected = false;
    disconnected = true;
    if (opts != null) {
      query = opts['query'];
    }
    if (io.autoConnect) open();
  }

  ///
  /// Subscribe to open, close and packet events
  ///
  /// @api private
  void subEvents() {
    if (subs?.isNotEmpty == true) return;

    var io = this.io;
    subs = [
      util.on(io, OP.open, onopen),
      util.on(io, OP.packet, onpacket),
      util.on(io, OP.close, onclose)
    ];
  }

  ///
  /// "Opens" the socket.
  ///
  /// @api public
  Socket open() => connect();

  Socket connect() {
    if (connected == true) return this;
    subEvents();
    io.open(); // ensure open
    if ('open' == io.readyState) onopen();
    emit(OP.connecting);
    return this;
  }

  ///
  /// Sends a `message` event.
  ///
  /// @return {Socket} self
  /// @api public
  Socket send(List args) {
    emit(OP.message, args);
    return this;
  }

  ///
  /// Override `emit`.
  /// If the event is in `events`, it's emitted normally.
  ///
  /// @param {String} event name
  /// @return {Socket} self
  /// @api public
  @override
  void emit(OP event, [data]) {
    emitWithAck(event, data);
  }

  /// Emits to this client.
  ///
  /// @return {Socket} self
  /// @api public
  void emitWithAck(OP event, dynamic data,
      {Function ack, bool binary = false}) {
    if (EVENTS.contains(event)) {
      super.emit(event, data);
    } else {
      var sendData = <dynamic>[event];
      sendData.add(data);

      var packet = {
        'data': sendData,
        'options': {}
      };

      // event ack callback
      if (ack != null) {
        _logger.fine('emitting packet with ack id $ids');
        acks['${ids}'] = ack;
        packet['id'] = '${ids++}';
      }

      if (connected == true) {
        this.packet(packet);
      } else {
        sendBuffer.add(packet);
      }
      flags = null;
    }
  }

  ///
  /// Sends a packet.
  ///
  /// @param {Object} packet
  /// @api private
  void packet(Map packet) {
    io.packet(packet);
  }

  ///
  /// Called upon engine `open`.
  ///
  /// @api private
  void onopen([_]) {
    _logger.fine('transport is open - connecting');
    // write connect packet if necessary
    Proto p = new Proto();
    p.op = OP.connect;
    packet({
      'type':OP.connect
    });
  }

  ///
  /// Called upon engine `close`.
  ///
  /// @param {String} reason
  /// @api private
  void onclose(reason) {
    _logger.fine('close ($reason)');
    emit(OP.disconnecting, reason);
    connected = false;
    disconnected = true;
    id = null;
    emit(OP.disconnect, reason);
  }

  ///
  /// Called with socket packet.
  ///
  /// @param {Object} packet
  /// @api private
  void onpacket(packet) {
    if (packet['nsp'] != hostname) return;

    switch (packet['type']) {
      case OP.connect:
        onconnect();
        break;

      //case EVENT:
        onevent(packet);
        break;

      //case BINARY_EVENT:
        onevent(packet);
        break;

      case OP.ack:
        onack(packet);
        break;

      //case BINARY_ACK:
        onack(packet);
        break;

      case OP.disconnect:
        ondisconnect();
        break;

      case OP.error:
        emit(OP.error, packet['data']);
        break;
    }
  }

  ///
  /// Called upon a server event.
  ///
  /// @param {Object} packet
  /// @api private
  void onevent(Map packet) {
    List args = packet['data'] ?? [];
//    debug('emitting event %j', args);

    if (null != packet['id']) {
//      debug('attaching ack callback to event');
      args.add(ack(packet['id']));
    }

    // dart doesn't support "String... rest" syntax.
    if (connected == true) {
      if (args.length > 2) {
        Function.apply(super.emit, [args.first, args.sublist(1)]);
      } else {
        Function.apply(super.emit, args);
      }
    } else {
      receiveBuffer.add(args);
    }
  }

  ///
  /// Produces an ack callback to emit with an event.
  ///
  /// @api private
  Function ack(id) {
    var sent = false;
    return (_) {
      // prevent double callbacks
      if (sent) return;
      sent = true;
      _logger.fine('sending ack $_');

      packet({
        'type': OP.ack,
        'id': id,
        'data': [_]
      });
    };
  }

  ///
  /// Called upon a server acknowlegement.
  ///
  /// @param {Object} packet
  /// @api private
  void onack(Map packet) {
    var ack = acks.remove(packet['id']);
    if (ack is Function) {
      _logger.fine('''calling ack ${packet['id']} with ${packet['data']}''');

      var args = packet['data'] as List;
      if (args.length > 1) {
        // Fix for #42 with nodejs server
        Function.apply(ack, [args]);
      } else {
        Function.apply(ack, args);
      }
    } else {
      _logger.fine('''bad ack ${packet['id']}''');
    }
  }

  ///
  /// Called upon server connect.
  ///
  /// @api private
  void onconnect() {
    connected = true;
    disconnected = false;
    emit(OP.connect);
    emitBuffered();
  }

  ///
  /// Emit buffered events (received and emitted).
  ///
  /// @api private
  void emitBuffered() {
    var i;
    for (i = 0; i < receiveBuffer.length; i++) {
      List args = receiveBuffer[i];
      if (args.length > 2) {
        Function.apply(super.emit, [args.first, args.sublist(1)]);
      } else {
        Function.apply(super.emit, args);
      }
    }
    receiveBuffer = [];

    for (i = 0; i < sendBuffer.length; i++) {
      packet(sendBuffer[i]);
    }
    sendBuffer = [];
  }

  ///
  /// Called upon server disconnect.
  ///
  /// @api private
  void ondisconnect() {
    _logger.fine('server disconnect (${hostname})');
    destroy();
    onclose('io server disconnect');
  }

  ///
  /// Called upon forced client/server side disconnections,
  /// this method ensures the manager stops tracking us and
  /// that reconnections don't get triggered for this.
  ///
  /// @api private.

  void destroy() {
    if (subs?.isNotEmpty == true) {
      // clean subscriptions to avoid reconnections
      for (var i = 0; i < subs.length; i++) {
        subs[i].destroy();
      }
      subs = null;
    }

    io.destroy(this);
  }

  ///
  /// Disconnects the socket manually.
  ///
  /// @return {Socket} self
  /// @api public
  Socket close() => disconnect();

  Socket disconnect() {
    if (connected == true) {
      _logger.fine('performing disconnect (${hostname})');
      packet({'type': OP.disconnect});
    }

    // remove socket from pool
    destroy();

    if (connected == true) {
      // fire events
      onclose('io client disconnect');
    }
    return this;
  }

  /// Disposes the socket manually which will destroy, close, disconnect the socket connection
  /// and clear all the event listeners. Unlike [close] or [disconnect] which won't clear
  /// all the event listeners
  ///
  /// @since 0.9.11
  void dispose() {
    disconnect();
    clearListeners();
  }

  ///
  /// Sets the compress flag.
  ///
  /// @param {Boolean} if `true`, compresses the sending data
  /// @return {Socket} self
  /// @api public
  Socket compress(compress) {
    flags = flags ??= {};
    flags['compress'] = compress;
    return this;
  }
}
