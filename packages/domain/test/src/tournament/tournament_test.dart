import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repository/repository.dart';

void main() {
  group('Tournament のテスト。', () {
    group('fromModel メソッドのテスト。', () {
      test('TournamentModel から Tournament に変換できる。', () {
        const model = TournamentModel(
          id: 't_1',
          title: 'テストトーナメント',
          description: 'テスト説明',
          category: 'TCG',
          venue: 'テスト会場',
          startDate: '2024-01-01T00:00:00Z',
          endDate: '2024-01-31T23:59:59Z',
          drawPoints: 1,
          maxRounds: 5,
          expectedPlayers: 32,
          createdAt: '2024-01-01T00:00:00Z',
          updatedAt: '2024-01-01T00:00:00Z',
        );

        final tournament = Tournament.fromModel(model);

        expect(tournament.id, model.id);
        expect(tournament.title, model.title);
        expect(tournament.description, model.description);
        expect(tournament.category, model.category);
        expect(tournament.venue, model.venue);
        expect(tournament.startDate, model.startDate);
        expect(tournament.endDate, model.endDate);
        expect(tournament.drawPoints, model.drawPoints);
        expect(tournament.maxRounds, model.maxRounds);
        expect(tournament.expectedPlayers, model.expectedPlayers);
        expect(tournament.status, model.status);
        expect(tournament.currentRound, model.currentRound);
        expect(tournament.createdAt, model.createdAt);
        expect(tournament.updatedAt, model.updatedAt);
      });
    });

    group('calculateRecommendedRounds メソッドのテスト。', () {
      test('expectedPlayers が null の場合、1 を返す。', () {
        const tournament = Tournament(
          id: 't_1',
          title: 'テストトーナメント',
          expectedPlayers: null,
          createdAt: '2024-01-01T00:00:00Z',
          updatedAt: '2024-01-01T00:00:00Z',
        );

        expect(tournament.calculateRecommendedRounds(), 1);
      });

      test('expectedPlayers が 0 の場合、1 を返す。', () {
        const tournament = Tournament(
          id: 't_1',
          title: 'テストトーナメント',
          expectedPlayers: 0,
          createdAt: '2024-01-01T00:00:00Z',
          updatedAt: '2024-01-01T00:00:00Z',
        );

        expect(tournament.calculateRecommendedRounds(), 1);
      });

      test('expectedPlayers が 8 の場合、3 を返す。', () {
        const tournament = Tournament(
          id: 't_1',
          title: 'テストトーナメント',
          expectedPlayers: 8,
          createdAt: '2024-01-01T00:00:00Z',
          updatedAt: '2024-01-01T00:00:00Z',
        );

        expect(tournament.calculateRecommendedRounds(), 3);
      });

      test('expectedPlayers が 16 の場合、4 を返す。', () {
        const tournament = Tournament(
          id: 't_1',
          title: 'テストトーナメント',
          expectedPlayers: 16,
          createdAt: '2024-01-01T00:00:00Z',
          updatedAt: '2024-01-01T00:00:00Z',
        );

        expect(tournament.calculateRecommendedRounds(), 4);
      });

      test('expectedPlayers が 32 の場合、5 を返す。', () {
        const tournament = Tournament(
          id: 't_1',
          title: 'テストトーナメント',
          expectedPlayers: 32,
          createdAt: '2024-01-01T00:00:00Z',
          updatedAt: '2024-01-01T00:00:00Z',
        );

        expect(tournament.calculateRecommendedRounds(), 5);
      });
    });

    group('isPreparing のテスト。', () {
      test('status が PREPARING の場合、true を返す。', () {
        const tournament = Tournament(
          id: 't_1',
          title: 'テストトーナメント',
          createdAt: '2024-01-01T00:00:00Z',
          updatedAt: '2024-01-01T00:00:00Z',
        );

        expect(tournament.isPreparing, true);
      });

      test('status が PREPARING 以外の場合、false を返す。', () {
        const tournament = Tournament(
          id: 't_1',
          title: 'テストトーナメント',
          status: 'IN_PROGRESS',
          createdAt: '2024-01-01T00:00:00Z',
          updatedAt: '2024-01-01T00:00:00Z',
        );

        expect(tournament.isPreparing, false);
      });
    });

    group('isStarted のテスト。', () {
      test('status が IN_PROGRESS の場合、true を返す。', () {
        const tournament = Tournament(
          id: 't_1',
          title: 'テストトーナメント',
          status: 'IN_PROGRESS',
          createdAt: '2024-01-01T00:00:00Z',
          updatedAt: '2024-01-01T00:00:00Z',
        );

        expect(tournament.isStarted, true);
      });

      test('status が IN_PROGRESS 以外の場合、false を返す。', () {
        const tournament = Tournament(
          id: 't_1',
          title: 'テストトーナメント',
          createdAt: '2024-01-01T00:00:00Z',
          updatedAt: '2024-01-01T00:00:00Z',
        );

        expect(tournament.isStarted, false);
      });
    });

    group('isCompleted のテスト。', () {
      test('status が COMPLETED の場合、true を返す。', () {
        const tournament = Tournament(
          id: 't_1',
          title: 'テストトーナメント',
          status: 'COMPLETED',
          createdAt: '2024-01-01T00:00:00Z',
          updatedAt: '2024-01-01T00:00:00Z',
        );

        expect(tournament.isCompleted, true);
      });

      test('status が COMPLETED 以外の場合、false を返す。', () {
        const tournament = Tournament(
          id: 't_1',
          title: 'テストトーナメント',
          createdAt: '2024-01-01T00:00:00Z',
          updatedAt: '2024-01-01T00:00:00Z',
        );

        expect(tournament.isCompleted, false);
      });
    });
  });
}
