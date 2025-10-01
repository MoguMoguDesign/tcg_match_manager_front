import 'package:injection/injection.dart';
import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain.dart';

part 'add_player_use_case.g.dart';

/// [AddPlayerUseCase] を提供する。
@riverpod
AddPlayerUseCase addPlayerUseCase(Ref ref) {
  return AddPlayerUseCase(
    playerRepository: ref.watch(playerRepositoryProvider),
  );
}

/// プレイヤー登録に関する処理を行う UseCase。
class AddPlayerUseCase {
  /// [AddPlayerUseCase] を生成する。
  ///
  /// [playerRepository] は、プレイヤーに関する通信を行うためのリポジトリ。
  const AddPlayerUseCase({
    required PlayerRepository playerRepository,
  }) : _playerRepository = playerRepository;

  final PlayerRepository _playerRepository;

  /// プレイヤーを登録する。
  ///
  /// [tournamentId] トーナメントID
  /// [name] プレイヤー名
  /// [playerNumber] プレイヤー番号
  /// [userId] ユーザーID
  ///
  /// Returns: 登録されたプレイヤー情報
  /// Throws: [FailureStatusException] API がエラーステータスを返した場合
  /// Throws: [GeneralFailureException] ネットワークエラーや予期しないエラーの場合
  Future<Player> invoke({
    required String tournamentId,
    required String name,
    required int playerNumber,
    required String userId,
  }) async {
    try {
      final request = AddPlayerRequest(
        name: name,
        playerNumber: playerNumber,
        userId: userId,
      );
      final result = await _playerRepository.addPlayer(
        tournamentId: tournamentId,
        request: request,
      );
      return Player.fromModel(result);
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
