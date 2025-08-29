import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain.dart';

part 'login_use_case.g.dart';

/// [LoginUseCase] を提供する。
@riverpod
LoginUseCase loginUseCase(Ref ref) {
  return LoginUseCase(accountRepository: ref.watch(accountRepositoryProvider));
}

/// ログイン用ユースケース。
class LoginUseCase {
  /// [LoginUseCase] を生成する。
  ///
  /// [accountRepository] は、アカウントに関する通信を行うためのリポジトリ。
  LoginUseCase({required AccountRepository accountRepository})
    : _accountRepository = accountRepository;

  final AccountRepository _accountRepository;

  // MEMO(masaki): 画面へ結果を表示するために暫定的に返り値を追加している。
  /// ログイン処理を実行する。
  Future<Account> invoke({
    required String serverUrl,
    required String userName,
    required String password,
    required bool isManualLogin,
    required bool isGuest,
  }) async {
    final result = await _accountRepository.login(
      baseUrl: normalizeServerUrl(serverUrl),
      username: userName.trim(),
      password: password.trim(),
    );
    switch (result) {
      case SuccessRepositoryResult(:final data):
        final account = Account.fromDto(data);
        // MEMO(masaki): 別 Provider へ保持する。
        return account;
      case FailureRepositoryResult(
        :final reason,
        :final data,
        :final statusCode,
      ):
        switch (reason) {
          case FailureRepositoryResultReason.failureStatus:
            throw FailureStatusException(data!.message);
          case FailureRepositoryResultReason.noConnection:
          case FailureRepositoryResultReason.connectionTimeout:
            throw GeneralFailureException(
              reason: GeneralFailureReason.noConnectionError,
              errorCode: reason.name,
            );
          case FailureRepositoryResultReason.notFound:
          case FailureRepositoryResultReason.connectionError:
            throw GeneralFailureException(
              reason: GeneralFailureReason.serverUrlNotFoundError,
              errorCode: reason.name,
            );
          case FailureRepositoryResultReason.badResponse:
            throw GeneralFailureException.badResponse(
              errorCode: reason.name,
              statusCode: statusCode,
            );
          case _:
            throw GeneralFailureException(
              reason: GeneralFailureReason.other,
              errorCode: reason.name,
            );
        }
    }
  }

  /// サーバー URL を正規化する。
  @visibleForTesting
  String normalizeServerUrl(String serverUrl) {
    //  serverUrl はバリデーションにより空文字にはなっていない。
    assert(serverUrl.isNotEmpty, 'serverUrl must not be empty');

    // 不要な空白をトリムする。
    final trimmedUrl = serverUrl.trim();

    // 先頭が `http://` または `https://` で始まらない場合は `https://` を付与する。
    final normalizedUrl =
        (trimmedUrl.startsWith('http://') || trimmedUrl.startsWith('https://'))
        ? trimmedUrl
        : 'https://$trimmedUrl';

    // 末尾に `/` がない場合は付与する。
    return normalizedUrl.endsWith('/') ? normalizedUrl : '$normalizedUrl/';
  }

}
