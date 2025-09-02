import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

/// アプリケーション共通のテキストフィールドウィジェット。
///
/// カスタマイズされたスタイルを持つテキスト入力フィールドを提供する。
class AppTextField extends StatelessWidget {
  /// [AppTextField] のコンストラクタ。
  ///
  /// [hintText] は必須パラメータ。
  /// その他のパラメータはオプション。
  const AppTextField({
    super.key,
    required this.hintText,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.suffixIcon,
  });

  /// プレースホルダーテキスト。
  final String hintText;
  
  /// テキスト変更時のコールバック。
  final ValueChanged<String>? onChanged;
  
  /// タップ時のコールバック。
  final VoidCallback? onTap;
  
  /// 読み取り専用かどうか。
  final bool readOnly;
  
  /// サフィックスアイコン。
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
/// タップするとモーダルやメニューを表示する選択フィールドを提供する。
class AppDropdownField extends StatelessWidget {
  /// [AppDropdownField] のコンストラクタ。
  ///
  /// [hintText] と [onTap] は必須パラメータ。
  const AppDropdownField({
    super.key,
    required this.hintText,
    required this.onTap,
  });

  /// プレースホルダーテキスト。
  final String hintText;
  
  /// タップ時のコールバック。
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
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(40),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    hintText,
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
                Transform.rotate(
                  angle: 1.5708, // 90度回転（下向き矢印）
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
