import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// プレイヤー情報を表示するコンテナウィジェット。
///
/// Figma の PlayerContainer に準拠した6種類のデザインパターンを提供。
/// Progress, Win, Lose, Progress Current User,
/// Win Current User, Lose Current User
class PlayerContainer extends StatelessWidget {
  /// [PlayerContainer] のコンストラクタ。
  ///
  /// [playerName] は必須パラメータ。
  const PlayerContainer({
    super.key,
    required this.playerName,
    this.score = '累計得点 0点',
    this.state = PlayerState.progress,
    this.isCurrentUser = false,
  });

  /// プレイヤー名。
  final String playerName;

  /// スコア表示（累計得点など）。
  final String score;

  /// プレイヤーの状態。
  final PlayerState state;

  /// 現在のユーザーかどうか。
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    final colors = _getStateColors(state, isCurrentUser);
    final showWinLabel = state == PlayerState.win;
    final showLoseLabel = state == PlayerState.lose;

    return SizedBox(
      height: 57, // VSContainerと高さを統一
      child: DecoratedBox(
      decoration: BoxDecoration(color: colors.backgroundColor),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // プレイヤー名
                Text(
                  playerName,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: colors.textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                // スコア
                Text(
                  score,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colors.textColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // WIN ラベル（勝利時のみ）
          if (showWinLabel)
            Positioned(
              right: 0,
              bottom: 0,
              child: Text(
                'WIN',
                style: AppTextStyles.headlineLarge.copyWith(
                  color: colors.winLabelColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          // LOSE ラベル（敗北時のみ）
          if (showLoseLabel)
            Positioned(
              right: 0,
              bottom: 0,
              child: Text(
                'LOSE',
                style: AppTextStyles.headlineLarge.copyWith(
                  color: colors.loseLabelColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      ),
    );
  }

  _PlayerContainerColors _getStateColors(
    PlayerState state,
    bool isCurrentUser,
  ) {
    if (isCurrentUser) {
      // Current User パターン
      switch (state) {
        case PlayerState.progress:
          return const _PlayerContainerColors(
            backgroundColor: AppColors.adminPrimary, // #3A44FB
            textColor: AppColors.white,
          );
        case PlayerState.win:
          return const _PlayerContainerColors(
            backgroundColor: AppColors.adminPrimary, // #3A44FB
            textColor: AppColors.white,
            winLabelColor: AppColors.whiteLightAlpha, // 透明な白
          );
        case PlayerState.lose:
          return const _PlayerContainerColors(
            backgroundColor: AppColors.adminPrimary, // #3A44FB (青色)
            textColor: AppColors.white,
            loseLabelColor: AppColors.whiteLightAlpha, // 透明な白
          );
      }
    } else {
      // 通常のユーザーパターン
      switch (state) {
        case PlayerState.progress:
          return const _PlayerContainerColors(
            backgroundColor: AppColors.textBlack, // #000336
            textColor: AppColors.white,
          );
        case PlayerState.win:
          return const _PlayerContainerColors(
            backgroundColor: AppColors.userPrimaryAlpha, // 落ち着いた緑色（透明度20%）
            textColor: AppColors.white,
            winLabelColor: AppColors.whiteLightAlpha, // 透明な白
          );
        case PlayerState.lose:
          return const _PlayerContainerColors(
            backgroundColor: AppColors.adminPrimaryAlpha, // 管理者色透明度版
            textColor: AppColors.white,
            loseLabelColor: AppColors.whiteLightAlpha, // 透明な白
          );
      }
    }
  }
}

/// プレイヤーの状態を表す列挙型。
enum PlayerState {
  /// 進行中。
  progress,

  /// 勝利。
  win,

  /// 敗北。
  lose,
}

/// プレイヤーコンテナの色情報を保持するクラス。
class _PlayerContainerColors {
  const _PlayerContainerColors({
    required this.backgroundColor,
    required this.textColor,
    this.winLabelColor,
    this.loseLabelColor,
  });

  /// 背景色。
  final Color backgroundColor;

  /// テキスト色。
  final Color textColor;

  /// WIN ラベルの色（勝利時のみ）。
  final Color? winLabelColor;

  /// LOSE ラベルの色（敗北時のみ）。
  final Color? loseLabelColor;
}
