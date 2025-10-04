import 'package:injection/injection.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:system/system.dart';

import '../repository_result.dart';
import 'match_list_response.dart';
import 'match_submit_result_request.dart';
import 'match_submit_result_response.dart';

part 'match_player_repository.g.dart';

/// [MatchPlayerRepository] を提供する。
@riverpod
MatchPlayerRepository matchPlayerRepository(Ref ref) {
  return MatchPlayerRepository(
    httpClient: ref.watch(httpClientProvider),
  );
}

/// プレイヤー側のマッチに関する通信を行うためのリポジトリ。
class MatchPlayerRepository {
  /// [MatchPlayerRepository] を生成する。
  ///
  /// [httpClient] は、HTTP 通信を行うためのクライアント。
  MatchPlayerRepository({required HttpClient httpClient})
      : _httpClient = httpClient;

  final HttpClient _httpClient;

  /// API バージョン。
  static const _apiVersion = 'v1';

  /// 公開されたマッチ一覧を取得する。
  ///
  /// - [baseUrl] は、API のベース URL。
  /// - [tournamentId] は、大会 ID。
  /// - [roundId] は、ラウンド ID。
  /// - [userId] は、ユーザー ID（個人ハイライト用）。
  Future<RepositoryResult<MatchListResponse>> getPublishedMatches({
    required String baseUrl,
    required String tournamentId,
    required String roundId,
    required String userId,
  }) async {
    // URL を生成する。
    final uri = Uri.parse(baseUrl).replace(
      path:
          '${Uri.parse(baseUrl).path}player/api/$_apiVersion/tournaments/$tournamentId/rounds/$roundId/matches',
      queryParameters: {
        'published': 'true',
        'userId': userId,
      },
    );

    final response = await _httpClient.getUri(uri);

    switch (response) {
      case SuccessHttpResponse(jsonData: final jsonData):
        // JsonList を Response に変換する。
        final matchList = (jsonData as List<dynamic>)
            .map((json) => Match.fromJson(json as Map<String, dynamic>))
            .toList();

        return SuccessRepositoryResult(matchList);
      case FailureHttpResponse(:final e, :final status, :final statusCode):
        final reason = FailureRepositoryResultReason.fromString(status.name);
        return RepositoryResult.failure(
          e,
          reason: reason,
          statusCode: statusCode,
        );
    }
  }

  /// マッチ結果を送信する（即座確定）。
  ///
  /// - [baseUrl] は、API のベース URL。
  /// - [tournamentId] は、大会 ID。
  /// - [roundId] は、ラウンド ID。
  /// - [matchId] は、マッチ ID。
  /// - [request] は、マッチ結果送信リクエスト。
  Future<RepositoryResult<MatchSubmitResultResponse>> submitMatchResult({
    required String baseUrl,
    required String tournamentId,
    required String roundId,
    required String matchId,
    required MatchSubmitResultRequest request,
  }) async {
    // リクエストボディを作成する。
    final requestBody = request.toJson();

    // URL を生成する。
    final uri = Uri.parse(baseUrl).replace(
      path:
          '${Uri.parse(baseUrl).path}player/api/$_apiVersion/tournaments/$tournamentId/rounds/$roundId/matches/$matchId:submitResult',
    );

    final response = await _httpClient.postUri(uri, requestBody);

    switch (response) {
      case SuccessHttpResponse(jsonData: final jsonData):
        // JsonMap を Response に変換する。
        final matchSubmitResultResponse =
            MatchSubmitResultResponse.fromJson(jsonData);

        return SuccessRepositoryResult(matchSubmitResultResponse);
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
