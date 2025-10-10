import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

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
      decoration: const BoxDecoration(
        color: AppColors.transparent,
        // 枠線はデザイン上不要。
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: _DiagonalSplitPainter(
              leftColor: colors.leftColor,
              rightColor: colors.rightColor,
            ),
          ),
          Center(
            child: Text(
              'vs',
              style: AppTextStyles.labelLarge.copyWith(
                color: colors.textColor,
                fontSize: sizeInfo.fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _VSSizeInfo _getSizeInfo(VSContainerSize size) {
    switch (size) {
      case VSContainerSize.small:
        // デザイン比率に合わせた縦長サイズ。
        return const _VSSizeInfo(width: 16, height: 45, fontSize: 10);
      case VSContainerSize.medium:
        // Figma 準拠: W20 x H57。
        return const _VSSizeInfo(width: 20, height: 57, fontSize: 12);
      case VSContainerSize.large:
        // 縦長比率を維持した拡大サイズ。
        return const _VSSizeInfo(width: 24, height: 68, fontSize: 14);
    }
  }

  _VSContainerColors _getPatternColors(
    VSContainerState state,
    VSContainerUserPosition userPosition,
  ) {
    // 左右のアウトカムを決定。
    _SideOutcome leftOutcome;
    _SideOutcome rightOutcome;
    switch (state) {
      case VSContainerState.progress:
        leftOutcome = _SideOutcome.progress;
        rightOutcome = _SideOutcome.progress;
      case VSContainerState.leftPlayerWin:
        leftOutcome = _SideOutcome.win;
        rightOutcome = _SideOutcome.lose;
      case VSContainerState.leftPlayerLose:
        leftOutcome = _SideOutcome.lose;
        rightOutcome = _SideOutcome.win;
    }

    // カレントユーザー位置。
    final isLeftCurrent = userPosition == VSContainerUserPosition.left;
    final isRightCurrent = userPosition == VSContainerUserPosition.right;

    Color mapColor(_SideOutcome outcome, {required bool isCurrent}) {
      if (isCurrent) {
        return AppColors.adminPrimary;
      }
      switch (outcome) {
        case _SideOutcome.progress:
          return AppColors.textBlack;
        case _SideOutcome.win:
          return AppColors.userPrimaryAlpha;
        case _SideOutcome.lose:
          return AppColors.adminPrimaryAlpha;
      }
    }

    final leftColor = mapColor(leftOutcome, isCurrent: isLeftCurrent);
    final rightColor = mapColor(rightOutcome, isCurrent: isRightCurrent);

    // 左下三角形と右上三角形をそれぞれ独立して描画。
    return _VSContainerColors(
      leftColor: leftColor,
      rightColor: rightColor,
      textColor: AppColors.white,
    );
  }

  // 対角スプリットは [_DiagonalSplitPainter] で表現する。
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
    required this.textColor,
    this.leftColor,
    this.rightColor,
  });

  /// テキスト色。
  final Color textColor;

  /// 左下三角形の色。不要な場合は null。
  final Color? leftColor;

  /// 右上三角形の色。不要な場合は null。
  final Color? rightColor;
}

/// VS 左右の見た目を決める内部アウトカム。
enum _SideOutcome { progress, win, lose }

class _DiagonalSplitPainter extends CustomPainter {
  const _DiagonalSplitPainter({this.leftColor, this.rightColor});

  final Color? leftColor;
  final Color? rightColor;

  @override
  void paint(Canvas canvas, Size size) {
    // 左下三角形を描画
    if (leftColor != null) {
      final leftPaint = Paint()..color = leftColor!;
      final leftPath = Path()
        ..moveTo(0, 0) // 左上
        ..lineTo(0, size.height) // 左下
        ..lineTo(size.width, size.height) // 右下
        ..close();
      canvas.drawPath(leftPath, leftPaint);
    }

    // 右上三角形を描画
    if (rightColor != null) {
      final rightPaint = Paint()..color = rightColor!;
      final rightPath = Path()
        ..moveTo(0, 0) // 左上
        ..lineTo(size.width, 0) // 右上
        ..lineTo(size.width, size.height) // 右下
        ..close();
      canvas.drawPath(rightPath, rightPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _DiagonalSplitPainter oldDelegate) {
    return oldDelegate.leftColor != leftColor ||
        oldDelegate.rightColor != rightColor;
  }
}
