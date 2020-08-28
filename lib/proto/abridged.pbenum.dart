///
//  Generated code. Do not modify.
//  source: abridged.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class OP extends $pb.ProtobufEnum {
  static const OP error = OP._(0, 'error');
  static const OP open = OP._(1, 'open');
  static const OP packet = OP._(2, 'packet');
  static const OP close = OP._(3, 'close');
  static const OP heartbeat = OP._(4, 'heartbeat');
  static const OP ack = OP._(5, 'ack');
  static const OP message = OP._(7, 'message');
  static const OP data = OP._(8, 'data');
  static const OP handshake = OP._(9, 'handshake');
  static const OP flush = OP._(10, 'flush');
  static const OP packetCreate = OP._(11, 'packetCreate');
  static const OP drain = OP._(12, 'drain');
  static const OP connect = OP._(13, 'connect');
  static const OP connect_error = OP._(14, 'connect_error');
  static const OP connect_timeout = OP._(15, 'connect_timeout');
  static const OP connecting = OP._(16, 'connecting');
  static const OP disconnect = OP._(17, 'disconnect');
  static const OP reconnect = OP._(18, 'reconnect');
  static const OP reconnect_attempt = OP._(19, 'reconnect_attempt');
  static const OP reconnect_failed = OP._(20, 'reconnect_failed');
  static const OP reconnect_error = OP._(21, 'reconnect_error');
  static const OP reconnecting = OP._(22, 'reconnecting');
  static const OP disconnecting = OP._(23, 'disconnecting');
  static const OP ping = OP._(24, 'ping');
  static const OP pong = OP._(25, 'pong');
  static const OP reqPQ = OP._(101, 'reqPQ');
  static const OP resPQ = OP._(102, 'resPQ');
  static const OP reqDHParams = OP._(103, 'reqDHParams');
  static const OP resDHParamsOK = OP._(104, 'resDHParamsOK');
  static const OP clientDHParams = OP._(105, 'clientDHParams');
  static const OP dhGenResult = OP._(106, 'dhGenResult');

  static const $core.List<OP> values = <OP> [
    error,
    open,
    packet,
    close,
    heartbeat,
    ack,
    message,
    data,
    handshake,
    flush,
    packetCreate,
    drain,
    connect,
    connect_error,
    connect_timeout,
    connecting,
    disconnect,
    reconnect,
    reconnect_attempt,
    reconnect_failed,
    reconnect_error,
    reconnecting,
    disconnecting,
    ping,
    pong,
    reqPQ,
    resPQ,
    reqDHParams,
    resDHParamsOK,
    clientDHParams,
    dhGenResult,
  ];

  static final $core.Map<$core.int, OP> _byValue = $pb.ProtobufEnum.initByValue(values);
  static OP valueOf($core.int value) => _byValue[value];

  const OP._($core.int v, $core.String n) : super(v, n);
}

