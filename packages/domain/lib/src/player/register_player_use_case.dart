import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain.dart';

part 'register_player_use_case.g.dart';

/// [RegisterPlayerUseCase] を提供する。
@riverpod
RegisterPlayerUseCase registerPlayerUseCase(Ref ref) {
  return RegisterPlayerUseCase(
    playerRegistrationRepository:
        ref.watch(playerRegistrationRepositoryProvider),
  );
}

/// プレイヤー登録用ユースケース。
class RegisterPlayerUseCase {
  /// [RegisterPlayerUseCase] を生成する。
  ///
  /// [playerRegistrationRepository] は、プレイヤー登録に関する通信を行うためのリポジトリ。
  RegisterPlayerUseCase({
    required PlayerRegistrationRepository playerRegistrationRepository,
  }) : _playerRegistrationRepository = playerRegistrationRepository;

  final PlayerRegistrationRepository _playerRegistrationRepository;

  /// プレイヤー登録処理を実行する。
  ///
  /// - [baseUrl] は、API のベース URL。
  /// - [tournamentId] は、大会 ID。
  /// - [playerName] は、プレイヤー名。
  Future<PlayerSession> invoke({
    required String baseUrl,
    required String tournamentId,
    required String playerName,
  }) async {
    final result = await _playerRegistrationRepository.registerPlayer(
      baseUrl: baseUrl,
      tournamentId: tournamentId,
      request: PlayerRegistrationRequest(name: playerName.trim()),
    );

    switch (result) {
      case SuccessRepositoryResult(:final data):
        // PlayerSession を生成する。
        final now = DateTime.now();
        return PlayerSession(
          playerId: data.playerId,
          playerNumber: data.playerNumber,
          userId: data.userId,
          tournamentId: tournamentId,
          playerName: playerName.trim(),
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
