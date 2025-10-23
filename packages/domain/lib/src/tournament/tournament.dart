import 'dart:math' as math;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:repository/repository.dart';

part 'tournament.freezed.dart';

/// トーナメント情報を表すドメインエンティティ。
@freezed
abstract class Tournament with _$Tournament {
  /// [Tournament] のコンストラクタ。
  const factory Tournament({
    /// トーナメント ID。
    required String id,

    /// トーナメントタイトル。
    required String title,

    /// トーナメントの説明。
    String? description,

    /// カテゴリー。
    String? category,

    /// 開催会場。
    String? venue,

    /// トーナメント開始日時（ISO 8601 形式）。
    String? startDate,

    /// トーナメント終了日時（ISO 8601 形式）。
    String? endDate,

    /// 引き分け得点（0点 or 1点）。
    @Default(0) int drawPoints,

    /// ラウンド数（自動計算時はnull）。
    int? maxRounds,

    /// 予定参加者数（自動計算用）。
    int? expectedPlayers,

    /// 実際のプレイヤー数。
    int? playerCount,

    /// トーナメントステータス。
    @Default('PREPARING') String status,

    /// 現在のラウンド番号。
    @Default(0) int currentRound,

    /// 作成日時（ISO 8601 形式）。
    required String createdAt,

    /// 更新日時（ISO 8601 形式）。
    required String updatedAt,
  }) = _Tournament;

  const Tournament._();

  /// [TournamentModel] からドメインエンティティに変換する。
  ///
  /// 注意: 新しいフィールドはTournamentModelに追加される必要があります。
  factory Tournament.fromModel(TournamentModel model) {
    return Tournament(
      id: model.id,
      title: model.title,
      description: model.description,
      category: model.category,
      venue: model.venue,
      startDate: model.startDate,
      endDate: model.endDate,
      drawPoints: model.drawPoints,
      maxRounds: model.maxRounds,
      expectedPlayers: model.expectedPlayers,
      playerCount: model.playerCount,
      status: model.status,
      currentRound: model.currentRound,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  /// 推奨ラウンド数を計算する。
  int calculateRecommendedRounds() {
    if (expectedPlayers == null || expectedPlayers! <= 0) {
      return 1;
    }
    // ceil(log2(players)) の計算
    final logValue = math.log(expectedPlayers!) / math.log(2);
    return math.max(1, logValue.ceil());
  }

  /// トーナメントが準備状態かどうかを判定する。
  bool get isPreparing => status == 'PREPARING';

  /// トーナメントが開始済みかどうかを判定する。
  bool get isStarted => status == 'IN_PROGRESS';

  /// トーナメントが完了済みかどうかを判定する。
  bool get isCompleted => status == 'COMPLETED';
}
