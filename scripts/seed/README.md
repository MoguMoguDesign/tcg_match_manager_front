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

### 3. Firestore セキュリティルールの設定（重要）

**⚠️ 注意**: 現在の実装では、firedart パッケージの制限により、サービスアカウント認証が完全にサポートされていません。そのため、開発環境でのみ使用可能です。

**開発環境での使用時の設定**:

Firebase Console で Firestore セキュリティルールを一時的に以下のように変更してください：

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // テストデータ投入時のみ許可（開発環境のみ）
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

**⚠️ 本番環境では絶対に上記のルールを使用しないでください！**

投入完了後は、元のセキュリティルールに戻すことを忘れないでください。

### 4. 依存関係のインストール

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

# dry-run モード（実際の書き込みを行わず、データ生成のみテスト）
dart run seed_test_data.dart --dry-run

# 特定のデータセットのみ投入
dart run seed_test_data.dart --dataset small

# 既存データを強制上書き
dart run seed_test_data.dart --force

# 詳細ログを出力
dart run seed_test_data.dart --verbose

# 複数オプション組み合わせ
dart run seed_test_data.dart --dataset small,bye --verbose --force
```

### 利用可能なオプション

| オプション | 短縮形 | 説明 | デフォルト |
|-----------|--------|------|-----------|
| `--dataset` | `-d` | 投入するデータセット（small, bye, completed, preparing, all） | all |
| `--emulator` | `-e` | エミュレータを使用する | false |
| `--force` | `-f` | 既存データを強制上書き | false |
| `--verbose` | `-v` | 詳細ログを出力 | false |
| `--dry-run` | - | 実際の書き込みを行わず、処理内容のみ表示 | false |
| `--help` | `-h` | ヘルプを表示 | - |

### データセットの種類

- `small`: テスト大会（小規模・開催中）- 8人、ラウンド2進行中
- `bye`: テスト大会（BYE あり）- 9人、BYEマッチを含む
- `completed`: テスト大会（完了済み）- 8人、3ラウンド完了
- `preparing`: テスト大会（開催前）- 12人、プレイヤー登録受付中

## トラブルシューティング

### 認証エラー

サービスアカウントキーのパスが正しいか確認してください。

```bash
ls -la ../../serviceAccountKey.json
```

### 権限エラー

Firebase Console で、サービスアカウントに **Cloud Datastore User** ロールが付与されているか確認してください。

## テスト実行

このスクリプトには単体テストが実装されています。

### 全テストの実行

```bash
# このディレクトリから実行
dart test

# または、特定のテストファイルのみ実行
dart test test/config/datasets_test.dart
dart test test/generators/dataset_factory_test.dart
dart test test/generators/small_tournament_generator_test.dart
dart test test/models/tournament_data_test.dart
dart test test/writer/firestore_writer_test.dart
```

### テストカバレッジの確認

```bash
# カバレッジレポートを生成
dart test --coverage=coverage

# カバレッジレポートをフォーマット（要 lcov インストール）
genhtml coverage/lcov.info -o coverage/html

# ブラウザで確認
open coverage/html/index.html
```

### 実装されているテスト

| テストファイル | 対象 | テスト内容 |
|---------------|------|-----------|
| `test/config/datasets_test.dart` | `TestDataset` enum | データセット定義の動作確認 |
| `test/generators/dataset_factory_test.dart` | `DatasetFactory` | データセット生成の動作確認 |
| `test/generators/small_tournament_generator_test.dart` | `SmallTournamentGenerator` | 小規模トーナメントデータ生成の動作確認 |
| `test/models/tournament_data_test.dart` | `TournamentData` | データモデルとバリデーションの動作確認 |
| `test/writer/firestore_writer_test.dart` | `WriteResult` | 書き込み結果の動作確認 |

### 統合テスト（今後実装予定）

Firebase Emulator を使った統合テストは今後実装予定です。

## 詳細ドキュメント

- [設計書](../../docs/テストデータ自動投入機能_設計書.md)
- [実装仕様書](../../docs/specs/test-data-seeder-implementation-spec.md)
- [クイックスタートガイド](../../docs/テストデータ自動投入_README.md)
