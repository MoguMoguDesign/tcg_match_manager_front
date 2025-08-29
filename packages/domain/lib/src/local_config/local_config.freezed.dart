// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'local_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LocalConfig {

/// ログイン状態。
 bool get isLoggedIn;
/// Create a copy of LocalConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocalConfigCopyWith<LocalConfig> get copyWith => _$LocalConfigCopyWithImpl<LocalConfig>(this as LocalConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalConfig&&(identical(other.isLoggedIn, isLoggedIn) || other.isLoggedIn == isLoggedIn));
}


@override
int get hashCode => Object.hash(runtimeType,isLoggedIn);

@override
String toString() {
  return 'LocalConfig(isLoggedIn: $isLoggedIn)';
}


}

/// @nodoc
abstract mixin class $LocalConfigCopyWith<$Res>  {
  factory $LocalConfigCopyWith(LocalConfig value, $Res Function(LocalConfig) _then) = _$LocalConfigCopyWithImpl;
@useResult
$Res call({
 bool isLoggedIn
});




}
/// @nodoc
class _$LocalConfigCopyWithImpl<$Res>
    implements $LocalConfigCopyWith<$Res> {
  _$LocalConfigCopyWithImpl(this._self, this._then);

  final LocalConfig _self;
  final $Res Function(LocalConfig) _then;

/// Create a copy of LocalConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoggedIn = null,}) {
  return _then(_self.copyWith(
isLoggedIn: null == isLoggedIn ? _self.isLoggedIn : isLoggedIn // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc


class _LocalConfig implements LocalConfig {
  const _LocalConfig({required this.isLoggedIn});
  

/// ログイン状態。
@override final  bool isLoggedIn;

/// Create a copy of LocalConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocalConfigCopyWith<_LocalConfig> get copyWith => __$LocalConfigCopyWithImpl<_LocalConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocalConfig&&(identical(other.isLoggedIn, isLoggedIn) || other.isLoggedIn == isLoggedIn));
}


@override
int get hashCode => Object.hash(runtimeType,isLoggedIn);

@override
String toString() {
  return 'LocalConfig(isLoggedIn: $isLoggedIn)';
}


}

/// @nodoc
abstract mixin class _$LocalConfigCopyWith<$Res> implements $LocalConfigCopyWith<$Res> {
  factory _$LocalConfigCopyWith(_LocalConfig value, $Res Function(_LocalConfig) _then) = __$LocalConfigCopyWithImpl;
@override @useResult
$Res call({
 bool isLoggedIn
});




}
/// @nodoc
class __$LocalConfigCopyWithImpl<$Res>
    implements _$LocalConfigCopyWith<$Res> {
  __$LocalConfigCopyWithImpl(this._self, this._then);

  final _LocalConfig _self;
  final $Res Function(_LocalConfig) _then;

/// Create a copy of LocalConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoggedIn = null,}) {
  return _then(_LocalConfig(
isLoggedIn: null == isLoggedIn ? _self.isLoggedIn : isLoggedIn // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
