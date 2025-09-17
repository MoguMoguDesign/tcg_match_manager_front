import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// 確認アクション用の共通ボタンウィジェット。
///
/// Figma の CommonConfirmButton に準拠し、
/// ユーザー向けと管理者向けの
/// 塗りつぶし／アウトラインの4種類のスタイルを提供する。
class CommonConfirmButton extends StatelessWidget {
  /// ボタンの見た目スタイルを指定するための列挙型。
  ///
  /// ユーザー向けの塗りつぶし、ユーザー向けのアウトライン、
  /// 管理者向けの塗りつぶし、管理者向けのアウトラインの
  /// 4種類を提供する。
  /// [CommonConfirmButton] のコンストラクタ。
  ///
  /// [text] と [onPressed] は必須パラメータ。
  /// [style] はデフォルトで [ConfirmButtonStyle.userFilled]。
  /// [isEnabled] はデフォルトで true。
  const CommonConfirmButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.style = ConfirmButtonStyle.userFilled,
    this.isEnabled = true,
    this.width,
  });

  static const double _height = 56;
  static const double _radius = 40;

  /// ボタンの見た目スタイル。
  final ConfirmButtonStyle style;

  /// ボタンに表示されるテキスト。
  final String text;

  /// タップ時に呼び出されるコールバックを指定する。
  final VoidCallback onPressed;

  /// ボタンが有効かどうか。
  final bool isEnabled;

  /// 幅を明示的に指定するかどうか。
  /// 指定しない場合は [double.infinity] で親幅いっぱいに広げる。
  final double? width;

  @override
  Widget build(BuildContext context) {
    final visual = _resolveVisual(style: style, isEnabled: isEnabled);

    return SizedBox(
      height: _height,
      width: width ?? double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: visual.backgroundColor,
          borderRadius: BorderRadius.circular(_radius),
          border: visual.border,
          boxShadow: visual.shadow,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? onPressed : null,
            borderRadius: BorderRadius.circular(_radius),
            child: Center(
              child: Text(
                text,
                style: AppTextStyles.labelLarge.copyWith(
                  color: visual.textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static _VisualStyle _resolveVisual({
    required ConfirmButtonStyle style,
    required bool isEnabled,
  }) {
    switch (style) {
      case ConfirmButtonStyle.userFilled:
        return _VisualStyle(
          backgroundColor: isEnabled
              ? AppColors.userPrimary
              : AppColors.userPrimary.withValues(alpha: 0.5),
          textColor: AppColors.textBlack,
          shadow: isEnabled
              ? [
                  BoxShadow(
                    color: AppColors.userPrimary.withValues(alpha: 0.5),
                    blurRadius: 20,
                  ),
                ]
              : null,
        );
      case ConfirmButtonStyle.userOutlined:
        return _VisualStyle(
          backgroundColor: AppColors.textBlack,
          textColor: AppColors.userPrimary,
          border: Border.all(color: AppColors.userPrimary, width: 2),
        );
      case ConfirmButtonStyle.adminFilled:
        return _VisualStyle(
          backgroundColor: isEnabled
              ? AppColors.adminPrimary
              : AppColors.adminPrimary.withValues(alpha: 0.5),
          textColor: AppColors.white,
          shadow: [
            BoxShadow(
              color: AppColors.adminPrimary.withValues(alpha: 0.1),
              blurRadius: 20,
            ),
          ],
        );
      case ConfirmButtonStyle.adminOutlined:
        return _VisualStyle(
          backgroundColor: AppColors.white,
          textColor: AppColors.textBlack,
          border: Border.all(color: AppColors.textBlack, width: 2),
        );
    }
  }
}

/// [CommonConfirmButton] のスタイルを表す列挙型。
enum ConfirmButtonStyle {
  /// ユーザー向けの塗りつぶしスタイル。
  userFilled,

  /// ユーザー向けのアウトラインスタイル。
  userOutlined,

  /// 管理者向けの塗りつぶしスタイル。
  adminFilled,

  /// 管理者向けのアウトラインスタイル。
  adminOutlined,
}

/// 内部的に使用する見た目情報を保持するクラス。
class _VisualStyle {
  const _VisualStyle({
    required this.backgroundColor,
    required this.textColor,
    this.border,
    this.shadow,
  });

  /// 背景色。
  final Color backgroundColor;

  /// テキスト色。
  final Color textColor;

  /// 枠線定義。不要な場合は null。
  final BoxBorder? border;

  /// 影定義。不要な場合は null。
  final List<BoxShadow>? shadow;
}
