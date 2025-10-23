// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Match _$MatchFromJson(Map<String, dynamic> json) => _Match(
  id: json['id'] as String,
  tableNumber: (json['tableNumber'] as num).toInt(),
  published: json['published'] as bool,
  player1: MatchPlayer.fromJson(json['player1'] as Map<String, dynamic>),
  player2: MatchPlayer.fromJson(json['player2'] as Map<String, dynamic>),
  isByeMatch: json['isByeMatch'] as bool,
  result: json['result'] == null
      ? null
      : MatchResultDetail.fromJson(json['result'] as Map<String, dynamic>),
  isMine: json['isMine'] as bool,
  meSide: json['meSide'] as String?,
);

Map<String, dynamic> _$MatchToJson(_Match instance) => <String, dynamic>{
  'id': instance.id,
  'tableNumber': instance.tableNumber,
  'published': instance.published,
  'player1': instance.player1,
  'player2': instance.player2,
  'isByeMatch': instance.isByeMatch,
  'result': instance.result,
  'isMine': instance.isMine,
  'meSide': instance.meSide,
};

_MatchPlayer _$MatchPlayerFromJson(Map<String, dynamic> json) => _MatchPlayer(
  id: json['id'] as String,
  name: json['name'] as String,
  matchingPoints: (json['matchingPoints'] as num).toInt(),
);

Map<String, dynamic> _$MatchPlayerToJson(_MatchPlayer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'matchingPoints': instance.matchingPoints,
    };

_MatchResultDetail _$MatchResultDetailFromJson(Map<String, dynamic> json) =>
    _MatchResultDetail(
      type: json['type'] as String,
      winnerId: json['winnerId'] as String?,
      submittedAt: json['submittedAt'] as String?,
      submittedBy: json['submittedBy'] as String?,
      submitterUserId: json['submitterUserId'] as String?,
    );

Map<String, dynamic> _$MatchResultDetailToJson(_MatchResultDetail instance) =>
    <String, dynamic>{
      'type': instance.type,
      'winnerId': instance.winnerId,
      'submittedAt': instance.submittedAt,
      'submittedBy': instance.submittedBy,
      'submitterUserId': instance.submitterUserId,
    };
