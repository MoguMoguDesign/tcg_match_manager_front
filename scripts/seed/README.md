# テストデータ投入スクリプト

Firebase Firestore にテストデータを自動投入するためのスクリプトです。

## セットアップ

### 1. サービスアカウントキーの取得

1. [Firebase Console](https://console.firebase.google.com/) を開く
2. プロジェクトを選択
3. **プロジェクト設定** > **サービスアカウント** タブ
4. **新しい秘密鍵を生成** をクリック
5. ダウンロードした JSON ファイルを `serviceAccountKey.json` という名前でプロジェクトルートに配置

```bash
# プロジェクトルートに配置
mv ~/Downloads/your-project-firebase-adminsdk-xxxxx.json ../../serviceAccountKey.json
```

### 2. 環境変数の設定

```bash
# プロジェクトルートで実行
cd ../..
cp .env.seed.example .env.seed

# .env.seed を編集して、プロジェクト ID を設定
# FIREBASE_PROJECT_ID=your-project-id
```

### 3. 依存関係のインストール

```bash
# このディレクトリで実行
dart pub get
```

## 使い方

### プロジェクトルートから実行

```bash
# 全データセットを投入
melos run seed:test-data

# エミュレータに投入
melos run seed:emulator
```

### 直接実行

```bash
# このディレクトリから実行
dart run seed_test_data.dart

# オプション指定
dart run seed_test_data.dart --dataset small --verbose
```

## トラブルシューティング

### 認証エラー

サービスアカウントキーのパスが正しいか確認してください。

```bash
ls -la ../../serviceAccountKey.json
```

### 権限エラー

Firebase Console で、サービスアカウントに **Cloud Datastore User** ロールが付与されているか確認してください。

## 詳細ドキュメント

- [設計書](../../docs/テストデータ自動投入機能_設計書.md)
- [実装仕様書](../../docs/specs/test-data-seeder-implementation-spec.md)
- [クイックスタートガイド](../../docs/テストデータ自動投入_README.md)
