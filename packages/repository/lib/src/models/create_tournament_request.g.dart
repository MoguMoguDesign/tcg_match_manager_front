// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_tournament_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateTournamentRequest _$CreateTournamentRequestFromJson(
  Map<String, dynamic> json,
) => _CreateTournamentRequest(
  title: json['name'] as String,
  description: json['overview'] as String,
  category: json['category'] as String,
  tournamentMode: json['tournamentMode'] as String? ?? 'FIXED_ROUNDS',
  startDate: json['date'] as String,
  endDate: json['endDate'] as String,
  startTime: json['startTime'] as String,
  endTime: json['endTime'] as String,
  drawPoints: (json['drawPoints'] as num?)?.toInt() ?? 0,
  maxRounds: (json['maxRound'] as num?)?.toInt(),
  expectedPlayers: (json['expectedPlayers'] as num?)?.toInt(),
);

Map<String, dynamic> _$CreateTournamentRequestToJson(
  _CreateTournamentRequest instance,
) => <String, dynamic>{
  'name': instance.title,
  'overview': instance.description,
  'category': instance.category,
  'tournamentMode': instance.tournamentMode,
  'date': instance.startDate,
  'endDate': instance.endDate,
  'startTime': instance.startTime,
  'endTime': instance.endTime,
  'drawPoints': instance.drawPoints,
  'maxRound': instance.maxRounds,
  'expectedPlayers': instance.expectedPlayers,
};
