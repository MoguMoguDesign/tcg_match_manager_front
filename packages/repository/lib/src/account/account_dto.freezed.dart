// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountDto {

/// 失敗状態かどうか。
///
/// 元々のフィールドでは int 型の値が返ってくるが、扱いやすくするために bool に変換している。
@JsonKey(name: 'STATUS')@flexibleBoolConverter bool get isFailureStatus;/// 副次的な ステータス。
///
/// 現状は初期値以外の値は返ってこない。
@JsonKey(name: 'SUB') int get sub;/// レスポンスメッセージ。
@JsonKey(name: 'MESSAGE') String get message;/// ユーザー ID。
@JsonKey(name: 'userId') String get userId;/// ユーザー名。
@JsonKey(name: 'username') String get username;/// 表示名。
@JsonKey(name: 'displayName') String get displayName;/// メールアドレス。
@JsonKey(name: 'email') String get email;/// API バージョン。
@JsonKey(name: 'apiVersion') int get apiVersion;/// アクセストークン。
@JsonKey(name: 'accessToken') String get accessToken;/// リフレッシュトークン。
@JsonKey(name: 'refreshToken') String get refreshToken;/// トークンの有効期限（Unix timestamp）。
@JsonKey(name: 'expiresAt') int get expiresAt;
/// Create a copy of AccountDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountDtoCopyWith<AccountDto> get copyWith => _$AccountDtoCopyWithImpl<AccountDto>(this as AccountDto, _$identity);

  /// Serializes this AccountDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountDto&&(identical(other.isFailureStatus, isFailureStatus) || other.isFailureStatus == isFailureStatus)&&(identical(other.sub, sub) || other.sub == sub)&&(identical(other.message, message) || other.message == message)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email)&&(identical(other.apiVersion, apiVersion) || other.apiVersion == apiVersion)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isFailureStatus,sub,message,userId,username,displayName,email,apiVersion,accessToken,refreshToken,expiresAt);

