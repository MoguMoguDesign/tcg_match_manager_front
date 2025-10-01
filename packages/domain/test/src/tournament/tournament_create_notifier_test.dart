import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';

import 'tournament_create_notifier_test.mocks.dart';

// CreateTournamentUseCase のモッククラスを生成する。
@GenerateNiceMocks([MockSpec<CreateTournamentUseCase>()])
void main() {
  late MockCreateTournamentUseCase mockCreateTournamentUseCase;
  late ProviderContainer container;

  setUp(() {
    mockCreateTournamentUseCase = MockCreateTournamentUseCase();
    container = ProviderContainer(
      overrides: [
        createTournamentUseCaseProvider.overrideWithValue(
          mockCreateTournamentUseCase,
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('tournamentCreateNotifierProvider のテスト。', () {
    test(
      'tournamentCreateNotifierProvider が TournamentCreateNotifier を返す。',
      () {
        expect(
          container.read(tournamentCreateNotifierProvider.notifier),
          isA<TournamentCreateNotifier>(),
        );
      },
    );
  });

  group('TournamentCreateNotifier のテスト。', () {
    group('build メソッドのテスト。', () {
      test('初期状態で TournamentCreateData を生成する。', () {
        // state を取得し、期待する値が設定されていることを確認する。
        final state = container.read(tournamentCreateNotifierProvider);

        expect(state, isA<TournamentCreateData>());
        expect(state.state, TournamentCreateState.initial);
        expect(state.tournament, isNull);
        expect(state.errorMessage, isNull);
      });
    });

    group('createTournament メソッドのテスト。', () {
      const testTitle = 'テスト大会';
      const testDescription = 'テスト大会の説明';
      const testStartDate = '2025-10-01T10:00:00Z';
      const testEndDate = '2025-10-01T18:00:00Z';

      test('トーナメントの作成に成功した場合、state が success になる。', () async {
        final testTournament = Tournament(
          id: 'test-id',
          title: testTitle,
          description: testDescription,
          startDate: testStartDate,
          endDate: testEndDate,
        );

        // createTournament メソッドが正常に完了するスタブを用意する。
        when(
          mockCreateTournamentUseCase.invoke(
            title: anyNamed('title'),
            description: anyNamed('description'),
            startDate: anyNamed('startDate'),
            endDate: anyNamed('endDate'),
          ),
        ).thenAnswer((_) async => testTournament);

        final notifier = container.read(
          tournamentCreateNotifierProvider.notifier,
        );

        // 初期 state を確認する。
        var state = container.read(tournamentCreateNotifierProvider);
        expect(state.state, TournamentCreateState.initial);

        // createTournament メソッドを実行する。
        await notifier.createTournament(
          title: testTitle,
          description: testDescription,
          startDate: testStartDate,
          endDate: testEndDate,
        );

        // state が success に更新されていることを確認する。
        state = container.read(tournamentCreateNotifierProvider);
        expect(state.state, TournamentCreateState.success);
        expect(state.tournament, testTournament);
        expect(state.errorMessage, isNull);

        // UseCase の invoke メソッドが正しい引数で呼び出されることを確認する。
        verify(
          mockCreateTournamentUseCase.invoke(
            title: testTitle,
            description: testDescription,
            startDate: testStartDate,
            endDate: testEndDate,
          ),
        ).called(1);
      });

      test('creating 状態の間、state が creating になる。', () async {
        final testTournament = Tournament(
          id: 'test-id',
          title: testTitle,
          description: testDescription,
          startDate: testStartDate,
          endDate: testEndDate,
        );

        // createTournament メソッドが正常に完了するスタブを用意する。
        when(
          mockCreateTournamentUseCase.invoke(
            title: anyNamed('title'),
            description: anyNamed('description'),
            startDate: anyNamed('startDate'),
            endDate: anyNamed('endDate'),
          ),
        ).thenAnswer((_) async {
          // creating 状態を確認する。
          final state = container.read(tournamentCreateNotifierProvider);
          expect(state.state, TournamentCreateState.creating);
          return testTournament;
        });

        final notifier = container.read(
          tournamentCreateNotifierProvider.notifier,
        );

        // createTournament メソッドを実行する。
        await notifier.createTournament(
          title: testTitle,
          description: testDescription,
          startDate: testStartDate,
          endDate: testEndDate,
        );
      });

      test('FailureStatusException が発生した場合、state が error になる。', () async {
        const testErrorMessage = '入力エラー';

        // FailureStatusException がスローされるスタブを用意する。
        when(
          mockCreateTournamentUseCase.invoke(
            title: anyNamed('title'),
            description: anyNamed('description'),
            startDate: anyNamed('startDate'),
            endDate: anyNamed('endDate'),
          ),
        ).thenThrow(const FailureStatusException(testErrorMessage));

        final notifier = container.read(
          tournamentCreateNotifierProvider.notifier,
        );

        // createTournament メソッドを実行する。
        await notifier.createTournament(
          title: testTitle,
          description: testDescription,
          startDate: testStartDate,
          endDate: testEndDate,
        );

        // state が error に更新されていることを確認する。
        final state = container.read(tournamentCreateNotifierProvider);
        expect(state.state, TournamentCreateState.error);
        expect(state.tournament, isNull);
        expect(state.errorMessage, testErrorMessage);
      });

      test(
        'GeneralFailureException (other) が発生した場合、state が error になる。',
        () async {
          // GeneralFailureException がスローされるスタブを用意する。
          when(
            mockCreateTournamentUseCase.invoke(
              title: anyNamed('title'),
              description: anyNamed('description'),
              startDate: anyNamed('startDate'),
              endDate: anyNamed('endDate'),
            ),
          ).thenThrow(
            const GeneralFailureException(
              reason: GeneralFailureReason.other,
              errorCode: 'AUTH_ERROR',
            ),
          );

          final notifier = container.read(
            tournamentCreateNotifierProvider.notifier,
          );

          // createTournament メソッドを実行する。
          await notifier.createTournament(
            title: testTitle,
            description: testDescription,
            startDate: testStartDate,
            endDate: testEndDate,
          );

          // state が error に更新されていることを確認する。
          final state = container.read(tournamentCreateNotifierProvider);
          expect(state.state, TournamentCreateState.error);
          expect(state.tournament, isNull);
          expect(state.errorMessage, '認証に失敗しました。再度ログインしてください。');
        },
      );

      test(
        'GeneralFailureException (noConnectionError) が発生した場合、state が error になる。',
        () async {
          // GeneralFailureException がスローされるスタブを用意する。
          when(
            mockCreateTournamentUseCase.invoke(
              title: anyNamed('title'),
              description: anyNamed('description'),
              startDate: anyNamed('startDate'),
              endDate: anyNamed('endDate'),
            ),
          ).thenThrow(
            const GeneralFailureException(
              reason: GeneralFailureReason.noConnectionError,
              errorCode: 'NETWORK_ERROR',
            ),
          );

          final notifier = container.read(
            tournamentCreateNotifierProvider.notifier,
          );

          // createTournament メソッドを実行する。
          await notifier.createTournament(
            title: testTitle,
            description: testDescription,
            startDate: testStartDate,
            endDate: testEndDate,
          );

          // state が error に更新されていることを確認する。
          final state = container.read(tournamentCreateNotifierProvider);
          expect(state.state, TournamentCreateState.error);
          expect(state.tournament, isNull);
          expect(state.errorMessage, 'ネットワークに接続できません。');
        },
      );

      test(
        'GeneralFailureException (serverUrlNotFoundError) が発生した場合、state が error になる。',
        () async {
          // GeneralFailureException がスローされるスタブを用意する。
          when(
            mockCreateTournamentUseCase.invoke(
              title: anyNamed('title'),
              description: anyNamed('description'),
              startDate: anyNamed('startDate'),
              endDate: anyNamed('endDate'),
            ),
          ).thenThrow(
            const GeneralFailureException(
              reason: GeneralFailureReason.serverUrlNotFoundError,
              errorCode: 'NOT_FOUND',
            ),
          );

          final notifier = container.read(
            tournamentCreateNotifierProvider.notifier,
          );

          // createTournament メソッドを実行する。
          await notifier.createTournament(
            title: testTitle,
            description: testDescription,
            startDate: testStartDate,
            endDate: testEndDate,
          );

          // state が error に更新されていることを確認する。
          final state = container.read(tournamentCreateNotifierProvider);
          expect(state.state, TournamentCreateState.error);
          expect(state.tournament, isNull);
          expect(state.errorMessage, 'サーバーURLが見つかりません。');
        },
      );

      test(
        'GeneralFailureException (badResponse) が発生した場合、state が error になる。',
        () async {
          // GeneralFailureException がスローされるスタブを用意する。
          when(
            mockCreateTournamentUseCase.invoke(
              title: anyNamed('title'),
              description: anyNamed('description'),
              startDate: anyNamed('startDate'),
              endDate: anyNamed('endDate'),
            ),
          ).thenThrow(
            const GeneralFailureException.badResponse(
              errorCode: 'BAD_RESPONSE',
              statusCode: 500,
            ),
          );

          final notifier = container.read(
            tournamentCreateNotifierProvider.notifier,
          );

          // createTournament メソッドを実行する。
          await notifier.createTournament(
            title: testTitle,
            description: testDescription,
            startDate: testStartDate,
            endDate: testEndDate,
          );

          // state が error に更新されていることを確認する。
          final state = container.read(tournamentCreateNotifierProvider);
          expect(state.state, TournamentCreateState.error);
          expect(state.tournament, isNull);
          expect(state.errorMessage, '不正なレスポンスです。');
        },
      );

      test('予期しない例外が発生した場合、state が error になる。', () async {
        // 予期しない例外がスローされるスタブを用意する。
        when(
          mockCreateTournamentUseCase.invoke(
            title: anyNamed('title'),
            description: anyNamed('description'),
            startDate: anyNamed('startDate'),
            endDate: anyNamed('endDate'),
          ),
        ).thenThrow(Exception('予期しないエラー'));

        final notifier = container.read(
          tournamentCreateNotifierProvider.notifier,
        );

        // createTournament メソッドを実行する。
        await notifier.createTournament(
          title: testTitle,
          description: testDescription,
          startDate: testStartDate,
          endDate: testEndDate,
        );

        // state が error に更新されていることを確認する。
        final state = container.read(tournamentCreateNotifierProvider);
        expect(state.state, TournamentCreateState.error);
        expect(state.tournament, isNull);
        expect(state.errorMessage, '予期しないエラーが発生しました');
      });
    });

    group('reset メソッドのテスト。', () {
      test('reset を呼ぶと state が初期状態に戻る。', () async {
        const testTitle = 'テスト大会';
        const testDescription = 'テスト大会の説明';
        const testStartDate = '2025-10-01T10:00:00Z';
        const testEndDate = '2025-10-01T18:00:00Z';

        final testTournament = Tournament(
          id: 'test-id',
          title: testTitle,
          description: testDescription,
          startDate: testStartDate,
          endDate: testEndDate,
        );

        // createTournament メソッドが正常に完了するスタブを用意する。
        when(
          mockCreateTournamentUseCase.invoke(
            title: anyNamed('title'),
            description: anyNamed('description'),
            startDate: anyNamed('startDate'),
            endDate: anyNamed('endDate'),
          ),
        ).thenAnswer((_) async => testTournament);

        final notifier = container.read(
          tournamentCreateNotifierProvider.notifier,
        );

        // createTournament メソッドを実行する。
        await notifier.createTournament(
          title: testTitle,
          description: testDescription,
          startDate: testStartDate,
          endDate: testEndDate,
        );

        // state が success になっていることを確認する。
        var state = container.read(tournamentCreateNotifierProvider);
        expect(state.state, TournamentCreateState.success);
        expect(state.tournament, testTournament);

        // reset を呼ぶ。
        notifier.reset();

        // state が初期状態に戻っていることを確認する。
        state = container.read(tournamentCreateNotifierProvider);
        expect(state.state, TournamentCreateState.initial);
        expect(state.tournament, isNull);
        expect(state.errorMessage, isNull);
      });
    });
  });
}
