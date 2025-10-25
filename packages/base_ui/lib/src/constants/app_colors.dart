// デザインシステムのカラー定義ファイルのため、ハードコーディングされた色の使用を許可
// ignore_for_file: avoid_hardcoded_color

import 'package:flutter/material.dart';

/// アプリケーション全体で使用するカラーパレットを定義する。
///
/// TCG マッチマネージャーアプリのブランドカラーや、
/// 各種 UI コンポーネントで使用する統一された色を提供する。
/// Figma デザインシステム (node-id: 45-5042) に基づく。
class AppColors {
  // ==========================================
  // 基本色系統（白 → グレー → 黒）
  // ==========================================

  /// 純白色。
  /// 背景やコンテナの基本色として使用される。
  static const Color white = Color(0xFFFFFFFF);

  /// 純黒色。
  /// テキストやアイコンの基本色として使用される。
  static const Color black = Color(0xFF000000);

  /// 透明色。
  /// オーバーレイやダイアログの背景として使用される。
  static const Color transparent = Color(0x00000000);

  /// アプリ全体の背景色（オフホワイト）。
  /// メイン背景として使用される。
  static const Color background = Color(0xFFFEFEFE);

  /// 薄いグレー色。
  /// セクション背景や薄い境界線として使用される。
  static const Color grayLight = Color(0xFFF9FAFF);

  /// 非常に薄い背景色。
  /// ページ全体の背景として使用される。
  static const Color backgroundLight = Color(0xFFF8F9FA);

  /// 入力フィールド背景用の色。
  /// テキストフィールドの背景として使用される。
  static const Color backgroundField = Color(0xFFF5F5F5);

  /// 薄い青系背景色。
  /// アクセント背景として使用される。
  static const Color backgroundBlue = Color(0xFFF1F3FF);

  /// 軽い境界線用のグレー色。
  /// 薄い境界線や分割線として使用される。
  static const Color borderLight = Color(0xFFE0E0E0);

  /// グレー境界線用の色。
  /// 標準的な境界線として使用される。
  static const Color borderGray = Color(0xFFE2E8F0);

  /// 無効状態の境界線用の色。
  /// 無効なボタンやフィールドの境界線として使用される。
  static const Color borderDisabled = Color(0xFFD9D9D9);

  /// 中間のグレー色。
  /// セカンダリテキストやアイコンとして使用される。
  static const Color gray = Color(0xFFA5A6AE);

  /// 無効状態テキスト用の色。
  /// 無効なボタンやテキストで使用される。
  static const Color textDisabled = Color(0xFF9CA3AF);

  /// 濃いグレー色。
  /// サブテキストやヒントテキストとして使用される。
  static const Color grayDark = Color(0xFF7A7A83);

  /// セカンダリテキスト用のグレー色。
  /// 補助テキストや説明文で使用される。
  static const Color textGray = Color(0xFF6B7280);

  /// Flutter デフォルトのグレー色。
  /// 一般的なグレー表示に使用される。
  static const Color grey = Color(0xFF9E9E9E);

  /// テキスト用の濃い青色。
  /// 主要なテキストコンテンツで使用される。
  static const Color textBlack = Color(0xFF000336);

  // ==========================================
  // ブランドカラー系統
  // ==========================================

  /// ユーザー用のプライマリカラー（明るい緑）。
  /// ボタンやアクセントカラーとして使用される。
  static const Color userPrimary = Color(0xFFB4EF03);

  /// 管理者用のプライマリカラー（青）。
  /// 管理者向け機能の UI 要素で使用される。
  static const Color adminPrimary = Color(0xFF3A44FB);

  /// Flutter デフォルトの青色。
  /// 一般的な青色表示に使用される。
  static const Color blue = Color(0xFF2196F3);

  // ==========================================
  // 状態色系統（緑 → 黄 → 赤）
  // ==========================================

  /// アクティブ成功状態の緑色。
  /// 選択されたボタンやアクティブ状態で使用される。
  static const Color successActive = Color(0xFF22C55E);

  /// 成功状態を示す緑色。
  /// SnackBarや成功メッセージで使用される。
  static const Color success = Color(0xFF38A169);

  /// 警告・ゴールド色。
  /// 継続中トーナメントのアクセントとして使用される。
  static const Color warning = Color(0xFFFFD700);

  /// エラー状態を示す赤色。
  /// エラーメッセージや削除ボタンで使用される。
  static const Color error = Color(0xFFEF4444);

  /// Flutter デフォルトの赤色。
  /// 一般的な赤色表示に使用される。
  static const Color red = Color(0xFFF44336);

  /// アラート用の赤色。
  /// 警告やエラー、重要なアクションボタンで使用される。
  static const Color alart = Color(0xFFFF4646);

  // ==========================================
  // 特殊カラー
  // ==========================================

  /// 敗北状態を示す薄紫色。
  /// VS コンテナやプレイヤーコンテナの敗北状態で使用される。
  static const Color loseNormal = Color(0xFFD4CAF0);

  /// 金メダル色。
  /// 1位のランキング表示で使用される。
  static const Color gold = Color(0xFFFFD700);

  /// 銀メダル色。
  /// 2位のランキング表示で使用される。
  static const Color silver = Color(0xFFC0C0C0);

  /// 銅メダル色。
  /// 3位のランキング表示で使用される。
  static const Color bronze = Color(0xFFCD7F32);

  // ==========================================
  // 透明度版カラー
  // ==========================================

  /// 白色の透明度版（透明度50%）。
  /// 半透明の背景やオーバーレイとして使用される。
  static const Color whiteAlpha = Color(0x80FFFFFF);

  /// 白色の透明度版（透明度20%）。
  /// 薄いラベル背景として使用される。
  static const Color whiteLightAlpha = Color(0x33FFFFFF);

  /// 白色の透明度版（透明度70%）。
  /// オーバーレイや半透明背景として使用される。
  static const Color white70 = Color(0xB3FFFFFF);

  /// ユーザープライマリカラーの透明度版（透明度20%）。
  /// オーバーレイや薄い背景として使用される。
  static const Color userPrimaryAlpha = Color(0x33B4EF03);

  /// 管理者カラーの透明度版（透明度20%）。
  /// 管理者向けオーバーレイとして使用される。
  static const Color adminPrimaryAlpha = Color(0x333A44FB);

  // ==========================================
  // グラデーション用カラー
  // ==========================================

  /// ライトグリーンのグラデーション色。
  /// 認証画面のグラデーションで使用される。
  static const Color gradientLightGreen = Color(0xFFD8FF62);

  /// ダークブルーのグラデーション色。
  /// トーナメント詳細画面のグラデーションで使用される。
  static const Color gradientDarkBlue = Color(0xFF1219A9);

  /// 非常に濃い色のグラデーション。
  /// グラデーションの終端色として使用される。
  static const Color gradientBlack = Color(0xFF071301);
}
