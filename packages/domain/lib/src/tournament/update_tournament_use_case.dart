import 'package:injection/injection.dart';
import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain.dart';

part 'update_tournament_use_case.g.dart';

/// [UpdateTournamentUseCase] を提供する。
@riverpod
UpdateTournamentUseCase updateTournamentUseCase(Ref ref) {
  return UpdateTournamentUseCase(
    tournamentRepository: ref.watch(tournamentRepositoryProvider),
  );
}

/// トーナメント更新に関する処理を行う UseCase。
class UpdateTournamentUseCase {
  /// [UpdateTournamentUseCase] を生成する。
  ///
  /// [tournamentRepository] は、トーナメントに関する通信を行うためのリポジトリ。
  UpdateTournamentUseCase({required TournamentRepository tournamentRepository})
    : _tournamentRepository = tournamentRepository;

  final TournamentRepository _tournamentRepository;

  /// トーナメント情報を更新する。
  ///
  /// [id]: トーナメント ID
  /// [title]: 更新するタイトル（null の場合は更新しない）
  /// [description]: 更新する説明（null の場合は更新しない）
  /// [startDate]: 更新する開始日時（null の場合は更新しない）
  /// [endDate]: 更新する終了日時（null の場合は更新しない）
  ///
  /// Returns: 更新されたトーナメント情報
  /// Throws: [FailureStatusException] API がエラーステータスを返した場合
  /// Throws: [GeneralFailureException] ネットワークエラーや予期しないエラーの場合
  Future<Tournament> invoke({
    required String id,
    String? title,
    String? description,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final request = UpdateTournamentRequest(
        title: title,
        description: description,
        startDate: startDate,
        endDate: endDate,
      );

      final result = await _tournamentRepository.updateTournament(id, request);
      return Tournament.fromModel(result);
    } on AdminApiException catch (e) {
      switch (e.code) {
        case 'INVALID_ARGUMENT':
        case 'PARSE_ERROR':
          throw FailureStatusException(e.message);
        case 'NOT_FOUND':
          throw FailureStatusException('指定されたトーナメントが見つかりません');
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
