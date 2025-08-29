import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:system/system.dart';
import 'package:util/util.dart';

part 'repository_result.freezed.dart';

/// リポジトリによる通信結果を表すクラス。
///
/// 成功の場合は [SuccessRepositoryResult]、失敗の場合は [FailureRepositoryResult] が使用される。
@freezed
sealed class RepositoryResult<T> with _$RepositoryResult<T> {
  /// 通信成功の結果を生成する。
  const factory RepositoryResult.success(T data) = SuccessRepositoryResult<T>;

  /// 通信失敗の結果を生成する。
  @Assert(
    'reason != FailureRepositoryResultReason.failureStatus || data != null',
    'data must not be null when reason is failureStatus',
  )
  const factory RepositoryResult.failure(
    /// 例外オブジェクト。
    ///
    /// reason が [FailureRepositoryResultReason.failureStatus] の場合、
    /// [data] へ変換する前の [JsonMap] を格納しておく。
    Object e, {

    /// 失敗の理由を表す列挙型。
    required FailureRepositoryResultReason reason,

    /// [T] 型の DTO クラス用フィールド。
    ///
    /// reason が [FailureRepositoryResultReason.failureStatus] の場合、
    /// 成功時と同じ DTO クラスを格納する必要がある。
    T? data,

    /// HTTP レスポンスのステータスコード。
    ///
    /// reason が [FailureRepositoryResultReason.badResponse] の場合には NN となる。
    int? statusCode,
  }) = FailureRepositoryResult;
}

/// 失敗の理由を表す列挙型。
///
/// [failureStatus] の場合、 API に応じたステータスコードを domain 側で別途定義する。
///
/// それ以外の場合は、[ErrorStatus] に対応した値となっている。
enum FailureRepositoryResultReason {
  /// API のレスポンス内で失敗ステータスが返された場合。
  failureStatus,

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

  /// 文字列から [FailureRepositoryResultReason] を生成する。
  ///
  /// 不正な文字列が渡された場合、 [ArgumentError] が発生する。
  factory FailureRepositoryResultReason.fromString(String name) {
    final value = FailureRepositoryResultReason.values.byName(name);
    return value;
  }
}
