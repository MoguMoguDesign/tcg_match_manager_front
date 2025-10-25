import '../models/tournament_data.dart';
import 'tournament_generator.dart';

/// 開催前トーナメント（プレイヤー登録受付中）のデータを生成する。
///
/// 詳細仕様: [player-firebase-test-data-spec.md] の「データセット 4」を参照。
class PreparingTournamentGenerator extends TournamentGenerator {
  @override
  String generateTournamentId() => 'test-tournament-preparing-001';

  @override
  TournamentData generate() {
    final tournamentId = generateTournamentId();

    // トーナメント情報
    final tournament = {
      'title': 'テスト大会（開催前）',
      'description': 'プレイヤー登録受付中',
      'category': 'テスト',
      'venue': 'テスト会場',
      'startDate': generateTimestamp(offsetDays: 1),
      'endDate': null,
      'drawPoints': 0,
      'maxRounds': null,
      'expectedPlayers': 32,
      'playerCount': 12,
      'status': 'PREPARING',
      'currentRound': 0,
      'adminUid': 'test-admin-uid-004',
      'createdAt': generateTimestamp(offsetDays: 0, offsetHours: -5),
      'updatedAt': generateTimestamp(),
    };

    // プレイヤー情報（12 人）
    final players = <PlayerData>[
      for (var i = 0; i < 12; i++)
        PlayerData(
          id: generatePlayerId(i),
          data: {
            'name': 'テストプレイヤー${i + 1}',
            'playerNumber': i + 1,
            'status': 'ACTIVE',
            'userId': generateUserId(i),
            'matchHistory': {
              'totalPoints': 0,
              'stairMatchCount': 0,
              'byeCount': 0,
              'opponents': <String>[],
              'matchResults': <Map<String, dynamic>>[],
            },
            'registeredAt':
                generateTimestamp(offsetDays: 0, offsetHours: -(5 - i ~/ 3)),
            'droppedAt': null,
          },
        ),
    ];

    // ラウンド情報（開催前なので空）
    final rounds = <RoundData>[];

    return TournamentData(
      tournamentId: tournamentId,
      tournament: tournament,
      players: players,
      rounds: rounds,
    );
  }
}
