import 'package:injection/injection.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:system/system.dart';

import '../repository_result.dart';
import 'player_registration_request.dart';
import 'player_registration_response.dart';

part 'player_registration_repository.g.dart';

/// [PlayerRegistrationRepository] を提供する。
@riverpod
PlayerRegistrationRepository playerRegistrationRepository(Ref ref) {
  return PlayerRegistrationRepository(
    httpClient: ref.watch(httpClientProvider),
  );
}

/// プレイヤー登録に関する通信を行うためのリポジトリ。
class PlayerRegistrationRepository {
  /// [PlayerRegistrationRepository] を生成する。
  ///
  /// [httpClient] は、HTTP 通信を行うためのクライアント。
  PlayerRegistrationRepository({required HttpClient httpClient})
      : _httpClient = httpClient;

  final HttpClient _httpClient;

  /// API バージョン。
  static const _apiVersion = 'v1';

  /// プレイヤーを登録する。
  ///
  /// - [baseUrl] は、API のベース URL。
  /// - [tournamentId] は、大会 ID。
  /// - [request] は、プレイヤー登録リクエスト。
  Future<RepositoryResult<PlayerRegistrationResponse>> registerPlayer({
    required String baseUrl,
    required String tournamentId,
    required PlayerRegistrationRequest request,
  }) async {
    // リクエストボディを作成する。
    final requestBody = request.toJson();

    // URL を生成する。
    final uri = Uri.parse(baseUrl).replace(
      path: '${Uri.parse(baseUrl).path}player/api/$_apiVersion/tournaments/$tournamentId/players',
    );

    final response = await _httpClient.postUri(uri, requestBody);

    switch (response) {
      case SuccessHttpResponse(jsonData: final jsonData):
        // JsonMap を Response に変換する。
        final playerRegistrationResponse =
            PlayerRegistrationResponse.fromJson(jsonData);

        return SuccessRepositoryResult(playerRegistrationResponse);
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
