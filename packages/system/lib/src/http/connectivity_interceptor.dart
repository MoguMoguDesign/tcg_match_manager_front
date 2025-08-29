import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

/// リクエスト時にインターネット接続を確認する [Interceptor].
///
/// ネットワーク接続が無い場合は [NetworkConnectionDioException] をスローする。
///
/// iOS シミュレータ上では接続状況が適切に反映されず、Wifi 接続した Android エミュレータもモバイル通信環境の挙動は異なるため、
/// 必要に応じて実機での動作確認を行う。
class ConnectivityInterceptor extends Interceptor {
  /// [ConnectivityInterceptor] を生成する。
  ///
  /// [connectivity] が null の場合は [Connectivity] のインスタンスを生成する。
  /// このインスタンスはテスト時に注入することでモック化することができる。
  ConnectivityInterceptor({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  /// ネットワーク接続状態を確認するための [Connectivity] インスタンス。
  final Connectivity _connectivity;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!(await _isConnected())) {
      return handler.reject(
        // 専用のエラーを吐く。
        NetworkConnectionDioException(requestOptions: options),
      );
    }
    return handler.next(options);
  }

  /// ネットワーク接続があるかどうか。
  Future<bool> _isConnected() async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }
}

/// ネットワーク接続が無い場合専用の [DioException].
///
/// [DioExceptionType] とは別の分岐を行うためにクラスとして用意している。
class NetworkConnectionDioException extends DioException {
  /// [NetworkConnectionDioException] を生成する。
  NetworkConnectionDioException({required super.requestOptions});
}
