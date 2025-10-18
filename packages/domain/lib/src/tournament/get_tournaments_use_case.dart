import 'package:injection/injection.dart';
import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain.dart';

part 'get_tournaments_use_case.g.dart';

/// [GetTournamentsUseCase] を提供する。
@riverpod
GetTournamentsUseCase getTournamentsUseCase(Ref ref) {
  return GetTournamentsUseCase(
    tournamentRepository: ref.watch(tournamentRepositoryProvider),
  );
}

/// トーナメント一覧取得に関する処理を行う UseCase。
class GetTournamentsUseCase {
  /// [GetTournamentsUseCase] を生成する。
  ///
  /// [tournamentRepository] は、トーナメントに関する通信を行うためのリポジトリ。
  const GetTournamentsUseCase({
    required TournamentRepository tournamentRepository,
  }) : _tournamentRepository = tournamentRepository;

  final TournamentRepository _tournamentRepository;

  /// トーナメント一覧を取得する。
  ///
  /// Returns: トーナメント一覧
  /// Throws: [FailureStatusException] API がエラーステータスを返した場合
  /// Throws: [GeneralFailureException] ネットワークエラーや予期しないエラーの場合
  Future<List<Tournament>> invoke() async {
    try {
      final results = await _tournamentRepository.getTournaments();
      return results.map(Tournament.fromModel).toList();
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
