class RankingPlayer {
  final int rank;
  final String name;
  final int score;
  final double omwPercentage;
  final bool isCurrentPlayer;
  
  const RankingPlayer({
    required this.rank,
    required this.name,
    required this.score,
    required this.omwPercentage,
    this.isCurrentPlayer = false,
  });
}

class MockRankingData {
  static const List<RankingPlayer> finalRanking = [
    RankingPlayer(
      rank: 1,
      name: 'プレイヤー自身',
      score: 12,
      omwPercentage: 50.0,
      isCurrentPlayer: true,
    ),
    RankingPlayer(
      rank: 2,
      name: 'プレイヤー1',
      score: 12,
      omwPercentage: 50.0,
    ),
    RankingPlayer(
      rank: 3,
      name: 'プレイヤー2',
      score: 9,
      omwPercentage: 45.0,
    ),
    RankingPlayer(
      rank: 4,
      name: 'プレイヤー3',
      score: 9,
      omwPercentage: 42.0,
    ),
    RankingPlayer(
      rank: 5,
      name: 'プレイヤー4',
      score: 6,
      omwPercentage: 38.0,
    ),
    RankingPlayer(
      rank: 6,
      name: 'プレイヤー5',
      score: 3,
      omwPercentage: 35.0,
    ),
  ];
}