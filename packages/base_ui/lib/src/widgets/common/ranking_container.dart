import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import 'ranking_row.dart';

/// ランキング一覧を表示するコンテナウィジェット。
///
/// Figma の RankingContainer に準拠し、複数の RankingRow を表示する。
class RankingContainer extends StatelessWidget {
  /// [RankingContainer] のコンストラクタ。
  const RankingContainer({
    super.key,
    required this.rankings,
    this.currentUserId,
    this.title = 'ランキング',
  });

  /// ランキングデータのリスト。
  final List<RankingData> rankings;

  /// 現在のユーザーID（このIDの行をcurrentUserとして表示）。
  final String? currentUserId;

  /// タイトル文字列。
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ヘッダー
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: AppTextStyles.headlineLarge.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // ランキングリスト
          ...rankings.asMap().entries.map((entry) {
            final index = entry.key;
            final ranking = entry.value;
            final isCurrentUser = currentUserId != null &&
                                ranking.userId == currentUserId;

            return Column(
              children: [
                if (index > 0) const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: RankingRow(
                    leftLabel: ranking.playerName,
                    rightValue: ranking.score,
                    type: isCurrentUser
                        ? RankingRowType.currentUser
                        : RankingRowType.other,
                    rankNumber: ranking.rank,
                    metaLeft: ranking.metaLeft,
                    metaRight: ranking.metaRight,
                  ),
                ),
              ],
            );
          }),

          const SizedBox(height: 16),
        ],
      );
  }
}

/// ランキングデータを表すクラス。
class RankingData {
  /// [RankingData] のコンストラクタ。
  const RankingData({
    required this.userId,
    required this.playerName,
    required this.score,
    required this.rank,
    this.metaLeft,
    this.metaRight,
  });

  /// ユーザーID。
  final String userId;

  /// プレイヤー名。
  final String playerName;

  /// スコア文字列。
  final String score;

  /// 順位。
  final int rank;

  /// 左側のメタ情報（例: 累計得点 12点）。
  final String? metaLeft;

  /// 右側のメタ情報（例: OMW% 50%）。
  final String? metaRight;
}
