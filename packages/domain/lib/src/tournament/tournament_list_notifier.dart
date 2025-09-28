import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain.dart';

part 'tournament_list_notifier.g.dart';

/// トーナメント一覧の状態。
enum TournamentListState {
  /// 初期状態
  initial,

  /// 読み込み中
  loading,

  /// 読み込み成功
  loaded,

  /// 読み込み失敗
  error,
}

/// トーナメント一覧のデータ。
class TournamentListData {
  /// [TournamentListData] のコンストラクタ。
  const TournamentListData({
    this.state = TournamentListState.initial,
    this.tournaments = const [],
    this.errorMessage,
  });

  /// 状態。
  final TournamentListState state;

  /// トーナメント一覧。
  final List<Tournament> tournaments;

  /// エラーメッセージ。
  final String? errorMessage;

  /// コピーを作成する。
  TournamentListData copyWith({
    TournamentListState? state,
    List<Tournament>? tournaments,
    String? errorMessage,
  }) {
    return TournamentListData(
      state: state ?? this.state,
      tournaments: tournaments ?? this.tournaments,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// [TournamentListData] を管理する Notifier。
@Riverpod(keepAlive: true)
class TournamentListNotifier extends _$TournamentListNotifier {
  /// UseCase。
  GetTournamentsUseCase get _getTournamentsUseCase =>
      ref.read(getTournamentsUseCaseProvider);

  @override
  TournamentListData build() {
    return const TournamentListData();
  }

  /// トーナメント一覧を取得する。
  Future<void> loadTournaments() async {
    state = state.copyWith(state: TournamentListState.loading);

    try {
      final tournaments = await _getTournamentsUseCase.invoke();
      state = state.copyWith(
        state: TournamentListState.loaded,
        tournaments: tournaments,
      );
    } on FailureStatusException catch (e) {
      state = state.copyWith(
        state: TournamentListState.error,
        errorMessage: e.message,
      );
    } on GeneralFailureException catch (e) {
      String message;
      switch (e.reason) {
        case GeneralFailureReason.other:
          message = '認証に失敗しました。再度ログインしてください。';
        case GeneralFailureReason.noConnectionError:
          message = 'ネットワークに接続できません。';
        case GeneralFailureReason.serverUrlNotFoundError:
          message = 'サーバーURLが見つかりません。';
        case GeneralFailureReason.badResponse:
          message = '不正なレスポンスです。';
      }
      state = state.copyWith(
        state: TournamentListState.error,
        errorMessage: message,
      );
    } on Exception {
      state = state.copyWith(
        state: TournamentListState.error,
        errorMessage: '予期しないエラーが発生しました',
      );
    }
  }

  /// トーナメント一覧を更新する。
  Future<void> refreshTournaments() async {
    await loadTournaments();
  }
}