@override
String toString() {
  return 'AccountDto(isFailureStatus: $isFailureStatus, sub: $sub, message: $message, userId: $userId, username: $username, displayName: $displayName, email: $email, apiVersion: $apiVersion, accessToken: $accessToken, refreshToken: $refreshToken, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $AccountDtoCopyWith<$Res>  {
  factory $AccountDtoCopyWith(AccountDto value, $Res Function(AccountDto) _then) = _$AccountDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'STATUS')@flexibleBoolConverter bool isFailureStatus,@JsonKey(name: 'SUB') int sub,@JsonKey(name: 'MESSAGE') String message,@JsonKey(name: 'userId') String userId,@JsonKey(name: 'username') String username,@JsonKey(name: 'displayName') String displayName,@JsonKey(name: 'email') String email,@JsonKey(name: 'apiVersion') int apiVersion,@JsonKey(name: 'accessToken') String accessToken,@JsonKey(name: 'refreshToken') String refreshToken,@JsonKey(name: 'expiresAt') int expiresAt
});




}
/// @nodoc
class _$AccountDtoCopyWithImpl<$Res>
    implements $AccountDtoCopyWith<$Res> {
  _$AccountDtoCopyWithImpl(this._self, this._then);

  final AccountDto _self;
  final $Res Function(AccountDto) _then;

/// Create a copy of AccountDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isFailureStatus = null,Object? sub = null,Object? message = null,Object? userId = null,Object? username = null,Object? displayName = null,Object? email = null,Object? apiVersion = null,Object? accessToken = null,Object? refreshToken = null,Object? expiresAt = null,}) {
  return _then(_self.copyWith(
isFailureStatus: null == isFailureStatus ? _self.isFailureStatus : isFailureStatus // ignore: cast_nullable_to_non_nullable
as bool,sub: null == sub ? _self.sub : sub // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,apiVersion: null == apiVersion ? _self.apiVersion : apiVersion // ignore: cast_nullable_to_non_nullable
as int,accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _AccountDto implements AccountDto {
  const _AccountDto({@JsonKey(name: 'STATUS')@flexibleBoolConverter required this.isFailureStatus, @JsonKey(name: 'SUB') this.sub = 0, @JsonKey(name: 'MESSAGE') this.message = '', @JsonKey(name: 'userId') this.userId = '', @JsonKey(name: 'username') this.username = '', @JsonKey(name: 'displayName') this.displayName = '', @JsonKey(name: 'email') this.email = '', @JsonKey(name: 'apiVersion') this.apiVersion = 1, @JsonKey(name: 'accessToken') this.accessToken = '', @JsonKey(name: 'refreshToken') this.refreshToken = '', @JsonKey(name: 'expiresAt') this.expiresAt = 0});
  factory _AccountDto.fromJson(Map<String, dynamic> json) => _$AccountDtoFromJson(json);

/// 失敗状態かどうか。
///
/// 元々のフィールドでは int 型の値が返ってくるが、扱いやすくするために bool に変換している。
@override@JsonKey(name: 'STATUS')@flexibleBoolConverter final  bool isFailureStatus;
/// 副次的な ステータス。
///
/// 現状は初期値以外の値は返ってこない。
@override@JsonKey(name: 'SUB') final  int sub;
/// レスポンスメッセージ。
@override@JsonKey(name: 'MESSAGE') final  String message;
/// ユーザー ID。
@override@JsonKey(name: 'userId') final  String userId;
/// ユーザー名。
@override@JsonKey(name: 'username') final  String username;
/// 表示名。
@override@JsonKey(name: 'displayName') final  String displayName;
/// メールアドレス。
@override@JsonKey(name: 'email') final  String email;
/// API バージョン。
@override@JsonKey(name: 'apiVersion') final  int apiVersion;
/// アクセストークン。
@override@JsonKey(name: 'accessToken') final  String accessToken;
/// リフレッシュトークン。
@override@JsonKey(name: 'refreshToken') final  String refreshToken;
/// トークンの有効期限（Unix timestamp）。
@override@JsonKey(name: 'expiresAt') final  int expiresAt;

/// Create a copy of AccountDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountDtoCopyWith<_AccountDto> get copyWith => __$AccountDtoCopyWithImpl<_AccountDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountDto&&(identical(other.isFailureStatus, isFailureStatus) || other.isFailureStatus == isFailureStatus)&&(identical(other.sub, sub) || other.sub == sub)&&(identical(other.message, message) || other.message == message)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email)&&(identical(other.apiVersion, apiVersion) || other.apiVersion == apiVersion)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isFailureStatus,sub,message,userId,username,displayName,email,apiVersion,accessToken,refreshToken,expiresAt);

@override
String toString() {
  return 'AccountDto(isFailureStatus: $isFailureStatus, sub: $sub, message: $message, userId: $userId, username: $username, displayName: $displayName, email: $email, apiVersion: $apiVersion, accessToken: $accessToken, refreshToken: $refreshToken, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$AccountDtoCopyWith<$Res> implements $AccountDtoCopyWith<$Res> {
  factory _$AccountDtoCopyWith(_AccountDto value, $Res Function(_AccountDto) _then) = __$AccountDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'STATUS')@flexibleBoolConverter bool isFailureStatus,@JsonKey(name: 'SUB') int sub,@JsonKey(name: 'MESSAGE') String message,@JsonKey(name: 'userId') String userId,@JsonKey(name: 'username') String username,@JsonKey(name: 'displayName') String displayName,@JsonKey(name: 'email') String email,@JsonKey(name: 'apiVersion') int apiVersion,@JsonKey(name: 'accessToken') String accessToken,@JsonKey(name: 'refreshToken') String refreshToken,@JsonKey(name: 'expiresAt') int expiresAt
});




}
/// @nodoc
class __$AccountDtoCopyWithImpl<$Res>
    implements _$AccountDtoCopyWith<$Res> {
  __$AccountDtoCopyWithImpl(this._self, this._then);

  final _AccountDto _self;
  final $Res Function(_AccountDto) _then;

/// Create a copy of AccountDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isFailureStatus = null,Object? sub = null,Object? message = null,Object? userId = null,Object? username = null,Object? displayName = null,Object? email = null,Object? apiVersion = null,Object? accessToken = null,Object? refreshToken = null,Object? expiresAt = null,}) {
  return _then(_AccountDto(
isFailureStatus: null == isFailureStatus ? _self.isFailureStatus : isFailureStatus // ignore: cast_nullable_to_non_nullable
as bool,sub: null == sub ? _self.sub : sub // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,apiVersion: null == apiVersion ? _self.apiVersion : apiVersion // ignore: cast_nullable_to_non_nullable
as int,accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
