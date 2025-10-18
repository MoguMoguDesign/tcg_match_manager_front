import 'package:injection/injection.dart';
import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain.dart';

part 'delete_tournament_use_case.g.dart';

/// [DeleteTournamentUseCase] を提供する。
@riverpod
DeleteTournamentUseCase deleteTournamentUseCase(Ref ref) {
  return DeleteTournamentUseCase(
    tournamentRepository: ref.watch(tournamentRepositoryProvider),
  );
}

/// トーナメント削除に関する処理を行う UseCase。
class DeleteTournamentUseCase {
  /// [DeleteTournamentUseCase] を生成する。
  ///
  /// [tournamentRepository] は、トーナメントに関する通信を行うためのリポジトリ。
  const DeleteTournamentUseCase({
    required TournamentRepository tournamentRepository,
  }) : _tournamentRepository = tournamentRepository;

  final TournamentRepository _tournamentRepository;

  /// 指定されたIDのトーナメントを削除する。
  ///
  /// [id]: 削除するトーナメント ID
  ///
  /// Throws: [FailureStatusException] API がエラーステータスを返した場合
  /// Throws: [GeneralFailureException] ネットワークエラーや予期しないエラーの場合
  Future<void> invoke({required String id}) async {
    try {
      await _tournamentRepository.deleteTournament(id);
    } on AdminApiException catch (e) {
      switch (e.code) {
        case 'INVALID_ARGUMENT':
          throw FailureStatusException(e.message);
        case 'NOT_FOUND':
          throw const FailureStatusException('指定されたトーナメントが見つかりません');
        case 'CONFLICT':
        case 'TOURNAMENT_HAS_ACTIVE_MATCHES':
        case 'BUSINESS_RULE_VIOLATION':
          throw FailureStatusException('削除できません: ${e.message}');
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
