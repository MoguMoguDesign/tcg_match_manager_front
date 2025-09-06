import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

/// テーブル番号を表示する縦長のコンテナウィジェット。
///
/// Figma の TableNumberColumn（node-id: 244-5517）に準拠し、
/// 試合テーブル番号を視覚的に表示する。
class TableNumberColumn extends StatelessWidget {
  /// [TableNumberColumn] のコンストラクタ。
  ///
  /// [tableNumber] は必須パラメータ。
  const TableNumberColumn({
    super.key,
    required this.tableNumber,
    this.style = TableNumberStyle.primary,
  });

  /// テーブル番号。
  final int tableNumber;

  /// コンテナのスタイル。
  final TableNumberStyle style;

  @override
  Widget build(BuildContext context) {
    final colors = _getStyleColors(style);

    return Container(
      width: 48,
      height: 120,
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colors.borderColor,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'TABLE',
            style: AppTextStyles.labelSmall.copyWith(
              color: colors.labelColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tableNumber.toString(),
            style: AppTextStyles.headlineLarge.copyWith(
              color: colors.numberColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  _TableNumberColors _getStyleColors(TableNumberStyle style) {
    switch (style) {
      case TableNumberStyle.primary:
        return const _TableNumberColors(
          backgroundColor: AppColors.textBlack,
          borderColor: AppColors.whiteAlpha,
          labelColor: AppColors.gray,
          numberColor: AppColors.white,
        );
      case TableNumberStyle.secondary:
        return const _TableNumberColors(
          backgroundColor: AppColors.white,
          borderColor: AppColors.gray,
          labelColor: AppColors.gray,
          numberColor: AppColors.textBlack,
        );
      case TableNumberStyle.admin:
        return const _TableNumberColors(
          backgroundColor: AppColors.adminPrimary,
          borderColor: AppColors.adminPrimary,
          labelColor: AppColors.white,
          numberColor: AppColors.white,
        );
    }
  }
}

/// [TableNumberColumn] のスタイルを表す列挙型。
enum TableNumberStyle {
  /// プライマリスタイル（ダークテーマ）。
  primary,

  /// セカンダリスタイル（ライトテーマ）。
  secondary,

  /// 管理者スタイル。
  admin,
}

/// テーブル番号コンテナの色情報を保持するクラス。
class _TableNumberColors {
  const _TableNumberColors({
    required this.backgroundColor,
    required this.borderColor,
    required this.labelColor,
    required this.numberColor,
  });

  /// 背景色。
  final Color backgroundColor;

  /// 境界線色。
  final Color borderColor;

  /// ラベル色。
  final Color labelColor;

  /// 番号色。
  final Color numberColor;
}
