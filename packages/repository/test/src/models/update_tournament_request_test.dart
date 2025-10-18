import 'package:flutter_test/flutter_test.dart';
import 'package:repository/repository.dart';

void main() {
  group('UpdateTournamentRequest のテスト', () {
    group('コンストラクタのテスト', () {
      test('デフォルトコンストラクタで全てのフィールドがnullのインスタンスを作成できる', () {
        const request = UpdateTournamentRequest();

        expect(request.name, isNull);
        expect(request.overview, isNull);
        expect(request.category, isNull);
        expect(request.date, isNull);
        expect(request.remarks, isNull);
      });

      test('デフォルトコンストラクタで一部のフィールドを指定してインスタンスを作成できる', () {
        const request = UpdateTournamentRequest(
          name: 'テスト大会',
          date: '2025-10-01T10:00:00Z',
        );

        expect(request.name, 'テスト大会');
        expect(request.overview, isNull);
        expect(request.category, isNull);
        expect(request.date, '2025-10-01T10:00:00Z');
        expect(request.remarks, isNull);
      });

      test('fullコンストラクタで全てのフィールドを指定してインスタンスを作成できる', () {
        const request = UpdateTournamentRequest.full(
          name: 'テスト大会',
          overview: 'テスト大会の概要',
          category: 'テストカテゴリ',
          date: '2025-10-01T10:00:00Z',
          remarks: '備考',
        );

        expect(request.name, 'テスト大会');
        expect(request.overview, 'テスト大会の概要');
        expect(request.category, 'テストカテゴリ');
        expect(request.date, '2025-10-01T10:00:00Z');
        expect(request.remarks, '備考');
      });
    });

    group('hasUpdates のテスト', () {
      test('全てのフィールドがnullの場合、falseを返す', () {
        const request = UpdateTournamentRequest();

        expect(request.hasUpdates, isFalse);
      });

      test('name だけが指定されている場合、trueを返す', () {
        const request = UpdateTournamentRequest(name: 'テスト大会');

        expect(request.hasUpdates, isTrue);
      });

      test('overview だけが指定されている場合、trueを返す', () {
        const request = UpdateTournamentRequest(overview: 'テスト概要');

        expect(request.hasUpdates, isTrue);
      });

      test('category だけが指定されている場合、trueを返す', () {
        const request = UpdateTournamentRequest(category: 'カテゴリ');

        expect(request.hasUpdates, isTrue);
      });

      test('date だけが指定されている場合、trueを返す', () {
        const request = UpdateTournamentRequest(date: '2025-10-01T10:00:00Z');

        expect(request.hasUpdates, isTrue);
      });

      test('remarks だけが指定されている場合、trueを返す', () {
        const request = UpdateTournamentRequest(remarks: '備考');

        expect(request.hasUpdates, isTrue);
      });

      test('複数のフィールドが指定されている場合、trueを返す', () {
        const request = UpdateTournamentRequest(
          name: 'テスト大会',
          date: '2025-10-01T10:00:00Z',
        );

        expect(request.hasUpdates, isTrue);
      });
    });

    group('toJson のテスト', () {
      test('全てのフィールドがnullの場合、空のMapを返す', () {
        const request = UpdateTournamentRequest();

        final json = request.toJson();

        expect(json, isEmpty);
      });

      test('name だけが指定されている場合、nameのみを含むMapを返す', () {
        const request = UpdateTournamentRequest(name: 'テスト大会');

        final json = request.toJson();

        expect(json, {'name': 'テスト大会'});
      });

      test('overview だけが指定されている場合、overviewのみを含むMapを返す', () {
        const request = UpdateTournamentRequest(overview: 'テスト概要');

        final json = request.toJson();

        expect(json, {'overview': 'テスト概要'});
      });

      test('category だけが指定されている場合、categoryのみを含むMapを返す', () {
        const request = UpdateTournamentRequest(category: 'カテゴリ');

        final json = request.toJson();

        expect(json, {'category': 'カテゴリ'});
      });

      test('date だけが指定されている場合、dateのみを含むMapを返す', () {
        const request = UpdateTournamentRequest(date: '2025-10-01T10:00:00Z');

        final json = request.toJson();

        expect(json, {'date': '2025-10-01T10:00:00Z'});
      });

      test('remarks だけが指定されている場合、remarksのみを含むMapを返す', () {
        const request = UpdateTournamentRequest(remarks: '備考');

        final json = request.toJson();

        expect(json, {'remarks': '備考'});
      });

      test('複数のフィールドが指定されている場合、指定されたフィールドのみを含むMapを返す', () {
        const request = UpdateTournamentRequest(
          name: 'テスト大会',
          date: '2025-10-01T10:00:00Z',
        );

        final json = request.toJson();

        expect(json, {'name': 'テスト大会', 'date': '2025-10-01T10:00:00Z'});
      });

      test('全てのフィールドが指定されている場合、全てのフィールドを含むMapを返す', () {
        const request = UpdateTournamentRequest.full(
          name: 'テスト大会',
          overview: 'テスト大会の概要',
          category: 'テストカテゴリ',
          date: '2025-10-01T10:00:00Z',
          remarks: '備考',
        );

        final json = request.toJson();

        expect(json, {
          'name': 'テスト大会',
          'overview': 'テスト大会の概要',
          'category': 'テストカテゴリ',
          'date': '2025-10-01T10:00:00Z',
          'remarks': '備考',
        });
      });
    });
  });
}
