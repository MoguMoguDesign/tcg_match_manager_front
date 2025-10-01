import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';

import 'player_list_notifier_test.mocks.dart';

// GetPlayersUseCase のモッククラスを生成する。
@GenerateNiceMocks([MockSpec<GetPlayersUseCase>()])
void main() {
  late MockGetPlayersUseCase mockGetPlayersUseCase;
  late ProviderContainer container;

  setUp(() {
    mockGetPlayersUseCase = MockGetPlayersUseCase();
    container = ProviderContainer(
      overrides: [
        getPlayersUseCaseProvider.overrideWithValue(
          mockGetPlayersUseCase,
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('playerListNotifierProvider のテスト。', () {
    test('playerListNotifierProvider が PlayerListNotifier を返す。', () {
      expect(
        container.read(playerListNotifierProvider.notifier),
        isA<PlayerListNotifier>(),
      );
    });
  });

  group('PlayerListNotifier のテスト。', () {
    group('build メソッドのテスト。', () {
      test('初期状態で PlayerListData を生成する。', () {
        // state を取得し、期待する値が設定されていることを確認する。
        final state = container.read(playerListNotifierProvider);

        expect(state, isA<PlayerListData>());
        expect(state.state, PlayerListState.initial);
        expect(state.players, isEmpty);
        expect(state.errorMessage, isNull);
      });
    });

    group('loadPlayers メソッドのテスト。', () {
      const testTournamentId = 'test-tournament-id';

      test('プレイヤー一覧の取得に成功した場合、state が loaded になる。', () async {
        final testPlayers = [
          const Player(
            playerId: 'p_1',
            name: 'テストプレイヤー1',
            playerNumber: 1,
            status: 'ACTIVE',
            userId: 'user-1',
          ),
          const Player(
            playerId: 'p_2',
            name: 'テストプレイヤー2',
            playerNumber: 2,
            status: 'ACTIVE',
            userId: 'user-2',
          ),
        ];

        // getPlayers メソッドが正常に完了するスタブを用意する。
        when(
          mockGetPlayersUseCase.invoke(
            tournamentId: anyNamed('tournamentId'),
            status: anyNamed('status'),
          ),
        ).thenAnswer((_) async => testPlayers);

        final notifier = container.read(
          playerListNotifierProvider.notifier,
        );

        // 初期 state を確認する。
        var state = container.read(playerListNotifierProvider);
        expect(state.state, PlayerListState.initial);

        // loadPlayers メソッドを実行する。
        await notifier.loadPlayers(tournamentId: testTournamentId);

        // state が loaded に更新されていることを確認する。
        state = container.read(playerListNotifierProvider);
        expect(state.state, PlayerListState.loaded);
        expect(state.players, testPlayers);
        expect(state.errorMessage, isNull);

        // UseCase の invoke メソッドが呼び出されることを確認する。
        verify(
          mockGetPlayersUseCase.invoke(
            tournamentId: testTournamentId,
            status: null,
          ),
        ).called(1);
      });

      test('loading 状態の間、state が loading になる。', () async {
        final testPlayers = [
          const Player(
            playerId: 'p_1',
            name: 'テストプレイヤー1',
            playerNumber: 1,
            status: 'ACTIVE',
            userId: 'user-1',
          ),
        ];

        // getPlayers メソッドが正常に完了するスタブを用意する。
        when(
          mockGetPlayersUseCase.invoke(
            tournamentId: anyNamed('tournamentId'),
            status: anyNamed('status'),
          ),
        ).thenAnswer((_) async {
          // loading 状態を確認する。
          final state = container.read(playerListNotifierProvider);
          expect(state.state, PlayerListState.loading);
          return testPlayers;
        });

        final notifier = container.read(
          playerListNotifierProvider.notifier,
        );

        // loadPlayers メソッドを実行する。
        await notifier.loadPlayers(tournamentId: testTournamentId);
      });

      test('status パラメータを指定した場合、正しく動作する。', () async {
        final testPlayers = [
          const Player(
            playerId: 'p_1',
            name: 'テストプレイヤー1',
            playerNumber: 1,
            status: 'ACTIVE',
            userId: 'user-1',
          ),
        ];

        // getPlayers メソッドが正常に完了するスタブを用意する。
        when(
          mockGetPlayersUseCase.invoke(
            tournamentId: anyNamed('tournamentId'),
            status: anyNamed('status'),
          ),
        ).thenAnswer((_) async => testPlayers);

        final notifier = container.read(
          playerListNotifierProvider.notifier,
        );

        // loadPlayers メソッドを実行する。
        await notifier.loadPlayers(
          tournamentId: testTournamentId,
          status: 'ACTIVE',
        );

        // state が loaded に更新されていることを確認する。
        final state = container.read(playerListNotifierProvider);
        expect(state.state, PlayerListState.loaded);
        expect(state.players, testPlayers);

        // UseCase の invoke メソッドが正しい引数で呼び出されることを確認する。
        verify(
          mockGetPlayersUseCase.invoke(
            tournamentId: testTournamentId,
            status: 'ACTIVE',
          ),
        ).called(1);
      });

      test('空のプレイヤー一覧を取得した場合、state が loaded になる。', () async {
        // getPlayers メソッドが空リストを返すスタブを用意する。
        when(
          mockGetPlayersUseCase.invoke(
            tournamentId: anyNamed('tournamentId'),
            status: anyNamed('status'),
          ),
        ).thenAnswer((_) async => []);

        final notifier = container.read(
          playerListNotifierProvider.notifier,
        );

        // loadPlayers メソッドを実行する。
        await notifier.loadPlayers(tournamentId: testTournamentId);

        // state が loaded に更新されていることを確認する。
        final state = container.read(playerListNotifierProvider);
        expect(state.state, PlayerListState.loaded);
        expect(state.players, isEmpty);
        expect(state.errorMessage, isNull);
      });

      test('FailureStatusException が発生した場合、state が error になる。', () async {
        const testErrorMessage = '取得エラー';

        // FailureStatusException がスローされるスタブを用意する。
        when(
          mockGetPlayersUseCase.invoke(
            tournamentId: anyNamed('tournamentId'),
            status: anyNamed('status'),
          ),
        ).thenThrow(const FailureStatusException(testErrorMessage));

        final notifier = container.read(
          playerListNotifierProvider.notifier,
        );

        // loadPlayers メソッドを実行する。
        await notifier.loadPlayers(tournamentId: testTournamentId);

        // state が error に更新されていることを確認する。
        final state = container.read(playerListNotifierProvider);
        expect(state.state, PlayerListState.error);
        expect(state.players, isEmpty);
        expect(state.errorMessage, testErrorMessage);
      });

      test(
        'GeneralFailureException (other) が発生した場合、state が error になる。',
        () async {
          // GeneralFailureException がスローされるスタブを用意する。
          when(
            mockGetPlayersUseCase.invoke(
              tournamentId: anyNamed('tournamentId'),
              status: anyNamed('status'),
            ),
          ).thenThrow(
            const GeneralFailureException(
              reason: GeneralFailureReason.other,
              errorCode: 'AUTH_ERROR',
            ),
          );

          final notifier = container.read(
            playerListNotifierProvider.notifier,
          );

          // loadPlayers メソッドを実行する。
          await notifier.loadPlayers(tournamentId: testTournamentId);

          // state が error に更新されていることを確認する。
          final state = container.read(playerListNotifierProvider);
          expect(state.state, PlayerListState.error);
          expect(state.players, isEmpty);
          expect(state.errorMessage, '認証に失敗しました。再度ログインしてください。');
        },
      );

      test(
        'GeneralFailureException (noConnectionError) が発生した場合、state が error になる。',
        () async {
          // GeneralFailureException がスローされるスタブを用意する。
          when(
            mockGetPlayersUseCase.invoke(
              tournamentId: anyNamed('tournamentId'),
              status: anyNamed('status'),
            ),
          ).thenThrow(
            const GeneralFailureException(
              reason: GeneralFailureReason.noConnectionError,
              errorCode: 'NETWORK_ERROR',
            ),
          );

          final notifier = container.read(
            playerListNotifierProvider.notifier,
          );

          // loadPlayers メソッドを実行する。
          await notifier.loadPlayers(tournamentId: testTournamentId);

          // state が error に更新されていることを確認する。
          final state = container.read(playerListNotifierProvider);
          expect(state.state, PlayerListState.error);
          expect(state.players, isEmpty);
          expect(state.errorMessage, 'ネットワークに接続できません。');
        },
      );

      test(
        'GeneralFailureException (serverUrlNotFoundError) が発生した場合、state が error になる。',
        () async {
          // GeneralFailureException がスローされるスタブを用意する。
          when(
            mockGetPlayersUseCase.invoke(
              tournamentId: anyNamed('tournamentId'),
              status: anyNamed('status'),
            ),
          ).thenThrow(
            const GeneralFailureException(
              reason: GeneralFailureReason.serverUrlNotFoundError,
              errorCode: 'NOT_FOUND',
            ),
          );

          final notifier = container.read(
            playerListNotifierProvider.notifier,
          );

          // loadPlayers メソッドを実行する。
          await notifier.loadPlayers(tournamentId: testTournamentId);

          // state が error に更新されていることを確認する。
          final state = container.read(playerListNotifierProvider);
          expect(state.state, PlayerListState.error);
          expect(state.players, isEmpty);
          expect(state.errorMessage, 'サーバーURLが見つかりません。');
        },
      );

      test(
        'GeneralFailureException (badResponse) が発生した場合、state が error になる。',
        () async {
          // GeneralFailureException がスローされるスタブを用意する。
          when(
            mockGetPlayersUseCase.invoke(
              tournamentId: anyNamed('tournamentId'),
              status: anyNamed('status'),
            ),
          ).thenThrow(
            const GeneralFailureException.badResponse(
              errorCode: 'BAD_RESPONSE',
              statusCode: 500,
            ),
          );

          final notifier = container.read(
            playerListNotifierProvider.notifier,
          );

          // loadPlayers メソッドを実行する。
          await notifier.loadPlayers(tournamentId: testTournamentId);

          // state が error に更新されていることを確認する。
          final state = container.read(playerListNotifierProvider);
          expect(state.state, PlayerListState.error);
          expect(state.players, isEmpty);
          expect(state.errorMessage, '不正なレスポンスです。');
        },
      );

      test('予期しない例外が発生した場合、state が error になる。', () async {
        // 予期しない例外がスローされるスタブを用意する。
        when(
          mockGetPlayersUseCase.invoke(
            tournamentId: anyNamed('tournamentId'),
            status: anyNamed('status'),
          ),
        ).thenThrow(Exception('予期しないエラー'));

        final notifier = container.read(
          playerListNotifierProvider.notifier,
        );

        // loadPlayers メソッドを実行する。
        await notifier.loadPlayers(tournamentId: testTournamentId);

        // state が error に更新されていることを確認する。
        final state = container.read(playerListNotifierProvider);
        expect(state.state, PlayerListState.error);
        expect(state.players, isEmpty);
        expect(state.errorMessage, '予期しないエラーが発生しました');
      });
    });

    group('refreshPlayers メソッドのテスト。', () {
      const testTournamentId = 'test-tournament-id';

      test('refreshPlayers が loadPlayers を呼び出す。', () async {
        final testPlayers = [
          const Player(
            playerId: 'p_1',
            name: 'テストプレイヤー1',
            playerNumber: 1,
            status: 'ACTIVE',
            userId: 'user-1',
          ),
        ];

        // getPlayers メソッドが正常に完了するスタブを用意する。
        when(
          mockGetPlayersUseCase.invoke(
            tournamentId: anyNamed('tournamentId'),
            status: anyNamed('status'),
          ),
        ).thenAnswer((_) async => testPlayers);

        final notifier = container.read(
          playerListNotifierProvider.notifier,
        );

        // refreshPlayers メソッドを実行する。
        await notifier.refreshPlayers(tournamentId: testTournamentId);

        // state が loaded に更新されていることを確認する。
        final state = container.read(playerListNotifierProvider);
        expect(state.state, PlayerListState.loaded);
        expect(state.players, testPlayers);

        // UseCase の invoke メソッドが呼び出されることを確認する。
        verify(
          mockGetPlayersUseCase.invoke(
            tournamentId: testTournamentId,
            status: null,
          ),
        ).called(1);
      });

      test('refreshPlayers が status パラメータを渡す。', () async {
        final testPlayers = [
          const Player(
            playerId: 'p_1',
            name: 'テストプレイヤー1',
            playerNumber: 1,
            status: 'ACTIVE',
            userId: 'user-1',
          ),
        ];

        // getPlayers メソッドが正常に完了するスタブを用意する。
        when(
          mockGetPlayersUseCase.invoke(
            tournamentId: anyNamed('tournamentId'),
            status: anyNamed('status'),
          ),
        ).thenAnswer((_) async => testPlayers);

        final notifier = container.read(
          playerListNotifierProvider.notifier,
        );

        // refreshPlayers メソッドを実行する。
        await notifier.refreshPlayers(
          tournamentId: testTournamentId,
          status: 'ACTIVE',
        );

        // UseCase の invoke メソッドが正しい引数で呼び出されることを確認する。
        verify(
          mockGetPlayersUseCase.invoke(
            tournamentId: testTournamentId,
            status: 'ACTIVE',
          ),
        ).called(1);
      });
    });
  });
}
