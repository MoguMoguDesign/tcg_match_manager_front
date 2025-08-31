import 'package:flutter/material.dart';
import 'app_colors.dart';

/// アプリケーション全体で使用するテキストスタイルを定義する。
/// 
/// TCGマッチマネージャーアプリで一貫したタイポグラフィを提供するため、
/// ヘッドライン、ラベル、ボディテキストのスタイルを統一的に管理する。
class AppTextStyles {
  /// アプリケーション全体で使用するフォントファミリー。
  static const String fontFamily = 'M PLUS 1p';
  
  /// 大見出し用のテキストスタイル。
  /// 主要なタイトルやページヘッダーで使用される。
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 20,
    height: 1,
    color: AppColors.primary,
    letterSpacing: -0.28,
  );
  
  /// 大きなラベル用のテキストスタイル。
  /// セクションヘッダーや重要なラベルで使用される。
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    height: 2.25, // 36px / 16px
    color: AppColors.textBlack,
  );
  
  /// 中サイズのラベル用のテキストスタイル。
  /// ボタンや小見出しで使用される。
  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 14,
    height: 1,
    color: AppColors.white,
    letterSpacing: -0.28,
  );
  
  /// 小さなラベル用のテキストスタイル。
  /// バッジやタグ、補助的な情報で使用される。
  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 10,
    height: 1,
    color: AppColors.primary,
    letterSpacing: -0.28,
  );
  
  /// 中サイズの本文テキストスタイル。
  /// 通常の説明文やコンテンツで使用される。
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.normal,
    fontSize: 16,
    height: 1,
    color: AppColors.white,
    letterSpacing: -0.28,
  );
  
  /// 小さな本文テキストスタイル。
  /// 補助的な情報や詳細データで使用される。
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.normal,
    fontSize: 12,
    height: 1,
    color: AppColors.white,
    letterSpacing: -0.28,
  );
}
