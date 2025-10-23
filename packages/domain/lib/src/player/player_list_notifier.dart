import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain.dart';

part 'player_list_notifier.g.dart';

/// プレイヤー一覧の状態。
enum PlayerListState {
  /// 初期状態
  initial,

  /// 読み込み中
  loading,

  /// 読み込み成功
  loaded,

  /// 読み込み失敗
  error,
}

/// プレイヤー一覧のデータ。
class PlayerListData {
  /// [PlayerListData] のコンストラクタ。
  const PlayerListData({
    this.state = PlayerListState.initial,
    this.players = const [],
    this.errorMessage,
  });

  /// 状態。
  final PlayerListState state;

  /// プレイヤー一覧。
  final List<Player> players;

  /// エラーメッセージ。
  final String? errorMessage;

  /// コピーを作成する。
  PlayerListData copyWith({
    PlayerListState? state,
    List<Player>? players,
    String? errorMessage,
  }) {
    return PlayerListData(
      state: state ?? this.state,
      players: players ?? this.players,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// [PlayerListData] を管理する Notifier。
@Riverpod(keepAlive: true)
class PlayerListNotifier extends _$PlayerListNotifier {
  /// UseCase。
  GetPlayersUseCase get _getPlayersUseCase =>
      ref.read(getPlayersUseCaseProvider);

  @override
  PlayerListData build() {
    return const PlayerListData();
  }

  /// プレイヤー一覧を取得する。
  Future<void> loadPlayers({
    required String tournamentId,
    String? status,
  }) async {
    state = state.copyWith(state: PlayerListState.loading);

    try {
      final players = await _getPlayersUseCase.invoke(
        tournamentId: tournamentId,
        status: status,
      );
      state = state.copyWith(state: PlayerListState.loaded, players: players);
    } on FailureStatusException catch (e) {
      state = state.copyWith(
        state: PlayerListState.error,
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
        state: PlayerListState.error,
        errorMessage: message,
      );
    } on Exception {
      state = state.copyWith(
        state: PlayerListState.error,
        errorMessage: '予期しないエラーが発生しました',
      );
    }
  }

  /// プレイヤー一覧を更新する。
  Future<void> refreshPlayers({
    required String tournamentId,
    String? status,
  }) async {
    await loadPlayers(tournamentId: tournamentId, status: status);
  }
}
