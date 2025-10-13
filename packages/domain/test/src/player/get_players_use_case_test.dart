import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:repository/repository.dart';

import 'get_players_use_case_test.mocks.dart';

// PlayerRepository のモッククラスを生成する。
@GenerateNiceMocks([MockSpec<PlayerRepository>()])
void main() {
  late MockPlayerRepository mockPlayerRepository;
  late GetPlayersUseCase useCase;

  setUp(() {
    mockPlayerRepository = MockPlayerRepository();
    useCase = GetPlayersUseCase(playerRepository: mockPlayerRepository);
  });

  group('GetPlayersUseCase のテスト。', () {
    const testTournamentId = 'test-tournament-id';

    test('プレイヤー一覧の取得に成功した場合、Player のリストを返す。', () async {
      final testPlayerModels = [
        const PlayerModel(
          playerId: 'p_1',
          name: 'テストプレイヤー1',
          playerNumber: 1,
          status: 'ACTIVE',
          userId: 'user-1',
        ),
        const PlayerModel(
          playerId: 'p_2',
          name: 'テストプレイヤー2',
          playerNumber: 2,
          status: 'ACTIVE',
          userId: 'user-2',
        ),
      ];

      // getPlayers メソッドが正常に完了するスタブを用意する。
      when(
        mockPlayerRepository.getPlayers(
          tournamentId: anyNamed('tournamentId'),
          status: anyNamed('status'),
        ),
      ).thenAnswer((_) async => testPlayerModels);

      // invoke メソッドを実行する。
      final result = await useCase.invoke(
        tournamentId: testTournamentId,
      );

      // 結果を確認する。
      expect(result, isA<List<Player>>());
      expect(result.length, 2);
      expect(result[0].playerId, 'p_1');
      expect(result[0].name, 'テストプレイヤー1');
      expect(result[1].playerId, 'p_2');
      expect(result[1].name, 'テストプレイヤー2');

      // Repository の getPlayers が呼び出されることを確認する。
      verify(
        mockPlayerRepository.getPlayers(
          tournamentId: testTournamentId,
        ),
      ).called(1);
    });

    test('status パラメータを指定した場合、正しく動作する。', () async {
      final testPlayerModels = [
        const PlayerModel(
          playerId: 'p_1',
          name: 'テストプレイヤー1',
          playerNumber: 1,
          status: 'ACTIVE',
          userId: 'user-1',
        ),
      ];

      // getPlayers メソッドが正常に完了するスタブを用意する。
      when(
        mockPlayerRepository.getPlayers(
          tournamentId: anyNamed('tournamentId'),
          status: anyNamed('status'),
        ),
      ).thenAnswer((_) async => testPlayerModels);

      // invoke メソッドを実行する。
      final result = await useCase.invoke(
        tournamentId: testTournamentId,
        status: 'ACTIVE',
      );

      // 結果を確認する。
      expect(result, isA<List<Player>>());
      expect(result.length, 1);

      // Repository の getPlayers が正しい引数で呼び出されることを確認する。
      verify(
        mockPlayerRepository.getPlayers(
          tournamentId: testTournamentId,
          status: 'ACTIVE',
        ),
      ).called(1);
    });

    test('空のプレイヤー一覧を取得した場合、空のリストを返す。', () async {
      // getPlayers メソッドが空リストを返すスタブを用意する。
      when(
        mockPlayerRepository.getPlayers(
          tournamentId: anyNamed('tournamentId'),
          status: anyNamed('status'),
        ),
      ).thenAnswer((_) async => []);

      // invoke メソッドを実行する。
      final result = await useCase.invoke(
        tournamentId: testTournamentId,
      );

      // 結果を確認する。
      expect(result, isA<List<Player>>());
      expect(result, isEmpty);
    });

    test(
      'AdminApiException (PARSE_ERROR) が発生した場合、 '
      'FailureStatusExceptionをスローする。',
      () async {
      const testErrorMessage = 'パースエラー';

      // AdminApiException をスローするスタブを用意する。
      when(
        mockPlayerRepository.getPlayers(
          tournamentId: anyNamed('tournamentId'),
          status: anyNamed('status'),
        ),
      ).thenThrow(
        const AdminApiException(
          code: 'PARSE_ERROR',
          message: testErrorMessage,
        ),
      );

      // invoke メソッドを実行し、例外がスローされることを確認する。
      expect(
        () => useCase.invoke(
          tournamentId: testTournamentId,
        ),
        throwsA(isA<FailureStatusException>()),
      );
    });

    test(
      'AdminApiException (UNAUTHENTICATED) が発生した場合、 '
      'GeneralFailureExceptionをスローする。',
      () async {
      // AdminApiException をスローするスタブを用意する。
      when(
        mockPlayerRepository.getPlayers(
          tournamentId: anyNamed('tournamentId'),
          status: anyNamed('status'),
        ),
      ).thenThrow(
        const AdminApiException(
          code: 'UNAUTHENTICATED',
          message: '未認証',
        ),
      );

      // invoke メソッドを実行し、例外がスローされることを確認する。
      expect(
        () => useCase.invoke(
          tournamentId: testTournamentId,
        ),
        throwsA(isA<GeneralFailureException>()),
      );
    });

    test(
      'AdminApiException (NETWORK_ERROR) が発生した場合、 '
      'GeneralFailureException(noConnectionError)をスローする。',
      () async {
      // AdminApiException をスローするスタブを用意する。
      when(
        mockPlayerRepository.getPlayers(
          tournamentId: anyNamed('tournamentId'),
          status: anyNamed('status'),
        ),
      ).thenThrow(
        const AdminApiException(
          code: 'NETWORK_ERROR',
          message: 'ネットワークエラー',
        ),
      );

      // invoke メソッドを実行する。
      try {
        await useCase.invoke(
          tournamentId: testTournamentId,
        );
        fail('例外がスローされるべき');
      } on GeneralFailureException catch (e) {
        expect(e.reason, GeneralFailureReason.noConnectionError);
      }
    });

    test(
      'AdminApiException (その他) が発生した場合、 '
      'GeneralFailureExceptionをスローする。',
      () async {
      // AdminApiException をスローするスタブを用意する。
      when(
        mockPlayerRepository.getPlayers(
          tournamentId: anyNamed('tournamentId'),
          status: anyNamed('status'),
        ),
      ).thenThrow(
        const AdminApiException(
          code: 'SERVER_ERROR',
          message: 'サーバーエラー',
        ),
      );

      // invoke メソッドを実行し、例外がスローされることを確認する。
      expect(
        () => useCase.invoke(
          tournamentId: testTournamentId,
        ),
        throwsA(isA<GeneralFailureException>()),
      );
    });
  });
}
