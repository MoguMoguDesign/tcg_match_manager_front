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
    required String title,

    /// 大会の説明。
    required String description,

    /// 大会開始日時（ISO 8601 形式）。
    required String startDate,

    /// 大会終了日時（ISO 8601 形式）。
    required String endDate,
  }) = _TournamentModel;

  /// JSON から TournamentModel インスタンスを作成する。
  factory TournamentModel.fromJson(Map<String, dynamic> json) =>
      _$TournamentModelFromJson(json);
}
