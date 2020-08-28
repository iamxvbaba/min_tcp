import 'dart:io';

import 'package:logging/logging.dart';
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
      emit(OP.error, {'msg': msg, 'desc': desc, 'type': 'TransportError'});
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
  void onPacket(packet) {
    emit(OP.packet, packet);
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
