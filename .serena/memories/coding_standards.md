# コーディング標準

## ドキュメンテーション標準
- **言語**: 全て日本語で記載
- **コメント形式**: 
  - パブリックAPI: `///` 形式のドキュメントコメント必須
  - 内部実装: `//` 形式の通常コメント
- **文体規則**:
  - 半角文字と全角文字の間にスペース
  - 文末は `。` で終える（ただし半角文字で終わる場合は `.` でも可）
  - 一文要約から始め、空行で区切って詳細説明を続ける

## 型別コメント規則
- **bool型**: 「かどうか」で終わる
  ```dart
  /// 管理者かどうか。
  bool isAdmin;
  ```
- **変数・プロパティ**: 名詞句で終わる
  ```dart
  /// ユーザーの年齢を表す整数値。
  int age;
  ```
- **関数・メソッド**: 動詞で終わる
  ```dart
  /// 新しいユーザーを追加する。
  void addUser(User user) { ... }
  ```

## lint ルール
- **基盤**: altive_lints ^1.22.0
- **カスタム**: custom_lint ^0.7.6
- **要求事項**:
  - public_member_api_docs: パブリックAPIドキュメント必須
  - 高いテストカバレッジ基準（100%目標）
  - 全INFOレベルまで解決必須

## アーキテクチャパターン
- **Clean Architecture**: 関心事の明確な分離
- **状態管理**: Riverpod + コード生成
- **依存性注入**: Provider オーバーライド
- **テスト**: モックを使った包括的カバレッジ

## コード生成
- **不変データクラス**: Freezed
- **JSON シリアライゼーション**: json_annotation + json_serializable
- **状態管理**: riverpod_generator
- **ビルドツール**: build_runner

## 実装前チェックリスト
1. CLAUDE.md 読み込み
2. 常に適用されるルール4つ全て読み込み（project.mdc, before-implementation.mdc, after-implementation.mdc, documentation.mdc）
3. パッケージ固有ルール読み込み
4. 関連仕様書・設計資料確認

## 実装後検証
1. 対象ファイルのテスト実行
2. 変更ファイルのlintチェック（dart analyze）
3. custom_lintチェック（プロジェクトルートから実行）
4. 全問題解決まで修正継続