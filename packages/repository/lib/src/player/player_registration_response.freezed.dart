// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_registration_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlayerRegistrationResponse {

/// プレイヤー ID。
 String get playerId;/// プレイヤー番号。
 int get playerNumber;/// プレイヤーステータス（ACTIVE, DROPPED など）。
 String get status;/// ユーザー ID（UUID v4）。
 String get userId;
/// Create a copy of PlayerRegistrationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerRegistrationResponseCopyWith<PlayerRegistrationResponse> get copyWith => _$PlayerRegistrationResponseCopyWithImpl<PlayerRegistrationResponse>(this as PlayerRegistrationResponse, _$identity);

  /// Serializes this PlayerRegistrationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerRegistrationResponse&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.playerNumber, playerNumber) || other.playerNumber == playerNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,playerNumber,status,userId);

@override
String toString() {
  return 'PlayerRegistrationResponse(playerId: $playerId, playerNumber: $playerNumber, status: $status, userId: $userId)';
}


}

/// @nodoc
abstract mixin class $PlayerRegistrationResponseCopyWith<$Res>  {
  factory $PlayerRegistrationResponseCopyWith(PlayerRegistrationResponse value, $Res Function(PlayerRegistrationResponse) _then) = _$PlayerRegistrationResponseCopyWithImpl;
@useResult
$Res call({
 String playerId, int playerNumber, String status, String userId
});




}
/// @nodoc
class _$PlayerRegistrationResponseCopyWithImpl<$Res>
    implements $PlayerRegistrationResponseCopyWith<$Res> {
  _$PlayerRegistrationResponseCopyWithImpl(this._self, this._then);

  final PlayerRegistrationResponse _self;
  final $Res Function(PlayerRegistrationResponse) _then;

/// Create a copy of PlayerRegistrationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playerId = null,Object? playerNumber = null,Object? status = null,Object? userId = null,}) {
  return _then(_self.copyWith(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerNumber: null == playerNumber ? _self.playerNumber : playerNumber // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _PlayerRegistrationResponse implements PlayerRegistrationResponse {
  const _PlayerRegistrationResponse({required this.playerId, required this.playerNumber, required this.status, required this.userId});
  factory _PlayerRegistrationResponse.fromJson(Map<String, dynamic> json) => _$PlayerRegistrationResponseFromJson(json);

/// プレイヤー ID。
@override final  String playerId;
/// プレイヤー番号。
@override final  int playerNumber;
/// プレイヤーステータス（ACTIVE, DROPPED など）。
@override final  String status;
/// ユーザー ID（UUID v4）。
@override final  String userId;

/// Create a copy of PlayerRegistrationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerRegistrationResponseCopyWith<_PlayerRegistrationResponse> get copyWith => __$PlayerRegistrationResponseCopyWithImpl<_PlayerRegistrationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerRegistrationResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerRegistrationResponse&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.playerNumber, playerNumber) || other.playerNumber == playerNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,playerNumber,status,userId);

@override
String toString() {
  return 'PlayerRegistrationResponse(playerId: $playerId, playerNumber: $playerNumber, status: $status, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$PlayerRegistrationResponseCopyWith<$Res> implements $PlayerRegistrationResponseCopyWith<$Res> {
  factory _$PlayerRegistrationResponseCopyWith(_PlayerRegistrationResponse value, $Res Function(_PlayerRegistrationResponse) _then) = __$PlayerRegistrationResponseCopyWithImpl;
@override @useResult
$Res call({
 String playerId, int playerNumber, String status, String userId
});




}
/// @nodoc
class __$PlayerRegistrationResponseCopyWithImpl<$Res>
    implements _$PlayerRegistrationResponseCopyWith<$Res> {
  __$PlayerRegistrationResponseCopyWithImpl(this._self, this._then);

  final _PlayerRegistrationResponse _self;
  final $Res Function(_PlayerRegistrationResponse) _then;

/// Create a copy of PlayerRegistrationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? playerNumber = null,Object? status = null,Object? userId = null,}) {
  return _then(_PlayerRegistrationResponse(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerNumber: null == playerNumber ? _self.playerNumber : playerNumber // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
