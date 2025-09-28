import 'package:injection/injection.dart';
import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain.dart';

part 'create_tournament_use_case.g.dart';

/// [CreateTournamentUseCase] を提供する。
@riverpod
CreateTournamentUseCase createTournamentUseCase(Ref ref) {
  return CreateTournamentUseCase(
    tournamentRepository: ref.watch(tournamentRepositoryProvider),
  );
}

/// トーナメント作成に関する処理を行う UseCase。
class CreateTournamentUseCase {
  /// [CreateTournamentUseCase] を生成する。
  ///
  /// [tournamentRepository] は、トーナメントに関する通信を行うためのリポジトリ。
  const CreateTournamentUseCase({
    required TournamentRepository tournamentRepository,
  }) : _tournamentRepository = tournamentRepository;

  final TournamentRepository _tournamentRepository;

  /// トーナメントを作成する。
  ///
  /// [title]: トーナメントのタイトル
  /// [description]: トーナメントの説明
  /// [startDate]: 開始日時（ISO 8601 形式）
  /// [endDate]: 終了日時（ISO 8601 形式）
  ///
  /// Returns: 作成されたトーナメント情報
  /// Throws: [FailureStatusException] API がエラーステータスを返した場合
  /// Throws: [GeneralFailureException] ネットワークエラーや予期しないエラーの場合
  Future<Tournament> invoke({
    required String title,
    required String description,
    required String startDate,
    required String endDate,
  }) async {
    try {
      final request = CreateTournamentRequest(
        title: title,
        description: description,
        startDate: startDate,
        endDate: endDate,
      );

      final result = await _tournamentRepository.createTournament(request);
      return Tournament.fromModel(result);
    } on AdminApiException catch (e) {
      switch (e.code) {
        case 'INVALID_ARGUMENT':
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
