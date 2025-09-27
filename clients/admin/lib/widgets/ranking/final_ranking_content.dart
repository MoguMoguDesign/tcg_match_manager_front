import 'package:base_ui/base_ui.dart';
import 'package:flutter/material.dart';

/// 最終順位表示コンテンツ
///
/// タブ内で再利用可能な最終順位表示ウィジェット
class FinalRankingContent extends StatelessWidget {
  /// 最終順位表示コンテンツのコンストラクタ
  const FinalRankingContent({super.key});

  @override
  Widget build(BuildContext context) {
    final rankings = _getRankingData();

    return ColoredBox(
      color: AppColors.backgroundLight,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 64,
          vertical: 24,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF1F3FF), // admin-card color
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // ヘッダー
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      color: AppColors.adminPrimary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      '最終順位',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '参加者: ${rankings.length}人',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textGray,
                      ),
                    ),
                  ],
                ),
              ),
              // ランキングリスト
              Expanded(
                child: ListView.builder(
                  itemCount: rankings.length,
                  itemBuilder: (context, index) {
                    final ranking = rankings[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          // 順位
                          SizedBox(
                            width: 50,
                            child: Text(
                              '${ranking.rank}位',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: _getRankColor(ranking.rank),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // プレイヤー情報
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // プレイヤー名
                                Text(
                                  ranking.playerName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textBlack,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // 累計得点とOMW%
                                Text(
                                  '累計得点 ${ranking.totalPoints}点 '
                                  'OMW% ${ranking.omwPercentage}%',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textBlack,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // 順位アイコン（上位3位のみ）
                          if (ranking.rank <= 3)
                            Icon(
                              ranking.rank == 1
                                  ? Icons.emoji_events
                                  : ranking.rank == 2
                                      ? Icons.military_tech
                                      : Icons.workspace_premium,
                              color: _getRankColor(ranking.rank),
                              size: 20,
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ランキング順位に応じた色を取得
  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // 金色
      case 2:
        return const Color(0xFFC0C0C0); // 銀色
      case 3:
        return const Color(0xFFCD7F32); // 銅色
      default:
        return AppColors.textBlack;
    }
  }

  /// ダミーデータ生成
  List<PlayerRanking> _getRankingData() {
    return [
      const PlayerRanking(
        rank: 1,
        playerName: 'プレイヤー名1',
        totalPoints: 12,
        omwPercentage: 65,
      ),
      const PlayerRanking(
        rank: 2,
        playerName: 'プレイヤー名2',
        totalPoints: 12,
        omwPercentage: 63,
      ),
      const PlayerRanking(
        rank: 3,
        playerName: 'プレイヤー名3',
        totalPoints: 12,
        omwPercentage: 60,
      ),
      const PlayerRanking(
        rank: 4,
        playerName: 'プレイヤー名4',
        totalPoints: 9,
        omwPercentage: 58,
      ),
      const PlayerRanking(
        rank: 5,
        playerName: 'プレイヤー名5',
        totalPoints: 9,
        omwPercentage: 55,
      ),
      const PlayerRanking(
        rank: 6,
        playerName: 'プレイヤー名6',
        totalPoints: 9,
        omwPercentage: 52,
      ),
      const PlayerRanking(
        rank: 7,
        playerName: 'プレイヤー名7',
        totalPoints: 6,
        omwPercentage: 48,
      ),
      const PlayerRanking(
        rank: 8,
        playerName: 'プレイヤー名8',
        totalPoints: 6,
        omwPercentage: 45,
      ),
      const PlayerRanking(
        rank: 9,
        playerName: 'プレイヤー名9',
        totalPoints: 6,
        omwPercentage: 42,
      ),
      const PlayerRanking(
        rank: 10,
        playerName: 'プレイヤー名10',
        totalPoints: 3,
        omwPercentage: 40,
      ),
      const PlayerRanking(
        rank: 11,
        playerName: 'プレイヤー名11',
        totalPoints: 3,
        omwPercentage: 38,
      ),
      const PlayerRanking(
        rank: 12,
        playerName: 'プレイヤー名12',
        totalPoints: 3,
        omwPercentage: 35,
      ),
      const PlayerRanking(
        rank: 13,
        playerName: 'プレイヤー名13',
        totalPoints: 0,
        omwPercentage: 32,
      ),
      const PlayerRanking(
        rank: 14,
        playerName: 'プレイヤー名14',
        totalPoints: 0,
        omwPercentage: 30,
      ),
      const PlayerRanking(
        rank: 15,
        playerName: 'プレイヤー名15',
        totalPoints: 0,
        omwPercentage: 28,
      ),
      const PlayerRanking(
        rank: 16,
        playerName: 'プレイヤー名16',
        totalPoints: 0,
        omwPercentage: 25,
      ),
    ];
  }
}

/// プレイヤーランキングデータクラス
class PlayerRanking {
  /// プレイヤーランキングのコンストラクタ
  const PlayerRanking({
    required this.rank,
    required this.playerName,
    required this.totalPoints,
    required this.omwPercentage,
  });

  /// 順位
  final int rank;

  /// プレイヤー名
  final String playerName;

  /// 累計得点
  final int totalPoints;

  /// OMW%
  final int omwPercentage;
}
