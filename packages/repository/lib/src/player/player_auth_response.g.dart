// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlayerAuthResponse _$PlayerAuthResponseFromJson(Map<String, dynamic> json) =>
    _PlayerAuthResponse(
      valid: json['valid'] as bool,
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
    );

Map<String, dynamic> _$PlayerAuthResponseToJson(_PlayerAuthResponse instance) =>
    <String, dynamic>{
      'valid': instance.valid,
      'playerId': instance.playerId,
      'playerName': instance.playerName,
    };
