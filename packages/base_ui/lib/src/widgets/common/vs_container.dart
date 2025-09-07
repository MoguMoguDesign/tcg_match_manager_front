import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

/// VS（対戦）を示すコンテナウィジェット。
///
/// Figma の VSContainer デザインパターンに準拠し、
/// プレイヤー間の対戦を視覚的に表現する。
/// 9つの異なるデザインパターンをサポート。
class VSContainer extends StatelessWidget {
  /// [VSContainer] のコンストラクタ。
  const VSContainer({
    super.key,
    this.size = VSContainerSize.medium,
    this.state = VSContainerState.progress,
    this.currentUserPosition = VSContainerUserPosition.none,
    // 後方互換性のため残しておく（廃止予定）
    @Deprecated('Use state and currentUserPosition instead')
    this.style = VSContainerStyle.primary,
  });

  /// VSコンテナのサイズ。
  final VSContainerSize size;

  /// VSコンテナの状態（進行中、左プレイヤー勝利、左プレイヤー敗北）。
  final VSContainerState state;

  /// 現在のユーザーの位置（なし、左側、右側）。
  final VSContainerUserPosition currentUserPosition;

  /// VSコンテナのスタイル（廃止予定）。
  @Deprecated('Use state and currentUserPosition instead')
  final VSContainerStyle style;

  @override
  Widget build(BuildContext context) {
    final sizeInfo = _getSizeInfo(size);
    final colors = _getPatternColors(state, currentUserPosition);

    return Container(
      width: sizeInfo.width,
      height: sizeInfo.height,
      decoration: BoxDecoration(
        gradient: colors.gradient,
        color: colors.backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: colors.borderColor,
          width: 2,
        ),

      ),
      child: Center(
        child: Text(
          'vs',
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

  _VSContainerColors _getPatternColors(
    VSContainerState state,
    VSContainerUserPosition userPosition,
  ) {
    switch (state) {
      case VSContainerState.progress:
        switch (userPosition) {
          case VSContainerUserPosition.none:
            // Progress - 基本進行中状態（濃い青）
            return const _VSContainerColors(
              backgroundColor: AppColors.textBlack, // #000336
              textColor: AppColors.white,
              borderColor: AppColors.textBlack,
            );
          case VSContainerUserPosition.left:
          case VSContainerUserPosition.right:
            // Progress Current User - カレントユーザー進行中（青）
            return const _VSContainerColors(
              backgroundColor: AppColors.adminPrimary, // #3A44FB
              textColor: AppColors.white,
              borderColor: AppColors.adminPrimary,
            );
        }
      case VSContainerState.leftPlayerWin:
        return _VSContainerColors(
          // Left Player Win - 緑と青のグラデーション
          gradient: const LinearGradient(
            colors: [AppColors.userPrimary, AppColors.adminPrimary], // 緑→青
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          textColor: AppColors.white,
          borderColor: AppColors.userPrimary,
        );
      case VSContainerState.leftPlayerLose:
        return const _VSContainerColors(
          // Left Player Lose - 紫系グラデーション
          gradient: LinearGradient(
            colors: [Color(0xFFB0A3E3), Color(0xFF8A7CA8)], // 薄い紫→濃い紫
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          textColor: AppColors.white,
          borderColor: Color(0xFFB0A3E3),
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

/// [VSContainer] の状態を表す列挙型。
enum VSContainerState {
  /// 進行中状態。
  progress,

  /// 左プレイヤー勝利状態。
  leftPlayerWin,

  /// 左プレイヤー敗北状態。
  leftPlayerLose,
}

/// 現在のユーザーの位置を表す列挙型。
enum VSContainerUserPosition {
  /// 通常ユーザー（カレントユーザーなし）。
  none,

  /// カレントユーザーが左側。
  left,

  /// カレントユーザーが右側。
  right,
}

/// [VSContainer] のスタイルを表す列挙型（廃止予定）。
@Deprecated('Use VSContainerState and VSContainerUserPosition instead')
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
    this.backgroundColor,
    this.gradient,
    required this.textColor,
    required this.borderColor,

  });

  /// 背景色（gradientがnullの場合に使用）。
  final Color? backgroundColor;

  /// グラデーション（backgroundColorより優先）。
  final Gradient? gradient;

  /// テキスト色。
  final Color textColor;

  /// 境界線色。
  final Color borderColor;


}
