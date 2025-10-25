import 'package:test/test.dart';

import '../../generators/dataset_factory.dart';
import '../../models/tournament_data.dart';

void main() {
  group('DatasetFactory のテスト。', () {
    late DatasetFactory factory;

    setUp(() {
      factory = DatasetFactory();
    });

    group('generate メソッドのテスト。', () {
      test('small データセットで SmallTournamentGenerator のデータを生成する。', () {
        final result = factory.generate('small');

        expect(result, isA<TournamentData>());
        expect(result.tournamentId, equals('test-tournament-small-001'));
        expect(result.players.length, equals(8));
        expect(result.rounds.length, equals(2));
      });

      test('bye データセットで ByeTournamentGenerator のデータを生成する。', () {
        final result = factory.generate('bye');

        expect(result, isA<TournamentData>());
        expect(result.tournamentId, equals('test-tournament-bye-001'));
        expect(result.players.length, equals(9));
      });

      test('completed データセットで CompletedTournamentGenerator のデータを生成する。',
          () {
        final result = factory.generate('completed');

        expect(result, isA<TournamentData>());
        expect(result.tournamentId, equals('test-tournament-completed-001'));
        expect(result.players.length, equals(8));
        expect(result.tournament['status'], equals('COMPLETED'));
      });

      test('preparing データセットで PreparingTournamentGenerator のデータを生成する。',
          () {
        final result = factory.generate('preparing');

        expect(result, isA<TournamentData>());
        expect(result.tournamentId, equals('test-tournament-preparing-001'));
        expect(result.tournament['status'], equals('PREPARING'));
      });

      test('無効なデータセット ID で ArgumentError をスローする。', () {
        expect(
          () => factory.generate('invalid'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('空文字列で ArgumentError をスローする。', () {
        expect(
          () => factory.generate(''),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('_createGenerator メソッドの動作確認テスト。', () {
      test('生成されたデータが検証をパスする。', () {
        // すべてのデータセットで検証が成功することを確認する。
        const datasetIds = ['small', 'bye', 'completed', 'preparing'];

        for (final datasetId in datasetIds) {
          final data = factory.generate(datasetId);
          final validation = data.validate();

          expect(
            validation.isValid,
            isTrue,
            reason: 'データセット $datasetId の検証が失敗: ${validation.errors}',
          );
        }
      });

      test('生成されたデータのトーナメント ID がユニークである。', () {
        const datasetIds = ['small', 'bye', 'completed', 'preparing'];
        final tournamentIds = <String>{};

        for (final datasetId in datasetIds) {
          final data = factory.generate(datasetId);
          tournamentIds.add(data.tournamentId);
        }

        expect(
          tournamentIds.length,
          equals(datasetIds.length),
          reason: 'トーナメント ID が重複しています',
        );
      });
    });
  });
}
