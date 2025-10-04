// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_auth_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlayerAuthResponse {

/// 有効かどうか。
 bool get valid;/// プレイヤー ID。
 String get playerId;/// プレイヤー名。
 String get playerName;
/// Create a copy of PlayerAuthResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerAuthResponseCopyWith<PlayerAuthResponse> get copyWith => _$PlayerAuthResponseCopyWithImpl<PlayerAuthResponse>(this as PlayerAuthResponse, _$identity);

  /// Serializes this PlayerAuthResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerAuthResponse&&(identical(other.valid, valid) || other.valid == valid)&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.playerName, playerName) || other.playerName == playerName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,valid,playerId,playerName);

@override
String toString() {
  return 'PlayerAuthResponse(valid: $valid, playerId: $playerId, playerName: $playerName)';
}


}

/// @nodoc
abstract mixin class $PlayerAuthResponseCopyWith<$Res>  {
  factory $PlayerAuthResponseCopyWith(PlayerAuthResponse value, $Res Function(PlayerAuthResponse) _then) = _$PlayerAuthResponseCopyWithImpl;
@useResult
$Res call({
 bool valid, String playerId, String playerName
});




}
/// @nodoc
class _$PlayerAuthResponseCopyWithImpl<$Res>
    implements $PlayerAuthResponseCopyWith<$Res> {
  _$PlayerAuthResponseCopyWithImpl(this._self, this._then);

  final PlayerAuthResponse _self;
  final $Res Function(PlayerAuthResponse) _then;

/// Create a copy of PlayerAuthResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? valid = null,Object? playerId = null,Object? playerName = null,}) {
  return _then(_self.copyWith(
valid: null == valid ? _self.valid : valid // ignore: cast_nullable_to_non_nullable
as bool,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _PlayerAuthResponse implements PlayerAuthResponse {
  const _PlayerAuthResponse({required this.valid, required this.playerId, required this.playerName});
  factory _PlayerAuthResponse.fromJson(Map<String, dynamic> json) => _$PlayerAuthResponseFromJson(json);

/// 有効かどうか。
@override final  bool valid;
/// プレイヤー ID。
@override final  String playerId;
/// プレイヤー名。
@override final  String playerName;

/// Create a copy of PlayerAuthResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerAuthResponseCopyWith<_PlayerAuthResponse> get copyWith => __$PlayerAuthResponseCopyWithImpl<_PlayerAuthResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerAuthResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerAuthResponse&&(identical(other.valid, valid) || other.valid == valid)&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.playerName, playerName) || other.playerName == playerName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,valid,playerId,playerName);

@override
String toString() {
  return 'PlayerAuthResponse(valid: $valid, playerId: $playerId, playerName: $playerName)';
}


}

/// @nodoc
abstract mixin class _$PlayerAuthResponseCopyWith<$Res> implements $PlayerAuthResponseCopyWith<$Res> {
  factory _$PlayerAuthResponseCopyWith(_PlayerAuthResponse value, $Res Function(_PlayerAuthResponse) _then) = __$PlayerAuthResponseCopyWithImpl;
@override @useResult
$Res call({
 bool valid, String playerId, String playerName
});




}
/// @nodoc
class __$PlayerAuthResponseCopyWithImpl<$Res>
    implements _$PlayerAuthResponseCopyWith<$Res> {
  __$PlayerAuthResponseCopyWithImpl(this._self, this._then);

  final _PlayerAuthResponse _self;
  final $Res Function(_PlayerAuthResponse) _then;

/// Create a copy of PlayerAuthResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? valid = null,Object? playerId = null,Object? playerName = null,}) {
  return _then(_PlayerAuthResponse(
valid: null == valid ? _self.valid : valid // ignore: cast_nullable_to_non_nullable
as bool,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
