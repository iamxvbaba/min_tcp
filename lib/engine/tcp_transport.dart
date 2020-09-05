// Copyright (C) 2017 Potix Corporation. All Rights Reserved
// History: 26/04/2017
// Author: jumperchen<jumperchen@potix.com>

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:logging/logging.dart';
import 'package:min_tcp/engine/transport.dart';
import 'package:min_tcp/proto/abridged.pb.dart';

import '../proto/abridged.pbenum.dart';

class TcpTransport extends Transport {
  static final Logger _logger = Logger('min_tcp:transport.TCPTransport');

  @override
  String name = 'tcp';
  Socket _socket;

  TcpTransport(Map opts) : super(opts);

  @override
  void doOpen() {
    print("this.hostname:${this.hostname},this.port:${this.port}");

    Socket.connect(this.hostname, this.port).then((Socket sock) {
      this._socket = sock;
      //首次必须先发送 0xaa
      firstByte();
      addEventListeners();

      // emit open
      Proto p = new Proto();
      p.op = OP.open;
      emit(OP.packet,p);
    }).catchError((e) {
      onError(e);
      print("cnm!!!!!!! 1 e:$e");
    });
  }

// connect after first byte
  void firstByte() {
    var message = Uint8List(1);
    var bytedata = ByteData.view(message.buffer);
    bytedata.setUint8(0, 0xaa);
    _socket.add(message);
  }

  /// Adds event listeners to the socket
  ///
  /// @api private
  void addEventListeners() {
    onOpen();
    this._socket.listen((data) => onData(data));
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
    this._socket.add(packets);
    done();
  }

  /// Closes socket.
  ///
  /// @api private
  @override
  void doClose() {
    print("=====close=====");
    this._socket?.close();
  }
}
