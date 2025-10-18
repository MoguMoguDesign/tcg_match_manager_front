// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Player {

/// プレイヤー ID。
 String get playerId;/// プレイヤー名。
 String get name;/// プレイヤー番号。
 int get playerNumber;/// プレイヤーステータス（ACTIVE, DROPPED など）。
 String get status;/// ユーザー ID（UUID v4）。
 String get userId;
/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerCopyWith<Player> get copyWith => _$PlayerCopyWithImpl<Player>(this as Player, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Player&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.playerNumber, playerNumber) || other.playerNumber == playerNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.userId, userId) || other.userId == userId));
}


@override
int get hashCode => Object.hash(runtimeType,playerId,name,playerNumber,status,userId);

@override
String toString() {
  return 'Player(playerId: $playerId, name: $name, playerNumber: $playerNumber, status: $status, userId: $userId)';
}


}

/// @nodoc
abstract mixin class $PlayerCopyWith<$Res>  {
  factory $PlayerCopyWith(Player value, $Res Function(Player) _then) = _$PlayerCopyWithImpl;
@useResult
$Res call({
 String playerId, String name, int playerNumber, String status, String userId
});




}
/// @nodoc
class _$PlayerCopyWithImpl<$Res>
    implements $PlayerCopyWith<$Res> {
  _$PlayerCopyWithImpl(this._self, this._then);

  final Player _self;
  final $Res Function(Player) _then;

/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playerId = null,Object? name = null,Object? playerNumber = null,Object? status = null,Object? userId = null,}) {
  return _then(_self.copyWith(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,playerNumber: null == playerNumber ? _self.playerNumber : playerNumber // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc


class _Player extends Player {
  const _Player({required this.playerId, required this.name, required this.playerNumber, required this.status, required this.userId}): super._();
  

/// プレイヤー ID。
@override final  String playerId;
/// プレイヤー名。
@override final  String name;
/// プレイヤー番号。
@override final  int playerNumber;
/// プレイヤーステータス（ACTIVE, DROPPED など）。
@override final  String status;
/// ユーザー ID（UUID v4）。
@override final  String userId;

/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerCopyWith<_Player> get copyWith => __$PlayerCopyWithImpl<_Player>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Player&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.playerNumber, playerNumber) || other.playerNumber == playerNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.userId, userId) || other.userId == userId));
}


@override
int get hashCode => Object.hash(runtimeType,playerId,name,playerNumber,status,userId);

@override
String toString() {
  return 'Player(playerId: $playerId, name: $name, playerNumber: $playerNumber, status: $status, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$PlayerCopyWith<$Res> implements $PlayerCopyWith<$Res> {
  factory _$PlayerCopyWith(_Player value, $Res Function(_Player) _then) = __$PlayerCopyWithImpl;
@override @useResult
$Res call({
 String playerId, String name, int playerNumber, String status, String userId
});




}
/// @nodoc
class __$PlayerCopyWithImpl<$Res>
    implements _$PlayerCopyWith<$Res> {
  __$PlayerCopyWithImpl(this._self, this._then);

  final _Player _self;
  final $Res Function(_Player) _then;

/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? name = null,Object? playerNumber = null,Object? status = null,Object? userId = null,}) {
  return _then(_Player(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,playerNumber: null == playerNumber ? _self.playerNumber : playerNumber // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
