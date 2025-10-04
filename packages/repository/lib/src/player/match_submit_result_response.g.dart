// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_submit_result_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MatchSubmitResultResponse _$MatchSubmitResultResponseFromJson(
  Map<String, dynamic> json,
) => _MatchSubmitResultResponse(
  result: MatchResult.fromJson(json['result'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MatchSubmitResultResponseToJson(
  _MatchSubmitResultResponse instance,
) => <String, dynamic>{'result': instance.result};

_MatchResult _$MatchResultFromJson(Map<String, dynamic> json) => _MatchResult(
  type: json['type'] as String,
  winnerId: json['winnerId'] as String,
  submittedAt: json['submittedAt'] as String,
  submittedBy: json['submittedBy'] as String,
  submitterUserId: json['submitterUserId'] as String,
);

Map<String, dynamic> _$MatchResultToJson(_MatchResult instance) =>
    <String, dynamic>{
      'type': instance.type,
      'winnerId': instance.winnerId,
      'submittedAt': instance.submittedAt,
      'submittedBy': instance.submittedBy,
      'submitterUserId': instance.submitterUserId,
    };
