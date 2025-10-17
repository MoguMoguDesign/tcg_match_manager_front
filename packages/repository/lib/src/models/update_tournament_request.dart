/// トーナメント更新リクエスト用のモデルクラス。
///
/// 管理者が既存のトーナメント情報を更新する際のAPIリクエストで使用する。
/// パーシャル更新をサポートするため、全フィールドがオプショナル。
class UpdateTournamentRequest {
  /// [UpdateTournamentRequest]のコンストラクタ。
  const UpdateTournamentRequest({ // coverage:ignore-line
    this.name,
    this.overview,
    this.category,
    this.date,
    this.remarks,
  });

  /// 全フィールド必須のファクトリコンストラクタ。
  const UpdateTournamentRequest.full({ // coverage:ignore-line
    required this.name,
    required this.overview,
    required this.category,
    required this.date,
    required this.remarks,
  });

  /// トーナメント名（オプショナル）。
  final String? name;

  /// トーナメント概要（オプショナル）。
  final String? overview;

  /// トーナメントカテゴリ（オプショナル）。
  final String? category;

  /// トーナメント開催日時（ISO8601形式）（オプショナル）。
  final String? date;

  /// 備考（オプショナル）。
  final String? remarks;

  /// 更新フィールドが存在するかチェックする。
  bool get hasUpdates =>
      name != null ||
      overview != null ||
      category != null ||
      date != null ||
      remarks != null;

  /// JSONに変換する。
  ///
  /// nullでないフィールドのみがJSONに含まれる。
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (name != null) {
      json['name'] = name;
    }
    if (overview != null) {
      json['overview'] = overview;
    }
    if (category != null) {
      json['category'] = category;
    }
    if (date != null) {
      json['date'] = date;
    }
    if (remarks != null) {
      json['remarks'] = remarks;
    }

    return json;
  }
}
