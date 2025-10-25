import '../models/tournament_data.dart';
import 'tournament_generator.dart';

/// 完了済みトーナメント（8 人、3 ラウンド完了）のデータを生成する。
///
/// 詳細仕様: [player-firebase-test-data-spec.md] の「データセット 3」を参照。
class CompletedTournamentGenerator extends TournamentGenerator {
  @override
  String generateTournamentId() => 'test-tournament-completed-001';

  @override
  TournamentData generate() {
    final tournamentId = generateTournamentId();

    // トーナメント情報
    final tournament = {
      'title': 'テスト大会（完了済み）',
      'description': '8 人参加、3 ラウンド完了',
      'category': 'テスト',
      'venue': 'テスト会場',
      'startDate': generateTimestamp(offsetDays: -2),
      'endDate': generateTimestamp(offsetDays: -2, offsetHours: 8),
      'drawPoints': 1,
      'maxRounds': 3,
      'expectedPlayers': 8,
      'playerCount': 8,
      'status': 'COMPLETED',
      'currentRound': 3,
      'adminUid': 'test-admin-uid-003',
      'createdAt': generateTimestamp(offsetDays: -2, offsetHours: -1),
      'updatedAt': generateTimestamp(offsetDays: -2, offsetHours: 8),
    };

    // プレイヤー情報（8 人）
    // 簡略化のため、基本情報のみ
    final players = <PlayerData>[
      for (var i = 0; i < 8; i++)
        PlayerData(
          id: generatePlayerId(i),
          data: {
            'name': 'テストプレイヤー${i + 1}',
            'playerNumber': i + 1,
            'status': 'ACTIVE',
            'userId': generateUserId(i),
            'matchHistory': {
              'totalPoints': _calculateFinalPoints(i),
              'stairMatchCount': 0,
              'byeCount': 0,
              'opponents': <String>[],
              'matchResults': _generateFinalMatchResults(i),
            },
            'registeredAt':
                generateTimestamp(offsetDays: -2, offsetHours: -(9 - i)),
            'droppedAt': null,
          },
        ),
    ];

    // ラウンド情報（3 ラウンドすべて完了）
    final rounds = <RoundData>[
      for (var round = 1; round <= 3; round++)
        RoundData(
          id: generateRoundId(round),
          data: {
            'roundNumber': round,
            'status': 'COMPLETED',
            'startedAt': generateTimestamp(
              offsetDays: -2,
              offsetHours: (round - 1) * 3,
            ),
            'completedAt': generateTimestamp(
              offsetDays: -2,
              offsetHours: (round - 1) * 3 + 2,
            ),
            'generationSeed': 12345020 + round,
          },
          matches: _generateCompletedRoundMatches(round),
        ),
    ];

    return TournamentData(
      tournamentId: tournamentId,
      tournament: tournament,
      players: players,
      rounds: rounds,
    );
  }

  /// 最終勝ち点を計算する（簡略化版）。
  int _calculateFinalPoints(int playerIndex) {
    // プレイヤー 0,2,4,6 が強い設定
    if (playerIndex % 2 == 0) {
      return playerIndex == 0 ? 9 : 6; // プレイヤー1 が全勝
    }
    return 3; // 敗者
  }

  /// 最終マッチ結果を生成する（簡略化版）。
  List<Map<String, dynamic>> _generateFinalMatchResults(int playerIndex) {
    final points = _calculateFinalPoints(playerIndex);
    final wins = points ~/ 3;

    return [
      for (var round = 1; round <= 3; round++)
        {
          'round': round,
          'result': round <= wins ? 'WIN' : 'LOSS',
          'points': round <= wins ? 3 : 0,
        },
    ];
  }

  /// 完了済みラウンドのマッチを生成する。
  List<MatchData> _generateCompletedRoundMatches(int roundNumber) {
    return [
      for (var i = 0; i < 4; i++)
        MatchData(
          id: generateMatchId(roundNumber, i + 1),
          data: {
            'tableNumber': i + 1,
            'published': true,
            'player1': {
              'id': generatePlayerId(i * 2),
              'name': 'テストプレイヤー${i * 2 + 1}',
              'matchingPoints': 0, // 簡略化
            },
            'player1UserId': generateUserId(i * 2),
            'player2': {
              'id': generatePlayerId(i * 2 + 1),
              'name': 'テストプレイヤー${i * 2 + 2}',
              'matchingPoints': 0, // 簡略化
            },
            'player2UserId': generateUserId(i * 2 + 1),
            'result': {
              'type': 'PLAYER1_WIN',
              'winnerId': generatePlayerId(i * 2),
              'submittedAt': generateTimestamp(
                offsetDays: -2,
                offsetHours: (roundNumber - 1) * 3 + 2,
              ),
              'submittedBy': generatePlayerId(i * 2),
              'submitterUserId': generateUserId(i * 2),
            },
            'isByeMatch': false,
            'pointDifference': 0,
            'createdAt': generateTimestamp(
              offsetDays: -2,
              offsetHours: (roundNumber - 1) * 3,
            ),
          },
        ),
    ];
  }
}
