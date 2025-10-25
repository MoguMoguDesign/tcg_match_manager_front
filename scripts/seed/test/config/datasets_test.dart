import 'package:test/test.dart';

import '../../config/datasets.dart';

void main() {
  group('TestDataset のテスト。', () {
    group('fromId メソッドのテスト。', () {
      test('有効な ID で正しい TestDataset を返す。', () {
        expect(TestDataset.fromId('small'), equals(TestDataset.small));
        expect(TestDataset.fromId('bye'), equals(TestDataset.bye));
        expect(TestDataset.fromId('completed'), equals(TestDataset.completed));
        expect(
          TestDataset.fromId('preparing'),
          equals(TestDataset.preparing),
        );
      });

      test('無効な ID で ArgumentError をスローする。', () {
        expect(
          () => TestDataset.fromId('invalid'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('空文字列で ArgumentError をスローする。', () {
        expect(
          () => TestDataset.fromId(''),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('allIds メソッドのテスト。', () {
      test('すべてのデータセット ID を返す。', () {
        final allIds = TestDataset.allIds;

        expect(allIds.length, equals(4));
        expect(allIds, contains('small'));
        expect(allIds, contains('bye'));
        expect(allIds, contains('completed'));
        expect(allIds, contains('preparing'));
      });

      test('返されるリストの順序が定義順と一致する。', () {
        final allIds = TestDataset.allIds;

        expect(allIds[0], equals('small'));
        expect(allIds[1], equals('bye'));
        expect(allIds[2], equals('completed'));
        expect(allIds[3], equals('preparing'));
      });
    });

    group('プロパティのテスト。', () {
      test('各データセットの id プロパティが正しい。', () {
        expect(TestDataset.small.id, equals('small'));
        expect(TestDataset.bye.id, equals('bye'));
        expect(TestDataset.completed.id, equals('completed'));
        expect(TestDataset.preparing.id, equals('preparing'));
      });

      test('各データセットの displayName プロパティが正しい。', () {
        expect(
          TestDataset.small.displayName,
          equals('テスト大会（小規模・開催中）'),
        );
        expect(TestDataset.bye.displayName, equals('テスト大会（BYE あり）'));
        expect(
          TestDataset.completed.displayName,
          equals('テスト大会（完了済み）'),
        );
        expect(
          TestDataset.preparing.displayName,
          equals('テスト大会（開催前）'),
        );
      });
    });

    group('包括的なテスト。', () {
      test('すべての値で fromId が正常に動作する。', () {
        for (final dataset in TestDataset.values) {
          final result = TestDataset.fromId(dataset.id);
          expect(result, equals(dataset));
        }
      });
    });
  });
}
