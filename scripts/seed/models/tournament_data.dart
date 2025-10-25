/// トーナメント投入データの全体を表す。
class TournamentData {
  /// コンストラクタ。
  TournamentData({
    required this.tournamentId,
    required this.tournament,
    required this.players,
    required this.rounds,
  });

  /// トーナメント ID。
  final String tournamentId;

  /// トーナメントドキュメント。
  final Map<String, dynamic> tournament;

  /// プレイヤーデータのリスト。
  final List<PlayerData> players;

  /// ラウンドデータのリスト。
  final List<RoundData> rounds;

  /// データの整合性を検証する。
  ValidationResult validate() {
    final errors = <String>[];

    // プレイヤー数の整合性チェック
    final playerCount = tournament['playerCount'] as int?;
    if (playerCount != null && playerCount != players.length) {
      errors.add('プレイヤー数が不一致: '
          'トーナメント=$playerCount, 実際=${players.length}');
    }

    // ラウンド数の整合性チェック
    final currentRound = tournament['currentRound'] as int?;
    if (currentRound != null && currentRound > rounds.length) {
      errors.add('ラウンド数が不一致: '
          '現在ラウンド=$currentRound, 実際=${rounds.length}');
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }
}

/// プレイヤー投入データ。
class PlayerData {
  /// コンストラクタ。
  PlayerData({
    required this.id,
    required this.data,
  });

  /// プレイヤードキュメント ID。
  final String id;

  /// プレイヤードキュメントデータ。
  final Map<String, dynamic> data;
}

/// ラウンド投入データ。
class RoundData {
  /// コンストラクタ。
  RoundData({
    required this.id,
    required this.data,
    required this.matches,
  });

  /// ラウンドドキュメント ID（例: "round1"）。
  final String id;

  /// ラウンドドキュメントデータ。
  final Map<String, dynamic> data;

  /// マッチデータのリスト。
  final List<MatchData> matches;
}

/// マッチ投入データ。
class MatchData {
  /// コンストラクタ。
  MatchData({
    required this.id,
    required this.data,
  });

  /// マッチドキュメント ID。
  final String id;

  /// マッチドキュメントデータ。
  final Map<String, dynamic> data;
}

/// 検証結果。
class ValidationResult {
  /// コンストラクタ。
  ValidationResult({
    required this.isValid,
    required this.errors,
  });

  /// 検証が成功したかどうか。
  final bool isValid;

  /// エラーメッセージのリスト。
  final List<String> errors;
}
