import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_tournament_request.freezed.dart';

/// 大会作成用のリクエスト。
///
/// 新しいトーナメントを作成するためのパラメータを保持する。
@freezed
abstract class CreateTournamentRequest with _$CreateTournamentRequest {
  /// [CreateTournamentRequest] のコンストラクタ。
  const factory CreateTournamentRequest({
    /// トーナメントタイトル。
    required String title,

    /// トーナメントの説明。
    required String description,

    /// 大会カテゴリ。
    required String category,

    /// 大会運営方式（'FIXED_ROUNDS': 指定ラウンド方式 | 'ELIMINATION': 勝者が1人まで残る方式）。
    @Default('FIXED_ROUNDS') String tournamentMode,

    /// トーナメント開始日時（ISO 8601 形式）。
    required String startDate,

    /// トーナメント終了日時（ISO 8601 形式）。
    required String endDate,

    /// 開催開始時刻（HH:mm形式）。
    required String startTime,

    /// 開催終了時刻（HH:mm形式）。
    required String endTime,

    /// 引き分け得点（0点 or 1点）。
    @Default(0) int drawPoints,

    /// ラウンド数（手動指定時、nullの場合は自動計算）。
    int? maxRounds,

    /// 予定参加者数（自動計算用）。
    int? expectedPlayers,
  }) = _CreateTournamentRequest;
}
