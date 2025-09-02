import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

/// アプリケーション共通のボタンウィジェット。
///
/// プライマリボタンとセカンダリボタンの表示を切り替えることができる。
class AppButton extends StatelessWidget {
  /// [AppButton] のコンストラクタ。
  ///
  /// [text] と [onPressed] は必須パラメータ。
  /// [isPrimary] はボタンの種類を指定し、デフォルトは `true`。
  /// [isEnabled] はボタンの有効状態を指定し、デフォルトは `true`。
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.isEnabled = true,
  });

  /// ボタンに表示するテキスト。
  final String text;
  
  /// ボタンがタップされた時のコールバック。
  final VoidCallback onPressed;
  
  /// プライマリボタンかどうか。
  final bool isPrimary;
  
  /// ボタンが有効かどうか。
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isPrimary ? AppColors.primary : AppColors.textBlack,
        borderRadius: const BorderRadius.all(Radius.circular(40)),
        border: isPrimary
            ? null
            : Border.all(color: AppColors.primary, width: 2),
        boxShadow: isPrimary && isEnabled
            ? [
                const BoxShadow(
                  color: Color(0x80D8FF62),
                  blurRadius: 20,
                ),
              ]
            : null,
      ),
      child: SizedBox(
        height: 56,
        width: double.infinity,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? onPressed : null,
            borderRadius: const BorderRadius.all(Radius.circular(40)),
            child: Center(
              child: Text(
                text,
                style: AppTextStyles.labelLarge.copyWith(
                  color: isPrimary ? AppColors.textBlack : AppColors.primary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 小さなサイズのボタンウィジェット。
///
/// 補助的な操作やナビゲーション用の小さなボタンを表示する。
class SmallButton extends StatelessWidget {
  /// [SmallButton] のコンストラクタ。
  ///
  /// [text] と [onPressed] は必須パラメータ。
  /// [isEnabled] はボタンの有効状態を指定し、デフォルトは `true`。
  const SmallButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
  });

  /// ボタンに表示するテキスト。
  final String text;
  
  /// ボタンがタップされた時のコールバック。
  final VoidCallback onPressed;
  
  /// ボタンが有効かどうか。
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.textBlack,
        borderRadius: BorderRadius.all(Radius.circular(28)),
        border: Border.fromBorderSide(
          BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? onPressed : null,
            borderRadius: const BorderRadius.all(Radius.circular(28)),
            child: Text(
              text,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
