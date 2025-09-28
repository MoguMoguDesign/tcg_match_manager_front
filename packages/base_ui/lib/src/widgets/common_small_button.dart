import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

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
    Widget? leadingIcon,
    Widget? trailingIcon,
  }) : _leadingIcon = leadingIcon,
       _trailingIcon = trailingIcon;

  /// 左側にアイコンを表示するコンストラクタ。
  ///
  /// テキストの左側に [icon] を表示する。右側アイコンは使用しない。
  const CommonSmallButton.leadingIcon({
    super.key,
    required this.text,
    required this.onPressed,
    required Widget icon,
    this.style = SmallButtonStyle.primary,
    this.isEnabled = true,
    this.width,
  }) : _leadingIcon = icon,
       _trailingIcon = null;

  /// 右側にアイコンを表示するコンストラクタ。
  ///
  /// テキストの右側に [icon] を表示する。左側アイコンは使用しない。
  const CommonSmallButton.trailingIcon({
    super.key,
    required this.text,
    required this.onPressed,
    required Widget icon,
    this.style = SmallButtonStyle.primary,
    this.isEnabled = true,
    this.width,
  }) : _leadingIcon = null,
       _trailingIcon = icon;

  /// ボタンの高さを定義する。
  static const double _height = 40;

  /// ボタンの角丸半径を定義する。
  static const double _radius = 28;

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

  /// 左側に表示するアイコンウィジェット。
  final Widget? _leadingIcon;

  /// 右側に表示するアイコンウィジェット。
  final Widget? _trailingIcon;

  @override
  Widget build(BuildContext context) {
    final visual = _resolveVisual(style: style, isEnabled: isEnabled);

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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildContent(visual),
            ),
          ),
        ),
      ),
    );
  }

  /// テキストとアイコンの並びを構築する。
  Widget _buildContent(_VisualStyle visual) {
    final textWidget = Text(
      text,
      style: AppTextStyles.labelLarge.copyWith(
        color: visual.textColor,
        fontSize: 16,
        height: 1,
      ),
    );

    // スタイルに基づいて自動的にアイコンを設定
    var leadingIcon = _leadingIcon;
    var trailingIcon = _trailingIcon;

    if (style == SmallButtonStyle.adminOutlinedWithArrowLeft) {
      leadingIcon = const Icon(Icons.keyboard_arrow_left, size: 24);
    } else if (style == SmallButtonStyle.adminOutlinedWithArrowRight) {
      trailingIcon = const Icon(Icons.keyboard_arrow_right, size: 24);
    }

    final hasLeading = leadingIcon != null;
    final hasTrailing = trailingIcon != null;

    if (!hasLeading && !hasTrailing) {
      return textWidget;
    }

    final children = <Widget>[
      if (hasLeading) ...[
        _IconContainer(icon: leadingIcon, color: visual.textColor),
        const SizedBox(width: 8),
      ],
      textWidget,
      if (hasTrailing) ...[
        const SizedBox(width: 8),
        _IconContainer(icon: trailingIcon, color: visual.textColor),
      ],
    ];

    return Row(mainAxisSize: MainAxisSize.min, children: children);
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
          backgroundColor: isEnabled
              ? AppColors.textBlack
              : AppColors.textBlack.withValues(alpha: 0.3),
          textColor: isEnabled
              ? AppColors.userPrimary
              : AppColors.gray.withValues(alpha: 0.6),
          border: Border.all(
            color: isEnabled
                ? AppColors.userPrimary
                : AppColors.gray.withValues(alpha: 0.4),
            width: 2,
          ),
        );
      case SmallButtonStyle.neutralOutlined:
        return _VisualStyle(
          backgroundColor: isEnabled
              ? AppColors.textBlack
              : AppColors.textBlack.withValues(alpha: 0.3),
          textColor: isEnabled
              ? AppColors.white
              : AppColors.gray.withValues(alpha: 0.6),
          border: Border.all(
            color: isEnabled
                ? AppColors.white
                : AppColors.gray.withValues(alpha: 0.4),
            width: 2,
          ),
        );
      case SmallButtonStyle.admin:
        return _VisualStyle(
          backgroundColor: isEnabled
              ? AppColors.adminPrimary
              : AppColors.adminPrimary.withValues(alpha: 0.5),
          textColor: AppColors.white,
        );
      case SmallButtonStyle.adminOutlinedWithArrowLeft:
        return _VisualStyle(
          backgroundColor: AppColors.white,
          textColor: isEnabled ? AppColors.textBlack : AppColors.gray,
          border: Border.all(
            color: isEnabled
                ? AppColors.textBlack
                : AppColors.gray.withValues(alpha: 0.4),
            width: 2,
          ),
        );
      case SmallButtonStyle.adminOutlinedWithArrowRight:
        return _VisualStyle(
          backgroundColor: AppColors.white,
          textColor: isEnabled ? AppColors.textBlack : AppColors.gray,
          border: Border.all(
            color: isEnabled
                ? AppColors.textBlack
                : AppColors.gray.withValues(alpha: 0.4),
            width: 2,
          ),
        );
      case SmallButtonStyle.whiteOutlined:
        return _VisualStyle(
          backgroundColor: AppColors.white,
          textColor: isEnabled ? AppColors.textBlack : AppColors.gray,
          border: Border.all(
            color: isEnabled
                ? AppColors.textBlack
                : AppColors.gray.withValues(alpha: 0.4),
            width: 2,
          ),
        );
    }
  }
}

/// アイコンのタップ領域や配置を統一するためのラッパーウィジェット。
class _IconContainer extends StatelessWidget {
  /// [_IconContainer] のコンストラクタ。
  const _IconContainer({required this.icon, required this.color});

  /// 表示するアイコンウィジェット。
  final Widget icon;

  /// アイコンの色。
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 20,
      child: FittedBox(
        child: IconTheme(
          data: IconThemeData(color: color, size: 20),
          child: icon,
        ),
      ),
    );
  }
}

/// [CommonSmallButton] のスタイルを表す列挙型。
enum SmallButtonStyle {
  /// プライマリスタイル（ユーザー向けの塗りつぶし）。
  primary,

  /// セカンダリスタイル（アウトライン）。
  secondary,

  /// ニュートラルアウトラインスタイル（黒地に白アウトライン/白文字）。
  neutralOutlined,

  /// 管理者スタイル（管理者向けの塗りつぶし）。
  admin,

  /// 管理者アウトライン + 左矢印スタイル。
  adminOutlinedWithArrowLeft,

  /// 管理者アウトライン + 右矢印スタイル。
  adminOutlinedWithArrowRight,

  /// 白背景に黒アウトライン（両者敗北ボタン用）。
  whiteOutlined,
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
