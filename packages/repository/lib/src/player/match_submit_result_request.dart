import 'package:freezed_annotation/freezed_annotation.dart';

part 'match_submit_result_request.freezed.dart';
part 'match_submit_result_request.g.dart';

/// マッチ結果送信リクエスト。
@freezed
abstract class MatchSubmitResultRequest with _$MatchSubmitResultRequest {
  /// [MatchSubmitResultRequest] のコンストラクタ。
  const factory MatchSubmitResultRequest({
    /// 結果タイプ。
    /// PLAYER1_WIN, PLAYER2_WIN, DRAW, BOTH_LOSS, NO_SHOW, BYE
    required String type,

    /// 勝者のプレイヤー ID。
    required String winnerId,

    /// ユーザー ID（本人確認用）。
    required String userId,
  }) = _MatchSubmitResultRequest;

  /// JSON から [MatchSubmitResultRequest] を生成する。
  factory MatchSubmitResultRequest.fromJson(Map<String, dynamic> json) =>
      _$MatchSubmitResultRequestFromJson(json);
}
