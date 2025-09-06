import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

/// プレイヤー情報を表示するコンテナウィジェット。
///
/// Figma の PlayerContainer（node-id: 244-5574）に準拠し、
/// プレイヤー名とメタ情報を統一されたスタイルで表示する。
class PlayerContainer extends StatelessWidget {
  /// [PlayerContainer] のコンストラクタ。
  ///
  /// [playerName] は必須パラメータ。
  const PlayerContainer({
    super.key,
    required this.playerName,
    this.playerNumber,
    this.isWinner = false,
    this.showBorder = true,
    this.style = PlayerContainerStyle.primary,
  });

  /// プレイヤー名。
  final String playerName;

  /// プレイヤー番号（オプション）。
  final int? playerNumber;

  /// 勝者かどうか。
  final bool isWinner;

  /// 境界線を表示するかどうか。
  final bool showBorder;

  /// コンテナのスタイル。
  final PlayerContainerStyle style;

  @override
  Widget build(BuildContext context) {
    final colors = _getStyleColors(style, isWinner);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: showBorder ? Border.all(
          color: colors.borderColor,
          width: isWinner ? 2 : 1,
        ) : null,
        boxShadow: isWinner ? colors.shadow : null,
      ),
      child: Row(
        children: [
          if (playerNumber != null) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: colors.numberBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  playerNumber.toString(),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: colors.numberTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              playerName,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textColor,
                fontSize: 16,
                fontWeight: isWinner ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          if (isWinner) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.emoji_events,
              color: colors.winnerIconColor,
              size: 20,
            ),
          ],
        ],
      ),
    );
  }

  _PlayerContainerColors _getStyleColors(
    PlayerContainerStyle style, 
    bool isWinner,
  ) {
    switch (style) {
      case PlayerContainerStyle.primary:
        return _PlayerContainerColors(
          backgroundColor: isWinner 
              ? AppColors.userPrimaryAlpha 
              : AppColors.textBlack,
          textColor: isWinner 
              ? AppColors.textBlack 
              : AppColors.white,
          borderColor: isWinner 
              ? AppColors.userPrimary 
              : AppColors.whiteAlpha,
          numberBackgroundColor: isWinner 
              ? AppColors.userPrimary 
              : AppColors.gray,
          numberTextColor: AppColors.textBlack,
          winnerIconColor: AppColors.userPrimary,
          shadow: isWinner ? [
            const BoxShadow(
              color: Color(0xFFD8FF62),
              blurRadius: 12,
              offset: Offset(0, 2),
            ),
          ] : null,
        );
      case PlayerContainerStyle.secondary:
        return _PlayerContainerColors(
          backgroundColor: isWinner 
              ? AppColors.adminPrimaryAlpha 
              : AppColors.white,
          textColor: AppColors.textBlack,
          borderColor: isWinner 
              ? AppColors.adminPrimary 
              : AppColors.gray,
          numberBackgroundColor: isWinner 
              ? AppColors.adminPrimary 
              : AppColors.grayLight,
          numberTextColor: isWinner 
              ? AppColors.white 
              : AppColors.textBlack,
          winnerIconColor: AppColors.adminPrimary,
          shadow: isWinner ? [
            BoxShadow(
              color: AppColors.adminPrimary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ] : null,
        );
    }
  }
}

/// [PlayerContainer] のスタイルを表す列挙型。
enum PlayerContainerStyle {
  /// プライマリスタイル（ダークテーマ）。
  primary,

  /// セカンダリスタイル（ライトテーマ）。
  secondary,
}

/// プレイヤーコンテナの色情報を保持するクラス。
class _PlayerContainerColors {
  const _PlayerContainerColors({
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    required this.numberBackgroundColor,
    required this.numberTextColor,
    required this.winnerIconColor,
    this.shadow,
  });

  /// 背景色。
  final Color backgroundColor;

  /// テキスト色。
  final Color textColor;

  /// 境界線色。
  final Color borderColor;

  /// 番号背景色。
  final Color numberBackgroundColor;

  /// 番号テキスト色。
  final Color numberTextColor;

  /// 勝者アイコン色。
  final Color winnerIconColor;

  /// 影定義。不要な場合は null。
  final List<BoxShadow>? shadow;
}
