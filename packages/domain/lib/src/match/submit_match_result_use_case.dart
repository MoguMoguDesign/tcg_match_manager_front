import 'package:repository/repository.dart' as repo;
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../general_error_exception.dart';
import 'match.dart';

part 'submit_match_result_use_case.g.dart';

/// [SubmitMatchResultUseCase] を提供する。
@riverpod
SubmitMatchResultUseCase submitMatchResultUseCase(Ref ref) {
  return SubmitMatchResultUseCase(
    matchPlayerRepository: ref.watch(repo.matchPlayerRepositoryProvider),
  );
}

/// マッチ結果送信用ユースケース。
class SubmitMatchResultUseCase {
  /// [SubmitMatchResultUseCase] を生成する。
  ///
  /// [matchPlayerRepository] は、マッチに関する通信を行うためのリポジトリ。
  SubmitMatchResultUseCase({
    required repo.MatchPlayerRepository matchPlayerRepository,
  }) : _matchPlayerRepository = matchPlayerRepository;

  final repo.MatchPlayerRepository _matchPlayerRepository;

  /// マッチ結果送信処理を実行する。
  ///
  /// - [baseUrl] は、API のベース URL。
  /// - [tournamentId] は、大会 ID。
  /// - [roundId] は、ラウンド ID。
  /// - [matchId] は、マッチ ID。
  /// - [resultType] は、結果タイプ（PLAYER1_WIN, PLAYER2_WIN, DRAW, BOTH_LOSS, NO_SHOW, BYE）。
  /// - [winnerId] は、勝者のプレイヤー ID。
  /// - [userId] は、ユーザー ID（本人確認用）。
  Future<MatchResultDetail> invoke({
    required String baseUrl,
    required String tournamentId,
    required String roundId,
    required String matchId,
    required String resultType,
    required String winnerId,
    required String userId,
  }) async {
    final result = await _matchPlayerRepository.submitMatchResult(
      baseUrl: baseUrl,
      tournamentId: tournamentId,
      roundId: roundId,
      matchId: matchId,
      request: repo.MatchSubmitResultRequest(
        type: resultType,
        winnerId: winnerId,
        userId: userId,
      ),
    );

    switch (result) {
      case repo.SuccessRepositoryResult(:final data):
        // Repository層のMatchResultをDomain層のMatchResultDetailエンティティに変換する。
        return MatchResultDetail(
          type: data.result.type,
          winnerId: data.result.winnerId,
          submittedAt: data.result.submittedAt,
          submittedBy: data.result.submittedBy,
          submitterUserId: data.result.submitterUserId,
        );
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
