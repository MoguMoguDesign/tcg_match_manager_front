import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import 'vs_container.dart';

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
    this.rankNumber,
    this.metaLeft,
    this.metaRight,
    this.vsState = VSContainerState.progress,
    this.vsCurrentUserPosition = VSContainerUserPosition.none,
  });

  /// 左側のラベル文字列。
  final String leftLabel;

  /// 右側の値文字列。
  final String rightValue;

  /// サブテキスト（オプション）。
  final String? subtitle;

  /// 行の種別。
  final ResultRowType type;

  /// ランキングの番号。表示する場合は「1位」の形式で描画する。
  final int? rankNumber;

  /// 左側のメタ情報（例: 累計得点 12点）。
  final String? metaLeft;

  /// 右側のメタ情報（例: OMW% 50%）。
  final String? metaRight;

  /// VS コンテナの状態。
  final VSContainerState vsState;

  /// VS コンテナにおける現在ユーザーの位置。
  final VSContainerUserPosition vsCurrentUserPosition;

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
          if (rankNumber != null) ...[
            Text(
              '${rankNumber!}位',
              style: AppTextStyles.labelLarge.copyWith(
                color: style.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 12),
          ],

          // VS コンテナ（Figma: 20x57）。
          const SizedBox(width: 0),
          VSContainer(
            state: vsState,
            currentUserPosition: vsCurrentUserPosition,
          ),
          const SizedBox(width: 8),

          // プレイヤー情報。
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    leftLabel,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: style.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  _buildMetaOrSubtitle(style),
                ],
              ),
            ),
          ),

          // 右側の値。
          Text(
            rightValue,
            style: AppTextStyles.labelLarge.copyWith(color: style.textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaOrSubtitle(_ResolvedStyle style) {
    // メタ情報が両方与えられた場合は、区切り線で分割して表示する。
    if (metaLeft != null && metaRight != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            metaLeft!,
            style: AppTextStyles.bodySmall.copyWith(color: style.subTextColor),
          ),
          const SizedBox(width: 8),
          const SizedBox(
            height: 16,
            child: VerticalDivider(
              color: AppColors.white,
              thickness: 1,
              width: 1,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            metaRight!,
            style: AppTextStyles.bodySmall.copyWith(color: style.subTextColor),
          ),
        ],
      );
    }

    // それ以外は従来どおりサブタイトルを表示する。
    if (subtitle != null) {
      return Text(
        subtitle!,
        style: AppTextStyles.bodySmall.copyWith(color: style.subTextColor),
      );
    }

    return const SizedBox.shrink();
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
    required this.textColor,
    required this.subTextColor,
    this.border,
  });

  final Color backgroundColor;
  final Color textColor;
  final Color subTextColor;
  final BoxBorder? border;
}

_ResolvedStyle _resolveStyle(ResultRowType type) {
  switch (type) {
    case ResultRowType.currentUser:
      return const _ResolvedStyle(
        backgroundColor: AppColors.adminPrimary,
        textColor: AppColors.white,
        subTextColor: AppColors.white,
      );
    case ResultRowType.other:
      return _ResolvedStyle(
        backgroundColor: AppColors.textBlack,
        textColor: AppColors.userPrimary,
        subTextColor: AppColors.userPrimary,
        border: Border.all(color: AppColors.userPrimary),
      );
  }
}
