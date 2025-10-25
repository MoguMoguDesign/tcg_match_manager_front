import '../models/tournament_data.dart';

/// トーナメントデータ生成の抽象基底クラス。
abstract class TournamentGenerator {
  /// トーナメントデータを生成する。
  TournamentData generate();

  /// トーナメント ID を生成する。
  String generateTournamentId();

  /// プレイヤー ID を生成する。
  ///
  /// [index] プレイヤーのインデックス（0 始まり）。
  String generatePlayerId(int index) {
    return 'test-player-${(index + 1).toString().padLeft(3, '0')}';
  }

  /// ユーザー ID を生成する。
  ///
  /// [index] プレイヤーのインデックス（0 始まり）。
  String generateUserId(int index) {
    return 'test-user-${(index + 1).toString().padLeft(3, '0')}';
  }

  /// マッチ ID を生成する。
  ///
  /// [roundNumber] ラウンド番号。
  /// [matchNumber] マッチ番号。
  String generateMatchId(int roundNumber, int matchNumber) {
    return 'match-round$roundNumber-$matchNumber';
  }

  /// タイムスタンプを ISO8601 形式で生成する。
  ///
  /// [offsetDays] 現在時刻からの日数オフセット。
  /// [offsetHours] 現在時刻からの時間オフセット。
  String generateTimestamp({int offsetDays = 0, int offsetHours = 0}) {
    final now = DateTime.now().toUtc();
    final offset = now.add(Duration(days: offsetDays, hours: offsetHours));
    return offset.toIso8601String();
  }

  /// ラウンド ID を生成する。
  ///
  /// [roundNumber] ラウンド番号（1 始まり）。
  String generateRoundId(int roundNumber) {
    return 'round$roundNumber';
  }
}
