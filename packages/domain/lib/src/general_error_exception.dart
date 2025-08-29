import 'package:repository/repository.dart';

/// 処理が失敗した場合全般に発生する例外。
///
/// [FailureRepositoryResultReason.failureStatus] 以外の場合に発生する。
///
/// エラーメッセージは多言語対応のために、[reason] と [errorCode] を元に UI 側で表示する。
class GeneralFailureException implements Exception {
  /// [GeneralFailureException] を生成する。
  const GeneralFailureException({required this.reason, required this.errorCode})
    : statusCode = null,
      assert(
        reason != GeneralFailureReason.badResponse,
        'Use GeneralFailureException.badResponse constructor when reason is '
        'badResponse to ensure statusCode is provided',
      );

  /// [FailureRepositoryResultReason.badResponse] の場合の
  /// [GeneralFailureException] を生成する。
  const GeneralFailureException.badResponse({
    required this.errorCode,
    required this.statusCode,
  }) : reason = GeneralFailureReason.badResponse;

  /// 処理に失敗した理由。
  final GeneralFailureReason reason;

  /// アプリ側に表示するためのエラーコード。
  ///
  /// [FailureRepositoryResultReason] の値を文字列で格納する。
  final String errorCode;

  /// HTTP レスポンスのステータスコード。
  ///
  /// [FailureRepositoryResultReason.badResponse] の場合には必須となる。
  final int? statusCode;
}

/// 失敗した理由を表す列挙型。
///
/// [FailureRepositoryResultReason] の中から
/// ユーザー側に特定のエラー文として表示したいもの以外は [other] へ分類する。
enum GeneralFailureReason {
  /// インターネット接続が無いことによるエラー。
  noConnectionError,

  /// サーバー URL が間違っていることによるエラー。
  serverUrlNotFoundError,

  /// 不正なステータスコードが返ってきた場合のエラー。
  badResponse,

  /// その他のエラー。
  other,
}
