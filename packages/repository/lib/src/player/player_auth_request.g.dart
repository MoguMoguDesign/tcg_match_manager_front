// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_auth_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlayerAuthRequest _$PlayerAuthRequestFromJson(Map<String, dynamic> json) =>
    _PlayerAuthRequest(
      tournamentId: json['tournamentId'] as String,
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$PlayerAuthRequestToJson(_PlayerAuthRequest instance) =>
    <String, dynamic>{
      'tournamentId': instance.tournamentId,
      'userId': instance.userId,
    };
