// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_registration_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlayerRegistrationRequest {

/// プレイヤー名。
 String get name;
/// Create a copy of PlayerRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerRegistrationRequestCopyWith<PlayerRegistrationRequest> get copyWith => _$PlayerRegistrationRequestCopyWithImpl<PlayerRegistrationRequest>(this as PlayerRegistrationRequest, _$identity);

  /// Serializes this PlayerRegistrationRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerRegistrationRequest&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'PlayerRegistrationRequest(name: $name)';
}


}

/// @nodoc
abstract mixin class $PlayerRegistrationRequestCopyWith<$Res>  {
  factory $PlayerRegistrationRequestCopyWith(PlayerRegistrationRequest value, $Res Function(PlayerRegistrationRequest) _then) = _$PlayerRegistrationRequestCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class _$PlayerRegistrationRequestCopyWithImpl<$Res>
    implements $PlayerRegistrationRequestCopyWith<$Res> {
  _$PlayerRegistrationRequestCopyWithImpl(this._self, this._then);

  final PlayerRegistrationRequest _self;
  final $Res Function(PlayerRegistrationRequest) _then;

/// Create a copy of PlayerRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _PlayerRegistrationRequest implements PlayerRegistrationRequest {
  const _PlayerRegistrationRequest({required this.name});
  factory _PlayerRegistrationRequest.fromJson(Map<String, dynamic> json) => _$PlayerRegistrationRequestFromJson(json);

/// プレイヤー名。
@override final  String name;

/// Create a copy of PlayerRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerRegistrationRequestCopyWith<_PlayerRegistrationRequest> get copyWith => __$PlayerRegistrationRequestCopyWithImpl<_PlayerRegistrationRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerRegistrationRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerRegistrationRequest&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'PlayerRegistrationRequest(name: $name)';
}


}

/// @nodoc
abstract mixin class _$PlayerRegistrationRequestCopyWith<$Res> implements $PlayerRegistrationRequestCopyWith<$Res> {
  factory _$PlayerRegistrationRequestCopyWith(_PlayerRegistrationRequest value, $Res Function(_PlayerRegistrationRequest) _then) = __$PlayerRegistrationRequestCopyWithImpl;
@override @useResult
$Res call({
 String name
});




}
/// @nodoc
class __$PlayerRegistrationRequestCopyWithImpl<$Res>
    implements _$PlayerRegistrationRequestCopyWith<$Res> {
  __$PlayerRegistrationRequestCopyWithImpl(this._self, this._then);

  final _PlayerRegistrationRequest _self;
  final $Res Function(_PlayerRegistrationRequest) _then;

/// Create a copy of PlayerRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(_PlayerRegistrationRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
