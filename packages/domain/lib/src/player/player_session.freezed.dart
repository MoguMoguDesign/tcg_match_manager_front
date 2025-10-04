// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlayerSession {

/// プレイヤー ID.
 String get playerId;/// プレイヤー番号。
 int get playerNumber;/// ユーザー ID（認証用）。
 String get userId;/// 大会 ID.
 String get tournamentId;/// プレイヤー名。
 String get playerName;/// セッション作成時刻。
 DateTime get createdAt;/// セッション有効期限（24時間後）。
 DateTime get expiresAt;
/// Create a copy of PlayerSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerSessionCopyWith<PlayerSession> get copyWith => _$PlayerSessionCopyWithImpl<PlayerSession>(this as PlayerSession, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerSession&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.playerNumber, playerNumber) || other.playerNumber == playerNumber)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.tournamentId, tournamentId) || other.tournamentId == tournamentId)&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}


@override
int get hashCode => Object.hash(runtimeType,playerId,playerNumber,userId,tournamentId,playerName,createdAt,expiresAt);

@override
String toString() {
  return 'PlayerSession(playerId: $playerId, playerNumber: $playerNumber, userId: $userId, tournamentId: $tournamentId, playerName: $playerName, createdAt: $createdAt, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $PlayerSessionCopyWith<$Res>  {
  factory $PlayerSessionCopyWith(PlayerSession value, $Res Function(PlayerSession) _then) = _$PlayerSessionCopyWithImpl;
@useResult
$Res call({
 String playerId, int playerNumber, String userId, String tournamentId, String playerName, DateTime createdAt, DateTime expiresAt
});




}
/// @nodoc
class _$PlayerSessionCopyWithImpl<$Res>
    implements $PlayerSessionCopyWith<$Res> {
  _$PlayerSessionCopyWithImpl(this._self, this._then);

  final PlayerSession _self;
  final $Res Function(PlayerSession) _then;

/// Create a copy of PlayerSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playerId = null,Object? playerNumber = null,Object? userId = null,Object? tournamentId = null,Object? playerName = null,Object? createdAt = null,Object? expiresAt = null,}) {
  return _then(_self.copyWith(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerNumber: null == playerNumber ? _self.playerNumber : playerNumber // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,tournamentId: null == tournamentId ? _self.tournamentId : tournamentId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// @nodoc


class _PlayerSession extends PlayerSession {
  const _PlayerSession({required this.playerId, required this.playerNumber, required this.userId, required this.tournamentId, required this.playerName, required this.createdAt, required this.expiresAt}): super._();
  

/// プレイヤー ID.
@override final  String playerId;
/// プレイヤー番号。
@override final  int playerNumber;
/// ユーザー ID（認証用）。
@override final  String userId;
/// 大会 ID.
@override final  String tournamentId;
/// プレイヤー名。
@override final  String playerName;
/// セッション作成時刻。
@override final  DateTime createdAt;
/// セッション有効期限（24時間後）。
@override final  DateTime expiresAt;

/// Create a copy of PlayerSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerSessionCopyWith<_PlayerSession> get copyWith => __$PlayerSessionCopyWithImpl<_PlayerSession>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerSession&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.playerNumber, playerNumber) || other.playerNumber == playerNumber)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.tournamentId, tournamentId) || other.tournamentId == tournamentId)&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}


@override
int get hashCode => Object.hash(runtimeType,playerId,playerNumber,userId,tournamentId,playerName,createdAt,expiresAt);

@override
String toString() {
  return 'PlayerSession(playerId: $playerId, playerNumber: $playerNumber, userId: $userId, tournamentId: $tournamentId, playerName: $playerName, createdAt: $createdAt, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$PlayerSessionCopyWith<$Res> implements $PlayerSessionCopyWith<$Res> {
  factory _$PlayerSessionCopyWith(_PlayerSession value, $Res Function(_PlayerSession) _then) = __$PlayerSessionCopyWithImpl;
@override @useResult
$Res call({
 String playerId, int playerNumber, String userId, String tournamentId, String playerName, DateTime createdAt, DateTime expiresAt
});




}
/// @nodoc
class __$PlayerSessionCopyWithImpl<$Res>
    implements _$PlayerSessionCopyWith<$Res> {
  __$PlayerSessionCopyWithImpl(this._self, this._then);

  final _PlayerSession _self;
  final $Res Function(_PlayerSession) _then;

/// Create a copy of PlayerSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? playerNumber = null,Object? userId = null,Object? tournamentId = null,Object? playerName = null,Object? createdAt = null,Object? expiresAt = null,}) {
  return _then(_PlayerSession(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerNumber: null == playerNumber ? _self.playerNumber : playerNumber // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,tournamentId: null == tournamentId ? _self.tournamentId : tournamentId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
