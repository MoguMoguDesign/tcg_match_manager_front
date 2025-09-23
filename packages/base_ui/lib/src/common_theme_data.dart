// 設定ファイルのためカラーコードのハードコーディングを可能にする
// ignore_for_file: avoid_hardcoded_color

import 'package:flutter/material.dart';

import 'constants/app_colors.dart';

/// アプリ内で共通で用いられる [ThemeData].
abstract final class CommonThemeData {
  /// ライトテーマの [ThemeData] を取得する。
  static ThemeData get lightTheme {
    return ThemeData.from(
      useMaterial3: true,
      // MEMO(masaki): CommonSwitch のトグル時のカラーの不自然さを調整するために
      // 暫定的に _seedColor の代わりに Colors.blue を利用している
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    )._applyCommon();
  }

  /// ダークテーマの [ThemeData] を取得する。
  static ThemeData get darkTheme {
    return ThemeData.from(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: Brightness.dark,
      ),
    )._applyCommon();
  }

  static const Color _seedColor = AppColors.adminPrimary;
}

extension on ThemeData {
  /// lightTheme とdarkTheme に共通した設定を反映する。
  ThemeData _applyCommon() {
    return copyWith(
      iconTheme: iconTheme.copyWith(
        // MEMO(masaki): 参考
        // 初期値の 24 から更新する
        // size: 30,
      ),
    );
  }
}
