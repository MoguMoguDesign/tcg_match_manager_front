/// トーナメント表示用のデータクラス
class TournamentDisplayData {
  /// トーナメント表示データのコンストラクタ
  const TournamentDisplayData({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.currentParticipants,
    required this.maxParticipants,
    required this.gameType,
    required this.status,
    this.currentRound,
    this.description,
  });

  /// トーナメントID
  final String id;

  /// トーナメントタイトル
  final String title;

  /// 開催日（表示用）
  final String date;

  /// 開催時間（表示用）
  final String time;

  /// 現在の参加者数
  final int currentParticipants;

  /// 最大参加者数
  final int maxParticipants;

  /// ゲームタイプ（例：ポケカ）
  final String gameType;

  /// トーナメントステータス
  final TournamentStatus status;

  /// 現在のラウンド（開催中のみ）
  final int? currentRound;

  /// 大会の説明（オプション）
  final String? description;

  /// 表示用の参加者情報
  String get participantInfo => '$currentParticipants/$maxParticipants';

  /// 表示用の日時情報
  String get dateTimeInfo => '$date $time';
}

/// トーナメントステータス
enum TournamentStatus {
  /// 開催前
  upcoming('開催前'),

  /// 開催中
  ongoing('ラウンド進行中'),

  /// 開催済
  completed('開催済');

  const TournamentStatus(this.displayName);

  /// 表示名
  final String displayName;
}
