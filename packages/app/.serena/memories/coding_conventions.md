# コーディング規約

## リントルール
- `altive_lints`を使用した厳格なLintルール
- `public_member_api_docs`により全パブリックメンバーにドキュメント必須

## ドキュメント標準
- **日本語ドキュメント**: すべてのコメントとドキュメントは日本語で記述
- **Dart Doc形式**: `///` を使用したドキュメンテーションコメント
- クラス、メソッド、関数の目的と使用方法を明記

## コード生成
- **Freezed**: イミュータブルなデータクラス用
- **json_annotation/json_serializable**: JSON シリアライゼーション用
- **Riverpod Generator**: 状態管理プロバイダー用

## アーキテクチャパターン
### Clean Architecture レイヤー分離
- Domain Layer: ビジネスロジック、エンティティ、リポジトリインターフェース
- Data Layer: リポジトリ実装、データソース
- Presentation Layer: UI、状態管理
- Infrastructure: 依存性注入

### 命名規則
- **クラス**: PascalCase
- **メソッド/関数**: camelCase  
- **変数**: camelCase
- **定数**: camelCase（`static const`）
- **プライベートメンバー**: 先頭にアンダースコア

## 状態管理
- **Riverpod**を使用（コード生成付き）
- **Hooks**の併用も可
- 状態の不変性を保つためFreezedを活用

## 多言語対応
- ハードコーディングされた文字列は禁止
- `app_ja.arb`で日本語定義、`arb_translate`で他言語自動生成
- `L10n.of(context).fieldName`形式で使用

## テスト
- **100%カバレッジ**を目標（domain、repository、system、injection、utilパッケージ）
- Mockitoを使用したモックテスト
- テストファイル命名: `*_test.dart`

## ファイル構成
- パッケージ内での`src/`ディレクトリ使用
- エクスポート用のバレルファイル作成
- 適切なimport/exportの管理