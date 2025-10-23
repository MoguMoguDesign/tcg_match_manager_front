import 'package:injection/injection.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:system/system.dart';

import '../repository_result.dart';
import 'standing_response.dart';

part 'standing_player_repository.g.dart';

/// [StandingPlayerRepository] を提供する。
@riverpod
StandingPlayerRepository standingPlayerRepository(Ref ref) {
  return StandingPlayerRepository(
    httpClient: ref.watch(httpClientProvider),
  );
}

/// プレイヤー側の最終順位に関する通信を行うためのリポジトリ。
class StandingPlayerRepository {
  /// [StandingPlayerRepository] を生成する。
  ///
  /// [httpClient] は、HTTP 通信を行うためのクライアント。
  StandingPlayerRepository({required HttpClient httpClient})
      : _httpClient = httpClient;

  final HttpClient _httpClient;

  /// API バージョン。
  static const _apiVersion = 'v1';

  /// 最終順位を取得する。
  ///
  /// - [baseUrl] は、API のベース URL。
  /// - [tournamentId] は、大会 ID。
  /// - [userId] は、ユーザー ID（個人ハイライト用、任意）。
  Future<RepositoryResult<StandingResponse>> getFinalStandings({
    required String baseUrl,
    required String tournamentId,
    String? userId,
  }) async {
    // URL を生成する。
    final queryParameters = <String, String>{};
    if (userId != null) {
      queryParameters['userId'] = userId;
    }

    final uri = Uri.parse(baseUrl).replace(
      path:
          '${Uri.parse(baseUrl).path}player/api/$_apiVersion/tournaments/$tournamentId/standings:final',
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );

    final response = await _httpClient.getUri(uri);

    switch (response) {
      case SuccessHttpResponse(jsonData: final jsonData):
        // JsonMap を Response に変換する。
        final standingResponse =
            StandingResponse.fromJson(jsonData as Map<String, dynamic>);

        return SuccessRepositoryResult(standingResponse);
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
