import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

/// 試合結果を表示するコンテナウィジェット。
///
/// Figma の ResultContainer（node-id: 255-2469）に準拠し、
/// 勝敗や得点などの結果情報を表示する。
class ResultContainer extends StatelessWidget {
  /// [ResultContainer] のコンストラクタ。
  ///
  /// [result] は必須パラメータ。
  const ResultContainer({
    super.key,
    required this.result,
    this.style = ResultContainerStyle.primary,
    this.size = ResultContainerSize.medium,
  });

  /// 結果情報。
  final ResultData result;

  /// コンテナのスタイル。
  final ResultContainerStyle style;

  /// コンテナのサイズ。
  final ResultContainerSize size;

  @override
  Widget build(BuildContext context) {
    final colors = _getStyleColors(style);
    final dimensions = _getSizeDimensions(size);

    return Container(
      width: dimensions.width,
      height: dimensions.height,
      padding: EdgeInsets.all(dimensions.padding),
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colors.borderColor,
          width: result.isHighlight ? 2 : 1,
        ),
        boxShadow: result.isHighlight ? [
          BoxShadow(
            color: colors.highlightColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (result.title != null) ...[
            Text(
              result.title!,
              style: AppTextStyles.labelSmall.copyWith(
                color: colors.titleColor,
                fontSize: dimensions.titleFontSize,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: dimensions.spacing),
          ],
          Text(
            result.value,
            style: AppTextStyles.headlineLarge.copyWith(
              color: colors.valueColor,
              fontSize: dimensions.valueFontSize,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          if (result.subtitle != null) ...[
            SizedBox(height: dimensions.spacing),
            Text(
              result.subtitle!,
              style: AppTextStyles.labelSmall.copyWith(
                color: colors.subtitleColor,
                fontSize: dimensions.subtitleFontSize,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  _ResultContainerColors _getStyleColors(ResultContainerStyle style) {
    switch (style) {
      case ResultContainerStyle.primary:
        return const _ResultContainerColors(
          backgroundColor: AppColors.textBlack,
          borderColor: AppColors.whiteAlpha,
          titleColor: AppColors.gray,
          valueColor: AppColors.white,
          subtitleColor: AppColors.gray,
          highlightColor: AppColors.userPrimary,
        );
      case ResultContainerStyle.secondary:
        return const _ResultContainerColors(
          backgroundColor: AppColors.white,
          borderColor: AppColors.gray,
          titleColor: AppColors.gray,
          valueColor: AppColors.textBlack,
          subtitleColor: AppColors.gray,
          highlightColor: AppColors.adminPrimary,
        );
      case ResultContainerStyle.winner:
        return const _ResultContainerColors(
          backgroundColor: AppColors.userPrimaryAlpha,
          borderColor: AppColors.userPrimary,
          titleColor: AppColors.textBlack,
          valueColor: AppColors.textBlack,
          subtitleColor: AppColors.textBlack,
          highlightColor: AppColors.userPrimary,
        );
    }
  }

  _ResultContainerDimensions _getSizeDimensions(ResultContainerSize size) {
    switch (size) {
      case ResultContainerSize.small:
        return const _ResultContainerDimensions(
          width: 60,
          height: 60,
          padding: 8,
          spacing: 4,
          titleFontSize: 8,
          valueFontSize: 16,
          subtitleFontSize: 8,
        );
      case ResultContainerSize.medium:
        return const _ResultContainerDimensions(
          width: 80,
          height: 80,
          padding: 12,
          spacing: 6,
          titleFontSize: 10,
          valueFontSize: 20,
          subtitleFontSize: 10,
        );
      case ResultContainerSize.large:
        return const _ResultContainerDimensions(
          width: 100,
          height: 100,
          padding: 16,
          spacing: 8,
          titleFontSize: 12,
          valueFontSize: 24,
          subtitleFontSize: 12,
        );
    }
  }
}

/// [ResultContainer] のスタイルを表す列挙型。
enum ResultContainerStyle {
  /// プライマリスタイル（ダークテーマ）。
  primary,

  /// セカンダリスタイル（ライトテーマ）。
  secondary,

  /// 勝者スタイル（ハイライト表示）。
  winner,
}

/// [ResultContainer] のサイズを表す列挙型。
enum ResultContainerSize {
  /// 小サイズ。
  small,

  /// 中サイズ。
  medium,

  /// 大サイズ。
  large,
}

/// 結果データを保持するクラス。
class ResultData {
  /// [ResultData] のコンストラクタ。
  ///
  /// [value] は必須パラメータ。
  const ResultData({
    required this.value,
    this.title,
    this.subtitle,
    this.isHighlight = false,
  });

  /// メインの値（得点、順位など）。
  final String value;

  /// タイトル（オプション）。
  final String? title;

  /// サブタイトル（オプション）。
  final String? subtitle;

  /// ハイライト表示するかどうか。
  final bool isHighlight;
}

/// 結果コンテナの色情報を保持するクラス。
class _ResultContainerColors {
  const _ResultContainerColors({
    required this.backgroundColor,
    required this.borderColor,
    required this.titleColor,
    required this.valueColor,
    required this.subtitleColor,
    required this.highlightColor,
  });

  /// 背景色。
  final Color backgroundColor;

  /// 境界線色。
  final Color borderColor;

  /// タイトル色。
  final Color titleColor;

  /// 値色。
  final Color valueColor;

  /// サブタイトル色。
  final Color subtitleColor;

  /// ハイライト色。
  final Color highlightColor;
}

/// 結果コンテナのサイズ情報を保持するクラス。
class _ResultContainerDimensions {
  const _ResultContainerDimensions({
    required this.width,
    required this.height,
    required this.padding,
    required this.spacing,
    required this.titleFontSize,
    required this.valueFontSize,
    required this.subtitleFontSize,
  });

  /// 幅。
  final double width;

  /// 高さ。
  final double height;

  /// パディング。
  final double padding;

  /// 要素間のスペース。
  final double spacing;

  /// タイトルフォントサイズ。
  final double titleFontSize;

  /// 値フォントサイズ。
  final double valueFontSize;

  /// サブタイトルフォントサイズ。
  final double subtitleFontSize;
}
