import 'package:flutter/material.dart';

/// アプリケーション全体で使用するカラーパレットを定義する。
/// 
/// TCGマッチマネージャーアプリのブランドカラーや、
/// 各種UIコンポーネントで使用する統一された色を提供する。
class AppColors {
  /// メインのプライマリカラー（明るい緑）。
  /// ボタンやアクセントカラーとして使用される。
  static const Color primary = Color(0xFFB4EF03);
  
  /// テキスト用の濃い青色。
  /// 主要なテキストコンテンツで使用される。
  static const Color textBlack = Color(0xFF000336);
  
  /// 白色。
  /// 背景やテキストの色として使用される。
  static const Color white = Color(0xFFFFFFFF);
  
  /// 管理者用のプライマリカラー（青）。
  /// 管理者向け機能のUI要素で使用される。
  static const Color adminPrimary = Color(0xFF3A44FB);
  
  /// アプリ全体の背景色（オフホワイト）。
  static const Color background = Color(0xFFFEFEFE);
  
  /// グラデーション開始色（濃い青）。
  /// 背景グラデーションの開始点として使用される。
  static const Color gradientStart = Color(0xFF000336);
  
  /// グラデーション終了色（明るい青）。
  /// 背景グラデーションの終了点として使用される。
  static const Color gradientEnd = Color(0xFF3A44FB);
  
  /// プライマリカラーの透明度版（透明度20%）。
  /// オーバーレイや薄い背景として使用される。
  static const Color primaryAlpha = Color(0x33B4EF03);
  
  /// 管理者カラーの透明度版（透明度20%）。
  /// 管理者向けオーバーレイとして使用される。
  static const Color adminAlpha = Color(0x333A44FB);
  
  /// 白色の透明度版（透明度50%）。
  /// 半透明の背景やオーバーレイとして使用される。
  static const Color whiteAlpha = Color(0x80FFFFFF);
}