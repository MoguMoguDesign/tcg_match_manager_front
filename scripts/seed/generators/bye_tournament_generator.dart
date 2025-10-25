import '../models/tournament_data.dart';
import 'tournament_generator.dart';

/// BYE マッチを含むトーナメント（9 人）のデータを生成する。
///
/// 詳細仕様: [player-firebase-test-data-spec.md] の「データセット 2」を参照。
class ByeTournamentGenerator extends TournamentGenerator {
  @override
  String generateTournamentId() => 'test-tournament-bye-001';

  @override
  TournamentData generate() {
    final tournamentId = generateTournamentId();

    // トーナメント情報
    final tournament = {
      'title': 'テスト大会（BYE あり）',
      'description': '9 人参加、BYE マッチテスト用',
      'category': 'テスト',
      'venue': 'テスト会場',
      'startDate': generateTimestamp(offsetDays: 0),
      'endDate': null,
      'drawPoints': 0,
      'maxRounds': 4,
      'expectedPlayers': 9,
      'playerCount': 9,
      'status': 'IN_PROGRESS',
      'currentRound': 1,
      'adminUid': 'test-admin-uid-002',
      'createdAt': generateTimestamp(offsetDays: 0, offsetHours: -1),
      'updatedAt': generateTimestamp(),
    };

    // プレイヤー情報（9 人）
    final players = <PlayerData>[
      for (var i = 0; i < 9; i++)
        PlayerData(
          id: generatePlayerId(i),
          data: {
            'name': 'テストプレイヤー${i + 1}',
            'playerNumber': i + 1,
            'status': 'ACTIVE',
            'userId': generateUserId(i),
            'matchHistory': i == 8
                ? {
                    'totalPoints': 3, // BYE 勝ち
                    'stairMatchCount': 0,
                    'byeCount': 1,
                    'opponents': <String>[],
                    'matchResults': [
                      {'round': 1, 'result': 'BYE', 'points': 3},
                    ],
                  }
                : {
                    'totalPoints': 0,
                    'stairMatchCount': 0,
                    'byeCount': 0,
                    'opponents': <String>[],
                    'matchResults': <Map<String, dynamic>>[],
                  },
            'registeredAt':
                generateTimestamp(offsetDays: 0, offsetHours: -(9 - i)),
            'droppedAt': null,
          },
        ),
    ];

    // ラウンド情報
    final rounds = <RoundData>[
      // Round 1（進行中、BYE マッチを含む）
      RoundData(
        id: generateRoundId(1),
        data: {
          'roundNumber': 1,
          'status': 'IN_PROGRESS',
          'startedAt': generateTimestamp(),
          'completedAt': null,
          'generationSeed': 12345010,
        },
        matches: _generateRound1Matches(),
      ),
    ];

    return TournamentData(
      tournamentId: tournamentId,
      tournament: tournament,
      players: players,
      rounds: rounds,
    );
  }

  /// Round 1 のマッチを生成する（BYE マッチを含む）。
  List<MatchData> _generateRound1Matches() {
    final matches = <MatchData>[];

    // 通常マッチ（4 マッチ）
    for (var i = 0; i < 4; i++) {
      matches.add(
        MatchData(
          id: generateMatchId(1, i + 1),
          data: {
            'tableNumber': i + 1,
            'published': true,
            'player1': {
              'id': generatePlayerId(i * 2),
              'name': 'テストプレイヤー${i * 2 + 1}',
              'matchingPoints': 0,
            },
            'player1UserId': generateUserId(i * 2),
            'player2': {
              'id': generatePlayerId(i * 2 + 1),
              'name': 'テストプレイヤー${i * 2 + 2}',
              'matchingPoints': 0,
            },
            'player2UserId': generateUserId(i * 2 + 1),
            'result': null, // 未入力
            'isByeMatch': false,
            'pointDifference': 0,
            'createdAt': generateTimestamp(),
          },
        ),
      );
    }

    // BYE マッチ（1 マッチ）
    matches.add(
      MatchData(
        id: generateMatchId(1, 5),
        data: {
          'tableNumber': 5,
          'published': true,
          'player1': {
            'id': generatePlayerId(8),
            'name': 'テストプレイヤー9',
            'matchingPoints': 0,
          },
          'player1UserId': generateUserId(8),
          'player2': null,
          'player2UserId': null,
          'result': {
            'type': 'BYE',
            'winnerId': generatePlayerId(8),
            'submittedAt': generateTimestamp(),
            'submittedBy': null,
            'submitterUserId': null,
          },
          'isByeMatch': true,
          'pointDifference': 0,
          'createdAt': generateTimestamp(),
        },
      ),
    );

    return matches;
  }
}
