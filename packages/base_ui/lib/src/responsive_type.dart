import 'package:flutter/material.dart';

/// レスポンシブ対応のための列挙型。
///
/// Material Design 3 の定義に準拠して、ウィンドウの横幅を元に分類する。
///
/// 参考：
/// https://m3.material.io/foundations/layout/applying-layout/window-size-classes
enum ResponsiveType {
  /// compact サイズ(横幅 600 dp 未満）。
  ///
  /// 主に、モバイルの縦向き時に用いられる。
  compact,

  /// medium サイズ（横幅 600 dp 以上 840 dp 未満）。
  ///
  /// 主に、タブレットの縦向き時に用いられる。
  medium,

  /// expanded サイズ（横幅 840 dp 以上）。
  ///
  /// 主に、モバイルやタブレットの横向き時に用いられる。
  expanded;

  /// ウィンドウの横幅を元に、[ResponsiveType] を生成する。
  factory ResponsiveType.fromWindowWidth(BuildContext context) {
    final windowWidth = MediaQuery.sizeOf(context).width;

    if (windowWidth < 600) {
      return compact;
    }
    if (windowWidth < 840) {
      return medium;
    }
    return expanded;
  }

  /// [compact] サイズかどうかを返す。
  bool get isCompact => this == compact;
}
