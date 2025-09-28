# プロジェクト概要

## 基本情報
- **プロジェクト名**: TCG Match Manager Frontend
- **アーキテクチャ**: Clean Architecture + モノレポ構成
- **パッケージ管理**: Melos
- **技術スタック**: Flutter + Dart + Riverpod

## パッケージ構成
このプロジェクトは以下のパッケージで構成されています：

### Clients
- **`clients/app`** - メインの Flutter アプリケーション
- **`clients/admin`** - 管理者用 Flutter アプリケーション

### Packages (Clean Architecture レイヤー)
- **`packages/app`** - アプリケーションエントリーポイント
- **`packages/base_ui`** - 共通 UI コンポーネントとテーマ
- **`packages/domain`** - ビジネスロジックとユースケース（Domain Layer）
- **`packages/repository`** - データレイヤーとリポジトリ実装（Data Layer）
- **`packages/system`** - システムレベルサービス（HTTP、ローカルストレージ）
- **`packages/injection`** - 依存性注入の設定
- **`packages/util`** - ユーティリティ関数とヘルパー（純粋なDart）

## 主要技術
- **状態管理**: コード生成付き Riverpod
- **UI**: カスタムテーマ付き Flutter Material Design
- **ローカライゼーション**: ARB ファイルを使った多言語サポート（日本語/英語）
- **テスト**: モックを使った包括的なテストカバレッジ（100%目標）
- **コード生成**: Freezed、build_runner
- **静的解析**: altive_lints + custom_lint

## 開発環境
- **Flutter バージョン管理**: FVM (.fvmrc設定)
- **SDK要求**: Dart ^3.9.0
- **IDE設定**: Cursor IDE用詳細ルール定義