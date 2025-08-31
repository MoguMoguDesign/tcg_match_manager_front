import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../models/ranking.dart';

class RankingCard extends StatelessWidget {
  const RankingCard({
    super.key,
    required this.player,
  });

  final RankingPlayer player;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          // 順位
          Container(
            width: 40,
            alignment: Alignment.centerLeft,
            child: Text(
              '${player.rank}位',
              style: AppTextStyles.labelMedium,
            ),
          ),
          // グラデーション装飾
          Container(
            width: 20,
            height: 57,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary,
                  AppColors.adminPrimary,
                ],
              ),
            ),
          ),
          // プレイヤー情報
          Expanded(
            child: Container(
              height: 57,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: player.isCurrentPlayer 
                    ? AppColors.adminPrimary
                    : AppColors.textBlack,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.name,
                    style: AppTextStyles.labelMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        '累計得点 ${player.score}点',
                        style: AppTextStyles.bodySmall,
                      ),
                      Container(
                        width: 1,
                        height: 16,
                        color: AppColors.white,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      Text(
                        'OMW% ${player.omwPercentage.toInt()}%',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}