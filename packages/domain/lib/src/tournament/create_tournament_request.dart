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

    /// 開催会場。
    required String venue,

    /// トーナメント開始日時（ISO 8601 形式）。
    required String startDate,

    /// トーナメント終了日時（ISO 8601 形式）。
    required String endDate,

    /// 引き分け得点（0点 or 1点）。
    @Default(0) int drawPoints,

    /// ラウンド数（手動指定時、nullの場合は自動計算）。
    int? maxRounds,

    /// 予定参加者数（自動計算用）。
    int? expectedPlayers,
  }) = _CreateTournamentRequest;
}
