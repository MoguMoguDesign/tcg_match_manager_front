import 'package:injection/injection.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:system/system.dart';

import '../repository_result.dart';
import 'tournament_info_response.dart';

part 'tournament_info_repository.g.dart';

/// [TournamentInfoRepository] を提供する。
@riverpod
TournamentInfoRepository tournamentInfoRepository(Ref ref) {
  return TournamentInfoRepository(
    httpClient: ref.watch(httpClientProvider),
  );
}

/// プレイヤー側の大会情報に関する通信を行うためのリポジトリ。
class TournamentInfoRepository {
  /// [TournamentInfoRepository] を生成する。
  ///
  /// [httpClient] は、HTTP 通信を行うためのクライアント。
  TournamentInfoRepository({required HttpClient httpClient})
      : _httpClient = httpClient;

  final HttpClient _httpClient;

  /// API バージョン。
  static const _apiVersion = 'v1';

  /// 大会情報を取得する。
  ///
  /// - [baseUrl] は、API のベース URL。
  /// - [tournamentId] は、大会 ID。
  Future<RepositoryResult<TournamentInfoResponse>> getTournamentInfo({
    required String baseUrl,
    required String tournamentId,
  }) async {
    // URL を生成する。
    final uri = Uri.parse(baseUrl).replace(
      path:
          '${Uri.parse(baseUrl).path}player/api/$_apiVersion/tournaments/$tournamentId',
    );

    final response = await _httpClient.getUri(uri);

    switch (response) {
      case SuccessHttpResponse(jsonData: final jsonData):
        // JsonMap を Response に変換する。
        final tournamentInfoResponse =
            TournamentInfoResponse.fromJson(jsonData as Map<String, dynamic>);

        return SuccessRepositoryResult(tournamentInfoResponse);
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
