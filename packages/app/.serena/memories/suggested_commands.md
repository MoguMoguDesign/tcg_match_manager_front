# 推奨コマンド集

## 環境セットアップ
```bash
# macOSの場合
make setup-macos

# Windowsの場合
make setup-windows
```

## Melos/Flutter管理
```bash
# 依存関係のブートストラップ
fvm dart run melos bs

# すべてのパッケージのクリーン
melos clean

# Flutter/Dartのアップグレード
make upgrade-flutter
```

## テスト実行
```bash
# すべてのテストを実行
melos run test

# Flutterテストのみ実行
melos run test:flutter

# カバレッジ付きでFlutterテストを実行
melos run test:flutter-with-coverage

# カバレッジ付きでDartテストを実行
melos run test:dart-with-coverage

# 特定のパッケージのみテスト
PACKAGE=app melos run test:flutter
```

## コード品質
```bash
# 静的解析
melos run analyze

# カスタムリントチェック
melos run custom_lint

# コードフォーマット
melos run format

# 自動修正
melos run fix
```

## コード生成
```bash
# build_runnerでコード生成
melos run build_runner:build

# build_runnerでウォッチモード
melos run build_runner:watch
```

## 翻訳
```bash
# 翻訳処理（arb_translate）
melos run translate
```

## 依存関係管理
```bash
# 古い依存関係のチェック
melos run outdated

# 依存関係のアップグレード
melos run upgrade
```

## 日常開発でよく使うコマンド
```bash
# 1. 開発開始時
fvm dart run melos bs

# 2. テスト実行
melos run test

# 3. コード品質チェック
melos run analyze && melos run custom_lint

# 4. 完了時のフォーマット
melos run format
```