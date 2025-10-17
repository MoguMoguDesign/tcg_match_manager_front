import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';

import 'tournament_list_notifier_test.mocks.dart';

// GetTournamentsUseCase のモッククラスを生成する。
@GenerateNiceMocks([MockSpec<GetTournamentsUseCase>()])
void main() {
  late MockGetTournamentsUseCase mockGetTournamentsUseCase;
  late ProviderContainer container;

  setUp(() {
    mockGetTournamentsUseCase = MockGetTournamentsUseCase();
    container = ProviderContainer(
      overrides: [
        getTournamentsUseCaseProvider.overrideWithValue(
          mockGetTournamentsUseCase,
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('tournamentListNotifierProvider のテスト。', () {
    test('tournamentListNotifierProvider が TournamentListNotifier を返す。', () {
      expect(
        container.read(tournamentListNotifierProvider.notifier),
        isA<TournamentListNotifier>(),
      );
    });
  });

  group('TournamentListNotifier のテスト。', () {
    group('build メソッドのテスト。', () {
      test('初期状態で TournamentListData を生成する。', () {
        // state を取得し、期待する値が設定されていることを確認する。
        final state = container.read(tournamentListNotifierProvider);

        expect(state, isA<TournamentListData>());
        expect(state.state, TournamentListState.initial);
        expect(state.tournaments, isEmpty);
        expect(state.errorMessage, isNull);
      });
    });

    group('loadTournaments メソッドのテスト。', () {
      test('トーナメント一覧の取得に成功した場合、state が loaded になる。', () async {
        final testTournaments = [
          const Tournament(
            id: 'test-id-1',
            title: 'テスト大会1',
            description: 'テスト大会1の説明',
            venue: 'テスト会場1',
            startDate: '2025-10-01T10:00:00Z',
            endDate: '2025-10-01T18:00:00Z',
            createdAt: '2025-10-01T09:00:00Z',
            updatedAt: '2025-10-01T09:00:00Z',
          ),
          const Tournament(
            id: 'test-id-2',
            title: 'テスト大会2',
            description: 'テスト大会2の説明',
            venue: 'テスト会場2',
            startDate: '2025-10-02T10:00:00Z',
            endDate: '2025-10-02T18:00:00Z',
            createdAt: '2025-10-02T09:00:00Z',
            updatedAt: '2025-10-02T09:00:00Z',
          ),
        ];

        // getTournaments メソッドが正常に完了するスタブを用意する。
        when(
          mockGetTournamentsUseCase.invoke(),
        ).thenAnswer((_) async => testTournaments);

        final notifier = container.read(
          tournamentListNotifierProvider.notifier,
        );

        // 初期 state を確認する。
        var state = container.read(tournamentListNotifierProvider);
        expect(state.state, TournamentListState.initial);

        // loadTournaments メソッドを実行する。
        await notifier.loadTournaments();

        // state が loaded に更新されていることを確認する。
        state = container.read(tournamentListNotifierProvider);
        expect(state.state, TournamentListState.loaded);
        expect(state.tournaments, testTournaments);
        expect(state.errorMessage, isNull);

        // UseCase の invoke メソッドが呼び出されることを確認する。
        verify(mockGetTournamentsUseCase.invoke()).called(1);
      });

      test('loading 状態の間、state が loading になる。', () async {
        final testTournaments = [
          const Tournament(
            id: 'test-id-1',
            title: 'テスト大会1',
            description: 'テスト大会1の説明',
            venue: 'テスト会場1',
            startDate: '2025-10-01T10:00:00Z',
            endDate: '2025-10-01T18:00:00Z',
            createdAt: '2025-10-01T09:00:00Z',
            updatedAt: '2025-10-01T09:00:00Z',
          ),
        ];

        // getTournaments メソッドが正常に完了するスタブを用意する。
        when(mockGetTournamentsUseCase.invoke()).thenAnswer((_) async {
          // loading 状態を確認する。
          final state = container.read(tournamentListNotifierProvider);
          expect(state.state, TournamentListState.loading);
          return testTournaments;
        });

        final notifier = container.read(
          tournamentListNotifierProvider.notifier,
        );

        // loadTournaments メソッドを実行する。
        await notifier.loadTournaments();
      });

      test('空のトーナメント一覧を取得した場合、state が loaded になる。', () async {
        // getTournaments メソッドが空リストを返すスタブを用意する。
        when(mockGetTournamentsUseCase.invoke()).thenAnswer((_) async => []);

        final notifier = container.read(
          tournamentListNotifierProvider.notifier,
        );

        // loadTournaments メソッドを実行する。
        await notifier.loadTournaments();

        // state が loaded に更新されていることを確認する。
        final state = container.read(tournamentListNotifierProvider);
        expect(state.state, TournamentListState.loaded);
        expect(state.tournaments, isEmpty);
        expect(state.errorMessage, isNull);
      });

      test('FailureStatusException が発生した場合、state が error になる。', () async {
        const testErrorMessage = '取得エラー';

        // FailureStatusException がスローされるスタブを用意する。
        when(
          mockGetTournamentsUseCase.invoke(),
        ).thenThrow(const FailureStatusException(testErrorMessage));

        final notifier = container.read(
          tournamentListNotifierProvider.notifier,
        );

        // loadTournaments メソッドを実行する。
        await notifier.loadTournaments();

        // state が error に更新されていることを確認する。
        final state = container.read(tournamentListNotifierProvider);
        expect(state.state, TournamentListState.error);
        expect(state.tournaments, isEmpty);
        expect(state.errorMessage, testErrorMessage);
      });

      test(
        'GeneralFailureException (other) が発生した場合、state が error になる。',
        () async {
          // GeneralFailureException がスローされるスタブを用意する。
          when(mockGetTournamentsUseCase.invoke()).thenThrow(
            const GeneralFailureException(
              reason: GeneralFailureReason.other,
              errorCode: 'AUTH_ERROR',
            ),
          );

          final notifier = container.read(
            tournamentListNotifierProvider.notifier,
          );

          // loadTournaments メソッドを実行する。
          await notifier.loadTournaments();

          // state が error に更新されていることを確認する。
          final state = container.read(tournamentListNotifierProvider);
          expect(state.state, TournamentListState.error);
          expect(state.tournaments, isEmpty);
          expect(state.errorMessage, '認証に失敗しました。再度ログインしてください。');
        },
      );

      test('GeneralFailureException (noConnectionError) が発生した場合、'
          ' state が error になる。', () async {
        // GeneralFailureException がスローされるスタブを用意する。
        when(mockGetTournamentsUseCase.invoke()).thenThrow(
          const GeneralFailureException(
            reason: GeneralFailureReason.noConnectionError,
            errorCode: 'NETWORK_ERROR',
          ),
        );

        final notifier = container.read(
          tournamentListNotifierProvider.notifier,
        );

        // loadTournaments メソッドを実行する。
        await notifier.loadTournaments();

        // state が error に更新されていることを確認する。
        final state = container.read(tournamentListNotifierProvider);
        expect(state.state, TournamentListState.error);
        expect(state.tournaments, isEmpty);
        expect(state.errorMessage, 'ネットワークに接続できません。');
      });

      test('GeneralFailureException (serverUrlNotFoundError) が発生した場合、'
          ' state が error になる。', () async {
        // GeneralFailureException がスローされるスタブを用意する。
        when(mockGetTournamentsUseCase.invoke()).thenThrow(
          const GeneralFailureException(
            reason: GeneralFailureReason.serverUrlNotFoundError,
            errorCode: 'NOT_FOUND',
          ),
        );

        final notifier = container.read(
          tournamentListNotifierProvider.notifier,
        );

        // loadTournaments メソッドを実行する。
        await notifier.loadTournaments();

        // state が error に更新されていることを確認する。
        final state = container.read(tournamentListNotifierProvider);
        expect(state.state, TournamentListState.error);
        expect(state.tournaments, isEmpty);
        expect(state.errorMessage, 'サーバーURLが見つかりません。');
      });

      test(
        'GeneralFailureException (badResponse) が発生した場合、state が error になる。',
        () async {
          // GeneralFailureException がスローされるスタブを用意する。
          when(mockGetTournamentsUseCase.invoke()).thenThrow(
            const GeneralFailureException.badResponse(
              errorCode: 'BAD_RESPONSE',
              statusCode: 500,
            ),
          );

          final notifier = container.read(
            tournamentListNotifierProvider.notifier,
          );

          // loadTournaments メソッドを実行する。
          await notifier.loadTournaments();

          // state が error に更新されていることを確認する。
          final state = container.read(tournamentListNotifierProvider);
          expect(state.state, TournamentListState.error);
          expect(state.tournaments, isEmpty);
          expect(state.errorMessage, '不正なレスポンスです。');
        },
      );

      test('予期しない例外が発生した場合、state が error になる。', () async {
        // 予期しない例外がスローされるスタブを用意する。
        when(
          mockGetTournamentsUseCase.invoke(),
        ).thenThrow(Exception('予期しないエラー'));

        final notifier = container.read(
          tournamentListNotifierProvider.notifier,
        );

        // loadTournaments メソッドを実行する。
        await notifier.loadTournaments();

        // state が error に更新されていることを確認する。
        final state = container.read(tournamentListNotifierProvider);
        expect(state.state, TournamentListState.error);
        expect(state.tournaments, isEmpty);
        expect(state.errorMessage, '予期しないエラーが発生しました');
      });
    });

    group('copyWith のテスト。', () {
      test('copyWith で state に null を渡すと現在の state を保持する', () {
        const data = TournamentListData(state: TournamentListState.loaded);

        final copied = data.copyWith(
          tournaments: [
            const Tournament(
              id: 'test-id',
              title: 'Test Tournament',
              description: 'Test Description',
              venue: 'Test Venue',
              startDate: '2025-10-01T10:00:00Z',
              endDate: '2025-10-01T18:00:00Z',
              createdAt: '2025-10-01T09:00:00Z',
              updatedAt: '2025-10-01T09:00:00Z',
            ),
          ],
        );

        expect(copied.state, TournamentListState.loaded);
        expect(copied.tournaments, hasLength(1));
      });
    });

    group('refreshTournaments メソッドのテスト。', () {
      test('refreshTournaments が loadTournaments を呼び出す。', () async {
        final testTournaments = [
          const Tournament(
            id: 'test-id-1',
            title: 'テスト大会1',
            description: 'テスト大会1の説明',
            venue: 'テスト会場1',
            startDate: '2025-10-01T10:00:00Z',
            endDate: '2025-10-01T18:00:00Z',
            createdAt: '2025-10-01T09:00:00Z',
            updatedAt: '2025-10-01T09:00:00Z',
          ),
        ];

        // getTournaments メソッドが正常に完了するスタブを用意する。
        when(
          mockGetTournamentsUseCase.invoke(),
        ).thenAnswer((_) async => testTournaments);

        final notifier = container.read(
          tournamentListNotifierProvider.notifier,
        );

        // refreshTournaments メソッドを実行する。
        await notifier.refreshTournaments();

        // state が loaded に更新されていることを確認する。
        final state = container.read(tournamentListNotifierProvider);
        expect(state.state, TournamentListState.loaded);
        expect(state.tournaments, testTournaments);

        // UseCase の invoke メソッドが呼び出されることを確認する。
        verify(mockGetTournamentsUseCase.invoke()).called(1);
      });
    });
  });
}
