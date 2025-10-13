// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_tournament_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateTournamentRequest _$CreateTournamentRequestFromJson(
  Map<String, dynamic> json,
) => _CreateTournamentRequest(
  title: json['title'] as String,
  description: json['description'] as String,
  venue: json['venue'] as String,
  startDate: json['startDate'] as String,
  endDate: json['endDate'] as String,
  drawPoints: (json['drawPoints'] as num?)?.toInt() ?? 0,
  maxRounds: (json['maxRounds'] as num?)?.toInt(),
  expectedPlayers: (json['expectedPlayers'] as num?)?.toInt(),
);

Map<String, dynamic> _$CreateTournamentRequestToJson(
  _CreateTournamentRequest instance,
) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'venue': instance.venue,
  'startDate': instance.startDate,
  'endDate': instance.endDate,
  'drawPoints': instance.drawPoints,
  'maxRounds': instance.maxRounds,
  'expectedPlayers': instance.expectedPlayers,
};
