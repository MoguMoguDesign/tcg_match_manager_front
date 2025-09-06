import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

/// 小さなアクション用の共通ボタンウィジェット。
///
/// Figma の CommonSmallButton（node-id: 95-183）に準拠し、
/// コンパクトなボタン表示を提供する。
class CommonSmallButton extends StatelessWidget {
  /// [CommonSmallButton] のコンストラクタ。
  ///
  /// [text] と [onPressed] は必須パラメータ。
  /// [style] はデフォルトで [SmallButtonStyle.primary]。
  /// [isEnabled] はデフォルトで true。
  const CommonSmallButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.style = SmallButtonStyle.primary,
    this.isEnabled = true,
    this.width,
  });

  /// ボタンの高さを定義する。
  static const double _height = 36;
  
  /// ボタンの角丸半径を定義する。
  static const double _radius = 20;

  /// ボタンに表示されるテキスト。
  final String text;

  /// タップ時に呼び出されるコールバック。
  final VoidCallback onPressed;

  /// ボタンが有効かどうか。
  final bool isEnabled;

  /// ボタンの見た目スタイル。
  final SmallButtonStyle style;

  /// 幅を明示的に指定するかどうか。
  /// 指定しない場合は内容に応じたサイズになる。
  final double? width;

  @override
  Widget build(BuildContext context) {
    final visual = _resolveVisual(
      style: style,
      isEnabled: isEnabled,
    );

    return Container(
      height: _height,
      width: width,
      decoration: BoxDecoration(
        color: visual.backgroundColor,
        borderRadius: BorderRadius.circular(_radius),
        border: visual.border,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(_radius),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                text,
                style: AppTextStyles.labelSmall.copyWith(
                  color: visual.textColor,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static _VisualStyle _resolveVisual({
    required SmallButtonStyle style,
    required bool isEnabled,
  }) {
    switch (style) {
      case SmallButtonStyle.primary:
        return _VisualStyle(
          backgroundColor: isEnabled
              ? AppColors.userPrimary
              : AppColors.userPrimary.withValues(alpha: 0.5),
          textColor: AppColors.textBlack,
        );
      case SmallButtonStyle.secondary:
        return _VisualStyle(
          backgroundColor: AppColors.textBlack,
          textColor: AppColors.userPrimary,
          border: Border.all(color: AppColors.userPrimary),
        );
      case SmallButtonStyle.admin:
        return _VisualStyle(
          backgroundColor: isEnabled
              ? AppColors.adminPrimary
              : AppColors.adminPrimary.withValues(alpha: 0.5),
          textColor: AppColors.white,
        );
    }
  }
}

/// [CommonSmallButton] のスタイルを表す列挙型。
enum SmallButtonStyle {
  /// プライマリスタイル（ユーザー向けの塗りつぶし）。
  primary,

  /// セカンダリスタイル（アウトライン）。
  secondary,

  /// 管理者スタイル（管理者向けの塗りつぶし）。
  admin,
}

/// 内部的に使用する見た目情報を保持するクラス。
class _VisualStyle {
  const _VisualStyle({
    required this.backgroundColor,
    required this.textColor,
    this.border,
  });

  /// 背景色。
  final Color backgroundColor;

  /// テキスト色。
  final Color textColor;

  /// 枠線定義。不要な場合は null。
  final BoxBorder? border;
}
