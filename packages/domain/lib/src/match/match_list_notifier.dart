import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain.dart';

part 'match_list_notifier.g.dart';

/// [Match] のリストを管理する Notifier.
@Riverpod(keepAlive: true)
class MatchListNotifier extends _$MatchListNotifier {
  /// UseCase。
  GetPublishedMatchesUseCase get _useCase =>
      ref.read(getPublishedMatchesUseCaseProvider);

  @override
  AsyncValue<List<Match>> build() {
    // 初期状態は空のリスト。
    return const AsyncValue.data([]);
  }

  /// マッチリストを取得する。
  ///
  /// - [baseUrl] は、API のベース URL。
  /// - [tournamentId] は、大会 ID。
  /// - [roundId] は、ラウンド ID。
  /// - [userId] は、ユーザー ID（個人ハイライト用）。
  Future<void> fetchMatches({
    required String baseUrl,
    required String tournamentId,
    required String roundId,
    required String userId,
  }) async {
    // ローディング状態に設定する。
    state = const AsyncValue.loading();

    // UseCaseを使用してマッチリストを取得し、結果を state に設定する。
    state = await AsyncValue.guard(() async {
      return _useCase.invoke(
        baseUrl: baseUrl,
        tournamentId: tournamentId,
        roundId: roundId,
        userId: userId,
      );
    });
  }

  /// マッチリストをクリアする。
  void clearMatches() {
    state = const AsyncValue.data([]);
  }
}
