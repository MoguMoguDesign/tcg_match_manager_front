// ランキング表示用の英語ラベル使用を許可
// ignore_for_file: avoid_hardcoded_japanese

/// ランキング表示用のプレイヤー情報を表すデータクラス。
///
/// 順位、名前、スコア、OMW パーセンテージ、現在のユーザーかどうかの情報を保持する。
class RankingPlayer {
  /// [RankingPlayer]のコンストラクタ。
  ///
  /// [rank]、[name]、[score]、[omwPercentage]は必須パラメータ。
  /// [isCurrentPlayer]はオプションでデフォルトは`false`。
  const RankingPlayer({
    required this.rank,
    required this.name,
    required this.score,
    required this.omwPercentage,
    this.isCurrentPlayer = false,
  });

  /// プレイヤーの順位。
  final int rank;

  /// プレイヤーの名前。
  final String name;

  /// プレイヤーの現在のスコア。
  final int score;

  /// プレイヤーの OMW（Opponent Match Win）パーセンテージ。
  final double omwPercentage;

  /// このプレイヤーが現在のユーザーかどうか。
  final bool isCurrentPlayer;
}

/// ランキング用のモックデータを提供するクラス。
///
/// 最終ランキング表示のためのサンプルデータを定義する。
class MockRankingData {
  /// 最終ランキングのプレイヤー一覧。
  /// 現在のユーザーを含む6名のランキングデータ。
  static const List<RankingPlayer> finalRanking = [
    RankingPlayer(
      rank: 1,
      name: 'サトシ',
      score: 12,
      omwPercentage: 50,
      isCurrentPlayer: true,
    ),
    RankingPlayer(rank: 2, name: 'プレイヤー1', score: 12, omwPercentage: 50),
    RankingPlayer(rank: 3, name: 'プレイヤー2', score: 9, omwPercentage: 45),
    RankingPlayer(rank: 4, name: 'プレイヤー3', score: 9, omwPercentage: 42),
    RankingPlayer(rank: 5, name: 'プレイヤー4', score: 6, omwPercentage: 38),
    RankingPlayer(rank: 6, name: 'プレイヤー5', score: 3, omwPercentage: 35),
  ];
}
