import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain.dart';

part 'tournament_detail_notifier.g.dart';

/// トーナメント詳細の状態。
enum TournamentDetailState {
  /// 初期状態
  initial,

  /// 読み込み中
  loading,

  /// 読み込み成功
  loaded,

  /// 読み込み失敗
  error,
}

/// トーナメント詳細のデータ。
class TournamentDetailData {
  /// [TournamentDetailData] のコンストラクタ。
  const TournamentDetailData({
    this.state = TournamentDetailState.initial,
    this.tournament,
    this.errorMessage,
  });

  /// 状態。
  final TournamentDetailState state;

  /// トーナメント詳細。
  final Tournament? tournament;

  /// エラーメッセージ。
  final String? errorMessage;

  /// コピーを作成する。
  TournamentDetailData copyWith({
    TournamentDetailState? state,
    Tournament? tournament,
    String? errorMessage,
  }) {
    return TournamentDetailData(
      state: state ?? this.state,
      tournament: tournament ?? this.tournament,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// [TournamentDetailData] を管理する Notifier。
@riverpod
class TournamentDetailNotifier extends _$TournamentDetailNotifier {
  /// UseCase。
  GetTournamentUseCase get _getTournamentUseCase =>
      ref.read(getTournamentUseCaseProvider);

  @override
  TournamentDetailData build() {
    return const TournamentDetailData();
  }

  /// トーナメント詳細を取得する。
  ///
  /// [id]: トーナメント ID
  Future<void> loadTournament(String id) async {
    state = state.copyWith(state: TournamentDetailState.loading);

    try {
      final tournament = await _getTournamentUseCase.invoke(id: id);
      state = state.copyWith(
        state: TournamentDetailState.loaded,
        tournament: tournament,
      );
    } on FailureStatusException catch (e) {
      state = state.copyWith(
        state: TournamentDetailState.error,
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
        state: TournamentDetailState.error,
        errorMessage: message,
      );
    } on Exception {
      state = state.copyWith(
        state: TournamentDetailState.error,
        errorMessage: '予期しないエラーが発生しました',
      );
    }
  }

  /// トーナメント詳細を更新する。
  Future<void> refreshTournament(String id) async {
    await loadTournament(id);
  }

  /// 状態をリセットする。
  void reset() {
    state = const TournamentDetailData();
  }
}
