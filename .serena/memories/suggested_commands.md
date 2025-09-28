# 推奨コマンド一覧

## 環境セットアップ
```bash
# macOS環境のセットアップ
make setup-macos

# Windows環境のセットアップ
make setup-windows

# Flutter SDKのアップグレード
make upgrade-flutter
```

## アプリケーション実行
```bash
# メインアプリを起動
make run-app
# または
cd clients/app && fvm flutter run -d chrome

# 管理者アプリを起動
make run-admin
# または
cd clients/admin && fvm flutter run -d chrome

# 両方のアプリを同時起動
make run-both
```

## テスト実行
```bash
# 全テスト実行
melos run test

# Flutter依存パッケージのテスト
melos run test:flutter

# カバレッジ付きFlutterテスト
melos run test:flutter-with-coverage

# カバレッジ付きDartテスト
melos run test:dart-with-coverage

# 特定パッケージのテスト
PACKAGE=domain melos run test:flutter
```

## コード品質
```bash
# 静的解析
melos run analyze

# カスタムlint
melos run custom_lint
# または
dart run custom_lint

# フォーマット
melos run format

# 自動修正
melos run fix

# 単一ファイルの解析
dart analyze [ファイルパス]
```

## コード生成・ビルド
```bash
# ビルドランナー実行
melos run build_runner:build

# ビルドランナー監視モード
melos run build_runner:watch

# 翻訳処理
melos run translate
```

## パッケージ管理
```bash
# 依存関係の更新
melos run upgrade

# 古いパッケージの確認
melos run outdated

# メロスブートストラップ
fvm dart run melos bs
```

## クリーンアップ
```bash
# クライアントアプリのクリーン
make clean-clients

# 全体クリーン
melos run clean
```

## 重要な注意事項
- 全てのコマンドはプロジェクトルートから実行
- FVMを使用してFlutterバージョンを管理
- カスタムlintはプロジェクトルートからのみ実行可能
- テストコマンドは利用するテストパッケージ（flutter_test vs test）によって使い分け