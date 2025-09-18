import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import 'vs_container.dart';

/// ランキングの 1 行を表示するウィジェット。
///
/// Figma の RankingRow に準拠し、現在ユーザーとその他で配色などを出し分ける。
class RankingRow extends StatelessWidget {
  /// [RankingRow] のコンストラクタ。
  ///
  /// [leftLabel]、[rightValue] は必須パラメータ。
  const RankingRow({
    super.key,
    required this.leftLabel,
    required this.rightValue,
    this.subtitle,
    this.type = RankingRowType.other,
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
  final RankingRowType type;

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

    return SizedBox(
      height: 60,
      child: Row(
        children: [
          if (rankNumber != null) ...[
            SizedBox(
              width: 40,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  '${rankNumber!}位',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],

          // 右側本体（順位ブロックと分離してクリップする）。
          Expanded(
            child: ClipPath(
              clipper: _RankingRowClipper(),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: style.backgroundColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        leftLabel,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: style.textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      _buildMetaOrSubtitle(style),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaOrSubtitle(_ResolvedStyle style) {
    // メタ情報が両方与えられた場合は、区切り線で分割して表示する。
    if (metaLeft != null && metaRight != null) {
      return Row(
        children: [
          Flexible(
            child: Text(
              metaLeft!,
              style: AppTextStyles.bodySmall.copyWith(
                color: style.subTextColor,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Container(height: 16, width: 1, color: style.subTextColor),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              metaRight!,
              style: AppTextStyles.bodySmall.copyWith(
                color: style.subTextColor,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    // それ以外は従来どおりサブタイトルを表示する。
    if (subtitle != null) {
      return Text(
        subtitle!,
        style: AppTextStyles.bodySmall.copyWith(
          color: style.subTextColor,
          fontSize: 12,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

// ファイル末尾。

/// 行の種別を表す列挙型。
enum RankingRowType {
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
  });

  final Color backgroundColor;
  final Color textColor;
  final Color subTextColor;
}

_ResolvedStyle _resolveStyle(RankingRowType type) {
  switch (type) {
    case RankingRowType.currentUser:
      return const _ResolvedStyle(
        backgroundColor: AppColors.adminPrimary,
        textColor: AppColors.white,
        subTextColor: AppColors.white,
      );
    case RankingRowType.other:
      return const _ResolvedStyle(
        backgroundColor: Colors.transparent,
        textColor: AppColors.white,
        subTextColor: AppColors.white,
      );
  }
}

/// 左端を斜めにカットする [CustomClipper]。
class _RankingRowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, 0) // 左上
      ..lineTo(size.width, 0) // 右上
      ..lineTo(size.width, size.height) // 右下
      ..lineTo(20, size.height) // 左下から 20px 内側
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
