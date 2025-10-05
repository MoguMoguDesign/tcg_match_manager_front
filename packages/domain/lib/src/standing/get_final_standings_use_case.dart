import 'package:repository/repository.dart' as repo;
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../general_error_exception.dart';
import 'standing.dart';

part 'get_final_standings_use_case.g.dart';

/// [GetFinalStandingsUseCase] を提供する。
@riverpod
GetFinalStandingsUseCase getFinalStandingsUseCase(Ref ref) {
  return GetFinalStandingsUseCase(
    standingPlayerRepository: ref.watch(repo.standingPlayerRepositoryProvider),
  );
}

/// 最終順位取得用ユースケース。
class GetFinalStandingsUseCase {
  /// [GetFinalStandingsUseCase] を生成する。
  ///
  /// [standingPlayerRepository] は、最終順位に関する通信を行うためのリポジトリ。
  GetFinalStandingsUseCase({
    required repo.StandingPlayerRepository standingPlayerRepository,
  }) : _standingPlayerRepository = standingPlayerRepository;

  final repo.StandingPlayerRepository _standingPlayerRepository;

  /// 最終順位取得処理を実行する。
  ///
  /// - [baseUrl] は、API のベース URL。
  /// - [tournamentId] は、大会 ID。
  /// - [userId] は、ユーザー ID（個人ハイライト用、任意）。
  Future<Standing> invoke({
    required String baseUrl,
    required String tournamentId,
    String? userId,
  }) async {
    final result = await _standingPlayerRepository.getFinalStandings(
      baseUrl: baseUrl,
      tournamentId: tournamentId,
      userId: userId,
    );

    switch (result) {
      case repo.SuccessRepositoryResult(:final data):
        // Repository層のStandingResponseをDomain層のStandingエンティティに変換する。
        return Standing.fromRepositoryModel(data);
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
