import 'package:flutter_test/flutter_test.dart';
import 'package:repository/repository.dart';

void main() {
  group('CreateTournamentRequest のテスト', () {
    group('コンストラクタのテスト', () {
      test('正常にインスタンスを作成できる', () {
        const request = CreateTournamentRequest(
          title: 'テスト大会',
          description: 'テスト大会の説明',
          category: 'ポケモンカード',
          venue: 'テスト会場',
          startDate: '2025-10-01T10:00:00Z',
          endDate: '2025-10-01T18:00:00Z',
        );

        expect(request.title, 'テスト大会');
        expect(request.description, 'テスト大会の説明');
        expect(request.venue, 'テスト会場');
        expect(request.startDate, '2025-10-01T10:00:00Z');
        expect(request.endDate, '2025-10-01T18:00:00Z');
        expect(request.drawPoints, 0);
        expect(request.maxRounds, isNull);
        expect(request.expectedPlayers, isNull);
      });

      test('drawPoints のデフォルト値が 0 である', () {
        const request = CreateTournamentRequest(
          title: 'テスト大会',
          description: 'テスト大会の説明',
          category: 'ポケモンカード',
          venue: 'テスト会場',
          startDate: '2025-10-01T10:00:00Z',
          endDate: '2025-10-01T18:00:00Z',
        );

        expect(request.drawPoints, 0);
      });

      test('全てのフィールドを指定してインスタンスを作成できる', () {
        const request = CreateTournamentRequest(
          title: 'テスト大会',
          description: 'テスト大会の説明',
          category: 'ポケモンカード',
          venue: 'テスト会場',
          startDate: '2025-10-01T10:00:00Z',
          endDate: '2025-10-01T18:00:00Z',
          drawPoints: 1,
          maxRounds: 5,
          expectedPlayers: 32,
        );

        expect(request.title, 'テスト大会');
        expect(request.description, 'テスト大会の説明');
        expect(request.venue, 'テスト会場');
        expect(request.startDate, '2025-10-01T10:00:00Z');
        expect(request.endDate, '2025-10-01T18:00:00Z');
        expect(request.drawPoints, 1);
        expect(request.maxRounds, 5);
        expect(request.expectedPlayers, 32);
      });
    });

    group('fromJson のテスト', () {
      test('JSON から正常にインスタンスを生成できる', () {
        final json = {
          'name': 'テスト大会',
          'overview': 'テスト大会の説明',
          'category': 'ポケモンカード',
          'venue': 'テスト会場',
          'date': '2025-10-01T10:00:00Z',
          'endDate': '2025-10-01T18:00:00Z',
        };

        final request = CreateTournamentRequest.fromJson(json);

        expect(request.title, 'テスト大会');
        expect(request.description, 'テスト大会の説明');
        expect(request.category, 'ポケモンカード');
        expect(request.venue, 'テスト会場');
        expect(request.startDate, '2025-10-01T10:00:00Z');
        expect(request.endDate, '2025-10-01T18:00:00Z');
        expect(request.drawPoints, 0);
        expect(request.maxRounds, isNull);
        expect(request.expectedPlayers, isNull);
      });

      test('全てのフィールドを含む JSON から正常にインスタンスを生成できる', () {
        final json = {
          'name': 'テスト大会',
          'overview': 'テスト大会の説明',
          'category': 'ポケモンカード',
          'venue': 'テスト会場',
          'date': '2025-10-01T10:00:00Z',
          'endDate': '2025-10-01T18:00:00Z',
          'drawPoints': 1,
          'maxRound': 5,
          'expectedPlayers': 32,
        };

        final request = CreateTournamentRequest.fromJson(json);

        expect(request.title, 'テスト大会');
        expect(request.description, 'テスト大会の説明');
        expect(request.category, 'ポケモンカード');
        expect(request.venue, 'テスト会場');
        expect(request.startDate, '2025-10-01T10:00:00Z');
        expect(request.endDate, '2025-10-01T18:00:00Z');
        expect(request.drawPoints, 1);
        expect(request.maxRounds, 5);
        expect(request.expectedPlayers, 32);
      });
    });

    group('toJson のテスト', () {
      test('JSON に正常に変換できる', () {
        const request = CreateTournamentRequest(
          title: 'テスト大会',
          description: 'テスト大会の説明',
          category: 'ポケモンカード',
          venue: 'テスト会場',
          startDate: '2025-10-01T10:00:00Z',
          endDate: '2025-10-01T18:00:00Z',
        );

        final json = request.toJson();

        expect(json['name'], 'テスト大会');
        expect(json['overview'], 'テスト大会の説明');
        expect(json['category'], 'ポケモンカード');
        expect(json['venue'], 'テスト会場');
        expect(json['date'], '2025-10-01T10:00:00Z');
        expect(json['endDate'], '2025-10-01T18:00:00Z');
        expect(json['drawPoints'], 0);
      });

      test('全てのフィールドを含む JSON に正常に変換できる', () {
        const request = CreateTournamentRequest(
          title: 'テスト大会',
          description: 'テスト大会の説明',
          category: 'ポケモンカード',
          venue: 'テスト会場',
          startDate: '2025-10-01T10:00:00Z',
          endDate: '2025-10-01T18:00:00Z',
          drawPoints: 1,
          maxRounds: 5,
          expectedPlayers: 32,
        );

        final json = request.toJson();

        expect(json['name'], 'テスト大会');
        expect(json['overview'], 'テスト大会の説明');
        expect(json['category'], 'ポケモンカード');
        expect(json['venue'], 'テスト会場');
        expect(json['date'], '2025-10-01T10:00:00Z');
        expect(json['endDate'], '2025-10-01T18:00:00Z');
        expect(json['drawPoints'], 1);
        expect(json['maxRound'], 5);
        expect(json['expectedPlayers'], 32);
      });
    });

    group('copyWith のテスト', () {
      test('title のみを更新できる', () {
        const request = CreateTournamentRequest(
          title: 'テスト大会',
          description: 'テスト大会の説明',
          category: 'ポケモンカード',
          venue: 'テスト会場',
          startDate: '2025-10-01T10:00:00Z',
          endDate: '2025-10-01T18:00:00Z',
        );

        final updated = request.copyWith(title: '新しいタイトル');

        expect(updated.title, '新しいタイトル');
        expect(updated.description, 'テスト大会の説明');
        expect(updated.venue, 'テスト会場');
        expect(updated.startDate, '2025-10-01T10:00:00Z');
        expect(updated.endDate, '2025-10-01T18:00:00Z');
      });

      test('description のみを更新できる', () {
        const request = CreateTournamentRequest(
          title: 'テスト大会',
          description: 'テスト大会の説明',
          category: 'ポケモンカード',
          venue: 'テスト会場',
          startDate: '2025-10-01T10:00:00Z',
          endDate: '2025-10-01T18:00:00Z',
        );

        final updated = request.copyWith(description: '新しい説明');

        expect(updated.title, 'テスト大会');
        expect(updated.description, '新しい説明');
        expect(updated.venue, 'テスト会場');
      });

      test('venue のみを更新できる', () {
        const request = CreateTournamentRequest(
          title: 'テスト大会',
          description: 'テスト大会の説明',
          category: 'ポケモンカード',
          venue: 'テスト会場',
          startDate: '2025-10-01T10:00:00Z',
          endDate: '2025-10-01T18:00:00Z',
        );

        final updated = request.copyWith(venue: '新しい会場');

        expect(updated.title, 'テスト大会');
        expect(updated.description, 'テスト大会の説明');
        expect(updated.venue, '新しい会場');
      });

      test('startDate のみを更新できる', () {
        const request = CreateTournamentRequest(
          title: 'テスト大会',
          description: 'テスト大会の説明',
          category: 'ポケモンカード',
          venue: 'テスト会場',
          startDate: '2025-10-01T10:00:00Z',
          endDate: '2025-10-01T18:00:00Z',
        );

        final updated = request.copyWith(startDate: '2025-10-02T10:00:00Z');

        expect(updated.startDate, '2025-10-02T10:00:00Z');
        expect(updated.endDate, '2025-10-01T18:00:00Z');
      });

      test('endDate のみを更新できる', () {
        const request = CreateTournamentRequest(
          title: 'テスト大会',
          description: 'テスト大会の説明',
          category: 'ポケモンカード',
          venue: 'テスト会場',
          startDate: '2025-10-01T10:00:00Z',
          endDate: '2025-10-01T18:00:00Z',
        );

        final updated = request.copyWith(endDate: '2025-10-02T18:00:00Z');

        expect(updated.startDate, '2025-10-01T10:00:00Z');
        expect(updated.endDate, '2025-10-02T18:00:00Z');
      });

      test('drawPoints のみを更新できる', () {
        const request = CreateTournamentRequest(
          title: 'テスト大会',
          description: 'テスト大会の説明',
          category: 'ポケモンカード',
          venue: 'テスト会場',
          startDate: '2025-10-01T10:00:00Z',
          endDate: '2025-10-01T18:00:00Z',
        );

        final updated = request.copyWith(drawPoints: 1);

        expect(updated.drawPoints, 1);
        expect(updated.title, 'テスト大会');
      });

      test('maxRounds のみを更新できる', () {
        const request = CreateTournamentRequest(
          title: 'テスト大会',
          description: 'テスト大会の説明',
          category: 'ポケモンカード',
          venue: 'テスト会場',
          startDate: '2025-10-01T10:00:00Z',
          endDate: '2025-10-01T18:00:00Z',
        );

        final updated = request.copyWith(maxRounds: 5);

        expect(updated.maxRounds, 5);
        expect(updated.title, 'テスト大会');
      });

      test('expectedPlayers のみを更新できる', () {
        const request = CreateTournamentRequest(
          title: 'テスト大会',
          description: 'テスト大会の説明',
          category: 'ポケモンカード',
          venue: 'テスト会場',
          startDate: '2025-10-01T10:00:00Z',
          endDate: '2025-10-01T18:00:00Z',
        );

        final updated = request.copyWith(expectedPlayers: 32);

        expect(updated.expectedPlayers, 32);
        expect(updated.title, 'テスト大会');
      });

      test('複数のフィールドを同時に更新できる', () {
        const request = CreateTournamentRequest(
          title: 'テスト大会',
          description: 'テスト大会の説明',
          category: 'ポケモンカード',
          venue: 'テスト会場',
          startDate: '2025-10-01T10:00:00Z',
          endDate: '2025-10-01T18:00:00Z',
        );

        final updated = request.copyWith(
          title: '新しいタイトル',
          drawPoints: 1,
          maxRounds: 5,
        );

        expect(updated.title, '新しいタイトル');
        expect(updated.description, 'テスト大会の説明');
        expect(updated.drawPoints, 1);
        expect(updated.maxRounds, 5);
      });
    });

    group('equality のテスト', () {
      test('同じ値を持つインスタンスは等しい', () {
        const request1 = CreateTournamentRequest(
          title: 'テスト大会',
          description: 'テスト大会の説明',
          category: 'ポケモンカード',
          venue: 'テスト会場',
          startDate: '2025-10-01T10:00:00Z',
          endDate: '2025-10-01T18:00:00Z',
          drawPoints: 1,
          maxRounds: 5,
          expectedPlayers: 32,
        );

        const request2 = CreateTournamentRequest(
          title: 'テスト大会',
          description: 'テスト大会の説明',
          category: 'ポケモンカード',
          venue: 'テスト会場',
          startDate: '2025-10-01T10:00:00Z',
          endDate: '2025-10-01T18:00:00Z',
          drawPoints: 1,
          maxRounds: 5,
          expectedPlayers: 32,
        );

        expect(request1, equals(request2));
        expect(request1.hashCode, equals(request2.hashCode));
      });

      test('異なる値を持つインスタンスは等しくない', () {
        const request1 = CreateTournamentRequest(
          title: 'テスト大会',
          description: 'テスト大会の説明',
          category: 'ポケモンカード',
          venue: 'テスト会場',
          startDate: '2025-10-01T10:00:00Z',
          endDate: '2025-10-01T18:00:00Z',
        );

        const request2 = CreateTournamentRequest(
          title: '別の大会',
          description: 'テスト大会の説明',
          category: 'ポケモンカード',
          venue: 'テスト会場',
          startDate: '2025-10-01T10:00:00Z',
          endDate: '2025-10-01T18:00:00Z',
        );

        expect(request1, isNot(equals(request2)));
      });
    });
  });
}
