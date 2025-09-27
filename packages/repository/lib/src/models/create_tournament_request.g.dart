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
  startDate: json['startDate'] as String,
  endDate: json['endDate'] as String,
);

Map<String, dynamic> _$CreateTournamentRequestToJson(
  _CreateTournamentRequest instance,
) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'startDate': instance.startDate,
  'endDate': instance.endDate,
};
