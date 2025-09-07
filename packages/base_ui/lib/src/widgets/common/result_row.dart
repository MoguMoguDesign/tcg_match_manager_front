import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

/// 試合結果の 1 行を表示するウィジェット。
///
/// Figma の ResultRow に準拠し、現在ユーザーとその他で配色などを出し分ける。
class ResultRow extends StatelessWidget {
  /// [ResultRow] のコンストラクタ。
  ///
  /// [leftLabel]、[rightValue] は必須パラメータ。
  const ResultRow({
    super.key,
    required this.leftLabel,
    required this.rightValue,
    this.subtitle,
    this.type = ResultRowType.other,
  });

  /// 左側のラベル文字列。
  final String leftLabel;

  /// 右側の値文字列。
  final String rightValue;

  /// サブテキスト（オプション）。
  final String? subtitle;

  /// 行の種別。
  final ResultRowType type;

  @override
  Widget build(BuildContext context) {
    final style = _resolveStyle(type);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: style.border,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  leftLabel,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: style.leftColor,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: style.subColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            rightValue,
            style: AppTextStyles.labelLarge.copyWith(color: style.rightColor),
          ),
        ],
      ),
    );
  }
}

// EOF

/// 行の種別を表す列挙型。
enum ResultRowType {
  /// 現在のユーザーの行。
  currentUser,

  /// その他の行。
  other,
}

class _ResolvedStyle {
  const _ResolvedStyle({
    required this.backgroundColor,
    required this.leftColor,
    required this.rightColor,
    required this.subColor,
    this.border,
  });

  final Color backgroundColor;
  final Color leftColor;
  final Color rightColor;
  final Color subColor;
  final BoxBorder? border;
}

_ResolvedStyle _resolveStyle(ResultRowType type) {
  switch (type) {
    case ResultRowType.currentUser:
      return const _ResolvedStyle(
        backgroundColor: AppColors.userPrimary,
        leftColor: AppColors.textBlack,
        rightColor: AppColors.textBlack,
        subColor: AppColors.textBlack,
      );
    case ResultRowType.other:
      return _ResolvedStyle(
        backgroundColor: AppColors.textBlack,
        leftColor: AppColors.userPrimary,
        rightColor: AppColors.userPrimary,
        subColor: AppColors.userPrimary,
        border: Border.all(color: AppColors.userPrimary, width: 2),
      );
  }
}
