// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_player_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AddPlayerRequest _$AddPlayerRequestFromJson(Map<String, dynamic> json) =>
    _AddPlayerRequest(
      name: json['name'] as String,
      playerNumber: (json['playerNumber'] as num).toInt(),
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$AddPlayerRequestToJson(_AddPlayerRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'playerNumber': instance.playerNumber,
      'userId': instance.userId,
    };
