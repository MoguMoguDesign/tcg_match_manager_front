import 'package:flutter_test/flutter_test.dart';
import 'package:repository/src/repository_result.dart';

void main() {
  group('RepositoryResult のテスト。', () {
    group('success コンストラクタのテスト。', () {
      test('データを渡して成功結果を作成できる。', () {
        const testData = 'test data';
        const result = RepositoryResult.success(testData);

        expect(result, isA<SuccessRepositoryResult<String>>());
        expect((result as SuccessRepositoryResult<String>).data, testData);
      });

      test('null データでも成功結果を作成できる。', () {
        const String? testData = null;
        const result = RepositoryResult<String?>.success(testData);

        expect(result, isA<SuccessRepositoryResult<String?>>());
        expect((result as SuccessRepositoryResult<String?>).data, null);
      });
    });

    group('failure コンストラクタのテスト。', () {
      test('基本的な失敗結果を作成できる。', () {
        final exception = Exception('test error');
        const reason = FailureRepositoryResultReason.connectionTimeout;

        final result = RepositoryResult<String>.failure(
          exception,
          reason: reason,
        );

        expect(result, isA<FailureRepositoryResult<String>>());
        final failureResult = result as FailureRepositoryResult<String>;
        expect(failureResult.e, exception);
        expect(failureResult.reason, reason);
        expect(failureResult.data, null);
        expect(failureResult.statusCode, null);
      });

      test('データとステータスコードを含む失敗結果を作成できる。', () {
        final exception = Exception('test error');
        const reason = FailureRepositoryResultReason.badResponse;
        const testData = 'test data';
        const statusCode = 400;

        final result = RepositoryResult<String>.failure(
          exception,
          reason: reason,
          data: testData,
          statusCode: statusCode,
        );

        expect(result, isA<FailureRepositoryResult<String>>());
        final failureResult = result as FailureRepositoryResult<String>;
        expect(failureResult.e, exception);
        expect(failureResult.reason, reason);
        expect(failureResult.data, testData);
        expect(failureResult.statusCode, statusCode);
      });

      test('failureStatus の場合、data が非 null で失敗結果を作成できる。', () {
        final exception = Exception('test error');
        const reason = FailureRepositoryResultReason.failureStatus;
        const testData = 'test data';

        final result = RepositoryResult<String>.failure(
          exception,
          reason: reason,
          data: testData,
        );

        expect(result, isA<FailureRepositoryResult<String>>());
        final failureResult = result as FailureRepositoryResult<String>;
        expect(failureResult.e, exception);
        expect(failureResult.reason, reason);
        expect(failureResult.data, testData);
      });
    });
  });

  group('FailureRepositoryResultReason のテスト。', () {
    group('enum 値の確認。', () {
      test('すべての enum 値が定義されている。', () {
        const expectedValues = [
          FailureRepositoryResultReason.failureStatus,
          FailureRepositoryResultReason.notFound,
          FailureRepositoryResultReason.connectionTimeout,
          FailureRepositoryResultReason.sendTimeout,
          FailureRepositoryResultReason.receiveTimeout,
          FailureRepositoryResultReason.badCertificate,
          FailureRepositoryResultReason.badResponse,
          FailureRepositoryResultReason.cancel,
          FailureRepositoryResultReason.connectionError,
          FailureRepositoryResultReason.noConnection,
          FailureRepositoryResultReason.unknown,
        ];

        expect(FailureRepositoryResultReason.values, expectedValues);
      });
    });

    group('fromString メソッドのテスト。', () {
      test('有効な名前を渡した場合、対応する enum 値を返す。', () {
        expect(
          FailureRepositoryResultReason.fromString('failureStatus'),
          FailureRepositoryResultReason.failureStatus,
        );
        expect(
          FailureRepositoryResultReason.fromString('notFound'),
          FailureRepositoryResultReason.notFound,
        );
        expect(
          FailureRepositoryResultReason.fromString('connectionTimeout'),
          FailureRepositoryResultReason.connectionTimeout,
        );
        expect(
          FailureRepositoryResultReason.fromString('sendTimeout'),
          FailureRepositoryResultReason.sendTimeout,
        );
        expect(
          FailureRepositoryResultReason.fromString('receiveTimeout'),
          FailureRepositoryResultReason.receiveTimeout,
        );
        expect(
          FailureRepositoryResultReason.fromString('badCertificate'),
          FailureRepositoryResultReason.badCertificate,
        );
        expect(
          FailureRepositoryResultReason.fromString('badResponse'),
          FailureRepositoryResultReason.badResponse,
        );
        expect(
          FailureRepositoryResultReason.fromString('cancel'),
          FailureRepositoryResultReason.cancel,
        );
        expect(
          FailureRepositoryResultReason.fromString('connectionError'),
          FailureRepositoryResultReason.connectionError,
        );
        expect(
          FailureRepositoryResultReason.fromString('noConnection'),
          FailureRepositoryResultReason.noConnection,
        );
        expect(
          FailureRepositoryResultReason.fromString('unknown'),
          FailureRepositoryResultReason.unknown,
        );
      });

      test('無効な名前を渡した場合、ArgumentError が発生する。', () {
        expect(
          () => FailureRepositoryResultReason.fromString('invalidName'),
          throwsA(isA<ArgumentError>()),
        );
        expect(
          () => FailureRepositoryResultReason.fromString(''),
          throwsA(isA<ArgumentError>()),
        );
        expect(
          () => FailureRepositoryResultReason.fromString('NOTFOUND'),
          throwsA(isA<ArgumentError>()),
        );
      });
    });
  });
}
