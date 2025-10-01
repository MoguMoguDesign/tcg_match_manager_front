// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_player_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AddPlayerRequest {

 String get name; int get playerNumber; String get userId;
/// Create a copy of AddPlayerRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddPlayerRequestCopyWith<AddPlayerRequest> get copyWith => _$AddPlayerRequestCopyWithImpl<AddPlayerRequest>(this as AddPlayerRequest, _$identity);

  /// Serializes this AddPlayerRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddPlayerRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.playerNumber, playerNumber) || other.playerNumber == playerNumber)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,playerNumber,userId);

@override
String toString() {
  return 'AddPlayerRequest(name: $name, playerNumber: $playerNumber, userId: $userId)';
}


}

/// @nodoc
abstract mixin class $AddPlayerRequestCopyWith<$Res>  {
  factory $AddPlayerRequestCopyWith(AddPlayerRequest value, $Res Function(AddPlayerRequest) _then) = _$AddPlayerRequestCopyWithImpl;
@useResult
$Res call({
 String name, int playerNumber, String userId
});




}
/// @nodoc
class _$AddPlayerRequestCopyWithImpl<$Res>
    implements $AddPlayerRequestCopyWith<$Res> {
  _$AddPlayerRequestCopyWithImpl(this._self, this._then);

  final AddPlayerRequest _self;
  final $Res Function(AddPlayerRequest) _then;

/// Create a copy of AddPlayerRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? playerNumber = null,Object? userId = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,playerNumber: null == playerNumber ? _self.playerNumber : playerNumber // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _AddPlayerRequest implements AddPlayerRequest {
  const _AddPlayerRequest({required this.name, required this.playerNumber, required this.userId});
  factory _AddPlayerRequest.fromJson(Map<String, dynamic> json) => _$AddPlayerRequestFromJson(json);

@override final  String name;
@override final  int playerNumber;
@override final  String userId;

/// Create a copy of AddPlayerRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddPlayerRequestCopyWith<_AddPlayerRequest> get copyWith => __$AddPlayerRequestCopyWithImpl<_AddPlayerRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AddPlayerRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddPlayerRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.playerNumber, playerNumber) || other.playerNumber == playerNumber)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,playerNumber,userId);

@override
String toString() {
  return 'AddPlayerRequest(name: $name, playerNumber: $playerNumber, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$AddPlayerRequestCopyWith<$Res> implements $AddPlayerRequestCopyWith<$Res> {
  factory _$AddPlayerRequestCopyWith(_AddPlayerRequest value, $Res Function(_AddPlayerRequest) _then) = __$AddPlayerRequestCopyWithImpl;
@override @useResult
$Res call({
 String name, int playerNumber, String userId
});




}
/// @nodoc
class __$AddPlayerRequestCopyWithImpl<$Res>
    implements _$AddPlayerRequestCopyWith<$Res> {
  __$AddPlayerRequestCopyWithImpl(this._self, this._then);

  final _AddPlayerRequest _self;
  final $Res Function(_AddPlayerRequest) _then;

/// Create a copy of AddPlayerRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? playerNumber = null,Object? userId = null,}) {
  return _then(_AddPlayerRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,playerNumber: null == playerNumber ? _self.playerNumber : playerNumber // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
