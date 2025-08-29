import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:system/src/http/connectivity_interceptor.dart';
import 'package:system/src/http/dio_http_client.dart';

void main() {
  group('DioHttpClient のテスト。', () {
    group('コンストラクタのテスト。', () {
      test('BaseOptions が正しく設定される。', () {
        final client = DioHttpClient();

        expect(client.options, isA<BaseOptions>());
        expect(client.options.connectTimeout, const Duration(seconds: 10));
        expect(client.options.sendTimeout, const Duration(seconds: 10));
        expect(client.options.receiveTimeout, const Duration(seconds: 10));
      });

      test('ConnectivityInterceptor がインターセプターに追加される。', () {
        final client = DioHttpClient();

        expect(
          client.interceptors.any(
            (interceptor) => interceptor is ConnectivityInterceptor,
          ),
          isTrue,
        );
      });

      test('HttpClientAdapter が初期化される。', () {
        final client = DioHttpClient();

        expect(client.httpClientAdapter, isA<HttpClientAdapter>());
      });

      test('DioMixin が正しく実装されている。', () {
        final client = DioHttpClient();

        expect(client, isA<Dio>());
        expect(client, isA<DioMixin>());
      });
    });
  });
}
