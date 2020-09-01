import 'dart:io';
import 'dart:typed_data';

import 'package:logging/logging.dart';
import 'package:min_tcp/proto/abridged.pb.dart';
import '../proto/abridged.pbenum.dart';
import 'operator.dart';

abstract class Transport extends EventEmitter {
  static final Logger _logger = Logger('socket_io_client:transport.Transport');
  String hostname;
  int port;
  bool secure;
  String readyState;
  Socket socket;
  bool writable;
  String name;

  Transport(Map opts) {
    hostname = opts['hostname'];
    port = opts['port'];
    secure = opts['secure'];
    readyState = '';
    socket = opts['socket'];
  }

  /// Emits an error.
  ///
  /// @param {String} str
  /// @return {Transport} for chaining
  /// @api public
  void onError(msg, [desc]) {
    if (hasListeners(OP.error)) {
      Proto p = new Proto();
      p.op = OP.error;
      emit(OP.error, p);
    } else {
      _logger.fine('ignored transport error $msg ($desc)');
    }
  }

  ///
  /// Opens the transport.
  ///
  /// @api public
  void open() {
    if ('closed' == readyState || '' == readyState) {
      readyState = 'opening';
      doOpen();
    }
  }

  ///
  /// Closes the transport.
  ///
  /// @api private
  void close() {
    if ('opening' == readyState || 'open' == readyState) {
      doClose();
      onClose();
    }
  }

  ///
  /// Sends multiple packets.
  ///
  /// @param {Array} packets
  /// @api private
  void send(List packets) {
    if ('open' == readyState) {
      write(packets);
    } else {
      throw StateError('Transport not open');
    }
  }

  ///
  /// Called upon open
  ///
  /// @api private
  void onOpen() {
    readyState = 'open';
    writable = true;
    emit(OP.open);
  }

  ///
  /// Called with data.
  ///
  /// @param {String} data
  /// @api private
  void onData(data) {
    onPacket(data);
  }

  ///
  /// Called with a decoded packet.
  void onPacket(Uint8List data) {
    ByteData dataBuffer = ByteData.view(data.buffer);
    int length = dataBuffer.getUint32(0);
    Proto p = Proto.fromBuffer(data.sublist(4,4+length));
    emit(OP.packet, p);
  }

  ///
  /// Called upon close.
  ///
  /// @api private
  void onClose() {
    readyState = 'closed';
    emit(OP.close);
  }

  void write(List data);
  void doOpen();
  void doClose();
}
