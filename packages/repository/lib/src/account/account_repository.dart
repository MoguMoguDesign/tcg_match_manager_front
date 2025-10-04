import 'package:injection/injection.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:system/system.dart';

import '../repository_result.dart';
import 'account_dto.dart';

part 'account_repository.g.dart';

/// [AccountRepository] を提供する。
@riverpod
AccountRepository accountRepository(Ref ref) {
  return AccountRepository(httpClient: ref.watch(httpClientProvider));
}

/// アカウントに関する通信を行うためのリポジトリ。
class AccountRepository {
  /// [AccountRepository] を生成する。
  ///
  /// [httpClient] は、HTTP 通信を行うためのクライアント。
  AccountRepository({required HttpClient httpClient})
    : _httpClient = httpClient;

  final HttpClient _httpClient;

  // MEMO(masaki): 現行の実装では、基本的に全ての API で 同じバージョンなので別 API 利用時に共通化
  /// サーバーの API バージョン。
  static const _apiVersion = 7;

  /// ログイン処理を行う。
  ///
  /// - [baseUrl] は、API のベース URL。
  /// - [username] は、ユーザー名。
  /// - [password] は、パスワード。
  Future<RepositoryResult<AccountDto>> login({
    required String baseUrl,
    required String username,
    required String password,
  }) async {
    // リクエストボディを作成する。
    final requestBody = <String, dynamic>{
      'username': username,
      'password': password,
      'api_version': _apiVersion,
    };
    
    // URL を生成する。
    final uri = Uri.parse(baseUrl).replace(
      path: '${Uri.parse(baseUrl).path}api/v1/auth/login',
    );

    final response = await _httpClient.postUri(uri, requestBody);

    switch (response) {
      case SuccessHttpResponse(jsonData: final jsonData):
        // JsonMap を DTO に変換する。
        final jsonMap = jsonData as Map<String, dynamic>;
        final accountDto = AccountDto.fromJson(jsonMap);

        // 認証が失敗した場合。
        if (accountDto.isFailureStatus) {
          return FailureRepositoryResult(
            jsonMap,
            reason: FailureRepositoryResultReason.failureStatus,
            data: accountDto,
          );
        }

        return SuccessRepositoryResult(accountDto);
      case FailureHttpResponse(:final e, :final status, :final statusCode):
        final reason = FailureRepositoryResultReason.fromString(status.name);
        return RepositoryResult.failure(
          e,
          reason: reason,
          statusCode: statusCode,
        );
    }
  }
}
