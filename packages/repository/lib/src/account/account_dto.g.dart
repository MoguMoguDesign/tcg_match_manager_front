// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountDto _$AccountDtoFromJson(Map<String, dynamic> json) => _AccountDto(
  isFailureStatus: flexibleBoolConverter.fromJson(json['STATUS']),
  sub: (json['SUB'] as num?)?.toInt() ?? 0,
  message: json['MESSAGE'] as String? ?? '',
  userId: json['user_id'] as String? ?? '',
  username: json['username'] as String? ?? '',
  displayName: json['display_name'] as String? ?? '',
  email: json['email'] as String? ?? '',
  apiVersion: (json['api_version'] as num?)?.toInt() ?? 1,
  accessToken: json['access_token'] as String? ?? '',
  refreshToken: json['refresh_token'] as String? ?? '',
  expiresAt: (json['expires_at'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AccountDtoToJson(_AccountDto instance) =>
    <String, dynamic>{
      'STATUS': flexibleBoolConverter.toJson(instance.isFailureStatus),
      'SUB': instance.sub,
      'MESSAGE': instance.message,
      'user_id': instance.userId,
      'username': instance.username,
      'display_name': instance.displayName,
      'email': instance.email,
      'api_version': instance.apiVersion,
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'expires_at': instance.expiresAt,
    };
