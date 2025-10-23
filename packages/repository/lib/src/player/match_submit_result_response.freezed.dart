// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match_submit_result_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MatchSubmitResultResponse {

/// 結果詳細。
 MatchResult get result;
/// Create a copy of MatchSubmitResultResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchSubmitResultResponseCopyWith<MatchSubmitResultResponse> get copyWith => _$MatchSubmitResultResponseCopyWithImpl<MatchSubmitResultResponse>(this as MatchSubmitResultResponse, _$identity);

  /// Serializes this MatchSubmitResultResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchSubmitResultResponse&&(identical(other.result, result) || other.result == result));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,result);

@override
String toString() {
  return 'MatchSubmitResultResponse(result: $result)';
}


}

/// @nodoc
abstract mixin class $MatchSubmitResultResponseCopyWith<$Res>  {
  factory $MatchSubmitResultResponseCopyWith(MatchSubmitResultResponse value, $Res Function(MatchSubmitResultResponse) _then) = _$MatchSubmitResultResponseCopyWithImpl;
@useResult
$Res call({
 MatchResult result
});


$MatchResultCopyWith<$Res> get result;

}
/// @nodoc
class _$MatchSubmitResultResponseCopyWithImpl<$Res>
    implements $MatchSubmitResultResponseCopyWith<$Res> {
  _$MatchSubmitResultResponseCopyWithImpl(this._self, this._then);

  final MatchSubmitResultResponse _self;
  final $Res Function(MatchSubmitResultResponse) _then;

/// Create a copy of MatchSubmitResultResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? result = null,}) {
  return _then(_self.copyWith(
result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as MatchResult,
  ));
}
/// Create a copy of MatchSubmitResultResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MatchResultCopyWith<$Res> get result {
  
  return $MatchResultCopyWith<$Res>(_self.result, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _MatchSubmitResultResponse implements MatchSubmitResultResponse {
  const _MatchSubmitResultResponse({required this.result});
  factory _MatchSubmitResultResponse.fromJson(Map<String, dynamic> json) => _$MatchSubmitResultResponseFromJson(json);

/// 結果詳細。
@override final  MatchResult result;

/// Create a copy of MatchSubmitResultResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatchSubmitResultResponseCopyWith<_MatchSubmitResultResponse> get copyWith => __$MatchSubmitResultResponseCopyWithImpl<_MatchSubmitResultResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MatchSubmitResultResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MatchSubmitResultResponse&&(identical(other.result, result) || other.result == result));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,result);

@override
String toString() {
  return 'MatchSubmitResultResponse(result: $result)';
}


}

/// @nodoc
abstract mixin class _$MatchSubmitResultResponseCopyWith<$Res> implements $MatchSubmitResultResponseCopyWith<$Res> {
  factory _$MatchSubmitResultResponseCopyWith(_MatchSubmitResultResponse value, $Res Function(_MatchSubmitResultResponse) _then) = __$MatchSubmitResultResponseCopyWithImpl;
@override @useResult
$Res call({
 MatchResult result
});


@override $MatchResultCopyWith<$Res> get result;

}
/// @nodoc
class __$MatchSubmitResultResponseCopyWithImpl<$Res>
    implements _$MatchSubmitResultResponseCopyWith<$Res> {
  __$MatchSubmitResultResponseCopyWithImpl(this._self, this._then);

  final _MatchSubmitResultResponse _self;
  final $Res Function(_MatchSubmitResultResponse) _then;

/// Create a copy of MatchSubmitResultResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? result = null,}) {
  return _then(_MatchSubmitResultResponse(
result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as MatchResult,
  ));
}

/// Create a copy of MatchSubmitResultResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MatchResultCopyWith<$Res> get result {
  
  return $MatchResultCopyWith<$Res>(_self.result, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}


/// @nodoc
mixin _$MatchResult {

/// 結果タイプ。
 String get type;/// 勝者のプレイヤー ID。
 String get winnerId;/// 送信日時。
 String get submittedAt;/// 送信したプレイヤー ID。
 String get submittedBy;/// 送信者のユーザー ID。
 String get submitterUserId;
/// Create a copy of MatchResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchResultCopyWith<MatchResult> get copyWith => _$MatchResultCopyWithImpl<MatchResult>(this as MatchResult, _$identity);

  /// Serializes this MatchResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchResult&&(identical(other.type, type) || other.type == type)&&(identical(other.winnerId, winnerId) || other.winnerId == winnerId)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.submittedBy, submittedBy) || other.submittedBy == submittedBy)&&(identical(other.submitterUserId, submitterUserId) || other.submitterUserId == submitterUserId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,winnerId,submittedAt,submittedBy,submitterUserId);

@override
String toString() {
  return 'MatchResult(type: $type, winnerId: $winnerId, submittedAt: $submittedAt, submittedBy: $submittedBy, submitterUserId: $submitterUserId)';
}


}

/// @nodoc
abstract mixin class $MatchResultCopyWith<$Res>  {
  factory $MatchResultCopyWith(MatchResult value, $Res Function(MatchResult) _then) = _$MatchResultCopyWithImpl;
@useResult
$Res call({
 String type, String winnerId, String submittedAt, String submittedBy, String submitterUserId
});




}
/// @nodoc
class _$MatchResultCopyWithImpl<$Res>
    implements $MatchResultCopyWith<$Res> {
  _$MatchResultCopyWithImpl(this._self, this._then);

  final MatchResult _self;
  final $Res Function(MatchResult) _then;

/// Create a copy of MatchResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? winnerId = null,Object? submittedAt = null,Object? submittedBy = null,Object? submitterUserId = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,winnerId: null == winnerId ? _self.winnerId : winnerId // ignore: cast_nullable_to_non_nullable
as String,submittedAt: null == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as String,submittedBy: null == submittedBy ? _self.submittedBy : submittedBy // ignore: cast_nullable_to_non_nullable
as String,submitterUserId: null == submitterUserId ? _self.submitterUserId : submitterUserId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _MatchResult implements MatchResult {
  const _MatchResult({required this.type, required this.winnerId, required this.submittedAt, required this.submittedBy, required this.submitterUserId});
  factory _MatchResult.fromJson(Map<String, dynamic> json) => _$MatchResultFromJson(json);

/// 結果タイプ。
@override final  String type;
/// 勝者のプレイヤー ID。
@override final  String winnerId;
/// 送信日時。
@override final  String submittedAt;
/// 送信したプレイヤー ID。
@override final  String submittedBy;
/// 送信者のユーザー ID。
@override final  String submitterUserId;

/// Create a copy of MatchResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatchResultCopyWith<_MatchResult> get copyWith => __$MatchResultCopyWithImpl<_MatchResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MatchResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MatchResult&&(identical(other.type, type) || other.type == type)&&(identical(other.winnerId, winnerId) || other.winnerId == winnerId)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.submittedBy, submittedBy) || other.submittedBy == submittedBy)&&(identical(other.submitterUserId, submitterUserId) || other.submitterUserId == submitterUserId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,winnerId,submittedAt,submittedBy,submitterUserId);

@override
String toString() {
  return 'MatchResult(type: $type, winnerId: $winnerId, submittedAt: $submittedAt, submittedBy: $submittedBy, submitterUserId: $submitterUserId)';
}


}

/// @nodoc
abstract mixin class _$MatchResultCopyWith<$Res> implements $MatchResultCopyWith<$Res> {
  factory _$MatchResultCopyWith(_MatchResult value, $Res Function(_MatchResult) _then) = __$MatchResultCopyWithImpl;
@override @useResult
$Res call({
 String type, String winnerId, String submittedAt, String submittedBy, String submitterUserId
});




}
/// @nodoc
class __$MatchResultCopyWithImpl<$Res>
    implements _$MatchResultCopyWith<$Res> {
  __$MatchResultCopyWithImpl(this._self, this._then);

  final _MatchResult _self;
  final $Res Function(_MatchResult) _then;

/// Create a copy of MatchResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? winnerId = null,Object? submittedAt = null,Object? submittedBy = null,Object? submitterUserId = null,}) {
  return _then(_MatchResult(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,winnerId: null == winnerId ? _self.winnerId : winnerId // ignore: cast_nullable_to_non_nullable
as String,submittedAt: null == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as String,submittedBy: null == submittedBy ? _self.submittedBy : submittedBy // ignore: cast_nullable_to_non_nullable
as String,submitterUserId: null == submitterUserId ? _self.submitterUserId : submitterUserId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
