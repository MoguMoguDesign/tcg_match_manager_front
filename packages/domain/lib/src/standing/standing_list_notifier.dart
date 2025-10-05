import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain.dart';

part 'standing_list_notifier.g.dart';

/// [Standing] を管理する Notifier.
@Riverpod(keepAlive: true)
class StandingListNotifier extends _$StandingListNotifier {
  /// UseCase。
  GetFinalStandingsUseCase get _useCase =>
      ref.read(getFinalStandingsUseCaseProvider);

  @override
  AsyncValue<Standing?> build() {
    // 初期状態は null。
    return const AsyncValue.data(null);
  }

  /// 最終順位を取得する。
  ///
  /// - [baseUrl] は、API のベース URL。
  /// - [tournamentId] は、大会 ID。
  /// - [userId] は、ユーザー ID（個人ハイライト用、任意）。
  Future<void> fetchStandings({
    required String baseUrl,
    required String tournamentId,
    String? userId,
  }) async {
    // ローディング状態に設定する。
    state = const AsyncValue.loading();

    // UseCaseを使用して最終順位を取得し、結果を state に設定する。
    state = await AsyncValue.guard(() async {
      return _useCase.invoke(
        baseUrl: baseUrl,
        tournamentId: tournamentId,
        userId: userId,
      );
    });
  }

  /// 最終順位をクリアする。
  void clearStandings() {
    state = const AsyncValue.data(null);
  }
}
