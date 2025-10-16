import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:util/util.dart';

import '_export.dart';

/// HTTP リクエストを行うクライアントクラス。
class HttpClient {
  /// [HttpClient] を生成する。
  ///
  /// - [_dioHttpClient] には、実行環境に応じた [DioHttpClient] を渡す。
  HttpClient(this._dioHttpClient);

  final DioHttpClient _dioHttpClient;

  /// HTTP POST リクエストを行う。
  ///
  /// 返り値は [HttpResponse] であり、リクエストが成功した場合は [HttpResponse.success]
  /// が返る。
  ///
  /// リクエストが失敗した場合は、利用する側で dio パッケージに直接依存して [DioException] を
  /// 直接扱わないで済むように、[DioException] および [Exception] は内部でキャッチして、
  /// [HttpResponse.failure] を返す。
  Future<HttpResponse> postUri(Uri uri, JsonMap data) async {
    try {
      final response = await _dioHttpClient.postUri<String>(
        uri,
        data: jsonEncode(data),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      return HttpResponse.success(
        jsonData: jsonDecode(response.data!) as JsonMap,
        headers: response.headers.map,
      );
    } on DioException catch (e) {
      return _httpResponseFromDioException(e);
    } on Exception catch (e) {
      Logger.logError('Unexpected error: $e');
      return HttpResponse.failure(e: e, status: ErrorStatus.unknown);
    }
  }

  /// [DioException] から [HttpResponse.failure] を生成する。
  HttpResponse _httpResponseFromDioException(DioException e) {
    // MEMO(masaki): サーバー URL が不適切な場合の対応を検討
    // i) 完全に空文字の場合： unknown
    //   _normalizeServerUrl にて空文字の場合に `https://` をつける運用にしても、どちらにしろ unknown になる。
    //  事前に別途バリデーションで空文字を許容しなければ対応可能(#57)
    // ii) 不適切なドメインの場合：connectionError
    //  ドメイン自体(eg. invalid.example.com) が不適切な場合に発生する。
    // 　バリデーションで事前に許容するドメインが指定可能なら対応可能(#57)。
    // 　上記の対応が難しい場合、別途 インターネット接続確認用の Interceptor を用意(connectivity_plus 等を利用)した上で
    // 　ネット接続が無いは専用の例外を吐くという対応を取ることでエラーを分岐する。
    // iii) 適切な URL の場合：badResponse(404)
    // ドメイン自体は存在するが最終的な URL は不適切な場合に発生する。

    final status = ErrorStatus.fromDioException(e);
    // 発生状況を把握出来ているエラー以外ではエラーログを出力する。
    final expectedErrors = [
      ErrorStatus.notFound,
      ErrorStatus.connectionError,
      ErrorStatus.noConnection,
    ];
    if (!expectedErrors.contains(status)) {
      Logger.logError('Unexpected error: $e, status: $status');
    }

    return HttpResponse.failure(
      e: e,
      status: status,
      statusCode: e.response?.statusCode,
    );
  }
}
