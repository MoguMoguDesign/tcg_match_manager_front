import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:util/util.dart';

import 'connectivity_interceptor.dart';

part 'http_response.freezed.dart';

/// HTTP レスポンスの成功・失敗を freezed の sealed class でまとめて表現するクラス。
@freezed
sealed class HttpResponse with _$HttpResponse {
  /// 成功時のレスポンス。
  const factory HttpResponse.success({
    /// HTTP のレスポンスボディ。
    ///
    /// 実際のレスポンスボディは String 型だが、扱いやすいように JsonMap 型にデコードした形で格納する。
    required JsonMap jsonData,

    /// HTTP のレスポンスヘッダ。
    required Map<String, List<String>> headers,
  }) = SuccessHttpResponse;

  /// 失敗時のレスポンス。
  const factory HttpResponse.failure({
    /// HTTP リクエスト時に発生した例外オブジェクト。
    required Object e,

    ///  HTTP エラーの種別。
    required ErrorStatus status,

    /// HTTP レスポンスのステータスコード。
    ///
    /// status が [ErrorStatus.badResponse] の場合には NN となる。
    int? statusCode,
  }) = FailureHttpResponse;
}

/// HTTP レスポンスの主なエラーの種別を表現する列挙型。
///
/// エラーの発生原因を可能な限り詳細に UI 上に表現するために、
/// 現状挙動が確認出来ていないものも含めて [DioExceptionType] に対応するエラー種別を全て列挙している。
///
/// [DioExceptionType.badResponse] の場合、ステータスコードに対応する [ErrorStatus] を返す。
enum ErrorStatus {
  /// 404 Not Fount に対応するエラー。
  notFound,

  /// 接続がタイムアウトした場合。
  ///
  /// ユーザーのネットワーク接続が原因で発生すると考えられる。
  connectionTimeout,

  /// リクエスト送信時のタイムアウト。
  ///
  /// ユーザーのネットワーク接続が原因で発生すると考えられる。
  sendTimeout,

  /// レスポンス受信時のタイムアウト。
  ///
  /// ユーザーのネットワーク接続が原因で発生すると考えられる。
  receiveTimeout,

  /// 認証が不適切な場合。
  badCertificate,

  /// 不正なステータスコードが返された場合。
  ///
  /// [notFound] 等の詳細なステータスコードに該当しなかったものがこのエラーに分類される。
  badResponse,

  /// リクエストがキャンセルされた場合。
  cancel,

  /// 接続問題が発生した場合。
  ///
  /// リクエスト時に誤ったドメインが指定された場合などに発生する。
  connectionError,

  /// ネットワーク接続が無い場合。
  ///
  /// ユーザーのネットワーク接続が無い場合に発生する。
  noConnection,

  /// その他のエラー。
  unknown;

  /// [DioException] から [ErrorStatus] を生成する。
  ///
  /// [NetworkConnectionDioException] の場合、[ErrorStatus.noConnection] を返す。
  ///
  /// [DioExceptionType.badResponse] の場合、ステータスコードに対応するものがあれば該当の
  /// [ErrorStatus] を返す。それ以外の場合、同一の値の [ErrorStatus] を返す。
  ///
  /// [name] が不正な場合、エラーログを吐いた上で [ErrorStatus.unknown] を返す。
  factory ErrorStatus.fromDioException(DioException e) {
    if (e is NetworkConnectionDioException) {
      return ErrorStatus.noConnection;
    }

    final dioExceptionType = e.type;
    final statusCode = e.response?.statusCode;
    if (dioExceptionType == DioExceptionType.badResponse &&
        statusCode != null) {
      return switch (statusCode) {
        404 => ErrorStatus.notFound,
        _ => ErrorStatus.badResponse,
      };
    }

    final value = ErrorStatus.values.byNameOrNull(dioExceptionType.name);
    // DioException 内の type が追加/修正により ErrorStatus に対応しなくなった場合。
    // この状況は常に再現出来るケースではないためカバレッジには含めないが、
    // 発生した際にはログ出力及びテストが失敗するようにして迅速に気づけるようにしている。
    // coverage:ignore-start
    if (value == null) {
      Logger.logError(
        'ErrorStatus.fromDioException: $dioExceptionType is not valid',
      );
      return ErrorStatus.unknown;
    }
    // coverage:ignore-end
    return value;
  }
}
