import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: statusInfo.backgroundColor,
        borderRadius: BorderRadius.circular(4),
        border: showBorder ? Border.all(
          color: statusInfo.borderColor,
        ) : null,
      ),
      child: Text(
        statusInfo.label,
        style: AppTextStyles.labelSmall.copyWith(
          color: statusInfo.textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  _MatchStatusInfo _getStatusInfo(MatchStatus status) {
    switch (status) {
      case MatchStatus.playing:
        return const _MatchStatusInfo(
          label: '対戦中',
          backgroundColor: AppColors.transparent,
          textColor: AppColors.userPrimary,
          borderColor: AppColors.userPrimary,
        );
      case MatchStatus.finished:
        return const _MatchStatusInfo(
          label: '終了',
          backgroundColor: AppColors.transparent,
          textColor: AppColors.white,
          borderColor: AppColors.white,
        );
    }
  }
}

/// マッチステータスを表す列挙型。
enum MatchStatus {
  /// 進行中。
  playing,

  /// 終了。
  finished,
}

/// マッチステータス情報を保持するクラス。
class _MatchStatusInfo {
  const _MatchStatusInfo({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
  });

  /// ステータスラベル。
  final String label;

  /// 背景色。
  final Color backgroundColor;

  /// テキスト色。
  final Color textColor;

  /// 境界線色。
  final Color borderColor;
}
