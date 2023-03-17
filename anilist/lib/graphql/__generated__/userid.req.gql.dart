// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:anilist/graphql/__generated__/serializers.gql.dart' as _i6;
import 'package:anilist/graphql/__generated__/userid.ast.gql.dart' as _i5;
import 'package:anilist/graphql/__generated__/userid.data.gql.dart' as _i2;
import 'package:anilist/graphql/__generated__/userid.var.gql.dart' as _i3;
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:ferry_exec/ferry_exec.dart' as _i1;
import 'package:gql_exec/gql_exec.dart' as _i4;

part 'userid.req.gql.g.dart';

abstract class GUserIDReq
    implements
        Built<GUserIDReq, GUserIDReqBuilder>,
        _i1.OperationRequest<_i2.GUserIDData, _i3.GUserIDVars> {
  GUserIDReq._();

  factory GUserIDReq([Function(GUserIDReqBuilder b) updates]) = _$GUserIDReq;

  static void _initializeBuilder(GUserIDReqBuilder b) => b
    ..operation = _i4.Operation(
      document: _i5.document,
      operationName: 'UserID',
    )
    ..executeOnListen = true;
  @override
  _i3.GUserIDVars get vars;
  @override
  _i4.Operation get operation;
  @override
  _i4.Request get execRequest => _i4.Request(
        operation: operation,
        variables: vars.toJson(),
      );
  @override
  String? get requestId;
  @override
  @BuiltValueField(serialize: false)
  _i2.GUserIDData? Function(
    _i2.GUserIDData?,
    _i2.GUserIDData?,
  )? get updateResult;
  @override
  _i2.GUserIDData? get optimisticResponse;
  @override
  String? get updateCacheHandlerKey;
  @override
  Map<String, dynamic>? get updateCacheHandlerContext;
  @override
  _i1.FetchPolicy? get fetchPolicy;
  @override
  bool get executeOnListen;
  @override
  _i2.GUserIDData? parseData(Map<String, dynamic> json) =>
      _i2.GUserIDData.fromJson(json);
  static Serializer<GUserIDReq> get serializer => _$gUserIDReqSerializer;
  Map<String, dynamic> toJson() => (_i6.serializers.serializeWith(
        GUserIDReq.serializer,
        this,
      ) as Map<String, dynamic>);
  static GUserIDReq? fromJson(Map<String, dynamic> json) =>
      _i6.serializers.deserializeWith(
        GUserIDReq.serializer,
        json,
      );
}
