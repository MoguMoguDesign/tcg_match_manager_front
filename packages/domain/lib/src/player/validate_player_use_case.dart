import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain.dart';

part 'validate_player_use_case.g.dart';

/// [ValidatePlayerUseCase] を提供する。
@riverpod
ValidatePlayerUseCase validatePlayerUseCase(Ref ref) {
  return ValidatePlayerUseCase(
    playerAuthRepository: ref.watch(playerAuthRepositoryProvider),
  );
}

/// プレイヤー認証用ユースケース。
class ValidatePlayerUseCase {
  /// [ValidatePlayerUseCase] を生成する。
  ///
  /// [playerAuthRepository] は、プレイヤー認証に関する通信を行うためのリポジトリ。
  ValidatePlayerUseCase({
    required PlayerAuthRepository playerAuthRepository,
  }) : _playerAuthRepository = playerAuthRepository;

  final PlayerAuthRepository _playerAuthRepository;

  /// プレイヤー認証処理を実行する。
  ///
  /// - [baseUrl] は、API のベース URL。
  /// - [tournamentId] は、大会 ID。
  /// - [userId] は、ユーザー ID（認証用）。
  Future<PlayerSession> invoke({
    required String baseUrl,
    required String tournamentId,
    required String userId,
  }) async {
    final result = await _playerAuthRepository.validatePlayer(
      baseUrl: baseUrl,
      tournamentId: tournamentId,
      request: PlayerAuthRequest(
        tournamentId: tournamentId,
        userId: userId,
      ),
    );

    switch (result) {
      case SuccessRepositoryResult(:final data):
        // PlayerSession を生成する。
        final now = DateTime.now();
        return PlayerSession(
          playerId: data.playerId,
          playerNumber: 0, // 認証レスポンスには playerNumber が含まれないため、デフォルト値を使用する。
          userId: userId,
          tournamentId: tournamentId,
          playerName: data.playerName,
          createdAt: now,
          expiresAt: now.add(const Duration(hours: 24)),
        );
      case FailureRepositoryResult(:final reason, :final statusCode):
        switch (reason) {
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
}
