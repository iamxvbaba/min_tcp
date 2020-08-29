///
//  Generated code. Do not modify.
//  source: abridged.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'abridged.pbenum.dart';

export 'abridged.pbenum.dart';

class Proto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Proto', package: const $pb.PackageName('api'), createEmptyInstance: create)
    ..a<$core.int>(1, 'from', $pb.PbFieldType.OU3)
    ..e<OP>(2, 'op', $pb.PbFieldType.OE, defaultOrMaker: OP.error, valueOf: OP.valueOf, enumValues: OP.values)
    ..aInt64(3, 'seq')
    ..a<$core.List<$core.int>>(4, 'data', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(5, 'AuthKeyHash', $pb.PbFieldType.OY, protoName: 'AuthKeyHash')
    ..a<$core.int>(6, 'pingInterval', $pb.PbFieldType.O3, protoName: 'pingInterval')
    ..a<$core.int>(7, 'pingTimeout', $pb.PbFieldType.O3, protoName: 'pingTimeout')
    ..hasRequiredFields = false
  ;

  Proto._() : super();
  factory Proto() => create();
  factory Proto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Proto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  Proto clone() => Proto()..mergeFromMessage(this);
  Proto copyWith(void Function(Proto) updates) => super.copyWith((message) => updates(message as Proto));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Proto create() => Proto._();
  Proto createEmptyInstance() => create();
  static $pb.PbList<Proto> createRepeated() => $pb.PbList<Proto>();
  @$core.pragma('dart2js:noInline')
  static Proto getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Proto>(create);
  static Proto _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get from => $_getIZ(0);
  @$pb.TagNumber(1)
  set from($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFrom() => $_has(0);
  @$pb.TagNumber(1)
  void clearFrom() => clearField(1);

  @$pb.TagNumber(2)
  OP get op => $_getN(1);
  @$pb.TagNumber(2)
  set op(OP v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasOp() => $_has(1);
  @$pb.TagNumber(2)
  void clearOp() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get seq => $_getI64(2);
  @$pb.TagNumber(3)
  set seq($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSeq() => $_has(2);
  @$pb.TagNumber(3)
  void clearSeq() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get data => $_getN(3);
  @$pb.TagNumber(4)
  set data($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasData() => $_has(3);
  @$pb.TagNumber(4)
  void clearData() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get authKeyHash => $_getN(4);
  @$pb.TagNumber(5)
  set authKeyHash($core.List<$core.int> v) { $_setBytes(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasAuthKeyHash() => $_has(4);
  @$pb.TagNumber(5)
  void clearAuthKeyHash() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get pingInterval => $_getIZ(5);
  @$pb.TagNumber(6)
  set pingInterval($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPingInterval() => $_has(5);
  @$pb.TagNumber(6)
  void clearPingInterval() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get pingTimeout => $_getIZ(6);
  @$pb.TagNumber(7)
  set pingTimeout($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasPingTimeout() => $_has(6);
  @$pb.TagNumber(7)
  void clearPingTimeout() => clearField(7);
}

class Response extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Response', package: const $pb.PackageName('api'), createEmptyInstance: create)
    ..a<$core.int>(1, 'code', $pb.PbFieldType.O3)
    ..aOS(2, 'msg')
    ..a<$core.List<$core.int>>(3, 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  Response._() : super();
  factory Response() => create();
  factory Response.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Response.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  Response clone() => Response()..mergeFromMessage(this);
  Response copyWith(void Function(Response) updates) => super.copyWith((message) => updates(message as Response));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Response create() => Response._();
  Response createEmptyInstance() => create();
  static $pb.PbList<Response> createRepeated() => $pb.PbList<Response>();
  @$core.pragma('dart2js:noInline')
  static Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Response>(create);
  static Response _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get code => $_getIZ(0);
  @$pb.TagNumber(1)
  set code($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get msg => $_getSZ(1);
  @$pb.TagNumber(2)
  set msg($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMsg() => $_has(1);
  @$pb.TagNumber(2)
  void clearMsg() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get data => $_getN(2);
  @$pb.TagNumber(3)
  set data($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasData() => $_has(2);
  @$pb.TagNumber(3)
  void clearData() => clearField(3);
}

class ID extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ID', package: const $pb.PackageName('api'), createEmptyInstance: create)
    ..p<$fixnum.Int64>(1, 'ids', $pb.PbFieldType.P6)
    ..hasRequiredFields = false
  ;

  ID._() : super();
  factory ID() => create();
  factory ID.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ID.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  ID clone() => ID()..mergeFromMessage(this);
  ID copyWith(void Function(ID) updates) => super.copyWith((message) => updates(message as ID));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ID create() => ID._();
  ID createEmptyInstance() => create();
  static $pb.PbList<ID> createRepeated() => $pb.PbList<ID>();
  @$core.pragma('dart2js:noInline')
  static ID getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ID>(create);
  static ID _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$fixnum.Int64> get ids => $_getList(0);
}

