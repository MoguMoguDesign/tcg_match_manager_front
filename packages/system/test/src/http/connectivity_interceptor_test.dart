import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:system/system.dart';

import 'connectivity_interceptor_test.mocks.dart';

// Connectivity と RequestInterceptorHandler のモッククラスを生成する。
@GenerateNiceMocks([
  MockSpec<Connectivity>(),
  MockSpec<RequestInterceptorHandler>(),
])
void main() {
  late MockConnectivity mockConnectivity;
  late MockRequestInterceptorHandler mockHandler;

  setUp(() {
    mockConnectivity = MockConnectivity();
    mockHandler = MockRequestInterceptorHandler();
  });

  group('ConnectivityInterceptor のテスト。', () {
    group('コンストラクタのテスト。', () {
      test('正常に ConnectivityInterceptor のインスタンスを作成できる。', () {
        final interceptor = ConnectivityInterceptor();
        expect(interceptor, isA<ConnectivityInterceptor>());
        expect(interceptor, isA<Interceptor>());
      });
    });

    group('onRequest メソッドのテスト。', () {
      test('ネットワーク接続がある場合、handler.next() を呼び出す。', () async {
        final requestOptions = RequestOptions(path: '/test');
        final interceptor = ConnectivityInterceptor(
          connectivity: mockConnectivity,
        );

        // ネットワーク接続がある状態をスタブする。
        when(
          mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.wifi]);

        // onRequest を実行する。
        await interceptor.onRequest(requestOptions, mockHandler);

        // Connectivity の checkConnectivity メソッドが呼び出されることを確認する。
        verify(mockConnectivity.checkConnectivity()).called(1);

        // handler.next() が正しい引数で呼び出されることを確認する。
        verify(mockHandler.next(requestOptions)).called(1);

        // handler.reject() は呼び出されないことを確認する。
        verifyNever(mockHandler.reject(any));
      });

      test('ネットワーク接続がない場合、NetworkConnectionDioException で '
          'handler.reject() を呼び出す。', () async {
        final requestOptions = RequestOptions(path: '/test');
        final interceptor = ConnectivityInterceptor(
          connectivity: mockConnectivity,
        );

        // ネットワーク接続がない状態をスタブする。
        when(
          mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.none]);

        // onRequest を実行する。
        await interceptor.onRequest(requestOptions, mockHandler);

        // Connectivity の checkConnectivity メソッドが呼び出されることを確認する。
        verify(mockConnectivity.checkConnectivity()).called(1);

        // NetworkConnectionDioException で handler.reject() が呼び出されることを確認する。
        verify(
          mockHandler.reject(
            argThat(
              predicate<DioException>(
                (exception) =>
                    exception is NetworkConnectionDioException &&
                    exception.requestOptions == requestOptions,
              ),
            ),
          ),
        ).called(1);

        // handler.next() は呼び出されないことを確認する。
        verifyNever(mockHandler.next(any));
      });
    });
  });

  group('NetworkConnectionDioException のテスト。', () {
    group('コンストラクタのテスト。', () {
      test('RequestOptions を渡して正常にインスタンスを作成できる。', () {
        final requestOptions = RequestOptions(path: '/test');

        final exception = NetworkConnectionDioException(
          requestOptions: requestOptions,
        );

        expect(exception, isA<NetworkConnectionDioException>());
        expect(exception, isA<DioException>());
        expect(exception.requestOptions, requestOptions);
      });
    });
  });
}
