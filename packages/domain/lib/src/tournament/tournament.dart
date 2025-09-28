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
    required String description,

    /// トーナメント開始日時（ISO 8601 形式）。
    required String startDate,

    /// トーナメント終了日時（ISO 8601 形式）。
    required String endDate,
  }) = _Tournament;

  const Tournament._();

  /// [TournamentModel] からドメインエンティティに変換する。
  factory Tournament.fromModel(TournamentModel model) {
    return Tournament(
      id: model.id,
      title: model.title,
      description: model.description,
      startDate: model.startDate,
      endDate: model.endDate,
    );
  }
}
