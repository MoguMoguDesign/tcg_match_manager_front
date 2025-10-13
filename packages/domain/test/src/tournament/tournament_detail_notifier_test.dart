import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';

import 'tournament_detail_notifier_test.mocks.dart';

// GetTournamentUseCase のモッククラスを生成する。
@GenerateNiceMocks([MockSpec<GetTournamentUseCase>()])
void main() {
  late MockGetTournamentUseCase mockGetTournamentUseCase;
  late ProviderContainer container;

  setUp(() {
    mockGetTournamentUseCase = MockGetTournamentUseCase();
    container = ProviderContainer(
      overrides: [
        getTournamentUseCaseProvider.overrideWithValue(
          mockGetTournamentUseCase,
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('tournamentDetailNotifierProvider のテスト。', () {
    test(
      'tournamentDetailNotifierProvider が TournamentDetailNotifier を返す。',
      () {
        expect(
          container.read(tournamentDetailNotifierProvider.notifier),
          isA<TournamentDetailNotifier>(),
        );
      },
    );
  });

  group('TournamentDetailData のテスト。', () {
    group('copyWith メソッドのテスト。', () {
      test('state のみを更新する。', () {
        const data = TournamentDetailData();

        final copied = data.copyWith(state: TournamentDetailState.loading);

        expect(copied.state, TournamentDetailState.loading);
        expect(copied.tournament, data.tournament);
        expect(copied.errorMessage, data.errorMessage);
      });

      test('引数なしで呼ぶと現在の値を保持する。', () {
        const data = TournamentDetailData(
          state: TournamentDetailState.loaded,
          tournament: Tournament(
            id: 't1',
            title: 'Tournament 1',
            createdAt: '2024-01-01',
            updatedAt: '2024-01-01',
          ),
          errorMessage: 'エラー',
        );

        final copied = data.copyWith();

        expect(copied.state, data.state);
        expect(copied.tournament, data.tournament);
        expect(copied.errorMessage, data.errorMessage);
      });
    });
  });

  group('TournamentDetailNotifier のテスト。', () {
    group('build メソッドのテスト。', () {
      test('初期状態で TournamentDetailData を生成する。', () {
        // state を取得し、期待する値が設定されていることを確認する。
        final state = container.read(tournamentDetailNotifierProvider);

        expect(state, isA<TournamentDetailData>());
        expect(state.state, TournamentDetailState.initial);
        expect(state.tournament, isNull);
        expect(state.errorMessage, isNull);
      });
    });

    group('loadTournament メソッドのテスト。', () {
      const testId = 'test-id';

      test('トーナメント詳細の取得に成功した場合、state が loaded になる。', () async {
        const testTournament = Tournament(
          id: testId,
          title: 'テスト大会',
          description: 'テスト大会の説明',
          venue: 'テスト会場',
          startDate: '2025-10-01T10:00:00Z',
          endDate: '2025-10-01T18:00:00Z',
          createdAt: '2025-10-01T09:00:00Z',
          updatedAt: '2025-10-01T09:00:00Z',
        );

        // getTournament メソッドが正常に完了するスタブを用意する。
        when(
          mockGetTournamentUseCase.invoke(id: anyNamed('id')),
        ).thenAnswer((_) async => testTournament);

        final notifier = container.read(
          tournamentDetailNotifierProvider.notifier,
        );

        // 初期 state を確認する。
        var state = container.read(tournamentDetailNotifierProvider);
        expect(state.state, TournamentDetailState.initial);

        // loadTournament メソッドを実行する。
        await notifier.loadTournament(testId);

        // state が loaded に更新されていることを確認する。
        state = container.read(tournamentDetailNotifierProvider);
        expect(state.state, TournamentDetailState.loaded);
        expect(state.tournament, testTournament);
        expect(state.errorMessage, isNull);

        // UseCase の invoke メソッドが正しい引数で呼び出されることを確認する。
        verify(mockGetTournamentUseCase.invoke(id: testId)).called(1);
      });

      test('loading 状態の間、state が loading になる。', () async {
        const testTournament = Tournament(
          id: testId,
          title: 'テスト大会',
          description: 'テスト大会の説明',
          venue: 'テスト会場',
          startDate: '2025-10-01T10:00:00Z',
          endDate: '2025-10-01T18:00:00Z',
          createdAt: '2025-10-01T09:00:00Z',
          updatedAt: '2025-10-01T09:00:00Z',
        );

        // getTournament メソッドが正常に完了するスタブを用意する。
        when(mockGetTournamentUseCase.invoke(id: anyNamed('id'))).thenAnswer((
          _,
        ) async {
          // loading 状態を確認する。
          final state = container.read(tournamentDetailNotifierProvider);
          expect(state.state, TournamentDetailState.loading);
          return testTournament;
        });

        final notifier = container.read(
          tournamentDetailNotifierProvider.notifier,
        );

        // loadTournament メソッドを実行する。
        await notifier.loadTournament(testId);
      });

      test('FailureStatusException が発生した場合、state が error になる。', () async {
        const testErrorMessage = '取得エラー';

        // FailureStatusException がスローされるスタブを用意する。
        when(
          mockGetTournamentUseCase.invoke(id: anyNamed('id')),
        ).thenThrow(const FailureStatusException(testErrorMessage));

        final notifier = container.read(
          tournamentDetailNotifierProvider.notifier,
        );

        // loadTournament メソッドを実行する。
        await notifier.loadTournament(testId);

        // state が error に更新されていることを確認する。
        final state = container.read(tournamentDetailNotifierProvider);
        expect(state.state, TournamentDetailState.error);
        expect(state.tournament, isNull);
        expect(state.errorMessage, testErrorMessage);
      });

      test(
        'GeneralFailureException (other) が発生した場合、state が error になる。',
        () async {
          // GeneralFailureException がスローされるスタブを用意する。
          when(mockGetTournamentUseCase.invoke(id: anyNamed('id'))).thenThrow(
            const GeneralFailureException(
              reason: GeneralFailureReason.other,
              errorCode: 'AUTH_ERROR',
            ),
          );

          final notifier = container.read(
            tournamentDetailNotifierProvider.notifier,
          );

          // loadTournament メソッドを実行する。
          await notifier.loadTournament(testId);

          // state が error に更新されていることを確認する。
          final state = container.read(tournamentDetailNotifierProvider);
          expect(state.state, TournamentDetailState.error);
          expect(state.tournament, isNull);
          expect(state.errorMessage, '認証に失敗しました。再度ログインしてください。');
        },
      );

      test(
        'GeneralFailureException (noConnectionError) が発生した場合、 '
        'state が error になる。',
        () async {
          // GeneralFailureException がスローされるスタブを用意する。
          when(mockGetTournamentUseCase.invoke(id: anyNamed('id'))).thenThrow(
            const GeneralFailureException(
              reason: GeneralFailureReason.noConnectionError,
              errorCode: 'NETWORK_ERROR',
            ),
          );

          final notifier = container.read(
            tournamentDetailNotifierProvider.notifier,
          );

          // loadTournament メソッドを実行する。
          await notifier.loadTournament(testId);

          // state が error に更新されていることを確認する。
          final state = container.read(tournamentDetailNotifierProvider);
          expect(state.state, TournamentDetailState.error);
          expect(state.tournament, isNull);
          expect(state.errorMessage, 'ネットワークに接続できません。');
        },
      );

      test(
        'GeneralFailureException (serverUrlNotFoundError) が発生した場合、 '
        'state が error になる。',
        () async {
          // GeneralFailureException がスローされるスタブを用意する。
          when(mockGetTournamentUseCase.invoke(id: anyNamed('id'))).thenThrow(
            const GeneralFailureException(
              reason: GeneralFailureReason.serverUrlNotFoundError,
              errorCode: 'NOT_FOUND',
            ),
          );

          final notifier = container.read(
            tournamentDetailNotifierProvider.notifier,
          );

          // loadTournament メソッドを実行する。
          await notifier.loadTournament(testId);

          // state が error に更新されていることを確認する。
          final state = container.read(tournamentDetailNotifierProvider);
          expect(state.state, TournamentDetailState.error);
          expect(state.tournament, isNull);
          expect(state.errorMessage, 'サーバーURLが見つかりません。');
        },
      );

      test(
        'GeneralFailureException (badResponse) が発生した場合、state が error になる。',
        () async {
          // GeneralFailureException がスローされるスタブを用意する。
          when(mockGetTournamentUseCase.invoke(id: anyNamed('id'))).thenThrow(
            const GeneralFailureException.badResponse(
              errorCode: 'BAD_RESPONSE',
              statusCode: 500,
            ),
          );

          final notifier = container.read(
            tournamentDetailNotifierProvider.notifier,
          );

          // loadTournament メソッドを実行する。
          await notifier.loadTournament(testId);

          // state が error に更新されていることを確認する。
          final state = container.read(tournamentDetailNotifierProvider);
          expect(state.state, TournamentDetailState.error);
          expect(state.tournament, isNull);
          expect(state.errorMessage, '不正なレスポンスです。');
        },
      );

      test('予期しない例外が発生した場合、state が error になる。', () async {
        // 予期しない例外がスローされるスタブを用意する。
        when(
          mockGetTournamentUseCase.invoke(id: anyNamed('id')),
        ).thenThrow(Exception('予期しないエラー'));

        final notifier = container.read(
          tournamentDetailNotifierProvider.notifier,
        );

        // loadTournament メソッドを実行する。
        await notifier.loadTournament(testId);

        // state が error に更新されていることを確認する。
        final state = container.read(tournamentDetailNotifierProvider);
        expect(state.state, TournamentDetailState.error);
        expect(state.tournament, isNull);
        expect(state.errorMessage, '予期しないエラーが発生しました');
      });
    });

    group('refreshTournament メソッドのテスト。', () {
      const testId = 'test-id';

      test('refreshTournament が loadTournament を呼び出す。', () async {
        const testTournament = Tournament(
          id: testId,
          title: 'テスト大会',
          description: 'テスト大会の説明',
          venue: 'テスト会場',
          startDate: '2025-10-01T10:00:00Z',
          endDate: '2025-10-01T18:00:00Z',
          createdAt: '2025-10-01T09:00:00Z',
          updatedAt: '2025-10-01T09:00:00Z',
        );

        // getTournament メソッドが正常に完了するスタブを用意する。
        when(
          mockGetTournamentUseCase.invoke(id: anyNamed('id')),
        ).thenAnswer((_) async => testTournament);

        final notifier = container.read(
          tournamentDetailNotifierProvider.notifier,
        );

        // refreshTournament メソッドを実行する。
        await notifier.refreshTournament(testId);

        // state が loaded に更新されていることを確認する。
        final state = container.read(tournamentDetailNotifierProvider);
        expect(state.state, TournamentDetailState.loaded);
        expect(state.tournament, testTournament);

        // UseCase の invoke メソッドが正しい引数で呼び出されることを確認する。
        verify(mockGetTournamentUseCase.invoke(id: testId)).called(1);
      });
    });

    group('reset メソッドのテスト。', () {
      test('reset を呼ぶと state が初期状態に戻る。', () async {
        const testId = 'test-id';
        const testTournament = Tournament(
          id: testId,
          title: 'テスト大会',
          description: 'テスト大会の説明',
          venue: 'テスト会場',
          startDate: '2025-10-01T10:00:00Z',
          endDate: '2025-10-01T18:00:00Z',
          createdAt: '2025-10-01T09:00:00Z',
          updatedAt: '2025-10-01T09:00:00Z',
        );

        // getTournament メソッドが正常に完了するスタブを用意する。
        when(
          mockGetTournamentUseCase.invoke(id: anyNamed('id')),
        ).thenAnswer((_) async => testTournament);

        final notifier = container.read(
          tournamentDetailNotifierProvider.notifier,
        );

        // loadTournament メソッドを実行する。
        await notifier.loadTournament(testId);

        // state が loaded になっていることを確認する。
        var state = container.read(tournamentDetailNotifierProvider);
        expect(state.state, TournamentDetailState.loaded);
        expect(state.tournament, testTournament);

        // reset を呼ぶ。
        notifier.reset();

        // state が初期状態に戻っていることを確認する。
        state = container.read(tournamentDetailNotifierProvider);
        expect(state.state, TournamentDetailState.initial);
        expect(state.tournament, isNull);
        expect(state.errorMessage, isNull);
      });
    });
  });
}
