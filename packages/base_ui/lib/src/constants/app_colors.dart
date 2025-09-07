// デザインシステムのカラー定義ファイルのため、ハードコーディングされた色の使用を許可
// ignore_for_file: avoid_hardcoded_color

import 'package:flutter/material.dart';

/// アプリケーション全体で使用するカラーパレットを定義する。
/// 
/// TCG マッチマネージャーアプリのブランドカラーや、
/// 各種 UI コンポーネントで使用する統一された色を提供する。
/// Figma デザインシステム (node-id: 45-5042) に基づく。
class AppColors {
  // ベースカラー (Figma デザインシステムから)
  /// 白色。
  /// 背景やテキストの色として使用される。
  static const Color white = Color(0xFFFFFFFF);
  
  /// 薄いグレー色。
  /// 背景や薄い境界線として使用される。
  static const Color grayLight = Color(0xFFF9FAFF);
  
  /// 中間のグレー色。
  /// セカンダリテキストやアイコンとして使用される。
  static const Color gray = Color(0xFFA5A6AE);
  
  /// 濃いグレー色。
  /// サブテキストやヒントテキストとして使用される。
  static const Color grayDark = Color(0xFF7A7A83);
  
  /// テキスト用の濃い青色。
  /// 主要なテキストコンテンツで使用される。
  static const Color textBlack = Color(0xFF000336);
  
  /// ユーザー用のプライマリカラー（明るい緑）。
  /// ボタンやアクセントカラーとして使用される。
  static const Color userPrimary = Color(0xFFB4EF03);
  
  /// 管理者用のプライマリカラー（青）。
  /// 管理者向け機能の UI 要素で使用される。
  static const Color adminPrimary = Color(0xFF3A44FB);
  
  // アプリ固有のカラー
  /// アプリ全体の背景色（オフホワイト）。
  static const Color background = Color(0xFFFEFEFE);
  
  // 透明度版カラー
  /// ユーザープライマリカラーの透明度版（透明度20%）。
  /// オーバーレイや薄い背景として使用される。
  static const Color userPrimaryAlpha = Color(0x33B4EF03);
  
  /// 管理者カラーの透明度版（透明度20%）。
  /// 管理者向けオーバーレイとして使用される。
  static const Color adminPrimaryAlpha = Color(0x333A44FB);
  
  /// 白色の透明度版（透明度50%）。
  /// 半透明の背景やオーバーレイとして使用される。
  static const Color whiteAlpha = Color(0x80FFFFFF);
  
  /// 敗北状態を示す薄紫色。
  /// VS コンテナやプレイヤーコンテナの敗北状態で使用される。
  static const Color loseNormal = Color(0xFFB0A3E3);
  
}
