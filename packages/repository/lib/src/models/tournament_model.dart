import 'package:freezed_annotation/freezed_annotation.dart';

part 'tournament_model.freezed.dart';
part 'tournament_model.g.dart';

/// 大会情報を表すモデルクラス。
///
/// API レスポンスから大会データを表現する。
@freezed
abstract class TournamentModel with _$TournamentModel {
  /// [TournamentModel] のコンストラクタ。
  const factory TournamentModel({
    /// 大会 ID。
    required String id,

    /// 大会タイトル。
    @JsonKey(name: 'name') required String title,

    /// 大会の説明。
    @JsonKey(name: 'overview') String? description,

    /// 大会カテゴリ。
    String? category,

    /// 大会運営方式（'FIXED_ROUNDS': 指定ラウンド方式 | 'ELIMINATION': 勝者が1人まで残る方式）。
    @Default('FIXED_ROUNDS') String tournamentMode,

    /// 大会開始日時（ISO 8601 形式）。
    @JsonKey(name: 'date') String? startDate,

    /// 大会終了日時（ISO 8601 形式）。
    String? endDate,

    /// 開催開始時刻（HH:mm形式）。
    String? startTime,

    /// 開催終了時刻（HH:mm形式）。
    String? endTime,

    /// 引き分け得点（0点 or 1点）。
    @Default(0) int drawPoints,

    /// ラウンド数。
    @JsonKey(name: 'maxRound') int? maxRounds,

    /// 予定参加者数。
    int? expectedPlayers,

    /// 備考。
    String? remarks,

    /// トーナメントステータス。
    @Default('PREPARING') String status,

    /// 現在のラウンド番号。
    @JsonKey(name: 'currentRound') @Default(0) int currentRound,

    /// スケジュールモード。
    @JsonKey(name: 'scheduleMode') String? scheduleMode,

    /// プレイヤー数。
    @JsonKey(name: 'playerCount') int? playerCount,

    /// 管理者UID。
    @JsonKey(name: 'adminUid') String? adminUid,

    /// 作成日時（ISO 8601 形式）。
    @JsonKey(name: 'createdAt') required String createdAt,

    /// 更新日時（ISO 8601 形式）。
    @JsonKey(name: 'updatedAt') required String updatedAt,
  }) = _TournamentModel;

  /// JSON から TournamentModel インスタンスを作成する。
  factory TournamentModel.fromJson(Map<String, dynamic> json) =>
      _$TournamentModelFromJson(json);
}
