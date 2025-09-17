import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// ダイアログ内で使用するボタン群を提供するウィジェット。
///
/// Figma の DialogButtons（node-id: 86-7843）に準拠し、
/// ダイアログ内のアクションボタンレイアウトを統一的に管理する。
class DialogButtons extends StatelessWidget {
  /// [DialogButtons] のコンストラクタ。
  ///
  /// [primaryText] と [onPrimaryPressed] は必須パラメータ。
  /// [secondaryText] が提供された場合はセカンダリボタンも表示される。
  const DialogButtons({
    super.key,
    required this.primaryText,
    required this.onPrimaryPressed,
    this.secondaryText,
    this.onSecondaryPressed,
    this.isVertical = false,
  });

  /// プライマリボタンのテキスト。
  final String primaryText;

  /// プライマリボタンタップ時のコールバック。
  final VoidCallback onPrimaryPressed;

  /// セカンダリボタンのテキスト。
  /// null の場合はセカンダリボタンを表示しない。
  final String? secondaryText;

  /// セカンダリボタンタップ時のコールバック。
  final VoidCallback? onSecondaryPressed;

  /// ボタンを縦方向に配置するかどうか。
  /// false の場合は横方向に配置される。
  final bool isVertical;

  @override
  Widget build(BuildContext context) {
    final hasSecondaryButton = secondaryText != null;

    if (isVertical) {
      return Column(
        children: [
          if (hasSecondaryButton) ...[
            _DialogActionButton(
              text: secondaryText!,
              style: DialogButtonStyle.secondary,
              onPressed: onSecondaryPressed ?? () {},
            ),
            const SizedBox(height: 12),
          ],
          _DialogActionButton(
            text: primaryText,
            style: DialogButtonStyle.primary,
            onPressed: onPrimaryPressed,
          ),
        ],
      );
    }

    return Row(
      children: [
        if (hasSecondaryButton) ...[
          Expanded(
            child: _DialogActionButton(
              text: secondaryText!,
              style: DialogButtonStyle.secondary,
              onPressed: onSecondaryPressed ?? () {},
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: _DialogActionButton(
            text: primaryText,
            style: DialogButtonStyle.primary,
            onPressed: onPrimaryPressed,
          ),
        ),
      ],
    );
  }
}

/// ダイアログボタンの内部実装ウィジェット。
class _DialogActionButton extends StatelessWidget {
  const _DialogActionButton({
    required this.text,
    required this.style,
    required this.onPressed,
  });

  /// ボタンのテキスト。
  final String text;

  /// ボタンのスタイル。
  final DialogButtonStyle style;

  /// ボタンタップ時のコールバック。
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = _getStyleColors(style);

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: colors.boxShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(22),
          child: Center(
            child: Text(
              text,
              style: AppTextStyles.labelMedium.copyWith(
                color: colors.textColor,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _DialogButtonColors _getStyleColors(DialogButtonStyle style) {
    switch (style) {
      case DialogButtonStyle.primary:
        return _DialogButtonColors(
          backgroundColor: AppColors.userPrimary,
          textColor: AppColors.textBlack,
          boxShadow: [
            BoxShadow(
              color: AppColors.userPrimary.withValues(alpha: 0.5),
              blurRadius: 20,
            ),
          ],
        );
      case DialogButtonStyle.secondary:
        return const _DialogButtonColors(
          backgroundColor: Colors.transparent,
          textColor: AppColors.gray,
        );
    }
  }
}

/// ダイアログボタンのスタイルを表す列挙型。
enum DialogButtonStyle {
  /// プライマリボタンのスタイル（塗りつぶし）。
  primary,

  /// セカンダリボタンのスタイル（アウトライン）。
  secondary,
}

/// ダイアログボタンの色情報を保持するクラス。
class _DialogButtonColors {
  const _DialogButtonColors({
    required this.backgroundColor,
    required this.textColor,
    this.boxShadow,
  });

  /// 背景色。
  final Color backgroundColor;

  /// テキスト色。
  final Color textColor;

  /// ボックスシャドウ。不要な場合は null。
  final List<BoxShadow>? boxShadow;
}
