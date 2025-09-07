import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

/// マッチリストのヘッダー部分を表示するウィジェット。
///
/// Figma の MatchListHeader（node-id: 253-6083）に準拠し、
/// カラム見出しを統一されたスタイルで表示する。
class MatchListHeader extends StatelessWidget {
  /// [MatchListHeader] のコンストラクタ。
  const MatchListHeader({
    super.key,
    this.style = MatchListHeaderStyle.primary,
    this.showTable = true,
    this.showPlayers = true,
    this.showStatus = true,
  });

  /// ヘッダーのスタイル。
  final MatchListHeaderStyle style;

  /// テーブル列を表示するかどうか。
  final bool showTable;

  /// プレイヤー列を表示するかどうか。
  final bool showPlayers;

  /// ステータス列を表示するかどうか。
  final bool showStatus;

  @override
  Widget build(BuildContext context) {
    final colors = _getStyleColors(style);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colors.borderColor,
        ),
      ),
      child: Row(
        children: [
          if (showTable) ...[
            SizedBox(
              width: 64,
              child: Text(
                'TABLE',
                style: AppTextStyles.labelSmall.copyWith(
                  color: colors.textColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 16),
          ],
          if (showPlayers) ...[
            Expanded(
              child: Text(
                'PLAYERS',
                style: AppTextStyles.labelSmall.copyWith(
                  color: colors.textColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 16),
          ],
          if (showStatus) ...[
            SizedBox(
              width: 80,
              child: Text(
                'STATUS',
                style: AppTextStyles.labelSmall.copyWith(
                  color: colors.textColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }

  _MatchListHeaderColors _getStyleColors(MatchListHeaderStyle style) {
    switch (style) {
      case MatchListHeaderStyle.primary:
        return const _MatchListHeaderColors(
          backgroundColor: AppColors.textBlack,
          textColor: AppColors.white,
          borderColor: AppColors.whiteAlpha,
        );
      case MatchListHeaderStyle.secondary:
        return const _MatchListHeaderColors(
          backgroundColor: AppColors.grayLight,
          textColor: AppColors.textBlack,
          borderColor: AppColors.gray,
        );
      case MatchListHeaderStyle.admin:
        return const _MatchListHeaderColors(
          backgroundColor: AppColors.adminPrimary,
          textColor: AppColors.white,
          borderColor: AppColors.adminPrimary,
        );
    }
  }
}

/// [MatchListHeader] のスタイルを表す列挙型。
enum MatchListHeaderStyle {
  /// プライマリスタイル（ダークテーマ）。
  primary,

  /// セカンダリスタイル（ライトテーマ）。
  secondary,

  /// 管理者スタイル。
  admin,
}

/// マッチリストヘッダーの色情報を保持するクラス。
class _MatchListHeaderColors {
  const _MatchListHeaderColors({
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
  });

  /// 背景色。
  final Color backgroundColor;

  /// テキスト色。
  final Color textColor;

  /// 境界線色。
  final Color borderColor;
}
