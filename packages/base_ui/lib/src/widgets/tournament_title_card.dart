import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// トーナメントタイトルを表示するカードウィジェット。
///
/// Figma の TournamentTitleCard（node-id: 244-5226, 254-2411）に準拠し、
/// トーナメント名とメタ情報を統一されたスタイルで表示する。
class TournamentTitleCard extends StatelessWidget {
  /// [TournamentTitleCard] のコンストラクタ。
  ///
  /// [title] は必須パラメータ。
  /// [date] と [participantCount] は Figma デザインに合わせた情報表示用。
  const TournamentTitleCard({
    super.key,
    required this.title,
    this.subtitle,
    this.date,
    this.participantCount,
    this.style = TournamentCardStyle.primary,
  });

  /// トーナメントのタイトル。
  final String title;

  /// サブタイトル（オプション）。
  final String? subtitle;

  /// 開催日（オプション）。
  final String? date;

  /// 参加者数（オプション）。
  final int? participantCount;

  /// カードのスタイル。
  final TournamentCardStyle style;

  @override
  Widget build(BuildContext context) {
    final colors = _getStyleColors(style);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: colors.border,
        boxShadow: colors.shadow,
      ),
      child: Column(
        children: [
          // タイトル（中央寄せ）
          Text(
            title,
            style: AppTextStyles.headlineLarge.copyWith(
              color: colors.titleColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          // 区切り線
          if (date != null || participantCount != null) ...[
            const SizedBox(height: 8),
            Container(
              height: 1,
              width: double.infinity,
              color: colors.titleColor.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 8),
          ],

          // メタ情報行（日付・参加者数）
          if (date != null || participantCount != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 日付情報
                if (date != null) ...[
                  Icon(Icons.access_time, color: colors.titleColor, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    date!,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: colors.titleColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],

                // セパレーター
                if (date != null && participantCount != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 1,
                    height: 16,
                    color: colors.titleColor.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 8),
                ],

                // 参加者数情報
                if (participantCount != null) ...[
                  Icon(Icons.person, color: colors.titleColor, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '$participantCount',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: colors.titleColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),

          // レガシーサブタイトル（互換性維持）
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.subtitleColor,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  _TournamentCardColors _getStyleColors(TournamentCardStyle style) {
    switch (style) {
      case TournamentCardStyle.primary:
        return const _TournamentCardColors(
          backgroundColor: AppColors.textBlack,
          titleColor: AppColors.userPrimary,
          subtitleColor: AppColors.white,
          border: Border.fromBorderSide(
            BorderSide(color: AppColors.whiteAlpha),
          ),
          shadow: [
            BoxShadow(
              color: AppColors.gradientLightGreen,
              blurRadius: 20,
              offset: Offset(0, 4),
            ),
          ],
        );
      case TournamentCardStyle.secondary:
        return const _TournamentCardColors(
          backgroundColor: AppColors.white,
          titleColor: AppColors.textBlack,
          subtitleColor: AppColors.grayDark,
          border: Border.fromBorderSide(BorderSide(color: AppColors.gray)),
        );
      case TournamentCardStyle.admin:
        return const _TournamentCardColors(
          backgroundColor: AppColors.adminPrimary,
          titleColor: AppColors.white,
          subtitleColor: AppColors.whiteAlpha,
          shadow: [
            BoxShadow(
              color: AppColors.adminPrimaryAlpha,
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        );
    }
  }
}

/// [TournamentTitleCard] のスタイルを表す列挙型。
enum TournamentCardStyle {
  /// プライマリスタイル（ダークテーマ）。
  primary,

  /// セカンダリスタイル（ライトテーマ）。
  secondary,

  /// 管理者スタイル（アドミンテーマ）。
  admin,
}

/// トーナメントカードの色情報を保持するクラス。
class _TournamentCardColors {
  const _TournamentCardColors({
    required this.backgroundColor,
    required this.titleColor,
    required this.subtitleColor,
    this.border,
    this.shadow,
  });

  /// 背景色。
  final Color backgroundColor;

  /// タイトル色。
  final Color titleColor;

  /// サブタイトル色。
  final Color subtitleColor;

  /// 枠線定義。不要な場合は null。
  final BoxBorder? border;

  /// 影定義。不要な場合は null。
  final List<BoxShadow>? shadow;
}
