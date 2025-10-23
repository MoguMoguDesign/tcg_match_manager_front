import 'package:repository/repository.dart' as repo;
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../general_error_exception.dart';
import 'match.dart';

part 'get_published_matches_use_case.g.dart';

/// [GetPublishedMatchesUseCase] を提供する。
@riverpod
GetPublishedMatchesUseCase getPublishedMatchesUseCase(Ref ref) {
  return GetPublishedMatchesUseCase(
    matchPlayerRepository: ref.watch(repo.matchPlayerRepositoryProvider),
  );
}

/// 公開対戦表取得用ユースケース。
class GetPublishedMatchesUseCase {
  /// [GetPublishedMatchesUseCase] を生成する。
  ///
  /// [matchPlayerRepository] は、マッチに関する通信を行うためのリポジトリ。
  GetPublishedMatchesUseCase({
    required repo.MatchPlayerRepository matchPlayerRepository,
  }) : _matchPlayerRepository = matchPlayerRepository;

  final repo.MatchPlayerRepository _matchPlayerRepository;

  /// 公開対戦表取得処理を実行する。
  ///
  /// - [baseUrl] は、API のベース URL。
  /// - [tournamentId] は、大会 ID。
  /// - [roundId] は、ラウンド ID。
  /// - [userId] は、ユーザー ID（個人ハイライト用）。
  Future<List<Match>> invoke({
    required String baseUrl,
    required String tournamentId,
    required String roundId,
    required String userId,
  }) async {
    final result = await _matchPlayerRepository.getPublishedMatches(
      baseUrl: baseUrl,
      tournamentId: tournamentId,
      roundId: roundId,
      userId: userId,
    );

    switch (result) {
      case repo.SuccessRepositoryResult(:final data):
        // Repository層のMatchモデルリストをDomain層のMatchエンティティリストに変換する。
        return data.map((repoMatch) => Match.fromRepositoryModel(repoMatch)).toList();
      case repo.FailureRepositoryResult(:final reason, :final statusCode):
        switch (reason) {
          case repo.FailureRepositoryResultReason.noConnection:
          case repo.FailureRepositoryResultReason.connectionTimeout:
            throw GeneralFailureException(
              reason: GeneralFailureReason.noConnectionError,
              errorCode: reason.name,
            );
          case repo.FailureRepositoryResultReason.notFound:
          case repo.FailureRepositoryResultReason.connectionError:
            throw GeneralFailureException(
              reason: GeneralFailureReason.serverUrlNotFoundError,
              errorCode: reason.name,
            );
          case repo.FailureRepositoryResultReason.badResponse:
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
}
