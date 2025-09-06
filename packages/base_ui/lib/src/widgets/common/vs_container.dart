import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

/// VS（対戦）を示すコンテナウィジェット。
///
/// Figma の VSContainer（node-id: 244-5640）に準拠し、
/// プレイヤー間の対戦を視覚的に表現する。
class VSContainer extends StatelessWidget {
  /// [VSContainer] のコンストラクタ。
  const VSContainer({
    super.key,
    this.size = VSContainerSize.medium,
    this.style = VSContainerStyle.primary,
  });

  /// VSコンテナのサイズ。
  final VSContainerSize size;

  /// VSコンテナのスタイル。
  final VSContainerStyle style;

  @override
  Widget build(BuildContext context) {
    final sizeInfo = _getSizeInfo(size);
    final colors = _getStyleColors(style);

    return Container(
      width: sizeInfo.width,
      height: sizeInfo.height,
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: colors.borderColor,
          width: 2,
        ),
        boxShadow: colors.shadow,
      ),
      child: Center(
        child: Text(
          'VS',
          style: AppTextStyles.labelLarge.copyWith(
            color: colors.textColor,
            fontSize: sizeInfo.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  _VSSizeInfo _getSizeInfo(VSContainerSize size) {
    switch (size) {
      case VSContainerSize.small:
        return const _VSSizeInfo(
          width: 32,
          height: 32,
          fontSize: 10,
        );
      case VSContainerSize.medium:
        return const _VSSizeInfo(
          width: 48,
          height: 48,
          fontSize: 14,
        );
      case VSContainerSize.large:
        return const _VSSizeInfo(
          width: 64,
          height: 64,
          fontSize: 18,
        );
    }
  }

  _VSContainerColors _getStyleColors(VSContainerStyle style) {
    switch (style) {
      case VSContainerStyle.primary:
        return const _VSContainerColors(
          backgroundColor: AppColors.userPrimary,
          textColor: AppColors.textBlack,
          borderColor: AppColors.userPrimary,
          shadow: [
            BoxShadow(
              color: Color(0xFFD8FF62),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        );
      case VSContainerStyle.secondary:
        return const _VSContainerColors(
          backgroundColor: AppColors.white,
          textColor: AppColors.textBlack,
          borderColor: AppColors.gray,
        );
      case VSContainerStyle.admin:
        return _VSContainerColors(
          backgroundColor: AppColors.adminPrimary,
          textColor: AppColors.white,
          borderColor: AppColors.adminPrimary,
          shadow: [
            BoxShadow(
              color: AppColors.adminPrimary.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        );
    }
  }
}

/// [VSContainer] のサイズを表す列挙型。
enum VSContainerSize {
  /// 小さいサイズ（32x32）。
  small,

  /// 中くらいのサイズ（48x48）。
  medium,

  /// 大きなサイズ（64x64）。
  large,
}

/// [VSContainer] のスタイルを表す列挙型。
enum VSContainerStyle {
  /// プライマリスタイル（ユーザー向け）。
  primary,

  /// セカンダリスタイル（ライト）。
  secondary,

  /// 管理者スタイル。
  admin,
}

/// VSコンテナのサイズ情報を保持するクラス。
class _VSSizeInfo {
  const _VSSizeInfo({
    required this.width,
    required this.height,
    required this.fontSize,
  });

  /// 幅。
  final double width;

  /// 高さ。
  final double height;

  /// フォントサイズ。
  final double fontSize;
}

/// VSコンテナの色情報を保持するクラス。
class _VSContainerColors {
  const _VSContainerColors({
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    this.shadow,
  });

  /// 背景色。
  final Color backgroundColor;

  /// テキスト色。
  final Color textColor;

  /// 境界線色。
  final Color borderColor;

  /// 影定義。不要な場合は null。
  final List<BoxShadow>? shadow;
}
