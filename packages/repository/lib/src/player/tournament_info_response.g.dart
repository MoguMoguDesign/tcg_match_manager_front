// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tournament_info_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TournamentInfoResponse _$TournamentInfoResponseFromJson(
  Map<String, dynamic> json,
) => _TournamentInfoResponse(
  id: json['id'] as String,
  name: json['name'] as String,
  status: json['status'] as String,
  schedule: ScheduleInfo.fromJson(json['schedule'] as Map<String, dynamic>),
  currentRound: (json['currentRound'] as num).toInt(),
);

Map<String, dynamic> _$TournamentInfoResponseToJson(
  _TournamentInfoResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'status': instance.status,
  'schedule': instance.schedule,
  'currentRound': instance.currentRound,
};

_ScheduleInfo _$ScheduleInfoFromJson(Map<String, dynamic> json) =>
    _ScheduleInfo(
      mode: json['mode'] as String,
      totalRounds: (json['totalRounds'] as num?)?.toInt(),
      maxRounds: (json['maxRounds'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ScheduleInfoToJson(_ScheduleInfo instance) =>
    <String, dynamic>{
      'mode': instance.mode,
      'totalRounds': instance.totalRounds,
      'maxRounds': instance.maxRounds,
    };
