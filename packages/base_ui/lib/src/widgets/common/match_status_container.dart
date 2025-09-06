import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

/// マッチステータスを表示するコンテナウィジェット。
///
/// Figma の MatchStatusContainer（node-id: 244-5549）に準拠し、
/// 試合の進行状況や結果を視覚的に表示する。
class MatchStatusContainer extends StatelessWidget {
  /// [MatchStatusContainer] のコンストラクタ。
  ///
  /// [status] は必須パラメータ。
  const MatchStatusContainer({
    super.key,
    required this.status,
    this.showBorder = true,
  });

  /// マッチのステータス。
  final MatchStatus status;

  /// 境界線を表示するかどうか。
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final statusInfo = _getStatusInfo(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: statusInfo.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: showBorder ? Border.all(
          color: statusInfo.borderColor,
        ) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (statusInfo.icon != null) ...[
            Icon(
              statusInfo.icon,
              color: statusInfo.textColor,
              size: 16,
            ),
            const SizedBox(width: 6),
          ],
          Text(
            statusInfo.label,
            style: AppTextStyles.labelSmall.copyWith(
              color: statusInfo.textColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  _MatchStatusInfo _getStatusInfo(MatchStatus status) {
    switch (status) {
      case MatchStatus.waiting:
        return const _MatchStatusInfo(
          label: '待機中',
          backgroundColor: AppColors.gray,
          textColor: AppColors.white,
          borderColor: AppColors.grayDark,
          icon: Icons.schedule,
        );
      case MatchStatus.playing:
        return const _MatchStatusInfo(
          label: '進行中',
          backgroundColor: AppColors.userPrimary,
          textColor: AppColors.textBlack,
          borderColor: AppColors.userPrimary,
          icon: Icons.play_arrow,
        );
      case MatchStatus.finished:
        return const _MatchStatusInfo(
          label: '終了',
          backgroundColor: AppColors.adminPrimary,
          textColor: AppColors.white,
          borderColor: AppColors.adminPrimary,
          icon: Icons.check_circle,
        );
      case MatchStatus.cancelled:
        return const _MatchStatusInfo(
          label: 'キャンセル',
          backgroundColor: Colors.red,
          textColor: AppColors.white,
          borderColor: Colors.redAccent,
          icon: Icons.cancel,
        );
      case MatchStatus.paused:
        return const _MatchStatusInfo(
          label: '一時停止',
          backgroundColor: Colors.orange,
          textColor: AppColors.white,
          borderColor: Colors.deepOrange,
          icon: Icons.pause,
        );
    }
  }
}

/// マッチステータスを表す列挙型。
enum MatchStatus {
  /// 待機中。
  waiting,

  /// 進行中。
  playing,

  /// 終了。
  finished,

  /// キャンセル。
  cancelled,

  /// 一時停止。
  paused,
}

/// マッチステータス情報を保持するクラス。
class _MatchStatusInfo {
  const _MatchStatusInfo({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    this.icon,
  });

  /// ステータスラベル。
  final String label;

  /// 背景色。
  final Color backgroundColor;

  /// テキスト色。
  final Color textColor;

  /// 境界線色。
  final Color borderColor;

  /// アイコン（オプション）。
  final IconData? icon;
}
