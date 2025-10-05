import 'package:repository/repository.dart' as repo;

/// 最終順位情報。
class Standing {
  /// [Standing] を生成する。
  const Standing({
    required this.calculatedAt,
    required this.rankings,
  });

  /// Repository モデルから [Standing] を生成する。
  factory Standing.fromRepositoryModel(repo.StandingResponse repoStanding) {
    return Standing(
      calculatedAt: repoStanding.calculatedAt,
      rankings: repoStanding.rankings
          .map((repoRanking) => RankingDetail.fromRepositoryModel(repoRanking))
          .toList(),
    );
  }

  /// 計算日時。
  final String calculatedAt;

  /// 順位表。
  final List<RankingDetail> rankings;
}

/// 順位詳細情報。
class RankingDetail {
  /// [RankingDetail] を生成する。
  const RankingDetail({
    required this.rank,
    required this.playerName,
    required this.matchPoints,
    required this.omwPercentage,
  });

  /// Repository モデルから [RankingDetail] を生成する。
  factory RankingDetail.fromRepositoryModel(repo.Ranking repoRanking) {
    return RankingDetail(
      rank: repoRanking.rank,
      playerName: repoRanking.playerName,
      matchPoints: repoRanking.matchPoints,
      omwPercentage: repoRanking.omwPercentage,
    );
  }

  /// 順位。
  final int rank;

  /// プレイヤー名。
  final String playerName;

  /// 累計勝ち点。
  final int matchPoints;

  /// OMWP（Opponent Match Win Percentage）。
  final double omwPercentage;
}
