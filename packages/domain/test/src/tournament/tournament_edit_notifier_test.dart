import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';

import 'tournament_edit_notifier_test.mocks.dart';

// GetTournamentUseCase と UpdateTournamentUseCase のモッククラスを生成する。
@GenerateNiceMocks([
  MockSpec<GetTournamentUseCase>(),
  MockSpec<UpdateTournamentUseCase>(),
])
void main() {
  late MockGetTournamentUseCase mockGetTournamentUseCase;
  late MockUpdateTournamentUseCase mockUpdateTournamentUseCase;
  late ProviderContainer container;

  setUp(() {
    mockGetTournamentUseCase = MockGetTournamentUseCase();
    mockUpdateTournamentUseCase = MockUpdateTournamentUseCase();
    container = ProviderContainer(
      overrides: [
        getTournamentUseCaseProvider.overrideWithValue(
          mockGetTournamentUseCase,
        ),
        updateTournamentUseCaseProvider.overrideWithValue(
          mockUpdateTournamentUseCase,
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('tournamentEditNotifierProvider のテスト。', () {
    test('tournamentEditNotifierProvider が TournamentEditNotifier を返す。', () {
      expect(
        container.read(tournamentEditNotifierProvider.notifier),
        isA<TournamentEditNotifier>(),
      );
    });
  });

  group('TournamentEditNotifier のテスト。', () {
    group('build メソッドのテスト。', () {
      test('初期状態で TournamentEditData を生成する。', () {
        // state を取得し、期待する値が設定されていることを確認する。
        final state = container.read(tournamentEditNotifierProvider);

        expect(state, isA<TournamentEditData>());
        expect(state.state, TournamentEditState.initial);
        expect(state.tournament, isNull);
        expect(state.errorMessage, isNull);
      });
    });

    group('loadTournament メソッドのテスト。', () {
      const testId = 'test-id';

      test('トーナメントの読み込みに成功した場合、state が loaded になる。', () async {
        const testTournament = Tournament(
          id: testId,
          title: 'テスト大会',
          description: 'テスト大会の説明',
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
          tournamentEditNotifierProvider.notifier,
        );

        // 初期 state を確認する。
        var state = container.read(tournamentEditNotifierProvider);
        expect(state.state, TournamentEditState.initial);

        // loadTournament メソッドを実行する。
        await notifier.loadTournament(testId);

        // state が loaded に更新されていることを確認する。
        state = container.read(tournamentEditNotifierProvider);
        expect(state.state, TournamentEditState.loaded);
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
          final state = container.read(tournamentEditNotifierProvider);
          expect(state.state, TournamentEditState.loading);
          return testTournament;
        });

        final notifier = container.read(
          tournamentEditNotifierProvider.notifier,
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
          tournamentEditNotifierProvider.notifier,
        );

        // loadTournament メソッドを実行する。
        await notifier.loadTournament(testId);

        // state が error に更新されていることを確認する。
        final state = container.read(tournamentEditNotifierProvider);
        expect(state.state, TournamentEditState.error);
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
            tournamentEditNotifierProvider.notifier,
          );

          // loadTournament メソッドを実行する。
          await notifier.loadTournament(testId);

          // state が error に更新されていることを確認する。
          final state = container.read(tournamentEditNotifierProvider);
          expect(state.state, TournamentEditState.error);
          expect(state.tournament, isNull);
          expect(state.errorMessage, '認証に失敗しました。再度ログインしてください。');
        },
      );

      test('GeneralFailureException (noConnectionError) が発生した場合、'
          ' state が error になる。', () async {
        // GeneralFailureException がスローされるスタブを用意する。
        when(mockGetTournamentUseCase.invoke(id: anyNamed('id'))).thenThrow(
          const GeneralFailureException(
            reason: GeneralFailureReason.noConnectionError,
            errorCode: 'NETWORK_ERROR',
          ),
        );

        final notifier = container.read(
          tournamentEditNotifierProvider.notifier,
        );

        // loadTournament メソッドを実行する。
        await notifier.loadTournament(testId);

        // state が error に更新されていることを確認する。
        final state = container.read(tournamentEditNotifierProvider);
        expect(state.state, TournamentEditState.error);
        expect(state.tournament, isNull);
        expect(state.errorMessage, 'ネットワークに接続できません。');
      });

      test('GeneralFailureException (serverUrlNotFoundError) が発生した場合、'
          ' state が error になる。', () async {
        // GeneralFailureException がスローされるスタブを用意する。
        when(mockGetTournamentUseCase.invoke(id: anyNamed('id'))).thenThrow(
          const GeneralFailureException(
            reason: GeneralFailureReason.serverUrlNotFoundError,
            errorCode: 'NOT_FOUND',
          ),
        );

        final notifier = container.read(
          tournamentEditNotifierProvider.notifier,
        );

        // loadTournament メソッドを実行する。
        await notifier.loadTournament(testId);

        // state が error に更新されていることを確認する。
        final state = container.read(tournamentEditNotifierProvider);
        expect(state.state, TournamentEditState.error);
        expect(state.tournament, isNull);
        expect(state.errorMessage, 'サーバーURLが見つかりません。');
      });

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
            tournamentEditNotifierProvider.notifier,
          );

          // loadTournament メソッドを実行する。
          await notifier.loadTournament(testId);

          // state が error に更新されていることを確認する。
          final state = container.read(tournamentEditNotifierProvider);
          expect(state.state, TournamentEditState.error);
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
          tournamentEditNotifierProvider.notifier,
        );

        // loadTournament メソッドを実行する。
        await notifier.loadTournament(testId);

        // state が error に更新されていることを確認する。
        final state = container.read(tournamentEditNotifierProvider);
        expect(state.state, TournamentEditState.error);
        expect(state.tournament, isNull);
        expect(state.errorMessage, '予期しないエラーが発生しました');
      });
    });

    group('updateTournament メソッドのテスト。', () {
      const testId = 'test-id';
      const testName = 'テスト大会（更新）';
      const testOverview = 'テスト大会の説明（更新）';
      const testCategory = 'カテゴリ';
      const testDate = '2025-10-02T10:00:00Z';
      const testRemarks = '備考';

      test('トーナメントの更新に成功した場合、state が success になる。', () async {
        const testTournament = Tournament(
          id: testId,
          title: testName,
          description: testOverview,
          startDate: testDate,
          endDate: testDate,
          createdAt: '2025-10-01T09:00:00Z',
          updatedAt: '2025-10-01T09:00:00Z',
        );

        // updateTournament メソッドが正常に完了するスタブを用意する。
        when(
          mockUpdateTournamentUseCase.invoke(
            id: anyNamed('id'),
            name: anyNamed('name'),
            overview: anyNamed('overview'),
            category: anyNamed('category'),
            date: anyNamed('date'),
            remarks: anyNamed('remarks'),
          ),
        ).thenAnswer((_) async => testTournament);

        final notifier = container.read(
          tournamentEditNotifierProvider.notifier,
        );

        // 初期 state を確認する。
        var state = container.read(tournamentEditNotifierProvider);
        expect(state.state, TournamentEditState.initial);

        // updateTournament メソッドを実行する。
        await notifier.updateTournament(
          id: testId,
          name: testName,
          overview: testOverview,
          category: testCategory,
          date: testDate,
          remarks: testRemarks,
        );

        // state が success に更新されていることを確認する。
        state = container.read(tournamentEditNotifierProvider);
        expect(state.state, TournamentEditState.success);
        expect(state.tournament, testTournament);
        expect(state.errorMessage, isNull);

        // UseCase の invoke メソッドが正しい引数で呼び出されることを確認する。
        verify(
          mockUpdateTournamentUseCase.invoke(
            id: testId,
            name: testName,
            overview: testOverview,
            category: testCategory,
            date: testDate,
            remarks: testRemarks,
          ),
        ).called(1);
      });

      test('updating 状態の間、state が updating になる。', () async {
        const testTournament = Tournament(
          id: testId,
          title: testName,
          description: testOverview,
          startDate: testDate,
          endDate: testDate,
          createdAt: '2025-10-01T09:00:00Z',
          updatedAt: '2025-10-01T09:00:00Z',
        );

        // updateTournament メソッドが正常に完了するスタブを用意する。
        when(
          mockUpdateTournamentUseCase.invoke(
            id: anyNamed('id'),
            name: anyNamed('name'),
            overview: anyNamed('overview'),
            category: anyNamed('category'),
            date: anyNamed('date'),
            remarks: anyNamed('remarks'),
          ),
        ).thenAnswer((_) async {
          // updating 状態を確認する。
          final state = container.read(tournamentEditNotifierProvider);
          expect(state.state, TournamentEditState.updating);
          return testTournament;
        });

        final notifier = container.read(
          tournamentEditNotifierProvider.notifier,
        );

        // updateTournament メソッドを実行する。
        await notifier.updateTournament(
          id: testId,
          name: testName,
          overview: testOverview,
          category: testCategory,
          date: testDate,
          remarks: testRemarks,
        );
      });

      test('一部のパラメータのみ更新する場合、正しく動作する。', () async {
        const testTournament = Tournament(
          id: testId,
          title: testName,
          description: 'テスト大会の説明',
          startDate: '2025-10-01T10:00:00Z',
          endDate: '2025-10-01T18:00:00Z',
          createdAt: '2025-10-01T09:00:00Z',
          updatedAt: '2025-10-01T09:00:00Z',
        );

        // updateTournament メソッドが正常に完了するスタブを用意する。
        when(
          mockUpdateTournamentUseCase.invoke(
            id: anyNamed('id'),
            name: anyNamed('name'),
            overview: anyNamed('overview'),
            category: anyNamed('category'),
            date: anyNamed('date'),
            remarks: anyNamed('remarks'),
          ),
        ).thenAnswer((_) async => testTournament);

        final notifier = container.read(
          tournamentEditNotifierProvider.notifier,
        );

        // updateTournament メソッドを実行する（name のみ更新）。
        await notifier.updateTournament(id: testId, name: testName);

        // state が success に更新されていることを確認する。
        final state = container.read(tournamentEditNotifierProvider);
        expect(state.state, TournamentEditState.success);
        expect(state.tournament, testTournament);

        // UseCase の invoke メソッドが正しい引数で呼び出されることを確認する。
        verify(
          mockUpdateTournamentUseCase.invoke(id: testId, name: testName),
        ).called(1);
      });

      test('FailureStatusException が発生した場合、state が error になる。', () async {
        const testErrorMessage = '更新エラー';

        // FailureStatusException がスローされるスタブを用意する。
        when(
          mockUpdateTournamentUseCase.invoke(
            id: anyNamed('id'),
            name: anyNamed('name'),
            overview: anyNamed('overview'),
            category: anyNamed('category'),
            date: anyNamed('date'),
            remarks: anyNamed('remarks'),
          ),
        ).thenThrow(const FailureStatusException(testErrorMessage));

        final notifier = container.read(
          tournamentEditNotifierProvider.notifier,
        );

        // updateTournament メソッドを実行する。
        await notifier.updateTournament(
          id: testId,
          name: testName,
          overview: testOverview,
          category: testCategory,
          date: testDate,
          remarks: testRemarks,
        );

        // state が error に更新されていることを確認する。
        final state = container.read(tournamentEditNotifierProvider);
        expect(state.state, TournamentEditState.error);
        expect(state.tournament, isNull);
        expect(state.errorMessage, testErrorMessage);
      });

      test(
        'GeneralFailureException (other) が発生した場合、state が error になる。',
        () async {
          // GeneralFailureException がスローされるスタブを用意する。
          when(
            mockUpdateTournamentUseCase.invoke(
              id: anyNamed('id'),
              name: anyNamed('name'),
              overview: anyNamed('overview'),
              category: anyNamed('category'),
              date: anyNamed('date'),
              remarks: anyNamed('remarks'),
            ),
          ).thenThrow(
            const GeneralFailureException(
              reason: GeneralFailureReason.other,
              errorCode: 'AUTH_ERROR',
            ),
          );

          final notifier = container.read(
            tournamentEditNotifierProvider.notifier,
          );

          // updateTournament メソッドを実行する。
          await notifier.updateTournament(
            id: testId,
            name: testName,
            overview: testOverview,
            category: testCategory,
            date: testDate,
            remarks: testRemarks,
          );

          // state が error に更新されていることを確認する。
          final state = container.read(tournamentEditNotifierProvider);
          expect(state.state, TournamentEditState.error);
          expect(state.tournament, isNull);
          expect(state.errorMessage, '認証に失敗しました。再度ログインしてください。');
        },
      );

      test('GeneralFailureException (noConnectionError) が発生した場合、'
          ' state が error になる。', () async {
        // GeneralFailureException がスローされるスタブを用意する。
        when(
          mockUpdateTournamentUseCase.invoke(
            id: anyNamed('id'),
            name: anyNamed('name'),
            overview: anyNamed('overview'),
            category: anyNamed('category'),
            date: anyNamed('date'),
            remarks: anyNamed('remarks'),
          ),
        ).thenThrow(
          const GeneralFailureException(
            reason: GeneralFailureReason.noConnectionError,
            errorCode: 'NETWORK_ERROR',
          ),
        );

        final notifier = container.read(
          tournamentEditNotifierProvider.notifier,
        );

        // updateTournament メソッドを実行する。
        await notifier.updateTournament(
          id: testId,
          name: testName,
          overview: testOverview,
          category: testCategory,
          date: testDate,
          remarks: testRemarks,
        );

        // state が error に更新されていることを確認する。
        final state = container.read(tournamentEditNotifierProvider);
        expect(state.state, TournamentEditState.error);
        expect(state.tournament, isNull);
        expect(state.errorMessage, 'ネットワークに接続できません。');
      });

      test('GeneralFailureException (serverUrlNotFoundError) が発生した場合、'
          ' state が error になる。', () async {
        // GeneralFailureException がスローされるスタブを用意する。
        when(
          mockUpdateTournamentUseCase.invoke(
            id: anyNamed('id'),
            name: anyNamed('name'),
            overview: anyNamed('overview'),
            category: anyNamed('category'),
            date: anyNamed('date'),
            remarks: anyNamed('remarks'),
          ),
        ).thenThrow(
          const GeneralFailureException(
            reason: GeneralFailureReason.serverUrlNotFoundError,
            errorCode: 'NOT_FOUND',
          ),
        );

        final notifier = container.read(
          tournamentEditNotifierProvider.notifier,
        );

        // updateTournament メソッドを実行する。
        await notifier.updateTournament(
          id: testId,
          name: testName,
          overview: testOverview,
          category: testCategory,
          date: testDate,
          remarks: testRemarks,
        );

        // state が error に更新されていることを確認する。
        final state = container.read(tournamentEditNotifierProvider);
        expect(state.state, TournamentEditState.error);
        expect(state.tournament, isNull);
        expect(state.errorMessage, 'サーバーURLが見つかりません。');
      });

      test(
        'GeneralFailureException (badResponse) が発生した場合、state が error になる。',
        () async {
          // GeneralFailureException がスローされるスタブを用意する。
          when(
            mockUpdateTournamentUseCase.invoke(
              id: anyNamed('id'),
              name: anyNamed('name'),
              overview: anyNamed('overview'),
              category: anyNamed('category'),
              date: anyNamed('date'),
              remarks: anyNamed('remarks'),
            ),
          ).thenThrow(
            const GeneralFailureException.badResponse(
              errorCode: 'BAD_RESPONSE',
              statusCode: 500,
            ),
          );

          final notifier = container.read(
            tournamentEditNotifierProvider.notifier,
          );

          // updateTournament メソッドを実行する。
          await notifier.updateTournament(
            id: testId,
            name: testName,
            overview: testOverview,
            category: testCategory,
            date: testDate,
            remarks: testRemarks,
          );

          // state が error に更新されていることを確認する。
          final state = container.read(tournamentEditNotifierProvider);
          expect(state.state, TournamentEditState.error);
          expect(state.tournament, isNull);
          expect(state.errorMessage, '不正なレスポンスです。');
        },
      );

      test('予期しない例外が発生した場合、state が error になる。', () async {
        // 予期しない例外がスローされるスタブを用意する。
        when(
          mockUpdateTournamentUseCase.invoke(
            id: anyNamed('id'),
            name: anyNamed('name'),
            overview: anyNamed('overview'),
            category: anyNamed('category'),
            date: anyNamed('date'),
            remarks: anyNamed('remarks'),
          ),
        ).thenThrow(Exception('予期しないエラー'));

        final notifier = container.read(
          tournamentEditNotifierProvider.notifier,
        );

        // updateTournament メソッドを実行する。
        await notifier.updateTournament(
          id: testId,
          name: testName,
          overview: testOverview,
          category: testCategory,
          date: testDate,
          remarks: testRemarks,
        );

        // state が error に更新されていることを確認する。
        final state = container.read(tournamentEditNotifierProvider);
        expect(state.state, TournamentEditState.error);
        expect(state.tournament, isNull);
        expect(state.errorMessage, '予期しないエラーが発生しました');
      });
    });

    group('copyWith のテスト。', () {
      test('copyWith で state に null を渡すと現在の state を保持する', () {
        const data = TournamentEditData(state: TournamentEditState.loaded);

        final copied = data.copyWith(
          tournament: const Tournament(
            id: 'test-id',
            title: 'Test Tournament',
            description: 'Test Description',
            startDate: '2025-10-01T10:00:00Z',
            endDate: '2025-10-01T18:00:00Z',
            createdAt: '2025-10-01T09:00:00Z',
            updatedAt: '2025-10-01T09:00:00Z',
          ),
        );

        expect(copied.state, TournamentEditState.loaded);
        expect(copied.tournament, isNotNull);
      });
    });

    group('reset メソッドのテスト。', () {
      test('reset を呼ぶと state が初期状態に戻る。', () async {
        const testId = 'test-id';
        const testTournament = Tournament(
          id: testId,
          title: 'テスト大会',
          description: 'テスト大会の説明',
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
          tournamentEditNotifierProvider.notifier,
        );

        // loadTournament メソッドを実行する。
        await notifier.loadTournament(testId);

        // state が loaded になっていることを確認する。
        var state = container.read(tournamentEditNotifierProvider);
        expect(state.state, TournamentEditState.loaded);
        expect(state.tournament, testTournament);

        // reset を呼ぶ。
        notifier.reset();

        // state が初期状態に戻っていることを確認する。
        state = container.read(tournamentEditNotifierProvider);
        expect(state.state, TournamentEditState.initial);
        expect(state.tournament, isNull);
        expect(state.errorMessage, isNull);
      });
    });
  });
}
