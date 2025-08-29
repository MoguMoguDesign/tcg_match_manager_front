import 'package:repository/repository.dart';

/// エラーステータスが返された場合に発生する例外。
///
/// [FailureRepositoryResultReason.failureStatus] だった場合に発生し、
/// 詳細なエラーは [message] に格納されている。
class FailureStatusException implements Exception {
  /// [FailureStatusException] を生成する。
  const FailureStatusException(this.message);

  /// エラーメッセージ。
  final String message;
}
