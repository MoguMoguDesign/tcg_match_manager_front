// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tournament_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TournamentModel _$TournamentModelFromJson(Map<String, dynamic> json) =>
    _TournamentModel(
      id: json['id'] as String,
      title: json['name'] as String,
      description: json['overview'] as String?,
      category: json['category'] as String?,
      tournamentMode: json['tournamentMode'] as String? ?? 'FIXED_ROUNDS',
      startDate: json['date'] as String?,
      endDate: json['endDate'] as String?,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      drawPoints: (json['drawPoints'] as num?)?.toInt() ?? 0,
      maxRounds: (json['maxRound'] as num?)?.toInt(),
      expectedPlayers: (json['expectedPlayers'] as num?)?.toInt(),
      remarks: json['remarks'] as String?,
      status: json['status'] as String? ?? 'PREPARING',
      currentRound: (json['currentRound'] as num?)?.toInt() ?? 0,
      scheduleMode: json['scheduleMode'] as String?,
      playerCount: (json['playerCount'] as num?)?.toInt(),
      adminUid: json['adminUid'] as String?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$TournamentModelToJson(_TournamentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
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
      'remarks': instance.remarks,
      'status': instance.status,
      'currentRound': instance.currentRound,
      'scheduleMode': instance.scheduleMode,
      'playerCount': instance.playerCount,
      'adminUid': instance.adminUid,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
