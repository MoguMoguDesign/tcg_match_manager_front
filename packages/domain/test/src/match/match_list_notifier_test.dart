import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';

import 'match_list_notifier_test.mocks.dart';

// GetPublishedMatchesUseCase のモッククラスを生成する。
@GenerateNiceMocks([MockSpec<GetPublishedMatchesUseCase>()])
void main() {
  late MockGetPublishedMatchesUseCase mockGetPublishedMatchesUseCase;
  late ProviderContainer container;

  setUp(() {
    mockGetPublishedMatchesUseCase = MockGetPublishedMatchesUseCase();
    container = ProviderContainer(
      overrides: [
        getPublishedMatchesUseCaseProvider
            .overrideWithValue(mockGetPublishedMatchesUseCase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('matchListNotifierProvider のテスト。', () {
    test('matchListNotifierProvider が MatchListNotifier を返す。', () {
      expect(
        container.read(matchListNotifierProvider.notifier),
        isA<MatchListNotifier>(),
      );
    });
  });

  group('MatchListNotifier のテスト。', () {
    group('build メソッドのテスト。', () {
      test('初期状態では空のリストを返す。', () async {
        final state = container.read(matchListNotifierProvider);

        // 初期状態は空のリストである。
        expect(state, const AsyncValue<List<Match>>.data([]));
      });
    });

    group('fetchMatches メソッドのテスト。', () {
      test('マッチリストを正常に取得した場合、state に設定される。', () async {
        final testMatches = [
          Match(
            id: 'match1',
            tableNumber: 1,
            published: true,
            player1: MatchPlayer(
              id: 'player1',
              name: 'Player 1',
              matchingPoints: 0,
            ),
            player2: MatchPlayer(
              id: 'player2',
              name: 'Player 2',
              matchingPoints: 0,
            ),
            isByeMatch: false,
            result: null,
            isMine: true,
            meSide: 'player1',
          ),
          Match(
            id: 'match2',
            tableNumber: 2,
            published: true,
            player1: MatchPlayer(
              id: 'player3',
              name: 'Player 3',
              matchingPoints: 3,
            ),
            player2: MatchPlayer(
              id: 'player4',
              name: 'Player 4',
              matchingPoints: 3,
            ),
            isByeMatch: false,
            result: null,
            isMine: false,
            meSide: null,
          ),
        ];

        // UseCaseが正常にマッチリストを返すスタブを用意する。
        when(
          mockGetPublishedMatchesUseCase.invoke(
            baseUrl: anyNamed('baseUrl'),
            tournamentId: anyNamed('tournamentId'),
            roundId: anyNamed('roundId'),
            userId: anyNamed('userId'),
          ),
        ).thenAnswer((_) async => testMatches);

        final notifier = container.read(matchListNotifierProvider.notifier);

        // fetchMatches を実行する。
        await notifier.fetchMatches(
          baseUrl: 'https://example.com/',
          tournamentId: 'tournament-123',
          roundId: 'round-456',
          userId: 'user-001',
        );

        // state が更新されていることを確認する。
        final state = container.read(matchListNotifierProvider);

        expect(state, isA<AsyncData<List<Match>>>());
        state.when(
          data: (matches) {
            expect(matches, hasLength(2));
            expect(matches[0].id, 'match1');
            expect(matches[0].tableNumber, 1);
            expect(matches[0].isMine, true);
            expect(matches[1].id, 'match2');
            expect(matches[1].tableNumber, 2);
            expect(matches[1].isMine, false);
          },
          loading: () => fail('状態はloadingではない'),
          error: (_, __) => fail('状態はerrorではない'),
        );

        // UseCaseが正しい引数で呼び出されることを確認する。
        verify(
          mockGetPublishedMatchesUseCase.invoke(
            baseUrl: 'https://example.com/',
            tournamentId: 'tournament-123',
            roundId: 'round-456',
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
          mockGetPublishedMatchesUseCase.invoke(
            baseUrl: anyNamed('baseUrl'),
            tournamentId: anyNamed('tournamentId'),
            roundId: anyNamed('roundId'),
            userId: anyNamed('userId'),
          ),
        ).thenThrow(testException);

        final notifier = container.read(matchListNotifierProvider.notifier);

        // fetchMatches を実行する。
        await notifier.fetchMatches(
          baseUrl: 'https://example.com/',
          tournamentId: 'tournament-123',
          roundId: 'round-456',
          userId: 'user-001',
        );

        // state がerror状態になっていることを確認する。
        final state = container.read(matchListNotifierProvider);

        expect(state, isA<AsyncError<List<Match>>>());
        state.when(
          data: (_) => fail('状態はdataではない'),
          loading: () => fail('状態はloadingではない'),
          error: (error, _) {
            expect(error, testException);
          },
        );

        // UseCaseが呼び出されることを確認する。
        verify(
          mockGetPublishedMatchesUseCase.invoke(
            baseUrl: 'https://example.com/',
            tournamentId: 'tournament-123',
            roundId: 'round-456',
            userId: 'user-001',
          ),
        ).called(1);
      });
    });

    group('clearMatches メソッドのテスト。', () {
      test('マッチリストをクリアして空のリストに戻す。', () async {
        final testMatches = [
          Match(
            id: 'match1',
            tableNumber: 1,
            published: true,
            player1: MatchPlayer(
              id: 'player1',
              name: 'Player 1',
              matchingPoints: 0,
            ),
            player2: MatchPlayer(
              id: 'player2',
              name: 'Player 2',
              matchingPoints: 0,
            ),
            isByeMatch: false,
            result: null,
            isMine: false,
            meSide: null,
          ),
        ];

        // UseCaseが正常にマッチリストを返すスタブを用意する。
        when(
          mockGetPublishedMatchesUseCase.invoke(
            baseUrl: anyNamed('baseUrl'),
            tournamentId: anyNamed('tournamentId'),
            roundId: anyNamed('roundId'),
            userId: anyNamed('userId'),
          ),
        ).thenAnswer((_) async => testMatches);

        final notifier = container.read(matchListNotifierProvider.notifier);

        // まずマッチリストを取得する。
        await notifier.fetchMatches(
          baseUrl: 'https://example.com/',
          tournamentId: 'tournament-123',
          roundId: 'round-456',
          userId: 'user-001',
        );

        // マッチリストが取得されていることを確認する。
        var state = container.read(matchListNotifierProvider);
        expect(state, isA<AsyncData<List<Match>>>());
        state.whenData((matches) => expect(matches, hasLength(1)));

        // マッチリストをクリアする。
        notifier.clearMatches();

        // マッチリストが空になっていることを確認する。
        state = container.read(matchListNotifierProvider);
        expect(state, const AsyncValue<List<Match>>.data([]));
      });
    });
  });
}
