import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

/// マッチリストのヘッダー部分を表示するウィジェット。
///
/// Figma の MatchListHeader（node-id: 253-6083）に準拠し、
/// ラウンドヘッダーと対戦表情報を表示する。
class MatchListHeader extends StatelessWidget {
  /// [MatchListHeader] のコンストラクタ。
  const MatchListHeader({
    super.key,
    required this.roundNumber,
    this.maxRounds = 6,
  });

  /// ラウンド番号。
  final int roundNumber;

  /// 最大ラウンド数。
  final int maxRounds;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ラウンドヘッダー部分
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: const BoxDecoration(
            color: AppColors.userPrimaryAlpha,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Center(
            child: Text(
              'ラウンド$roundNumber',
              style: AppTextStyles.headlineLarge.copyWith(
                color: AppColors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // ラウンド情報部分
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '対戦表',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.white,
                ),
              ),
              Text(
                '最大$maxRoundsラウンド',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
