// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_registration_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlayerRegistrationResponse _$PlayerRegistrationResponseFromJson(
  Map<String, dynamic> json,
) => _PlayerRegistrationResponse(
  playerId: json['playerId'] as String,
  playerNumber: (json['playerNumber'] as num).toInt(),
  status: json['status'] as String,
  userId: json['userId'] as String,
);

Map<String, dynamic> _$PlayerRegistrationResponseToJson(
  _PlayerRegistrationResponse instance,
) => <String, dynamic>{
  'playerId': instance.playerId,
  'playerNumber': instance.playerNumber,
  'status': instance.status,
  'userId': instance.userId,
};
