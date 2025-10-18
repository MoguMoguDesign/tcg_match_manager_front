// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountDto _$AccountDtoFromJson(Map<String, dynamic> json) => _AccountDto(
  isFailureStatus: flexibleBoolConverter.fromJson(json['STATUS']),
  sub: (json['SUB'] as num?)?.toInt() ?? 0,
  message: json['MESSAGE'] as String? ?? '',
  userId: json['userId'] as String? ?? '',
  username: json['username'] as String? ?? '',
  displayName: json['displayName'] as String? ?? '',
  email: json['email'] as String? ?? '',
  apiVersion: (json['apiVersion'] as num?)?.toInt() ?? 1,
  accessToken: json['accessToken'] as String? ?? '',
  refreshToken: json['refreshToken'] as String? ?? '',
  expiresAt: (json['expiresAt'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AccountDtoToJson(_AccountDto instance) =>
    <String, dynamic>{
      'STATUS': flexibleBoolConverter.toJson(instance.isFailureStatus),
      'SUB': instance.sub,
      'MESSAGE': instance.message,
      'userId': instance.userId,
      'username': instance.username,
      'displayName': instance.displayName,
      'email': instance.email,
      'apiVersion': instance.apiVersion,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'expiresAt': instance.expiresAt,
    };
