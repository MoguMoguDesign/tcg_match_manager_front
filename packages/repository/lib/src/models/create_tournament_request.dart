import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_tournament_request.freezed.dart';
part 'create_tournament_request.g.dart';

/// 大会作成リクエストを表すモデルクラス。
///
/// API への大会作成リクエストデータを表現する。
@freezed
abstract class CreateTournamentRequest with _$CreateTournamentRequest {
  /// [CreateTournamentRequest] のコンストラクタ。
  const factory CreateTournamentRequest({
    /// 大会タイトル。
    @JsonKey(name: 'name') required String title,

    /// 大会の説明。
    @JsonKey(name: 'overview') required String description,

    /// 大会カテゴリ。
    required String category,

    /// 開催会場。
    required String venue,

    /// 大会開始日時（ISO 8601 形式）。
    @JsonKey(name: 'date') required String startDate,

    /// 大会終了日時（ISO 8601 形式）。
    required String endDate,

    /// 引き分け得点（0点 or 1点）。
    @Default(0) int drawPoints,

    /// ラウンド数（手動指定時、nullの場合は自動計算）。
    @JsonKey(name: 'maxRound') int? maxRounds,

    /// 予定参加者数（自動計算用）。
    int? expectedPlayers,
  }) = _CreateTournamentRequest;

  /// JSON から CreateTournamentRequest インスタンスを作成する。
  factory CreateTournamentRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateTournamentRequestFromJson(json);
}
