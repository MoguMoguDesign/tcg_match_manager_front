import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// トーナメントのラウンドタイトルを表示するマテリアルウィジェット。
///
/// 最初・中間・最後の 3 パターンを切り替えて表示する。
class TournamentTitleCards extends StatelessWidget {
  /// [TournamentTitleCards] のコンストラクタ。
  ///
  /// [title] は必須パラメータ。
  const TournamentTitleCards({
    super.key,
    required this.title,
    this.subtitle,
    this.roundType = TournamentRoundType.medium,
  });

  /// タイトルテキスト。
  final String title;

  /// サブタイトルテキスト。
  final String? subtitle;

  /// ラウンド種別。
  final TournamentRoundType roundType;

  @override
  Widget build(BuildContext context) {
    final style = _resolveStyle(roundType);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: style.border,
      ),
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.labelLarge.copyWith(color: style.titleColor),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: style.subtitleColor,
                ),
              ),
            ],
          ],
        ),
      ),
      // 末尾要素は現状なし。
    );
  }
}

/// ラウンドの種別を表す列挙型。
enum TournamentRoundType {
  /// 最初のラウンド。
  first,

  /// 中間のラウンド。
  medium,

  /// 最後のラウンド。
  last,
}

class _ResolvedStyle {
  const _ResolvedStyle({
    required this.backgroundColor,
    required this.titleColor,
    required this.subtitleColor,
    this.border,
  });

  final Color backgroundColor;
  final Color titleColor;
  final Color subtitleColor;
  final BoxBorder? border;
}

_ResolvedStyle _resolveStyle(TournamentRoundType roundType) {
  switch (roundType) {
    case TournamentRoundType.first:
      return const _ResolvedStyle(
        backgroundColor: AppColors.userPrimary,
        titleColor: AppColors.textBlack,
        subtitleColor: AppColors.textBlack,
      );
    case TournamentRoundType.medium:
      return _ResolvedStyle(
        backgroundColor: AppColors.textBlack,
        titleColor: AppColors.userPrimary,
        subtitleColor: AppColors.userPrimary,
        border: Border.all(color: AppColors.userPrimary, width: 2),
      );
    case TournamentRoundType.last:
      return const _ResolvedStyle(
        backgroundColor: AppColors.adminPrimary,
        titleColor: AppColors.white,
        subtitleColor: AppColors.white,
      );
  }
}
