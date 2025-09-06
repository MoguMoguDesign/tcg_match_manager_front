import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// アプリケーション全体で使用する標準ボタンウィジェット。
///
/// プライマリーとセカンダリーの2つのスタイルをサポートし、
/// 無効状態やホバーエフェクトにも対応する。
class AppButton extends StatelessWidget {
  /// [AppButton]のコンストラクタ。
  ///
  /// [text]と[onPressed]は必須パラメータ。
  /// [isPrimary]はデフォルトでtrue、[isEnabled]はデフォルトでtrue。
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.isEnabled = true,
  });

  /// ボタンに表示されるテキスト。
  final String text;

  /// ボタンタップ時のコールバック関数。
  final VoidCallback onPressed;

  /// プライマリースタイルかどうか。
  final bool isPrimary;

  /// ボタンが有効かどうか。
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isPrimary ? AppColors.userPrimary : AppColors.textBlack,
        borderRadius: BorderRadius.circular(40),
        border: isPrimary
            ? null
            : Border.all(color: AppColors.userPrimary, width: 2),
        boxShadow: isPrimary && isEnabled
            ? [
                BoxShadow(
                  color: AppColors.userPrimary.withValues(alpha: 0.5),
                  blurRadius: 20,
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(40),
          child: Center(
            child: Text(
              text,
              style: AppTextStyles.labelLarge.copyWith(
                color: isPrimary ? AppColors.textBlack : AppColors.userPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 小さなボタンウィジェット。
///
/// コンパクトなレイアウトのために最適化された小さなボタンで、
/// 副アクションや補助的な操作に使用される。
class SmallButton extends StatelessWidget {
  /// [SmallButton]のコンストラクタ。
  ///
  /// [text]と[onPressed]は必須パラメータ。
  /// [isEnabled]はデフォルトでtrue。
  const SmallButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
  });

  /// ボタンに表示されるテキスト。
  final String text;

  /// ボタンタップ時のコールバック関数。
  final VoidCallback onPressed;

  /// ボタンが有効かどうか。
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.textBlack,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.userPrimary, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(28),
          child: Text(
            text,
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.userPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
