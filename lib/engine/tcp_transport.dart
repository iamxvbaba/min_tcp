// Copyright (C) 2017 Potix Corporation. All Rights Reserved
// History: 26/04/2017
// Author: jumperchen<jumperchen@potix.com>

import 'dart:async';
import 'dart:io';
import 'package:logging/logging.dart';
import 'package:min_tcp/engine/transport.dart';

import '../proto/abridged.pbenum.dart';


class TcpTransport extends Transport {
  static final Logger _logger =
  Logger('socket_io_client:transport.WebSocketTransport');

  @override
  String name = 'tcp';
  Socket _socket;


  TcpTransport(Map opts) : super(opts);

  @override
  void doOpen() {
    print("this.hostname:${this.hostname},this.port:${this.port}");

    Socket.connect(this.hostname,this.port).then((Socket sock) {
      this.socket = sock;
      addEventListeners();
    }).catchError((e) {
      onError(e);
    });
  }

  /// Adds event listeners to the socket
  ///
  /// @api private
  void addEventListeners() {
    _socket.listen((data) =>onData(data));
    _socket.handleError((e){
      onError('tcp error:$e');
    });
  }

  /// Writes data to socket.
  ///
  /// @param {Array} array of packets.
  /// @api private
  @override
  void write(List packets) {
    writable = false;
    var done = () {
      emit(OP.flush);
      // fake drain
      // defer to next tick to allow Socket to clear writeBuffer
      Timer.run(() {
        writable = true;
        emit(OP.drain);
      });
    };
    _socket.add(packets);
  }

  /// Closes socket.
  ///
  /// @api private
  @override
  void doClose() {
    _socket?.close();
  }
}
