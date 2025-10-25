import 'package:firedart/firedart.dart';
import 'package:logger/logger.dart';

import '../models/tournament_data.dart';

/// Firestore への書き込み結果。
class WriteResult {
  const WriteResult({
    required this.success,
    required this.tournamentId,
    this.error,
  });

  /// 書き込みが成功したかどうか。
  final bool success;

  /// トーナメント ID。
  final String tournamentId;

  /// エラーメッセージ（失敗時のみ）。
  final String? error;
}

/// Firestore へのテストデータ書き込みを行う。
class FirestoreWriter {
  FirestoreWriter({
    required this.firestore,
    required this.logger,
    this.forceOverwrite = false,
  });

  /// Firestore インスタンス。
  final Firestore firestore;

  /// ロガー。
  final Logger logger;

  /// 既存データを強制上書きするかどうか。
  final bool forceOverwrite;

  /// トーナメントデータを Firestore に書き込む。
  ///
  /// [data] 書き込むトーナメントデータ。
  ///
  /// 戻り値: 書き込み結果。
  Future<WriteResult> writeTournament(TournamentData data) async {
    try {
      logger.i('📝 トーナメント "${data.tournamentId}" の書き込み開始...');

      // 1. 既存データのチェック
      if (!forceOverwrite) {
        final exists = await _checkTournamentExists(data.tournamentId);
        if (exists) {
          final message = 'トーナメント "${data.tournamentId}" は既に存在します。'
              '上書きする場合は --force フラグを使用してください。';
          logger.w('⚠️  $message');
          return WriteResult(
            success: false,
            tournamentId: data.tournamentId,
            error: message,
          );
        }
      }

      // 2. トーナメントドキュメントを書き込み
      await _writeTournamentDocument(data.tournamentId, data.tournament);
      logger.d('  ✓ トーナメントドキュメント書き込み完了');

      // 3. プレイヤーデータを書き込み
      await _writePlayers(data.tournamentId, data.players);
      logger.d('  ✓ プレイヤーデータ (${data.players.length} 件) 書き込み完了');

      // 4. ラウンドデータを書き込み
      if (data.rounds.isNotEmpty) {
        await _writeRounds(data.tournamentId, data.rounds);
        logger.d('  ✓ ラウンドデータ (${data.rounds.length} 件) 書き込み完了');
      }

      logger.i('✅ トーナメント "${data.tournamentId}" の書き込み成功');

      return WriteResult(
        success: true,
        tournamentId: data.tournamentId,
      );
    } catch (e, stackTrace) {
      logger.e(
        '❌ トーナメント "${data.tournamentId}" の書き込み失敗',
        error: e,
        stackTrace: stackTrace,
      );

      return WriteResult(
        success: false,
        tournamentId: data.tournamentId,
        error: e.toString(),
      );
    }
  }

  /// トーナメントが既に存在するかチェックする。
  Future<bool> _checkTournamentExists(String tournamentId) async {
    try {
      final doc = await firestore
          .collection('tournaments')
          .document(tournamentId)
          .get();
      return doc.map.isNotEmpty;
    } catch (e) {
      // ドキュメントが存在しない場合は例外が発生する可能性がある
      return false;
    }
  }

  /// トーナメントドキュメントを書き込む。
  Future<void> _writeTournamentDocument(
    String tournamentId,
    Map<String, dynamic> data,
  ) async {
    await firestore
        .collection('tournaments')
        .document(tournamentId)
        .set(data);
  }

  /// プレイヤーデータを書き込む。
  Future<void> _writePlayers(
    String tournamentId,
    List<PlayerData> players,
  ) async {
    final playersCollection = firestore
        .collection('tournaments')
        .document(tournamentId)
        .collection('players');

    // バッチ書き込みで効率化
    for (final player in players) {
      await playersCollection.document(player.id).set(player.data);
    }
  }

  /// ラウンドデータとマッチデータを書き込む。
  Future<void> _writeRounds(
    String tournamentId,
    List<RoundData> rounds,
  ) async {
    final roundsCollection = firestore
        .collection('tournaments')
        .document(tournamentId)
        .collection('rounds');

    for (final round in rounds) {
      // ラウンドドキュメントを書き込み
      await roundsCollection.document(round.id).set(round.data);

      // マッチデータを書き込み
      if (round.matches.isNotEmpty) {
        final matchesCollection =
            roundsCollection.document(round.id).collection('matches');

        for (final match in round.matches) {
          await matchesCollection.document(match.id).set(match.data);
        }
      }
    }
  }
}
