/// トーナメント更新リクエスト用のモデルクラス。
///
/// 管理者が既存のトーナメント情報を更新する際のAPIリクエストで使用する。
/// パーシャル更新をサポートするため、全フィールドがオプショナル。
class UpdateTournamentRequest {
  /// [UpdateTournamentRequest]のコンストラクタ。
  const UpdateTournamentRequest({
    this.title,
    this.description,
    this.startDate,
    this.endDate,
  });

  /// 全フィールド必須のファクトリコンストラクタ。
  const UpdateTournamentRequest.full({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
  });

  /// トーナメントのタイトル（オプショナル）。
  final String? title;

  /// トーナメントの説明（オプショナル）。
  final String? description;

  /// トーナメントの開始日時（ISO8601形式）（オプショナル）。
  final String? startDate;

  /// トーナメントの終了日時（ISO8601形式）（オプショナル）。
  final String? endDate;

  /// 更新フィールドが存在するかチェックする。
  bool get hasUpdates =>
      title != null ||
      description != null ||
      startDate != null ||
      endDate != null;

  /// JSONに変換する。
  ///
  /// nullでないフィールドのみがJSONに含まれる。
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (title != null) {
      json['title'] = title;
    }
    if (description != null) {
      json['description'] = description;
    }
    if (startDate != null) {
      json['startDate'] = startDate;
    }
    if (endDate != null) {
      json['endDate'] = endDate;
    }

    return json;
  }
}
