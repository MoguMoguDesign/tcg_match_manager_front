import 'package:dio/dio.dart';

import 'connectivity_interceptor.dart';

/// [Dio] の HTTP クライアント。
///
/// [Dio] を実装した [DioMixin] により拡張している。
///
/// 参考：https://pub.dev/packages/dio#extends-dio-class.
///
// dio パッケージの Dart SDK 最低バージョンが 3.0 になるまで ignore しておく（実装内部のコメント参照）。
// ignore: prefer_mixin
class DioHttpClient with DioMixin implements Dio {
  /// [DioHttpClient] を生成する。
  ///
  /// - [options] には、共通の基本設定を追加する。
  /// - [interceptors] には、リクエストやレスポンス取得の完了前に行いたい処理を追加する。
  /// - [httpClientAdapter] では、プラットフォームに応じた [HttpClientAdapter] を初期化する。
  DioHttpClient() {
    options = BaseOptions(
      // 接続タイムアウト時間を指定。
      connectTimeout: const Duration(seconds: 10),
      // リクエスト送信時のタイムアウト時間を指定。
      sendTimeout: const Duration(seconds: 10),
      // レスポンス受信時のタイムアウト時間を指定。
      receiveTimeout: const Duration(seconds: 10),
    );
    interceptors.add(ConnectivityInterceptor());

    httpClientAdapter = HttpClientAdapter();
  }
}
