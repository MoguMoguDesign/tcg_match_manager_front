import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain.dart';

part 'tournament_create_notifier.g.dart';

/// トーナメント作成の状態。
enum TournamentCreateState {
  /// 初期状態
  initial,

  /// 作成中
  creating,

  /// 作成成功
  success,

  /// 作成失敗
  error,
}

/// トーナメント作成のデータ。
class TournamentCreateData {
  /// [TournamentCreateData] のコンストラクタ。
  const TournamentCreateData({
    this.state = TournamentCreateState.initial,
    this.tournament,
    this.errorMessage,
  });

  /// 状態。
  final TournamentCreateState state;

  /// 作成されたトーナメント。
  final Tournament? tournament;

  /// エラーメッセージ。
  final String? errorMessage;

  /// コピーを作成する。
  TournamentCreateData copyWith({
    TournamentCreateState? state,
    Tournament? tournament,
    String? errorMessage,
  }) {
    return TournamentCreateData(
      state: state ?? this.state,
      tournament: tournament ?? this.tournament,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// [TournamentCreateData] を管理する Notifier。
@riverpod
class TournamentCreateNotifier extends _$TournamentCreateNotifier {
  /// UseCase。
  CreateTournamentUseCase get _createTournamentUseCase =>
      ref.read(createTournamentUseCaseProvider);

  @override
  TournamentCreateData build() {
    return const TournamentCreateData();
  }

  /// トーナメントを作成する。
  ///
  /// [title]: トーナメントのタイトル
  /// [description]: トーナメントの説明
  /// [venue]: 開催会場
  /// [startDate]: 開始日時（ISO 8601 形式）
  /// [endDate]: 終了日時（ISO 8601 形式）
  /// [drawPoints]: 引き分け得点（オプション）
  /// [maxRounds]: ラウンド数（オプション、自動計算時はnull）
  /// [expectedPlayers]: 予定参加者数（オプション）
  Future<void> createTournament({
    required String title,
    required String description,
    required String venue,
    required String startDate,
    required String endDate,
    int drawPoints = 0,
    int? maxRounds,
    int? expectedPlayers,
  }) async {
    state = state.copyWith(state: TournamentCreateState.creating);

    try {
      final request = CreateTournamentRequest(
        title: title,
        description: description,
        venue: venue,
        startDate: startDate,
        endDate: endDate,
        drawPoints: drawPoints,
        maxRounds: maxRounds,
        expectedPlayers: expectedPlayers,
      );
      final tournament = await _createTournamentUseCase.call(request);
      state = state.copyWith(
        state: TournamentCreateState.success,
        tournament: tournament,
      );
    } on FailureStatusException catch (e) {
      state = state.copyWith(
        state: TournamentCreateState.error,
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
        case GeneralFailureReason.sessionExpired:
          message = 'セッションの有効期限が切れました。再度ログインしてください。';
      }
      state = state.copyWith(
        state: TournamentCreateState.error,
        errorMessage: message,
      );
    } on Exception {
      state = state.copyWith(
        state: TournamentCreateState.error,
        errorMessage: '予期しないエラーが発生しました',
      );
    }
  }

  /// 状態をリセットする。
  void reset() {
    state = const TournamentCreateData();
  }
}
