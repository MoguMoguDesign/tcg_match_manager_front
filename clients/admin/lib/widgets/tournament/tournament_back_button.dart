import 'package:base_ui/base_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// トーナメント画面用の統一された戻るボタン
class TournamentBackButton extends StatelessWidget {
  /// 戻るボタンのコンストラクタ
  const TournamentBackButton({this.onPressed, super.key});

  /// カスタムのコールバック（指定されない場合はcontext.pop()を使用）
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed ?? () => context.pop(),
      icon: const Icon(Icons.arrow_back, size: 24, color: AppColors.textBlack),
      label: const Text(
        '戻る',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textBlack,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        foregroundColor: AppColors.textBlack,
      ),
    );
  }
}
