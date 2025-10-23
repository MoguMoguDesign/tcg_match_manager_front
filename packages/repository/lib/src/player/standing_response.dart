import 'package:freezed_annotation/freezed_annotation.dart';

part 'standing_response.freezed.dart';
part 'standing_response.g.dart';

/// 最終順位レスポンス。
@freezed
abstract class StandingResponse with _$StandingResponse {
  /// [StandingResponse] のコンストラクタ。
  const factory StandingResponse({
    /// 計算日時。
    required String calculatedAt,

    /// 順位表。
    required List<Ranking> rankings,
  }) = _StandingResponse;

  /// JSON から [StandingResponse] を生成する。
  factory StandingResponse.fromJson(Map<String, dynamic> json) =>
      _$StandingResponseFromJson(json);
}

/// 順位情報。
@freezed
abstract class Ranking with _$Ranking {
  /// [Ranking] のコンストラクタ。
  const factory Ranking({
    /// 順位。
    required int rank,

    /// プレイヤー名。
    required String playerName,

    /// 累計勝ち点。
    required int matchPoints,

    /// OMWP（Opponent Match Win Percentage）。
    required double omwPercentage,
  }) = _Ranking;

  /// JSON から [Ranking] を生成する。
  factory Ranking.fromJson(Map<String, dynamic> json) =>
      _$RankingFromJson(json);
}
