// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match_submit_result_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MatchSubmitResultRequest {

/// 結果タイプ。
/// PLAYER1_WIN, PLAYER2_WIN, DRAW, BOTH_LOSS, NO_SHOW, BYE
 String get type;/// 勝者のプレイヤー ID。
 String get winnerId;/// ユーザー ID（本人確認用）。
 String get userId;
/// Create a copy of MatchSubmitResultRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchSubmitResultRequestCopyWith<MatchSubmitResultRequest> get copyWith => _$MatchSubmitResultRequestCopyWithImpl<MatchSubmitResultRequest>(this as MatchSubmitResultRequest, _$identity);

  /// Serializes this MatchSubmitResultRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchSubmitResultRequest&&(identical(other.type, type) || other.type == type)&&(identical(other.winnerId, winnerId) || other.winnerId == winnerId)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,winnerId,userId);

@override
String toString() {
  return 'MatchSubmitResultRequest(type: $type, winnerId: $winnerId, userId: $userId)';
}


}

/// @nodoc
abstract mixin class $MatchSubmitResultRequestCopyWith<$Res>  {
  factory $MatchSubmitResultRequestCopyWith(MatchSubmitResultRequest value, $Res Function(MatchSubmitResultRequest) _then) = _$MatchSubmitResultRequestCopyWithImpl;
@useResult
$Res call({
 String type, String winnerId, String userId
});




}
/// @nodoc
class _$MatchSubmitResultRequestCopyWithImpl<$Res>
    implements $MatchSubmitResultRequestCopyWith<$Res> {
  _$MatchSubmitResultRequestCopyWithImpl(this._self, this._then);

  final MatchSubmitResultRequest _self;
  final $Res Function(MatchSubmitResultRequest) _then;

/// Create a copy of MatchSubmitResultRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? winnerId = null,Object? userId = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,winnerId: null == winnerId ? _self.winnerId : winnerId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _MatchSubmitResultRequest implements MatchSubmitResultRequest {
  const _MatchSubmitResultRequest({required this.type, required this.winnerId, required this.userId});
  factory _MatchSubmitResultRequest.fromJson(Map<String, dynamic> json) => _$MatchSubmitResultRequestFromJson(json);

/// 結果タイプ。
/// PLAYER1_WIN, PLAYER2_WIN, DRAW, BOTH_LOSS, NO_SHOW, BYE
@override final  String type;
/// 勝者のプレイヤー ID。
@override final  String winnerId;
/// ユーザー ID（本人確認用）。
@override final  String userId;

/// Create a copy of MatchSubmitResultRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatchSubmitResultRequestCopyWith<_MatchSubmitResultRequest> get copyWith => __$MatchSubmitResultRequestCopyWithImpl<_MatchSubmitResultRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MatchSubmitResultRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MatchSubmitResultRequest&&(identical(other.type, type) || other.type == type)&&(identical(other.winnerId, winnerId) || other.winnerId == winnerId)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,winnerId,userId);

@override
String toString() {
  return 'MatchSubmitResultRequest(type: $type, winnerId: $winnerId, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$MatchSubmitResultRequestCopyWith<$Res> implements $MatchSubmitResultRequestCopyWith<$Res> {
  factory _$MatchSubmitResultRequestCopyWith(_MatchSubmitResultRequest value, $Res Function(_MatchSubmitResultRequest) _then) = __$MatchSubmitResultRequestCopyWithImpl;
@override @useResult
$Res call({
 String type, String winnerId, String userId
});




}
/// @nodoc
class __$MatchSubmitResultRequestCopyWithImpl<$Res>
    implements _$MatchSubmitResultRequestCopyWith<$Res> {
  __$MatchSubmitResultRequestCopyWithImpl(this._self, this._then);

  final _MatchSubmitResultRequest _self;
  final $Res Function(_MatchSubmitResultRequest) _then;

/// Create a copy of MatchSubmitResultRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? winnerId = null,Object? userId = null,}) {
  return _then(_MatchSubmitResultRequest(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,winnerId: null == winnerId ? _self.winnerId : winnerId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
