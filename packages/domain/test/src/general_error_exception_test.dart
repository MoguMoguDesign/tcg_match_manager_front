import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GeneralFailureException のテスト。', () {
    test('badResponse を指定した場合、AssertionError がスローされる。', () {
      // badResponse を指定してデフォルトコンストラクタを呼び出すと、AssertionError がスローされることを確認する。
      expect(
        () => GeneralFailureException(
          reason: GeneralFailureReason.badResponse,
          errorCode: 'badResponse',
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('GeneralFailureReason のテスト。', () {
    test('すべての列挙値が定義されている。', () {
      // 意図しない列挙値の削除や追加を検出する。
      const expectedValues = [
        GeneralFailureReason.noConnectionError,
        GeneralFailureReason.serverUrlNotFoundError,
        GeneralFailureReason.badResponse,
        GeneralFailureReason.other,
      ];

      expect(GeneralFailureReason.values, expectedValues);
    });

    test('列挙値の名前が変更されていない。', () {
      // enum 名のリファクタリングによる破壊的変更を検出する。
      expect(GeneralFailureReason.noConnectionError.name, 'noConnectionError');
      expect(
        GeneralFailureReason.serverUrlNotFoundError.name,
        'serverUrlNotFoundError',
      );
      expect(GeneralFailureReason.badResponse.name, 'badResponse');
      expect(GeneralFailureReason.other.name, 'other');
    });
  });
}
