import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const String fontFamily = 'M PLUS 1p';
  
  // ヘッドライン
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 20,
    height: 1.0,
    color: AppColors.primary,
    letterSpacing: -0.28,
  );
  
  // ラベル
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    height: 2.25, // 36px / 16px
    color: AppColors.textBlack,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 14,
    height: 1.0,
    color: AppColors.white,
    letterSpacing: -0.28,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 10,
    height: 1.0,
    color: AppColors.primary,
    letterSpacing: -0.28,
  );
  
  // ボディ
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.normal,
    fontSize: 16,
    height: 1.0,
    color: AppColors.white,
    letterSpacing: -0.28,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.normal,
    fontSize: 12,
    height: 1.0,
    color: AppColors.white,
    letterSpacing: -0.28,
  );
}