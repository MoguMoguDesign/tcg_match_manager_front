import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../common/button_icon.dart';

/// 管理者向けの確認アクション用ボタンウィジェット。
///
/// Figma の管理者用スタイルに準拠し、塗りつぶし／アウトラインの 2 種を想定。
/// 左アイコンあり／なしの 2 コンストラクタを提供する。
class AdminConfirmButton extends StatelessWidget {
  /// [AdminConfirmButton] のコンストラクタ。
  ///
  /// [text] と [onPressed] は必須パラメータ。
  /// [isFilled] はデフォルトで true、[isEnabled] はデフォルトで true。
  const AdminConfirmButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isFilled = true,
    this.isEnabled = true,
    this.width,
  }) : _leadingIcon = null,
       _buttonIconType = null;

  /// 左側にアイコンを表示するコンストラクタ。
  const AdminConfirmButton.leadingIcon({
    super.key,
    required this.text,
    required this.onPressed,
    required Widget icon,
    this.isFilled = true,
    this.isEnabled = true,
    this.width,
  }) : _leadingIcon = icon,
       _buttonIconType = null;

  /// 左側にButtonIconを表示するコンストラクタ。
  const AdminConfirmButton.leadingButtonIcon({
    super.key,
    required this.text,
    required this.onPressed,
    required ButtonIconType iconType,
    this.isFilled = true,
    this.isEnabled = true,
    this.width,
  }) : _leadingIcon = null,
       _buttonIconType = iconType;

  static const double _height = 56;
  static const double _radius = 40;

  /// ボタンに表示されるテキスト。
  final String text;

  /// タップ時に呼び出されるコールバックを指定する。
  final VoidCallback onPressed;

  /// 塗りつぶしスタイルかどうか。
  final bool isFilled;

  /// ボタンが有効かどうか。
  final bool isEnabled;

  /// 幅を明示的に指定するかどうか。
  /// 指定しない場合は [double.infinity] で親幅いっぱいに広げる。
  final double? width;

  /// 左側に表示するアイコンウィジェット。
  final Widget? _leadingIcon;

  /// 左側に表示するButtonIconの種類。
  final ButtonIconType? _buttonIconType;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isFilled
        ? (isEnabled
              ? AppColors.adminPrimary
              : AppColors.adminPrimary.withValues(alpha: 0.5))
        : AppColors.white;
    final textColor = isFilled ? AppColors.white : AppColors.textBlack;
    final border = isFilled
        ? null
        : Border.all(color: AppColors.textBlack, width: 2);
    final shadow = isFilled
        ? [
            BoxShadow(
              color: AppColors.adminPrimary.withValues(alpha: 0.1),
              blurRadius: 20,
            ),
          ]
        : null;

    return Container(
      height: _height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(_radius),
        border: border,
        boxShadow: shadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(_radius),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildContent(textColor),
            ),
          ),
        ),
      ),
    );
  }

  /// テキストと左アイコン（任意）の並びを構築する。
  Widget _buildContent(Color textColor) {
    final textWidget = Text(
      text,
      style: AppTextStyles.labelLarge.copyWith(
        color: textColor, 
        height: 1,
        fontSize: 16,
      ),
    );

    final leadingIcon = _leadingIcon;
    final buttonIconType = _buttonIconType;

    // ButtonIconTypeが指定されている場合はButtonIconを使用
    if (buttonIconType != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ButtonIcon(
            type: buttonIconType,
            color: textColor,
          ),
          const SizedBox(width: 12),
          textWidget,
        ],
      );
    }

    // 通常のアイコンウィジェットが指定されている場合
    if (leadingIcon != null) {
      return IconTheme(
        data: IconThemeData(color: textColor, size: 24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: FittedBox(child: leadingIcon),
            ),
            const SizedBox(width: 12),
            textWidget,
          ],
        ),
      );
    }

    return textWidget;
  }
}

// EOF
