import 'package:base_ui/base_ui.dart';
import 'package:flutter/material.dart';

/// トーナメント画面用の統一されたフッター
class TournamentFooter extends StatelessWidget {
  /// フッターのコンストラクタ
  const TournamentFooter({
    required this.maxParticipants,
    required this.actionButtonText,
    required this.onActionPressed,
    this.actionButtonStyle = ConfirmButtonStyle.adminFilled,
    super.key,
  });

  /// 最大参加者数
  final int maxParticipants;

  /// アクションボタンのテキスト
  final String actionButtonText;

  /// アクションボタンのスタイル
  final ConfirmButtonStyle actionButtonStyle;

  /// アクションボタンが押された時のコールバック
  final VoidCallback onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // 最大人数表示を右下に配置
          Row(
            children: [
              const Spacer(),
              Text(
                '最大人数: $maxParticipants人',
                style: const TextStyle(fontSize: 14, color: AppColors.textGray),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // アクションボタンを中央に配置
          Center(
            child: SizedBox(
              width: 192,
              height: 56,
              child: CommonConfirmButton(
                text: actionButtonText,
                style: actionButtonStyle,
                onPressed: onActionPressed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
