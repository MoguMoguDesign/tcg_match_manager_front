import 'package:freezed_annotation/freezed_annotation.dart';

part 'match_submit_result_response.freezed.dart';
part 'match_submit_result_response.g.dart';

/// マッチ結果送信レスポンス。
@freezed
abstract class MatchSubmitResultResponse with _$MatchSubmitResultResponse {
  /// [MatchSubmitResultResponse] のコンストラクタ。
  const factory MatchSubmitResultResponse({
    /// 結果詳細。
    required MatchResult result,
  }) = _MatchSubmitResultResponse;

  /// JSON から [MatchSubmitResultResponse] を生成する。
  factory MatchSubmitResultResponse.fromJson(Map<String, dynamic> json) =>
      _$MatchSubmitResultResponseFromJson(json);
}

/// マッチ結果詳細。
@freezed
abstract class MatchResult with _$MatchResult {
  /// [MatchResult] のコンストラクタ。
  const factory MatchResult({
    /// 結果タイプ。
    required String type,

    /// 勝者のプレイヤー ID。
    required String winnerId,

    /// 送信日時。
    required String submittedAt,

    /// 送信したプレイヤー ID。
    required String submittedBy,

    /// 送信者のユーザー ID。
    required String submitterUserId,
  }) = _MatchResult;

  /// JSON から [MatchResult] を生成する。
  factory MatchResult.fromJson(Map<String, dynamic> json) =>
      _$MatchResultFromJson(json);
}
