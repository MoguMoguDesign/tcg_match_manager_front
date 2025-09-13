import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import 'match_status_container.dart';

/// テーブル番号とステータスを表示する縦並びウィジェット。
///
/// Figma の Table Number column（node-id: 244-5517）に準拠し、
/// 上段に「1卓」、下段に [MatchStatusContainer]（Progress/Finished）を表示する。
class TableNumberColumn extends StatelessWidget {
  /// [TableNumberColumn] のコンストラクタ。
  const TableNumberColumn({
    super.key,
    required this.tableNumber,
    this.status = MatchStatus.playing,
  });

  /// テーブル番号。
  final int tableNumber;

  /// マッチステータス（Progress/Finished）。
  final MatchStatus status;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$tableNumber卓',
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 3),
        MatchStatusContainer(status: status),
      ],
    );
  }
}
