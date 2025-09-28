# タスク完了時のチェックリスト

## 実装後の必須検証手順

### 1. テスト実行
**新しいファイルを作成したり、既存のファイルを変更した場合は必ず実行**

#### テストコマンドの選択基準
- **flutter_test使用**: `flutter test test/path/to/test_file.dart`
- **test使用**: `dart test test/path/to/test_file.dart`

判断方法: テストファイルのimport文を確認
```dart
import 'package:flutter_test/flutter_test.dart'; // → flutter test
import 'package:test/test.dart'; // → dart test
```

#### パッケージ別実行方法
```bash
# 対象パッケージのディレクトリに移動してから実行
cd packages/domain
flutter test test/specific_test.dart

# または特定パッケージを指定
PACKAGE=domain melos run test:flutter
```

### 2. lintチェック
**変更したファイルのみを対象に実行**

#### 実行手順
1. **単一ファイル解析**:
   ```bash
   dart analyze [変更したファイルパス]
   ```

2. **カスタムlint**（プロジェクトルートから）:
   ```bash
   dart run custom_lint
   ```

3. **複数ファイル変更時**:
   - 各ファイルに対して個別に `dart analyze` 実行
   - 最後にプロジェクトルートから一度 `dart run custom_lint` 実行

#### 重要な注意事項
- **INFOレベルまで解決**: 全ての問題を解決するまで修正継続
- **3回ルール**: 同じファイルで3回以上lintエラー修正をループしている場合はユーザーに相談
- **全体チェック回避**: `melos run analyze` は時間がかかるため変更ファイルのみに集中

### 3. エラー対応
#### テスト失敗時
- 変更したファイルの修正
- 必要に応じてテストケースの修正

#### lint問題発生時
- 変更したファイルで発生した問題を全て解決
- custom_lintはプロジェクトルートからのみ実行可能

### 4. 完了確認
- [ ] 関連テストが全て成功
- [ ] 変更ファイルのlint問題が全て解決
- [ ] カスタムlintで問題なし
- [ ] コードが要求仕様を満たしている

## 避けるべき行動
- 全体テスト・解析の実行（時間がかかる）
- INFOレベル問題の放置
- 無限修正ループの継続（3回で相談）