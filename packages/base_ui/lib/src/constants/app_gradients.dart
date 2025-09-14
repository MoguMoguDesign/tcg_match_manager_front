import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'app_colors.dart';

/// 背景グラデーションテーマを提供する。
///
/// 画面背景に使用するグラデーションを Theme 拡張として管理する。
///
/// 局所的な Theme で上書きすることで、特定画面のみ配色を変更する運用に適している。
@immutable
class BackgroundGradientTheme extends ThemeExtension<BackgroundGradientTheme> {
  /// 指定の [scaffoldGradient] を持つテーマを作成する。
  const BackgroundGradientTheme({required this.scaffoldGradient});

  /// 画面背景に使用するグラデーション。
  final LinearGradient scaffoldGradient;

  @override
  /// 指定した値で新しいインスタンスを返す。
  ///
  /// 省略した引数は既存の値を引き継ぐ。
  BackgroundGradientTheme copyWith({LinearGradient? scaffoldGradient}) {
    return BackgroundGradientTheme(
      scaffoldGradient: scaffoldGradient ?? this.scaffoldGradient,
    );
  }

  @override
  /// 別のテーマとの間で線形補間を行う。
  ///
  /// 配列長の差異に強くするため、色は 3 色に正規化して補間する。
  BackgroundGradientTheme lerp(
    covariant ThemeExtension<BackgroundGradientTheme>? other,
    double t,
  ) {
    if (other is! BackgroundGradientTheme) {
      return this;
    }
    // begin/end は固定し、色のみ線形補間する。
    final a = scaffoldGradient.colors;
    final b = other.scaffoldGradient.colors;
    return BackgroundGradientTheme(
      scaffoldGradient: LinearGradient(
        begin: scaffoldGradient.begin,
        end: scaffoldGradient.end,
        colors: List<Color>.generate(
          3,
          (int i) => Color.lerp(a[i % a.length], b[i % b.length], t)!,
        ),
        stops: const <double>[0, 0.5, 1],
      ),
    );
  }
}

/// 既定の背景グラデーションテーマ。
const BackgroundGradientTheme kDefaultBackgroundGradient =
    BackgroundGradientTheme(
      scaffoldGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          AppColors.userPrimary,
          AppColors.textBlack,
          AppColors.adminPrimary,
        ],
        stops: <double>[0, 0.5, 1],
      ),
    );

/// SVG 背景画像を全面に敷くユーティリティウィジェット。
///
/// 指定された SVG を画面全体に表示する。
class SvgBackground extends StatelessWidget {
  const SvgBackground({
    super.key,
    required this.assetPath,
    required this.child,
  });

  /// アセットパス（例: assets/images/login_background.svg）。
  final String assetPath;

  /// 前景の子ウィジェット。
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned.fill(
          child: IgnorePointer(
            child: SvgPicture.asset(
              assetPath,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              excludeFromSemantics: true,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
