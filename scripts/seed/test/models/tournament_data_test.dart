import 'package:test/test.dart';

import '../../models/tournament_data.dart';

void main() {
  group('TournamentData のテスト。', () {
    group('validate メソッドのテスト。', () {
      test('正常なデータで検証が成功する。', () {
        final data = TournamentData(
          tournamentId: 'test-tournament-001',
          tournament: {
            'playerCount': 3,
            'currentRound': 2,
          },
          players: [
            PlayerData(id: 'player1', data: {}),
            PlayerData(id: 'player2', data: {}),
            PlayerData(id: 'player3', data: {}),
          ],
          rounds: [
            RoundData(id: 'round1', data: {}, matches: []),
            RoundData(id: 'round2', data: {}, matches: []),
          ],
        );

        final result = data.validate();

        expect(result.isValid, isTrue);
        expect(result.errors, isEmpty);
      });

      test('プレイヤー数が一致しない場合、検証エラーを返す。', () {
        final data = TournamentData(
          tournamentId: 'test-tournament-001',
          tournament: {
            'playerCount': 5, // 実際は 3 人
            'currentRound': 1,
          },
          players: [
            PlayerData(id: 'player1', data: {}),
            PlayerData(id: 'player2', data: {}),
            PlayerData(id: 'player3', data: {}),
          ],
          rounds: [
            RoundData(id: 'round1', data: {}, matches: []),
          ],
        );

        final result = data.validate();

        expect(result.isValid, isFalse);
        expect(result.errors.length, equals(1));
        expect(
          result.errors[0],
          contains('プレイヤー数が不一致'),
        );
      });

      test('ラウンド数が不整合の場合、検証エラーを返す。', () {
        final data = TournamentData(
          tournamentId: 'test-tournament-001',
          tournament: {
            'playerCount': 2,
            'currentRound': 5, // 実際は 2 ラウンドしかない
          },
          players: [
            PlayerData(id: 'player1', data: {}),
            PlayerData(id: 'player2', data: {}),
          ],
          rounds: [
            RoundData(id: 'round1', data: {}, matches: []),
            RoundData(id: 'round2', data: {}, matches: []),
          ],
        );

        final result = data.validate();

        expect(result.isValid, isFalse);
        expect(result.errors.length, equals(1));
        expect(
          result.errors[0],
          contains('ラウンド数が不一致'),
        );
      });

      test('複数の検証エラーがある場合、すべてのエラーを返す。', () {
        final data = TournamentData(
          tournamentId: 'test-tournament-001',
          tournament: {
            'playerCount': 10, // 実際は 2 人
            'currentRound': 5, // 実際は 1 ラウンド
          },
          players: [
            PlayerData(id: 'player1', data: {}),
            PlayerData(id: 'player2', data: {}),
          ],
          rounds: [
            RoundData(id: 'round1', data: {}, matches: []),
          ],
        );

        final result = data.validate();

        expect(result.isValid, isFalse);
        expect(result.errors.length, equals(2));
        expect(
          result.errors.any((e) => e.contains('プレイヤー数が不一致')),
          isTrue,
        );
        expect(
          result.errors.any((e) => e.contains('ラウンド数が不一致')),
          isTrue,
        );
      });

      test('playerCount が null の場合、検証をスキップする。', () {
        final data = TournamentData(
          tournamentId: 'test-tournament-001',
          tournament: {
            'currentRound': 1,
            // playerCount なし
          },
          players: [
            PlayerData(id: 'player1', data: {}),
            PlayerData(id: 'player2', data: {}),
          ],
          rounds: [
            RoundData(id: 'round1', data: {}, matches: []),
          ],
        );

        final result = data.validate();

        expect(result.isValid, isTrue);
        expect(result.errors, isEmpty);
      });

      test('currentRound が null の場合、検証をスキップする。', () {
        final data = TournamentData(
          tournamentId: 'test-tournament-001',
          tournament: {
            'playerCount': 2,
            // currentRound なし
          },
          players: [
            PlayerData(id: 'player1', data: {}),
            PlayerData(id: 'player2', data: {}),
          ],
          rounds: [
            RoundData(id: 'round1', data: {}, matches: []),
            RoundData(id: 'round2', data: {}, matches: []),
          ],
        );

        final result = data.validate();

        expect(result.isValid, isTrue);
        expect(result.errors, isEmpty);
      });

      test('currentRound がラウンド数と等しい場合、検証が成功する。', () {
        final data = TournamentData(
          tournamentId: 'test-tournament-001',
          tournament: {
            'playerCount': 2,
            'currentRound': 3, // rounds.length と同じ
          },
          players: [
            PlayerData(id: 'player1', data: {}),
            PlayerData(id: 'player2', data: {}),
          ],
          rounds: [
            RoundData(id: 'round1', data: {}, matches: []),
            RoundData(id: 'round2', data: {}, matches: []),
            RoundData(id: 'round3', data: {}, matches: []),
          ],
        );

        final result = data.validate();

        expect(result.isValid, isTrue);
        expect(result.errors, isEmpty);
      });

      test('空のプレイヤーリストで検証が成功する（準備中トーナメント）。', () {
        final data = TournamentData(
          tournamentId: 'test-tournament-001',
          tournament: {
            'playerCount': 0,
            'currentRound': 0,
          },
          players: [],
          rounds: [],
        );

        final result = data.validate();

        expect(result.isValid, isTrue);
        expect(result.errors, isEmpty);
      });
    });
  });

  group('PlayerData のテスト。', () {
    test('正常に作成できる。', () {
      final playerData = PlayerData(
        id: 'test-player-001',
        data: {'name': 'テストプレイヤー'},
      );

      expect(playerData.id, equals('test-player-001'));
      expect(playerData.data['name'], equals('テストプレイヤー'));
    });
  });

  group('RoundData のテスト。', () {
    test('正常に作成できる。', () {
      final roundData = RoundData(
        id: 'round1',
        data: {'roundNumber': 1},
        matches: [
          MatchData(id: 'match1', data: {}),
        ],
      );

      expect(roundData.id, equals('round1'));
      expect(roundData.data['roundNumber'], equals(1));
      expect(roundData.matches.length, equals(1));
    });
  });

  group('MatchData のテスト。', () {
    test('正常に作成できる。', () {
      final matchData = MatchData(
        id: 'match1',
        data: {'tableNumber': 1},
      );

      expect(matchData.id, equals('match1'));
      expect(matchData.data['tableNumber'], equals(1));
    });
  });

  group('ValidationResult のテスト。', () {
    test('検証成功の場合、isValid が true になる。', () {
      final result = ValidationResult(isValid: true, errors: []);

      expect(result.isValid, isTrue);
      expect(result.errors, isEmpty);
    });

    test('検証失敗の場合、isValid が false でエラーが含まれる。', () {
      final result = ValidationResult(
        isValid: false,
        errors: ['エラー1', 'エラー2'],
      );

      expect(result.isValid, isFalse);
      expect(result.errors.length, equals(2));
      expect(result.errors[0], equals('エラー1'));
      expect(result.errors[1], equals('エラー2'));
    });
  });
}
