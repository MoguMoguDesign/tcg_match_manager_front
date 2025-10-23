import 'package:injection/injection.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:system/system.dart';

import '../repository_result.dart';
import 'player_auth_request.dart';
import 'player_auth_response.dart';

part 'player_auth_repository.g.dart';

/// [PlayerAuthRepository] を提供する。
@riverpod
PlayerAuthRepository playerAuthRepository(Ref ref) {
  return PlayerAuthRepository(
    httpClient: ref.watch(httpClientProvider),
  );
}

/// プレイヤー認証に関する通信を行うためのリポジトリ。
class PlayerAuthRepository {
  /// [PlayerAuthRepository] を生成する。
  ///
  /// [httpClient] は、HTTP 通信を行うためのクライアント。
  PlayerAuthRepository({required HttpClient httpClient})
      : _httpClient = httpClient;

  final HttpClient _httpClient;

  /// API バージョン。
  static const _apiVersion = 'v1';

  /// プレイヤーを認証する（UserID による本人確認）。
  ///
  /// - [baseUrl] は、API のベース URL。
  /// - [tournamentId] は、大会 ID。
  /// - [request] は、プレイヤー認証リクエスト。
  Future<RepositoryResult<PlayerAuthResponse>> validatePlayer({
    required String baseUrl,
    required String tournamentId,
    required PlayerAuthRequest request,
  }) async {
    // リクエストボディを作成する。
    final requestBody = request.toJson();

    // URL を生成する。
    final uri = Uri.parse(baseUrl).replace(
      path:
          '${Uri.parse(baseUrl).path}player/api/$_apiVersion/tournaments/$tournamentId/auth/validate',
    );

    final response = await _httpClient.postUri(uri, requestBody);

    switch (response) {
      case SuccessHttpResponse(jsonData: final jsonData):
        // JsonMap を Response に変換する。
        final playerAuthResponse = PlayerAuthResponse.fromJson(
          jsonData as Map<String, dynamic>,
        );

        return SuccessRepositoryResult(playerAuthResponse);
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
