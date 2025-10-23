import 'dart:convert';

import 'package:repository/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain.dart';

part 'player_session_notifier.g.dart';

/// [PlayerSession] を管理する Notifier.
@Riverpod(keepAlive: true)
class PlayerSessionNotifier extends _$PlayerSessionNotifier {
  /// リポジトリ。
  LocalConfigRepository get _repository =>
      ref.read(localConfigRepositoryProvider);

  /// リポジトリから [PlayerSession] を取得する。
  PlayerSession get _playerSession {
    final sessionJson = _repository.getString(
      key: LocalConfigKey.playerSession,
    );

    if (sessionJson == null) {
      // セッション情報が存在しない場合、デフォルト値を返す。
      return PlayerSession(
        playerId: PlayerSession.playerIdDefault,
        playerNumber: PlayerSession.playerNumberDefault,
        userId: PlayerSession.userIdDefault,
        tournamentId: PlayerSession.tournamentIdDefault,
        playerName: PlayerSession.playerNameDefault,
        createdAt: DateTime.now(),
        expiresAt: DateTime.now(),
      );
    }

    return PlayerSession.fromJson(
      jsonDecode(sessionJson) as Map<String, dynamic>,
    );
  }

  @override
  PlayerSession build() {
    return _playerSession;
  }

  /// セッション情報を保存する。
  ///
  /// [session] で指定されたセッション情報をローカル設定に保存し、[state] に反映する。
  Future<void> saveSession(PlayerSession session) async {
    await _repository.setString(
      key: LocalConfigKey.playerSession,
      value: jsonEncode(session.toJson()),
    );
    state = session;
  }

  /// セッション情報をクリアする。
  ///
  /// ローカル設定からセッション情報を削除し、[state] をデフォルト値に戻す。
  Future<void> clearSession() async {
    final defaultSession = PlayerSession(
      playerId: PlayerSession.playerIdDefault,
      playerNumber: PlayerSession.playerNumberDefault,
      userId: PlayerSession.userIdDefault,
      tournamentId: PlayerSession.tournamentIdDefault,
      playerName: PlayerSession.playerNameDefault,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now(),
    );

    await _repository.setString(
      key: LocalConfigKey.playerSession,
      value: jsonEncode(defaultSession.toJson()),
    );
    state = defaultSession;
  }

  /// セッションが有効かどうか。
  ///
  /// セッション有効期限が現在時刻より後であれば true を返す。
  bool isSessionValid() {
    final session = state;

    // セッションが存在しない場合は無効。
    if (session.playerId == PlayerSession.playerIdDefault) {
      return false;
    }

    // セッション有効期限が現在時刻より後であれば有効。
    return session.expiresAt.isAfter(DateTime.now());
  }
}
