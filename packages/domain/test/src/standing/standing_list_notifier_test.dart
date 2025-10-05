import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';

import 'standing_list_notifier_test.mocks.dart';

// GetFinalStandingsUseCase のモッククラスを生成する。
@GenerateNiceMocks([MockSpec<GetFinalStandingsUseCase>()])
void main() {
  late MockGetFinalStandingsUseCase mockGetFinalStandingsUseCase;
  late ProviderContainer container;

  setUp(() {
    mockGetFinalStandingsUseCase = MockGetFinalStandingsUseCase();
    container = ProviderContainer(
      overrides: [
        getFinalStandingsUseCaseProvider
            .overrideWithValue(mockGetFinalStandingsUseCase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('standingListNotifierProvider のテスト。', () {
    test('standingListNotifierProvider が StandingListNotifier を返す。', () {
      expect(
        container.read(standingListNotifierProvider.notifier),
        isA<StandingListNotifier>(),
      );
    });
  });

  group('StandingListNotifier のテスト。', () {
    group('build メソッドのテスト。', () {
      test('初期状態では null を返す。', () async {
        final state = container.read(standingListNotifierProvider);

        // 初期状態は null である。
        expect(state, const AsyncValue<Standing?>.data(null));
      });
    });

    group('fetchStandings メソッドのテスト。', () {
      test('最終順位を正常に取得した場合、state に設定される。', () async {
        final testStanding = Standing(
          calculatedAt: '2025-10-05T15:00:00Z',
          rankings: [
            RankingDetail(
              rank: 1,
              playerName: 'Player A',
              matchPoints: 9,
              omwPercentage: 0.6667,
            ),
            RankingDetail(
              rank: 2,
              playerName: 'Player B',
              matchPoints: 6,
              omwPercentage: 0.5556,
            ),
            RankingDetail(
              rank: 3,
              playerName: 'Player C',
              matchPoints: 3,
              omwPercentage: 0.4444,
            ),
          ],
        );

        // UseCaseが正常に最終順位を返すスタブを用意する。
        when(
          mockGetFinalStandingsUseCase.invoke(
            baseUrl: anyNamed('baseUrl'),
            tournamentId: anyNamed('tournamentId'),
            userId: anyNamed('userId'),
          ),
        ).thenAnswer((_) async => testStanding);

        final notifier = container.read(standingListNotifierProvider.notifier);

        // fetchStandings を実行する。
        await notifier.fetchStandings(
          baseUrl: 'https://example.com/',
          tournamentId: 'tournament-123',
          userId: 'user-001',
        );

        // state が更新されていることを確認する。
        final state = container.read(standingListNotifierProvider);

        expect(state, isA<AsyncData<Standing?>>());
        state.when(
          data: (standing) {
            expect(standing, isNotNull);
            expect(standing!.calculatedAt, '2025-10-05T15:00:00Z');
            expect(standing.rankings, hasLength(3));
            expect(standing.rankings[0].rank, 1);
            expect(standing.rankings[0].playerName, 'Player A');
            expect(standing.rankings[1].rank, 2);
            expect(standing.rankings[1].playerName, 'Player B');
            expect(standing.rankings[2].rank, 3);
            expect(standing.rankings[2].playerName, 'Player C');
          },
          loading: () => fail('状態はloadingではない'),
          error: (_, __) => fail('状態はerrorではない'),
        );

        // UseCaseが正しい引数で呼び出されることを確認する。
        verify(
          mockGetFinalStandingsUseCase.invoke(
            baseUrl: 'https://example.com/',
            tournamentId: 'tournament-123',
            userId: 'user-001',
          ),
        ).called(1);
      });

      test('UseCaseで例外が発生した場合、error 状態になる。', () async {
        final testException = GeneralFailureException(
          reason: GeneralFailureReason.noConnectionError,
          errorCode: 'test',
        );

        // UseCaseが例外をスローするスタブを用意する。
        when(
          mockGetFinalStandingsUseCase.invoke(
            baseUrl: anyNamed('baseUrl'),
            tournamentId: anyNamed('tournamentId'),
            userId: anyNamed('userId'),
          ),
        ).thenThrow(testException);

        final notifier = container.read(standingListNotifierProvider.notifier);

        // fetchStandings を実行する。
        await notifier.fetchStandings(
          baseUrl: 'https://example.com/',
          tournamentId: 'tournament-123',
          userId: 'user-001',
        );

        // state がerror状態になっていることを確認する。
        final state = container.read(standingListNotifierProvider);

        expect(state, isA<AsyncError<Standing?>>());
        state.when(
          data: (_) => fail('状態はdataではない'),
          loading: () => fail('状態はloadingではない'),
          error: (error, _) {
            expect(error, testException);
          },
        );

        // UseCaseが呼び出されることを確認する。
        verify(
          mockGetFinalStandingsUseCase.invoke(
            baseUrl: 'https://example.com/',
            tournamentId: 'tournament-123',
            userId: 'user-001',
          ),
        ).called(1);
      });
    });

    group('clearStandings メソッドのテスト。', () {
      test('最終順位をクリアして null に戻す。', () async {
        final testStanding = Standing(
          calculatedAt: '2025-10-05T15:00:00Z',
          rankings: [
            RankingDetail(
              rank: 1,
              playerName: 'Player A',
              matchPoints: 9,
              omwPercentage: 0.6667,
            ),
          ],
        );

        // UseCaseが正常に最終順位を返すスタブを用意する。
        when(
          mockGetFinalStandingsUseCase.invoke(
            baseUrl: anyNamed('baseUrl'),
            tournamentId: anyNamed('tournamentId'),
            userId: anyNamed('userId'),
          ),
        ).thenAnswer((_) async => testStanding);

        final notifier = container.read(standingListNotifierProvider.notifier);

        // まず最終順位を取得する。
        await notifier.fetchStandings(
          baseUrl: 'https://example.com/',
          tournamentId: 'tournament-123',
          userId: 'user-001',
        );

        // 最終順位が取得されていることを確認する。
        var state = container.read(standingListNotifierProvider);
        expect(state, isA<AsyncData<Standing?>>());
        state.whenData((standing) => expect(standing, isNotNull));

        // 最終順位をクリアする。
        notifier.clearStandings();

        // 最終順位が null になっていることを確認する。
        state = container.read(standingListNotifierProvider);
        expect(state, const AsyncValue<Standing?>.data(null));
      });
    });
  });
}
