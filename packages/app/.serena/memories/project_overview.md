# プロジェクト概要

## 基本情報
- **プロジェクト名**: flutter_monorepo_sample (TCG Match Manager)
- **目的**: TCGトーナメント管理アプリケーション（マッチメイキング、ランキング、結果管理）
- **プラットフォーム**: Flutter Web（macOS/Windows開発環境対応）

## アーキテクチャ
- **Melos**を使用したモノレポアーキテクチャ
- **Clean Architecture**の原則に従った設計
- **Pub Workspaces**を利用したパッケージ管理

## パッケージ構成
- `app/` - メインFlutterアプリケーションのエントリーポイント
- `base_ui/` - 共通UIコンポーネントとテーマ
- `domain/` - ビジネスロジックとユースケース
- `injection/` - 依存性注入の設定
- `repository/` - データレイヤーとリポジトリ実装
- `system/` - システムレベルサービス（HTTP、ローカルストレージ）
- `util/` - ユーティリティ関数とヘルパー

## 主要技術スタック
- **状態管理**: Riverpod（コード生成付き）
- **UI**: Flutter Material Design（カスタムテーマ）
- **アーキテクチャ**: Clean Architecture + DDD
- **バージョン管理**: FVM（Flutter Version Management）
- **国際化**: arb_translate による多言語対応（日本語/英語）

## 現在のプロジェクト状況
- 16人対応の4ラウンドトーナメントシステム
- ランキングシステム（OMW計算含む）
- 各種UI画面（ログイン、マッチング、最終順位表など）