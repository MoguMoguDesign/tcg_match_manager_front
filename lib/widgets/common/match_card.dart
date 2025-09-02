import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../models/mock_data.dart';

/// 対戦カードを表示するウィジェット。
///
/// 対戦の詳細情報、プレイヤー情報、試合結果を表示する。
class MatchCard extends StatelessWidget {
  /// [MatchCard] のコンストラクタ。
  ///
  /// [match] は表示する対戦情報。
  /// [onResultTap] は結果タップ時のコールバック（オプション）。
  const MatchCard({super.key, required this.match, this.onResultTap});

  /// 表示する対戦情報。
  final Match match;
  
  /// 結果がタップされた時のコールバック。
  final VoidCallback? onResultTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          // テーブル番号とステータス
          Column(
            children: [
              Text('${match.tableNumber}卓', style: AppTextStyles.labelMedium),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: match.status == MatchStatus.ongoing
                        ? AppColors.primary
                        : AppColors.whiteAlpha,
                  ),
                ),
                child: Text(
                  match.status == MatchStatus.ongoing ? '対戦中' : '終了',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: match.status == MatchStatus.ongoing
                        ? AppColors.primary
                        : AppColors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          // 対戦カード
          Expanded(
            child: Row(
              children: [
                // プレイヤー1
                Expanded(
                  child: _buildPlayerCard(
                    match.player1,
                    match.winner == match.player1,
                    isLeft: true,
                  ),
                ),
                // VS 表示（斜めデザイン）。
                SizedBox(
                  width: 20,
                  height: 57,
                  child: Transform.rotate(
                    angle: -0.78539816339, // -45 度。
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppColors.primary, AppColors.adminPrimary],
                        ),
                      ),
                      child: Center(
                        child: Transform.rotate(
                          angle: 0.78539816339, // テキストを読みやすく戻す。
                          child: Text(
                            'vs',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // プレイヤー2
                Expanded(
                  child: _buildPlayerCard(
                    match.player2,
                    match.winner == match.player2,
                    isLeft: false,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCard(
    Player player,
    bool isWinner, {
    required bool isLeft,
  }) {
    Color backgroundColor;
    String? resultText;

    if (match.status == MatchStatus.completed) {
      if (isWinner) {
        backgroundColor = player.isCurrentPlayer
            ? AppColors.primaryAlpha
            : AppColors.primaryAlpha;
        resultText = 'WIN';
      } else {
        backgroundColor = player.isCurrentPlayer
            ? AppColors.adminAlpha
            : AppColors.adminAlpha;
        resultText = 'LOSE';
      }
    } else {
      backgroundColor = player.isCurrentPlayer
          ? AppColors.adminPrimary
          : AppColors.textBlack;
    }

    return Container(
      height: 57,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: isLeft
            ? const BorderRadius.only(
                topLeft: Radius.circular(4),
                bottomLeft: Radius.circular(4),
              )
            : const BorderRadius.only(
                topRight: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                player.name,
                style: AppTextStyles.labelMedium.copyWith(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
              Text('累計得点 ${player.score}点', style: AppTextStyles.bodySmall),
            ],
          ),
          if (resultText != null)
            Positioned(
              right: 4,
              bottom: 4,
              child: Text(
                resultText,
                style: AppTextStyles.headlineLarge.copyWith(
                  color: AppColors.whiteAlpha,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
