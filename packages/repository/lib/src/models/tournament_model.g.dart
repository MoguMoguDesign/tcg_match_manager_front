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
      venue: json['venue'] as String?,
      startDate: json['date'] as String?,
      endDate: json['endDate'] as String?,
      drawPoints: (json['drawPoints'] as num?)?.toInt() ?? 0,
      maxRounds: (json['max_round'] as num?)?.toInt(),
      expectedPlayers: (json['expectedPlayers'] as num?)?.toInt(),
      status: json['status'] as String? ?? 'PREPARING',
      currentRound: (json['current_round'] as num?)?.toInt() ?? 0,
      scheduleMode: json['schedule_mode'] as String?,
      playerCount: (json['player_count'] as num?)?.toInt(),
      adminUid: json['admin_uid'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$TournamentModelToJson(_TournamentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.title,
      'overview': instance.description,
      'category': instance.category,
      'venue': instance.venue,
      'date': instance.startDate,
      'endDate': instance.endDate,
      'drawPoints': instance.drawPoints,
      'max_round': instance.maxRounds,
      'expectedPlayers': instance.expectedPlayers,
      'status': instance.status,
      'current_round': instance.currentRound,
      'schedule_mode': instance.scheduleMode,
      'player_count': instance.playerCount,
      'admin_uid': instance.adminUid,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
