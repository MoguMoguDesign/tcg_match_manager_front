# タスク完了時のワークフロー

## 実装後の必須チェック

### 1. コード品質チェック
```bash
# 静的解析実行
melos run analyze

# カスタムリントチェック
melos run custom_lint

# 自動修正適用
melos run fix

# コードフォーマット
melos run format
```

### 2. テスト実行
```bash
# 関連するテストの実行
melos run test

# 特定パッケージのテスト（必要に応じて）
PACKAGE=domain melos run test:dart-with-coverage
PACKAGE=app melos run test:flutter-with-coverage
```

### 3. ビルド確認
```bash
# コード生成が必要な場合
melos run build_runner:build

# Flutter Webビルド確認
fvm flutter build web
```

### 4. 翻訳更新（UI変更時）
```bash
# 翻訳ファイル更新
melos run translate
```

## CLAUDE.mdルールの遵守

### 実装前チェックリスト
- [ ] 適切なCursorルールファイルを読み込み
- [ ] 常に適用されるルール（4つ）をすべて確認
- [ ] パッケージ固有のルールを適用
- [ ] ドキュメント要件の理解

### 必須ルールファイル
1. `/project.mdc` - プロジェクト概要
2. `/operations/before-implementation.mdc` - 実装前準備
3. `/operations/after-implementation.mdc` - 実装後検証
4. `/coding-rules/documentation.mdc` - 日本語ドキュメント標準
5. `/docs/` - 仕様書・設計資料

## エラーハンドリング

### よくあるエラーと対処法
- **依存関係エラー**: `fvm dart run melos bs` で解決
- **ビルドエラー**: `melos clean` → `melos bs` で再構築
- **Lintエラー**: `melos run fix` で自動修正試行
- **コード生成エラー**: `melos run build_runner:build` で再生成

## Git操作
- コミット前に品質チェック実行必須
- 適切なコミットメッセージ（日本語）
- PRレビュー前に全チェック完了確認