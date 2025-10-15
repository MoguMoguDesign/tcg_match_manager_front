import 'package:flutter_test/flutter_test.dart';
import 'package:repository/repository.dart';

void main() {
  group('TournamentModel のテスト', () {
    group('コンストラクタのテスト', () {
      test('必須フィールドのみでインスタンスを作成できる', () {
        final model = TournamentModel(
          id: 'tournament-123',
          title: 'テスト大会',
          createdAt: '2025-10-01T10:00:00Z',
          updatedAt: '2025-10-01T10:00:00Z',
        );

        expect(model.id, 'tournament-123');
        expect(model.title, 'テスト大会');
        expect(model.description, isNull);
        expect(model.category, isNull);
        expect(model.venue, isNull);
        expect(model.startDate, isNull);
        expect(model.endDate, isNull);
        expect(model.drawPoints, 0);
        expect(model.maxRounds, isNull);
        expect(model.expectedPlayers, isNull);
        expect(model.status, 'PREPARING');
        expect(model.currentRound, 0);
        expect(model.scheduleMode, isNull);
        expect(model.playerCount, isNull);
        expect(model.adminUid, isNull);
        expect(model.createdAt, '2025-10-01T10:00:00Z');
        expect(model.updatedAt, '2025-10-01T10:00:00Z');
      });

      test('全てのフィールドを指定してインスタンスを作成できる', () {
        final model = TournamentModel(
          id: 'tournament-123',
          title: 'テスト大会',
          description: 'テスト大会の説明',
          category: 'テストカテゴリ',
          venue: 'テスト会場',
          startDate: '2025-10-01T10:00:00Z',
          endDate: '2025-10-01T18:00:00Z',
          drawPoints: 1,
          maxRounds: 5,
          expectedPlayers: 32,
          status: 'IN_PROGRESS',
          currentRound: 2,
          scheduleMode: 'SWISS',
          playerCount: 30,
          adminUid: 'admin-uid-123',
          createdAt: '2025-10-01T09:00:00Z',
          updatedAt: '2025-10-01T11:00:00Z',
        );

        expect(model.id, 'tournament-123');
        expect(model.title, 'テスト大会');
        expect(model.description, 'テスト大会の説明');
        expect(model.category, 'テストカテゴリ');
        expect(model.venue, 'テスト会場');
        expect(model.startDate, '2025-10-01T10:00:00Z');
        expect(model.endDate, '2025-10-01T18:00:00Z');
        expect(model.drawPoints, 1);
        expect(model.maxRounds, 5);
        expect(model.expectedPlayers, 32);
        expect(model.status, 'IN_PROGRESS');
        expect(model.currentRound, 2);
        expect(model.scheduleMode, 'SWISS');
        expect(model.playerCount, 30);
        expect(model.adminUid, 'admin-uid-123');
        expect(model.createdAt, '2025-10-01T09:00:00Z');
        expect(model.updatedAt, '2025-10-01T11:00:00Z');
      });
    });

    group('fromJson のテスト', () {
      test('必須フィールドのみのJSONから正常にインスタンスを生成できる', () {
        final json = {
          'id': 'tournament-123',
          'name': 'テスト大会',
          'createdAt': '2025-10-01T10:00:00Z',
          'updatedAt': '2025-10-01T10:00:00Z',
        };

        final model = TournamentModel.fromJson(json);

        expect(model.id, 'tournament-123');
        expect(model.title, 'テスト大会');
        expect(model.description, isNull);
        expect(model.drawPoints, 0);
        expect(model.status, 'PREPARING');
        expect(model.currentRound, 0);
      });

      test('全てのフィールドを含むJSONから正常にインスタンスを生成できる', () {
        final json = {
          'id': 'tournament-123',
          'name': 'テスト大会',
          'overview': 'テスト大会の説明',
          'category': 'テストカテゴリ',
          'venue': 'テスト会場',
          'date': '2025-10-01T10:00:00Z',
          'endDate': '2025-10-01T18:00:00Z',
          'drawPoints': 1,
          'maxRound': 5,
          'expectedPlayers': 32,
          'status': 'IN_PROGRESS',
          'currentRound': 2,
          'scheduleMode': 'SWISS',
          'playerCount': 30,
          'adminUid': 'admin-uid-123',
          'createdAt': '2025-10-01T09:00:00Z',
          'updatedAt': '2025-10-01T11:00:00Z',
        };

        final model = TournamentModel.fromJson(json);

        expect(model.id, 'tournament-123');
        expect(model.title, 'テスト大会');
        expect(model.description, 'テスト大会の説明');
        expect(model.category, 'テストカテゴリ');
        expect(model.venue, 'テスト会場');
        expect(model.startDate, '2025-10-01T10:00:00Z');
        expect(model.endDate, '2025-10-01T18:00:00Z');
        expect(model.drawPoints, 1);
        expect(model.maxRounds, 5);
        expect(model.expectedPlayers, 32);
        expect(model.status, 'IN_PROGRESS');
        expect(model.currentRound, 2);
        expect(model.scheduleMode, 'SWISS');
        expect(model.playerCount, 30);
        expect(model.adminUid, 'admin-uid-123');
        expect(model.createdAt, '2025-10-01T09:00:00Z');
        expect(model.updatedAt, '2025-10-01T11:00:00Z');
      });
    });

    group('toJson のテスト', () {
      test('必須フィールドのみのインスタンスをJSONに変換できる', () {
        final model = TournamentModel(
          id: 'tournament-123',
          title: 'テスト大会',
          createdAt: '2025-10-01T10:00:00Z',
          updatedAt: '2025-10-01T10:00:00Z',
        );

        final json = model.toJson();

        expect(json['id'], 'tournament-123');
        expect(json['name'], 'テスト大会');
        expect(json['drawPoints'], 0);
        expect(json['status'], 'PREPARING');
        expect(json['currentRound'], 0);
        expect(json['createdAt'], '2025-10-01T10:00:00Z');
        expect(json['updatedAt'], '2025-10-01T10:00:00Z');
      });

      test('全てのフィールドを持つインスタンスをJSONに変換できる', () {
        final model = TournamentModel(
          id: 'tournament-123',
          title: 'テスト大会',
          description: 'テスト大会の説明',
          category: 'テストカテゴリ',
          venue: 'テスト会場',
          startDate: '2025-10-01T10:00:00Z',
          endDate: '2025-10-01T18:00:00Z',
          drawPoints: 1,
          maxRounds: 5,
          expectedPlayers: 32,
          status: 'IN_PROGRESS',
          currentRound: 2,
          scheduleMode: 'SWISS',
          playerCount: 30,
          adminUid: 'admin-uid-123',
          createdAt: '2025-10-01T09:00:00Z',
          updatedAt: '2025-10-01T11:00:00Z',
        );

        final json = model.toJson();

        expect(json['id'], 'tournament-123');
        expect(json['name'], 'テスト大会');
        expect(json['overview'], 'テスト大会の説明');
        expect(json['category'], 'テストカテゴリ');
        expect(json['venue'], 'テスト会場');
        expect(json['date'], '2025-10-01T10:00:00Z');
        expect(json['endDate'], '2025-10-01T18:00:00Z');
        expect(json['drawPoints'], 1);
        expect(json['maxRound'], 5);
        expect(json['expectedPlayers'], 32);
        expect(json['status'], 'IN_PROGRESS');
        expect(json['currentRound'], 2);
        expect(json['scheduleMode'], 'SWISS');
        expect(json['playerCount'], 30);
        expect(json['adminUid'], 'admin-uid-123');
        expect(json['createdAt'], '2025-10-01T09:00:00Z');
        expect(json['updatedAt'], '2025-10-01T11:00:00Z');
      });
    });

    group('copyWith のテスト', () {
      test('id を更新できる', () {
        final model = TournamentModel(
          id: 'tournament-123',
          title: 'テスト大会',
          createdAt: '2025-10-01T10:00:00Z',
          updatedAt: '2025-10-01T10:00:00Z',
        );

        final updated = model.copyWith(id: 'tournament-456');

        expect(updated.id, 'tournament-456');
        expect(updated.title, 'テスト大会');
      });

      test('title を更新できる', () {
        final model = TournamentModel(
          id: 'tournament-123',
          title: 'テスト大会',
          createdAt: '2025-10-01T10:00:00Z',
          updatedAt: '2025-10-01T10:00:00Z',
        );

        final updated = model.copyWith(title: '新しいタイトル');

        expect(updated.id, 'tournament-123');
        expect(updated.title, '新しいタイトル');
      });

      test('複数のフィールドを同時に更新できる', () {
        final model = TournamentModel(
          id: 'tournament-123',
          title: 'テスト大会',
          createdAt: '2025-10-01T10:00:00Z',
          updatedAt: '2025-10-01T10:00:00Z',
        );

        final updated = model.copyWith(
          title: '新しいタイトル',
          description: '新しい説明',
          drawPoints: 1,
        );

        expect(updated.id, 'tournament-123');
        expect(updated.title, '新しいタイトル');
        expect(updated.description, '新しい説明');
        expect(updated.drawPoints, 1);
      });
    });

    group('equality のテスト', () {
      test('同じ値を持つインスタンスは等しい', () {
        final model1 = TournamentModel(
          id: 'tournament-123',
          title: 'テスト大会',
          description: 'テスト大会の説明',
          drawPoints: 1,
          createdAt: '2025-10-01T10:00:00Z',
          updatedAt: '2025-10-01T10:00:00Z',
        );

        final model2 = TournamentModel(
          id: 'tournament-123',
          title: 'テスト大会',
          description: 'テスト大会の説明',
          drawPoints: 1,
          createdAt: '2025-10-01T10:00:00Z',
          updatedAt: '2025-10-01T10:00:00Z',
        );

        expect(model1, equals(model2));
        expect(model1.hashCode, equals(model2.hashCode));
      });

      test('異なる値を持つインスタンスは等しくない', () {
        final model1 = TournamentModel(
          id: 'tournament-123',
          title: 'テスト大会',
          createdAt: '2025-10-01T10:00:00Z',
          updatedAt: '2025-10-01T10:00:00Z',
        );

        final model2 = TournamentModel(
          id: 'tournament-456',
          title: 'テスト大会',
          createdAt: '2025-10-01T10:00:00Z',
          updatedAt: '2025-10-01T10:00:00Z',
        );

        expect(model1, isNot(equals(model2)));
      });
    });
  });
}
