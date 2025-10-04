// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_auth_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlayerAuthRequest {

/// 大会 ID。
 String get tournamentId;/// ユーザー ID（UUID v4）。
 String get userId;
/// Create a copy of PlayerAuthRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerAuthRequestCopyWith<PlayerAuthRequest> get copyWith => _$PlayerAuthRequestCopyWithImpl<PlayerAuthRequest>(this as PlayerAuthRequest, _$identity);

  /// Serializes this PlayerAuthRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerAuthRequest&&(identical(other.tournamentId, tournamentId) || other.tournamentId == tournamentId)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tournamentId,userId);

@override
String toString() {
  return 'PlayerAuthRequest(tournamentId: $tournamentId, userId: $userId)';
}


}

/// @nodoc
abstract mixin class $PlayerAuthRequestCopyWith<$Res>  {
  factory $PlayerAuthRequestCopyWith(PlayerAuthRequest value, $Res Function(PlayerAuthRequest) _then) = _$PlayerAuthRequestCopyWithImpl;
@useResult
$Res call({
 String tournamentId, String userId
});




}
/// @nodoc
class _$PlayerAuthRequestCopyWithImpl<$Res>
    implements $PlayerAuthRequestCopyWith<$Res> {
  _$PlayerAuthRequestCopyWithImpl(this._self, this._then);

  final PlayerAuthRequest _self;
  final $Res Function(PlayerAuthRequest) _then;

/// Create a copy of PlayerAuthRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tournamentId = null,Object? userId = null,}) {
  return _then(_self.copyWith(
tournamentId: null == tournamentId ? _self.tournamentId : tournamentId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _PlayerAuthRequest implements PlayerAuthRequest {
  const _PlayerAuthRequest({required this.tournamentId, required this.userId});
  factory _PlayerAuthRequest.fromJson(Map<String, dynamic> json) => _$PlayerAuthRequestFromJson(json);

/// 大会 ID。
@override final  String tournamentId;
/// ユーザー ID（UUID v4）。
@override final  String userId;

/// Create a copy of PlayerAuthRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerAuthRequestCopyWith<_PlayerAuthRequest> get copyWith => __$PlayerAuthRequestCopyWithImpl<_PlayerAuthRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerAuthRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerAuthRequest&&(identical(other.tournamentId, tournamentId) || other.tournamentId == tournamentId)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tournamentId,userId);

@override
String toString() {
  return 'PlayerAuthRequest(tournamentId: $tournamentId, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$PlayerAuthRequestCopyWith<$Res> implements $PlayerAuthRequestCopyWith<$Res> {
  factory _$PlayerAuthRequestCopyWith(_PlayerAuthRequest value, $Res Function(_PlayerAuthRequest) _then) = __$PlayerAuthRequestCopyWithImpl;
@override @useResult
$Res call({
 String tournamentId, String userId
});




}
/// @nodoc
class __$PlayerAuthRequestCopyWithImpl<$Res>
    implements _$PlayerAuthRequestCopyWith<$Res> {
  __$PlayerAuthRequestCopyWithImpl(this._self, this._then);

  final _PlayerAuthRequest _self;
  final $Res Function(_PlayerAuthRequest) _then;

/// Create a copy of PlayerAuthRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tournamentId = null,Object? userId = null,}) {
  return _then(_PlayerAuthRequest(
tournamentId: null == tournamentId ? _self.tournamentId : tournamentId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
