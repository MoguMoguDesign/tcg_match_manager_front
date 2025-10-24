/// トーナメント更新リクエスト用のモデルクラス。
///
/// 管理者が既存のトーナメント情報を更新する際のAPIリクエストで使用する。
/// パーシャル更新をサポートするため、全フィールドがオプショナル。
class UpdateTournamentRequest {
  /// [UpdateTournamentRequest]のコンストラクタ。
  // coverage:ignore-start
  const UpdateTournamentRequest({
    this.name,
    this.overview,
    this.category,
    this.tournamentMode,
    this.date,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.drawPoints,
    this.maxRounds,
    this.expectedPlayers,
    this.remarks,
  });
  // coverage:ignore-end

  /// 全フィールド必須のファクトリコンストラクタ。
  // coverage:ignore-start
  const UpdateTournamentRequest.full({
    required this.name,
    required this.overview,
    required this.category,
    this.tournamentMode,
    required this.date,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.drawPoints,
    this.maxRounds,
    this.expectedPlayers,
    required this.remarks,
  });
  // coverage:ignore-end

  /// トーナメント名（オプショナル）。
  final String? name;

  /// トーナメント概要（オプショナル）。
  final String? overview;

  /// トーナメントカテゴリ（オプショナル）。
  final String? category;

  /// 大会運営方式（'FIXED_ROUNDS': 指定ラウンド方式 | 'ELIMINATION': 勝者が1人まで残る方式）（オプショナル）。
  final String? tournamentMode;

  /// トーナメント開催日時（ISO8601形式）（オプショナル）。
  final String? date;

  /// トーナメント開始日（ISO8601形式）（オプショナル）。
  final String? startDate;

  /// トーナメント終了日（ISO8601形式）（オプショナル）。
  final String? endDate;

  /// 開始時刻（HH:mm形式）（オプショナル）。
  final String? startTime;

  /// 終了時刻（HH:mm形式）（オプショナル）。
  final String? endTime;

  /// 引き分け得点（0点 or 1点）（オプショナル）。
  final int? drawPoints;

  /// 最大ラウンド数（オプショナル）。
  final int? maxRounds;

  /// 予定参加者数（オプショナル）。
  final int? expectedPlayers;

  /// 備考（オプショナル）。
  final String? remarks;

  /// 更新フィールドが存在するかチェックする。
  bool get hasUpdates =>
      name != null ||
      overview != null ||
      category != null ||
      tournamentMode != null ||
      date != null ||
      startDate != null ||
      endDate != null ||
      startTime != null ||
      endTime != null ||
      drawPoints != null ||
      maxRounds != null ||
      expectedPlayers != null ||
      remarks != null;

  /// JSONに変換する。
  ///
  /// nullでないフィールドのみがJSONに含まれる。
  /// Firestoreのフィールド名にマッピングする。
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
    if (tournamentMode != null) {
      json['tournamentMode'] = tournamentMode;
    }
    // date フィールドは startDate として送信（Firestoreは date を期待）
    if (date != null) {
      json['date'] = date;
    } else if (startDate != null) {
      json['date'] = startDate;
    }
    if (endDate != null) {
      json['endDate'] = endDate;
    }
    if (startTime != null) {
      json['startTime'] = startTime;
    }
    if (endTime != null) {
      json['endTime'] = endTime;
    }
    if (drawPoints != null) {
      json['drawPoints'] = drawPoints;
    }
    // maxRounds は Firestore では maxRound として保存される
    if (maxRounds != null) {
      json['maxRound'] = maxRounds;
    }
    if (expectedPlayers != null) {
      json['expectedPlayers'] = expectedPlayers;
    }
    if (remarks != null) {
      json['remarks'] = remarks;
    }

    return json;
  }
}
