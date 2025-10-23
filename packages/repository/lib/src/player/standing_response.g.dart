// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'standing_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StandingResponse _$StandingResponseFromJson(Map<String, dynamic> json) =>
    _StandingResponse(
      calculatedAt: json['calculatedAt'] as String,
      rankings: (json['rankings'] as List<dynamic>)
          .map((e) => Ranking.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StandingResponseToJson(_StandingResponse instance) =>
    <String, dynamic>{
      'calculatedAt': instance.calculatedAt,
      'rankings': instance.rankings,
    };

_Ranking _$RankingFromJson(Map<String, dynamic> json) => _Ranking(
  rank: (json['rank'] as num).toInt(),
  playerName: json['playerName'] as String,
  matchPoints: (json['matchPoints'] as num).toInt(),
  omwPercentage: (json['omwPercentage'] as num).toDouble(),
);

Map<String, dynamic> _$RankingToJson(_Ranking instance) => <String, dynamic>{
  'rank': instance.rank,
  'playerName': instance.playerName,
  'matchPoints': instance.matchPoints,
  'omwPercentage': instance.omwPercentage,
};
