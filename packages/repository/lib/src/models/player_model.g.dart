// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlayerModel _$PlayerModelFromJson(Map<String, dynamic> json) => _PlayerModel(
  playerId: json['playerId'] as String,
  name: json['name'] as String,
  playerNumber: (json['playerNumber'] as num).toInt(),
  status: json['status'] as String,
  userId: json['userId'] as String,
);

Map<String, dynamic> _$PlayerModelToJson(_PlayerModel instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'name': instance.name,
      'playerNumber': instance.playerNumber,
      'status': instance.status,
      'userId': instance.userId,
    };
