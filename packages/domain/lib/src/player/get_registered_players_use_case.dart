import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain.dart';

part 'get_registered_players_use_case.g.dart';

/// [GetRegisteredPlayersUseCase] を提供する。
@riverpod
GetRegisteredPlayersUseCase getRegisteredPlayersUseCase(Ref ref) {
  return GetRegisteredPlayersUseCase(
    playerRegistrationRepository:
        ref.watch(playerRegistrationRepositoryProvider),
  );
}

/// 登録済みプレイヤー一覧取得用ユースケース。
class GetRegisteredPlayersUseCase {
  /// [GetRegisteredPlayersUseCase] を生成する。
  ///
  /// [playerRegistrationRepository] は、プレイヤー登録に関する通信を行うためのリポジトリ。
  GetRegisteredPlayersUseCase({
    required PlayerRegistrationRepository playerRegistrationRepository,
  }) : _playerRegistrationRepository = playerRegistrationRepository;

  final PlayerRegistrationRepository _playerRegistrationRepository;

  /// 登録済みプレイヤー一覧を取得する。
  ///
  /// - [tournamentId] は、大会 ID。
  ///
  /// Returns: プレイヤー一覧
  /// Throws: [GeneralFailureException] エラーが発生した場合
  Future<List<Player>> invoke({
    required String tournamentId,
  }) async {
    final result = await _playerRegistrationRepository.getPlayersFromFirestore(
      tournamentId: tournamentId,
    );

    switch (result) {
      case SuccessRepositoryResult(:final data):
        return data.map(Player.fromModel).toList();
      case FailureRepositoryResult(:final reason):
        throw GeneralFailureException(
          reason: GeneralFailureReason.other,
          errorCode: reason.name,
        );
    }
  }
}
