import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:system/src/http/connectivity_interceptor.dart';
import 'package:system/src/http/http_response.dart';
import 'package:util/util.dart';

void main() {
  group('HttpResponse のテスト。', () {
    group('success コンストラクタのテスト。', () {
      test('JSON データとヘッダーを渡して成功結果を作成できる。', () {
        final jsonData = {'message': 'success', 'status': 200} as JsonMap;
        final headers = <String, List<String>>{
          'content-type': ['application/json'],
          'x-custom-header': ['test-value'],
        };

        const result = HttpResponse.success(
          jsonData: {'message': 'success', 'status': 200},
          headers: {
            'content-type': ['application/json'],
            'x-custom-header': ['test-value'],
          },
        );

        expect(result, isA<SuccessHttpResponse>());
        expect((result as SuccessHttpResponse).jsonData, jsonData);
        expect(result.headers, headers);
      });
    });

    group('failure コンストラクタのテスト。', () {
      test('基本的な失敗結果を作成できる。', () {
        final exception = Exception('test error');
        const status = ErrorStatus.connectionTimeout;

        final result = HttpResponse.failure(e: exception, status: status);

        expect(result, isA<FailureHttpResponse>());
        final failureResult = result as FailureHttpResponse;
        expect(failureResult.e, exception);
        expect(failureResult.status, status);
        expect(failureResult.statusCode, null);
      });

      test('ステータスコードを含む失敗結果を作成できる。', () {
        final exception = Exception('bad response error');
        const status = ErrorStatus.badResponse;
        const statusCode = 500;

        final result = HttpResponse.failure(
          e: exception,
          status: status,
          statusCode: statusCode,
        );

        expect(result, isA<FailureHttpResponse>());
        final failureResult = result as FailureHttpResponse;
        expect(failureResult.e, exception);
        expect(failureResult.status, status);
        expect(failureResult.statusCode, statusCode);
      });
    });
  });

  group('ErrorStatus のテスト。', () {
    group('enum 値の確認。', () {
      test('すべての enum 値が定義されている。', () {
        const expectedValues = [
          ErrorStatus.notFound,
          ErrorStatus.connectionTimeout,
          ErrorStatus.sendTimeout,
          ErrorStatus.receiveTimeout,
          ErrorStatus.badCertificate,
          ErrorStatus.badResponse,
          ErrorStatus.cancel,
          ErrorStatus.connectionError,
          ErrorStatus.noConnection,
          ErrorStatus.unknown,
        ];

        expect(ErrorStatus.values, expectedValues);
      });
    });

    group('fromDioException ファクトリメソッドのテスト。', () {
      test(
        'NetworkConnectionDioException の場合、ErrorStatus.noConnection を返す。',
        () {
          final requestOptions = RequestOptions(path: '/test');
          final exception = NetworkConnectionDioException(
            requestOptions: requestOptions,
          );

          final result = ErrorStatus.fromDioException(exception);

          expect(result, ErrorStatus.noConnection);
        },
      );

      test('DioExceptionType.badResponse かつステータスコード 404 の場合、'
          ' ErrorStatus.notFound を返す。', () {
        final requestOptions = RequestOptions(path: '/test');
        final response = Response<String>(
          statusCode: 404,
          requestOptions: requestOptions,
        );
        final exception = DioException.badResponse(
          statusCode: 404,
          requestOptions: requestOptions,
          response: response,
        );

        final result = ErrorStatus.fromDioException(exception);

        expect(result, ErrorStatus.notFound);
      });

      test('DioExceptionType.badResponse かつ 404 以外のステータスコードの場合、'
          ' ErrorStatus.badResponse を返す。', () {
        final requestOptions = RequestOptions(path: '/test');
        final response = Response<String>(
          statusCode: 500,
          requestOptions: requestOptions,
        );
        final exception = DioException.badResponse(
          statusCode: 500,
          requestOptions: requestOptions,
          response: response,
        );

        final result = ErrorStatus.fromDioException(exception);

        expect(result, ErrorStatus.badResponse);
      });

      test('DioExceptionType.connectionTimeout の場合、'
          ' ErrorStatus.connectionTimeout を返す。', () {
        final requestOptions = RequestOptions(path: '/test');
        final exception = DioException(
          requestOptions: requestOptions,
          type: DioExceptionType.connectionTimeout,
        );

        final result = ErrorStatus.fromDioException(exception);

        expect(result, ErrorStatus.connectionTimeout);
      });

      test('DioExceptionType.sendTimeout の場合、ErrorStatus.sendTimeout を返す。', () {
        final requestOptions = RequestOptions(path: '/test');
        final exception = DioException(
          requestOptions: requestOptions,
          type: DioExceptionType.sendTimeout,
        );

        final result = ErrorStatus.fromDioException(exception);

        expect(result, ErrorStatus.sendTimeout);
      });

      test(
        'DioExceptionType.receiveTimeout の場合、ErrorStatus.receiveTimeout を返す。',
        () {
          final requestOptions = RequestOptions(path: '/test');
          final exception = DioException(
            requestOptions: requestOptions,
            type: DioExceptionType.receiveTimeout,
          );

          final result = ErrorStatus.fromDioException(exception);

          expect(result, ErrorStatus.receiveTimeout);
        },
      );

      test(
        'DioExceptionType.badCertificate の場合、ErrorStatus.badCertificate を返す。',
        () {
          final requestOptions = RequestOptions(path: '/test');
          final exception = DioException(
            requestOptions: requestOptions,
            type: DioExceptionType.badCertificate,
          );

          final result = ErrorStatus.fromDioException(exception);

          expect(result, ErrorStatus.badCertificate);
        },
      );

      test('DioExceptionType.cancel の場合、ErrorStatus.cancel を返す。', () {
        final requestOptions = RequestOptions(path: '/test');
        final exception = DioException(
          requestOptions: requestOptions,
          type: DioExceptionType.cancel,
        );

        final result = ErrorStatus.fromDioException(exception);

        expect(result, ErrorStatus.cancel);
      });

      test(
        'DioExceptionType.connectionError の場合、ErrorStatus.connectionError を返す。',
        () {
          final requestOptions = RequestOptions(path: '/test');
          final exception = DioException(
            requestOptions: requestOptions,
            type: DioExceptionType.connectionError,
          );

          final result = ErrorStatus.fromDioException(exception);

          expect(result, ErrorStatus.connectionError);
        },
      );

      test('DioExceptionType.unknown の場合、ErrorStatus.unknown を返す。', () {
        final requestOptions = RequestOptions(path: '/test');
        final exception = DioException(requestOptions: requestOptions);

        final result = ErrorStatus.fromDioException(exception);

        expect(result, ErrorStatus.unknown);
      });

      test('対応する ErrorStatus が存在しない DioExceptionType の場合、'
          ' ErrorStatus.unknown を返しログが出力される。', () {
        final logRecords = <LogRecord>[];
        final subscription = Logger.setupLogging(logRecords.add);
        addTearDown(() async {
          await subscription.cancel();
        });

        final requestOptions = RequestOptions(path: '/test');

        // ErrorStatus に対応しない DioExceptionType を探す。
        final unmatchedType = DioExceptionType.values.firstWhereOrNull(
          (type) =>
              !ErrorStatus.values.any((status) => status.name == type.name),
        );

        // すべての DioExceptionType に対応する ErrorStatus が存在する場合は正常。
        if (unmatchedType == null) {
          // この場合、実際のコードの null ケースは実行されないが、
          // coverage:ignore により 100% のカバレッジは維持される。
          markTestSkipped(
            'すべての DioExceptionType がマップされているため、'
            ' null ケースのテストをスキップします。',
          );
          return;
        }

        // 新しい DioExceptionType が見つかった場合、
        // フォールバック動作をテストしつつ、新しいタイプの存在を明示的に報告する。
        final exception = DioException(
          requestOptions: requestOptions,
          type: unmatchedType,
        );

        final result = ErrorStatus.fromDioException(exception);

        expect(result, ErrorStatus.unknown);

        // ログが出力されることを確認する。
        expect(
          logRecords,
          anyElement(
            predicate<LogRecord>(
              (record) => record.message.contains('is not valid'),
            ),
          ),
        );

        // 新しい DioExceptionType が追加されたことを明示的に通知する。
        fail(
          '🚨 新しい DioExceptionType が見つかりました: ${unmatchedType.name}。'
          ' ErrorStatus enum に対応する値を追加してください。',
        );
      });
    });
  });
}
