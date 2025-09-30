import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain.dart';

part 'tournament_edit_notifier.g.dart';

/// トーナメント編集の状態。
enum TournamentEditState {
  /// 初期状態
  initial,

  /// 読み込み中
  loading,

  /// 読み込み成功（編集可能）
  loaded,

  /// 更新中
  updating,

  /// 更新成功
  success,

  /// エラー
  error,
}

/// トーナメント編集のデータ。
class TournamentEditData {
  /// [TournamentEditData] のコンストラクタ。
  const TournamentEditData({
    this.state = TournamentEditState.initial,
    this.tournament,
    this.errorMessage,
  });

  /// 状態。
  final TournamentEditState state;

  /// 編集対象のトーナメント。
  final Tournament? tournament;

  /// エラーメッセージ。
  final String? errorMessage;

  /// コピーを作成する。
  TournamentEditData copyWith({
    TournamentEditState? state,
    Tournament? tournament,
    String? errorMessage,
  }) {
    return TournamentEditData(
      state: state ?? this.state,
      tournament: tournament ?? this.tournament,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// [TournamentEditData] を管理する Notifier。
@riverpod
class TournamentEditNotifier extends _$TournamentEditNotifier {
  /// UseCase。
  GetTournamentUseCase get _getTournamentUseCase =>
      ref.read(getTournamentUseCaseProvider);

  UpdateTournamentUseCase get _updateTournamentUseCase =>
      ref.read(updateTournamentUseCaseProvider);

  @override
  TournamentEditData build() {
    return const TournamentEditData();
  }

  /// 編集対象のトーナメントを読み込む。
  ///
  /// [id]: トーナメント ID
  Future<void> loadTournament(String id) async {
    state = state.copyWith(state: TournamentEditState.loading);

    try {
      final tournament = await _getTournamentUseCase.invoke(id: id);
      state = state.copyWith(
        state: TournamentEditState.loaded,
        tournament: tournament,
      );
    } on FailureStatusException catch (e) {
      state = state.copyWith(
        state: TournamentEditState.error,
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
        state: TournamentEditState.error,
        errorMessage: message,
      );
    } on Exception {
      state = state.copyWith(
        state: TournamentEditState.error,
        errorMessage: '予期しないエラーが発生しました',
      );
    }
  }

  /// トーナメント情報を更新する。
  ///
  /// [id]: トーナメント ID
  /// [title]: 更新するタイトル（null の場合は更新しない）
  /// [description]: 更新する説明（null の場合は更新しない）
  /// [startDate]: 更新する開始日時（null の場合は更新しない）
  /// [endDate]: 更新する終了日時（null の場合は更新しない）
  Future<void> updateTournament({
    required String id,
    String? title,
    String? description,
    String? startDate,
    String? endDate,
  }) async {
    state = state.copyWith(state: TournamentEditState.updating);

    try {
      final tournament = await _updateTournamentUseCase.invoke(
        id: id,
        title: title,
        description: description,
        startDate: startDate,
        endDate: endDate,
      );
      state = state.copyWith(
        state: TournamentEditState.success,
        tournament: tournament,
      );
    } on FailureStatusException catch (e) {
      state = state.copyWith(
        state: TournamentEditState.error,
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
        state: TournamentEditState.error,
        errorMessage: message,
      );
    } on Exception {
      state = state.copyWith(
        state: TournamentEditState.error,
        errorMessage: '予期しないエラーが発生しました',
      );
    }
  }

  /// 状態をリセットする。
  void reset() {
    state = const TournamentEditData();
  }
}
