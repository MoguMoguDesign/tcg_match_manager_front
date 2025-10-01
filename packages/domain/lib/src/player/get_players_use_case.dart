import 'package:injection/injection.dart';
import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain.dart';

part 'get_players_use_case.g.dart';

/// [GetPlayersUseCase] を提供する。
@riverpod
GetPlayersUseCase getPlayersUseCase(Ref ref) {
  return GetPlayersUseCase(
    playerRepository: ref.watch(playerRepositoryProvider),
  );
}

/// プレイヤー一覧取得に関する処理を行う UseCase。
class GetPlayersUseCase {
  /// [GetPlayersUseCase] を生成する。
  ///
  /// [playerRepository] は、プレイヤーに関する通信を行うためのリポジトリ。
  const GetPlayersUseCase({
    required PlayerRepository playerRepository,
  }) : _playerRepository = playerRepository;

  final PlayerRepository _playerRepository;

  /// プレイヤー一覧を取得する。
  ///
  /// [tournamentId] トーナメントID
  /// [status] プレイヤーステータス (オプション)
  ///
  /// Returns: プレイヤー一覧
  /// Throws: [FailureStatusException] API がエラーステータスを返した場合
  /// Throws: [GeneralFailureException] ネットワークエラーや予期しないエラーの場合
  Future<List<Player>> invoke({
    required String tournamentId,
    String? status,
  }) async {
    try {
      final results = await _playerRepository.getPlayers(
        tournamentId: tournamentId,
        status: status,
      );
      return results.map(Player.fromModel).toList();
    } on AdminApiException catch (e) {
      switch (e.code) {
        case 'INVALID_RESPONSE':
        case 'PARSE_ERROR':
          throw FailureStatusException(e.message);
        case 'UNAUTHENTICATED':
        case 'AUTH_ERROR':
          throw GeneralFailureException(
            reason: GeneralFailureReason.other,
            errorCode: e.code,
          );
        case 'NETWORK_ERROR':
          throw GeneralFailureException(
            reason: GeneralFailureReason.noConnectionError,
            errorCode: e.code,
          );
        default:
          throw GeneralFailureException(
            reason: GeneralFailureReason.other,
            errorCode: e.code,
          );
      }
    }
  }
}
