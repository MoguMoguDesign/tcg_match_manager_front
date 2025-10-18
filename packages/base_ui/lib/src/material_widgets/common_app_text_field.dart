import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// アプリケーション全体で使用する標準テキストフィールドウィジェット。
///
/// ヒントテキスト表示、入力値変更監視、読み取り専用モード、
/// 接尾辞アイコンなどをサポートする。
class AppTextField extends StatelessWidget {
  /// [AppTextField]のコンストラクタ。
  ///
  /// [hintText]は必須パラメータでフィールドのヒントを指定。
  /// [readOnly]はデフォルトでfalse。
  const AppTextField({
    super.key,
    required this.hintText,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.suffixIcon,
  });

  /// フィールドに表示されるヒントテキスト。
  final String hintText;

  /// テキスト変更時のコールバック関数。
  final ValueChanged<String>? onChanged;

  /// フィールドタップ時のコールバック関数。
  final VoidCallback? onTap;

  /// 読み取り専用かどうか。
  final bool readOnly;

  /// フィールドの末尾に表示されるアイコン。
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.textBlack,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: AppColors.whiteAlpha),
      ),
      child: TextField(
        onChanged: onChanged,
        onTap: onTap,
        readOnly: readOnly,
        style: AppTextStyles.bodyMedium,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.bodyMedium,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}

/// ドロップダウン選択用のフィールドウィジェット。
///
/// タップで選択肢を表示するデザインで、
/// 下向き矢印アイコンを持つ。
class AppDropdownField extends StatelessWidget {
  /// [AppDropdownField]のコンストラクタ。
  ///
  /// [hintText]と[onTap]はどちらも必須パラメータ。
  const AppDropdownField({
    super.key,
    required this.hintText,
    required this.onTap,
  });

  /// フィールドに表示されるヒントテキスト。
  final String hintText;

  /// フィールドタップ時のコールバック関数。
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.textBlack,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: AppColors.whiteAlpha),
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(40),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(hintText, style: AppTextStyles.bodyMedium),
                ),
                Transform.rotate(
                  angle: 1.5708, // 90度回転（下向き矢印）。
                  child: const Icon(
                    Icons.keyboard_arrow_right,
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
