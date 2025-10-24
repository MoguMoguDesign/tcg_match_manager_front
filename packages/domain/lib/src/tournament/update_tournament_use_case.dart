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
  /// [name]: 更新するトーナメント名（null の場合は更新しない）
  /// [overview]: 更新する概要（null の場合は更新しない）
  /// [category]: 更新するカテゴリ（null の場合は更新しない）
  /// [tournamentMode]: 更新する大会運営方式（null の場合は更新しない）
  /// [date]: 更新する開催日時（null の場合は更新しない）
  /// [startDate]: 更新する開始日（ISO 8601形式、null の場合は更新しない）
  /// [endDate]: 更新する終了日（ISO 8601形式、null の場合は更新しない）
  /// [startTime]: 更新する開始時刻（HH:mm形式、null の場合は更新しない）
  /// [endTime]: 更新する終了時刻（HH:mm形式、null の場合は更新しない）
  /// [drawPoints]: 更新する引き分け得点（null の場合は更新しない）
  /// [maxRounds]: 更新する最大ラウンド数（null の場合は更新しない）
  /// [expectedPlayers]: 更新する予定参加者数（null の場合は更新しない）
  /// [remarks]: 更新する備考（null の場合は更新しない）
  ///
  /// Returns: 更新されたトーナメント情報
  /// Throws: [FailureStatusException] API がエラーステータスを返した場合、
  /// またはトーナメントが完了済み/キャンセル済みの場合
  /// Throws: [GeneralFailureException] ネットワークエラーや予期しないエラーの場合
  Future<Tournament> invoke({
    required String id,
    String? name,
    String? overview,
    String? category,
    String? tournamentMode,
    String? date,
    String? startDate,
    String? endDate,
    String? startTime,
    String? endTime,
    int? drawPoints,
    int? maxRounds,
    int? expectedPlayers,
    String? remarks,
  }) async {
    try {
      // ステータスチェック: トーナメント情報を取得して状態を確認する。
      final tournament = await _tournamentRepository.getTournament(id);

      // 完了済みまたはキャンセル済みの場合は更新不可。
      if (tournament.status == 'COMPLETED') {
        throw const FailureStatusException('完了済みの大会は更新できません');
      }
      if (tournament.status == 'CANCELLED') {
        throw const FailureStatusException('キャンセル済みの大会は更新できません');
      }

      final request = UpdateTournamentRequest(
        name: name,
        overview: overview,
        category: category,
        tournamentMode: tournamentMode,
        date: date,
        startDate: startDate,
        endDate: endDate,
        startTime: startTime,
        endTime: endTime,
        drawPoints: drawPoints,
        maxRounds: maxRounds,
        expectedPlayers: expectedPlayers,
        remarks: remarks,
      );

      final result = await _tournamentRepository.updateTournament(id, request);
      return Tournament.fromModel(result);
    } on AdminApiException catch (e) {
      switch (e.code) {
        case 'INVALID_ARGUMENT':
        case 'PARSE_ERROR':
          throw FailureStatusException(e.message);
        case 'NOT_FOUND':
          throw const FailureStatusException('指定されたトーナメントが見つかりません');
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
