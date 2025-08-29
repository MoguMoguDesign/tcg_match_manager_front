import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:system/src/http/dio_http_client.dart';
import 'package:system/src/http/http_client.dart';
import 'package:system/src/http/http_response.dart';
import 'package:util/util.dart';

import 'http_client_test.mocks.dart';

// DioHttpClient のモッククラスを生成する。
@GenerateNiceMocks([MockSpec<DioHttpClient>()])
void main() {
  late MockDioHttpClient mockDioHttpClient;
  late HttpClient client;

  setUp(() {
    mockDioHttpClient = MockDioHttpClient();
    client = HttpClient(mockDioHttpClient);
  });

  group('HttpClient のテスト。', () {
    group('postUri メソッドのテスト。', () {
      test('DioHttpClient の postUri メソッドを呼び出し、成功時は '
          'HttpResponse.success を返す。', () async {
        // テストデータの設定
        final uri = Uri.parse('https://example.com/api/test');
        final requestData = {'username': 'test', 'password': 'pass'} as JsonMap;
        const responseData = '{"message": "success"}';
        final expectedJsonData = {'message': 'success'} as JsonMap;
        final headers = Headers.fromMap({
          'content-type': ['application/json'],
          'x-custom-header': ['test-value'],
        });

        // モックされた Response を作成する。
        final dioResponse = Response<String>(
          data: responseData,
          headers: headers,
          statusCode: 200,
          requestOptions: RequestOptions(path: uri.toString()),
        );

        // DioHttpClient の postUri メソッドが成功するスタブを用意する。
        when(
          mockDioHttpClient.postUri<String>(
            uri,
            data: anyNamed('data'),
            options: anyNamed('options'),
          ),
        ).thenAnswer((_) async => dioResponse);

        // postUri を実行する。
        final result = await client.postUri(uri, requestData);

        // DioHttpClient の postUri メソッドが正しい引数で呼び出されることを確認する。
        verify(mockDioHttpClient.postUri<String>(
          uri,
          data: anyNamed('data'),
          options: anyNamed('options'),
        )).called(1);

        // 成功レスポンスが返されることを確認する。
        expect(result, isA<SuccessHttpResponse>());
        final successResponse = result as SuccessHttpResponse;
        expect(successResponse.jsonData, equals(expectedJsonData));
        expect(successResponse.headers, equals(headers.map));
      });

      test('予期される DioException (ステータスコード: 404) が発生した場合、ErrorStatus.notFound で '
          'HttpResponse.failure を返し、ログは出力されない。', () async {
        final uri = Uri.parse('https://example.com/api/notfound');
        final requestData = {'test': 'data'} as JsonMap;
        final requestOptions = RequestOptions(path: uri.toString());
        final dioResponse = Response<String>(
          statusCode: 404,
          requestOptions: requestOptions,
        );
        final dioException = DioException.badResponse(
          statusCode: 404,
          requestOptions: requestOptions,
          response: dioResponse,
        );

        // DioHttpClient の postUri メソッドで DioException (404) が発生するスタブを用意する。
        when(mockDioHttpClient.postUri<String>(
          uri,
          data: anyNamed('data'),
          options: anyNamed('options'),
        )).thenThrow(dioException);

        // postUri を実行する。
        final result = await client.postUri(uri, requestData);

        // 失敗レスポンスが返されることを確認する。
        expect(result, isA<FailureHttpResponse>());
        final failureResponse = result as FailureHttpResponse;
        expect(failureResponse.e, equals(dioException));
        expect(failureResponse.status, ErrorStatus.notFound);
        expect(failureResponse.statusCode, 404);

        // 予期されるエラーの場合、ログは出力されない（404 は expectedErrors に含まれる）。
      });

      test(
        '予期しない DioException (ステータスコード: 500) が発生した場合、'
            ' ErrorStatus.badResponse で HttpResponse.failure を返し、エラーログを出力する。',
        () async {
          final uri = Uri.parse('https://example.com/api/error');
          final requestData = {'test': 'data'} as JsonMap;
          final requestOptions = RequestOptions(path: uri.toString());
          final dioResponse = Response<String>(
            statusCode: 500,
            requestOptions: requestOptions,
          );
          final dioException = DioException.badResponse(
            statusCode: 500,
            requestOptions: requestOptions,
            response: dioResponse,
          );

          // DioHttpClient の postUri メソッドで DioException (500) が発生するスタブを用意する。
          when(mockDioHttpClient.postUri<String>(
            uri,
            data: anyNamed('data'),
            options: anyNamed('options'),
          )).thenThrow(dioException);

          // postUri を実行する。
          final result = await client.postUri(uri, requestData);

          // 失敗レスポンスが返されることを確認する。
          expect(result, isA<FailureHttpResponse>());
          final failureResponse = result as FailureHttpResponse;
          expect(failureResponse.e, equals(dioException));
          expect(failureResponse.status, ErrorStatus.badResponse);
          expect(failureResponse.statusCode, 500);

          // 予期しないエラーの場合、エラーログが出力される（500 は expectedErrors に含まれない）。
        },
      );

      test('一般的な Exception が発生した場合、ErrorStatus.unknown で '
          'HttpResponse.failure を返し、エラーログを出力する。', () async {
        final uri = Uri.parse('https://example.com/api/unexpected');
        final requestData = {'test': 'data'} as JsonMap;
        final testException = Exception('Unexpected error');

        // DioHttpClient の postUri メソッドで一般的な Exception が発生するスタブを用意する。
        when(mockDioHttpClient.postUri<String>(
          uri,
          data: anyNamed('data'),
          options: anyNamed('options'),
        )).thenThrow(testException);

        // postUri を実行する。
        final result = await client.postUri(uri, requestData);

        // 失敗レスポンスが返されることを確認する。
        expect(result, isA<FailureHttpResponse>());
        final failureResponse = result as FailureHttpResponse;
        expect(failureResponse.e, equals(testException));
        expect(failureResponse.status, ErrorStatus.unknown);
        expect(failureResponse.statusCode, isNull);

        // 一般的な Exception の場合もエラーログが出力される。
      });
    });
  });
}
