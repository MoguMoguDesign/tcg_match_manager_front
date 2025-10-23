// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_submit_result_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MatchSubmitResultRequest _$MatchSubmitResultRequestFromJson(
  Map<String, dynamic> json,
) => _MatchSubmitResultRequest(
  type: json['type'] as String,
  winnerId: json['winnerId'] as String,
  userId: json['userId'] as String,
);

Map<String, dynamic> _$MatchSubmitResultRequestToJson(
  _MatchSubmitResultRequest instance,
) => <String, dynamic>{
  'type': instance.type,
  'winnerId': instance.winnerId,
  'userId': instance.userId,
};
