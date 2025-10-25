import 'package:test/test.dart';

import '../../writer/firestore_writer.dart';

void main() {
  group('WriteResult のテスト。', () {
    test('成功時の WriteResult を作成できる。', () {
      const result = WriteResult(
        success: true,
        tournamentId: 'test-tournament-001',
      );

      expect(result.success, isTrue);
      expect(result.tournamentId, equals('test-tournament-001'));
      expect(result.error, isNull);
    });

    test('失敗時の WriteResult を作成できる。', () {
      const result = WriteResult(
        success: false,
        tournamentId: 'test-tournament-001',
        error: 'テストエラー',
      );

      expect(result.success, isFalse);
      expect(result.tournamentId, equals('test-tournament-001'));
      expect(result.error, equals('テストエラー'));
    });

    test('エラーメッセージなしの失敗を作成できる。', () {
      const result = WriteResult(
        success: false,
        tournamentId: 'test-tournament-001',
      );

      expect(result.success, isFalse);
      expect(result.tournamentId, equals('test-tournament-001'));
      expect(result.error, isNull);
    });
  });

  // FirestoreWriter の実際の書き込みテストは、
  // Firebase Emulator を使った統合テストで実施する。
  // ここでは、WriteResult のテストのみ実装する。
  //
  // 統合テストは、scripts/seed/test/integration_test.dart で実施予定。
  //
  // FirestoreWriter クラス自体の単体テストは、モックが複雑になるため、
  // 統合テストでカバーする方針とする。
}
