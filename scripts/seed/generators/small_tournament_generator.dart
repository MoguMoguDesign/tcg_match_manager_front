import '../models/tournament_data.dart';
import 'tournament_generator.dart';

/// 小規模トーナメント（8 人、開催中）のデータを生成する。
///
/// 詳細仕様: [player-firebase-test-data-spec.md] の「データセット 1」を参照。
class SmallTournamentGenerator extends TournamentGenerator {
  @override
  String generateTournamentId() => 'test-tournament-small-001';

  @override
  TournamentData generate() {
    final tournamentId = generateTournamentId();

    // トーナメント情報
    final tournament = {
      'title': 'テスト大会（小規模・開催中）',
      'description': '8 人参加、ラウンド 2 進行中',
      'category': 'テスト',
      'venue': 'テスト会場',
      'startDate': generateTimestamp(offsetDays: -1),
      'endDate': generateTimestamp(offsetDays: 0, offsetHours: 6),
      'drawPoints': 1,
      'maxRounds': 3,
      'expectedPlayers': 8,
      'playerCount': 8,
      'status': 'IN_PROGRESS',
      'currentRound': 2,
      'adminUid': 'test-admin-uid-001',
      'createdAt': generateTimestamp(offsetDays: -1, offsetHours: -1),
      'updatedAt': generateTimestamp(),
    };

    // プレイヤー情報（8 人）
    final players = <PlayerData>[
      for (var i = 0; i < 8; i++)
        PlayerData(
          id: generatePlayerId(i),
          data: {
            'name': 'テストプレイヤー${i + 1}',
            'playerNumber': i + 1,
            'status': 'ACTIVE',
            'userId': generateUserId(i),
            'matchHistory': _generateMatchHistory(i),
            'registeredAt':
                generateTimestamp(offsetDays: -1, offsetHours: -(8 - i)),
            'droppedAt': null,
          },
        ),
    ];

    // ラウンド情報
    final rounds = <RoundData>[
      // Round 1（完了済み）
      RoundData(
        id: generateRoundId(1),
        data: {
          'roundNumber': 1,
          'status': 'COMPLETED',
          'startedAt': generateTimestamp(offsetDays: -1),
          'completedAt': generateTimestamp(offsetDays: -1, offsetHours: 1),
          'generationSeed': 12345001,
        },
        matches: _generateRound1Matches(),
      ),
      // Round 2（進行中）
      RoundData(
        id: generateRoundId(2),
        data: {
          'roundNumber': 2,
          'status': 'IN_PROGRESS',
          'startedAt': generateTimestamp(),
          'completedAt': null,
          'generationSeed': 12345002,
        },
        matches: _generateRound2Matches(),
      ),
    ];

    return TournamentData(
      tournamentId: tournamentId,
      tournament: tournament,
      players: players,
      rounds: rounds,
    );
  }

  /// プレイヤーのマッチ履歴を生成する。
  Map<String, dynamic> _generateMatchHistory(int playerIndex) {
    // Round 1 の結果（偶数番号が勝利）
    final isWinner = playerIndex % 2 == 0;

    return {
      'totalPoints': isWinner ? 3 : 0,
      'stairMatchCount': 0,
      'byeCount': 0,
      'opponents': [
        generatePlayerId(playerIndex % 2 == 0 ? playerIndex + 1 : playerIndex - 1),
      ],
      'matchResults': [
        {
          'round': 1,
          'result': isWinner ? 'WIN' : 'LOSS',
          'points': isWinner ? 3 : 0,
        },
      ],
    };
  }

  /// Round 1 のマッチを生成する。
  List<MatchData> _generateRound1Matches() {
    return [
      for (var i = 0; i < 4; i++)
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
            'result': {
              'type': 'PLAYER1_WIN',
              'winnerId': generatePlayerId(i * 2),
              'submittedAt': generateTimestamp(offsetDays: -1, offsetHours: 1),
              'submittedBy': generatePlayerId(i * 2),
              'submitterUserId': generateUserId(i * 2),
            },
            'isByeMatch': false,
            'pointDifference': 0,
            'createdAt': generateTimestamp(offsetDays: -1),
          },
        ),
    ];
  }

  /// Round 2 のマッチを生成する。
  List<MatchData> _generateRound2Matches() {
    // 勝者同士、敗者同士のマッチング
    return [
      // Match 1: 勝者ブラケット（未入力）
      MatchData(
        id: generateMatchId(2, 1),
        data: {
          'tableNumber': 1,
          'published': true,
          'player1': {
            'id': generatePlayerId(0),
            'name': 'テストプレイヤー1',
            'matchingPoints': 3,
          },
          'player1UserId': generateUserId(0),
          'player2': {
            'id': generatePlayerId(2),
            'name': 'テストプレイヤー3',
            'matchingPoints': 3,
          },
          'player2UserId': generateUserId(2),
          'result': null, // 未入力
          'isByeMatch': false,
          'pointDifference': 0,
          'createdAt': generateTimestamp(),
        },
      ),
      // Match 2: 勝者ブラケット（結果入力済み）
      MatchData(
        id: generateMatchId(2, 2),
        data: {
          'tableNumber': 2,
          'published': true,
          'player1': {
            'id': generatePlayerId(4),
            'name': 'テストプレイヤー5',
            'matchingPoints': 3,
          },
          'player1UserId': generateUserId(4),
          'player2': {
            'id': generatePlayerId(6),
            'name': 'テストプレイヤー7',
            'matchingPoints': 3,
          },
          'player2UserId': generateUserId(6),
          'result': {
            'type': 'PLAYER1_WIN',
            'winnerId': generatePlayerId(4),
            'submittedAt': generateTimestamp(offsetHours: 1),
            'submittedBy': generatePlayerId(4),
            'submitterUserId': generateUserId(4),
          },
          'isByeMatch': false,
          'pointDifference': 0,
          'createdAt': generateTimestamp(),
        },
      ),
      // Match 3: 敗者ブラケット（引き分け）
      MatchData(
        id: generateMatchId(2, 3),
        data: {
          'tableNumber': 3,
          'published': true,
          'player1': {
            'id': generatePlayerId(1),
            'name': 'テストプレイヤー2',
            'matchingPoints': 0,
          },
          'player1UserId': generateUserId(1),
          'player2': {
            'id': generatePlayerId(3),
            'name': 'テストプレイヤー4',
            'matchingPoints': 0,
          },
          'player2UserId': generateUserId(3),
          'result': {
            'type': 'DRAW',
            'winnerId': null,
            'submittedAt': generateTimestamp(offsetHours: 1),
            'submittedBy': generatePlayerId(1),
            'submitterUserId': generateUserId(1),
          },
          'isByeMatch': false,
          'pointDifference': 0,
          'createdAt': generateTimestamp(),
        },
      ),
      // Match 4: 敗者ブラケット（未入力）
      MatchData(
        id: generateMatchId(2, 4),
        data: {
          'tableNumber': 4,
          'published': true,
          'player1': {
            'id': generatePlayerId(5),
            'name': 'テストプレイヤー6',
            'matchingPoints': 0,
          },
          'player1UserId': generateUserId(5),
          'player2': {
            'id': generatePlayerId(7),
            'name': 'テストプレイヤー8',
            'matchingPoints': 0,
          },
          'player2UserId': generateUserId(7),
          'result': null, // 未入力
          'isByeMatch': false,
          'pointDifference': 0,
          'createdAt': generateTimestamp(),
        },
      ),
    ];
  }
}
