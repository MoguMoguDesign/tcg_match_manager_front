import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injection/injection.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';

import 'add_player_use_case_test.mocks.dart';

// PlayerRepository のモッククラスを生成する。
@GenerateNiceMocks([MockSpec<PlayerRepository>()])
void main() {
  late MockPlayerRepository mockPlayerRepository;
  late AddPlayerUseCase useCase;

  setUp(() {
    mockPlayerRepository = MockPlayerRepository();
    useCase = AddPlayerUseCase(playerRepository: mockPlayerRepository);
  });

  group('addPlayerUseCaseProvider のテスト。', () {
    test('addPlayerUseCaseProvider が AddPlayerUseCase を返す。', () {
      final container = ProviderContainer(
        overrides: [
          playerRepositoryProvider.overrideWithValue(mockPlayerRepository),
        ],
      );

      final result = container.read(addPlayerUseCaseProvider);

      expect(result, isA<AddPlayerUseCase>());

      container.dispose();
    });
  });

  group('AddPlayerUseCase のテスト。', () {
    const testTournamentId = 'test-tournament-id';
    const testName = 'テストプレイヤー';
    const testPlayerNumber = 42;
    const testUserId = 'test-user-id';

    test('プレイヤー登録に成功した場合、Player を返す。', () async {
      const testPlayerModel = PlayerModel(
        playerId: 'p_1',
        name: testName,
        playerNumber: testPlayerNumber,
        status: 'ACTIVE',
        userId: testUserId,
      );

      // addPlayer メソッドが正常に完了するスタブを用意する。
      when(
        mockPlayerRepository.addPlayer(
          tournamentId: anyNamed('tournamentId'),
          request: anyNamed('request'),
        ),
      ).thenAnswer((_) async => testPlayerModel);

      // invoke メソッドを実行する。
      final result = await useCase.invoke(
        tournamentId: testTournamentId,
        name: testName,
        playerNumber: testPlayerNumber,
        userId: testUserId,
      );

      // 結果を確認する。
      expect(result, isA<Player>());
      expect(result.playerId, 'p_1');
      expect(result.name, testName);
      expect(result.playerNumber, testPlayerNumber);
      expect(result.status, 'ACTIVE');
      expect(result.userId, testUserId);

      // Repository の addPlayer が呼び出されることを確認する。
      verify(
        mockPlayerRepository.addPlayer(
          tournamentId: testTournamentId,
          request: anyNamed('request'),
        ),
      ).called(1);
    });

    test('AdminApiException (INVALID_RESPONSE) が発生した場合、 '
        'FailureStatusExceptionをスローする。', () async {
      const testErrorMessage = '無効なレスポンス';

      // AdminApiException をスローするスタブを用意する。
      when(
        mockPlayerRepository.addPlayer(
          tournamentId: anyNamed('tournamentId'),
          request: anyNamed('request'),
        ),
      ).thenThrow(
        const AdminApiException(
          code: 'INVALID_RESPONSE',
          message: testErrorMessage,
        ),
      );

      // invoke メソッドを実行し、例外がスローされることを確認する。
      expect(
        () => useCase.invoke(
          tournamentId: testTournamentId,
          name: testName,
          playerNumber: testPlayerNumber,
          userId: testUserId,
        ),
        throwsA(isA<FailureStatusException>()),
      );
    });

    test('AdminApiException (PARSE_ERROR) が発生した場合、 '
        'FailureStatusExceptionをスローする。', () async {
      const testErrorMessage = 'パースエラー';

      // AdminApiException をスローするスタブを用意する。
      when(
        mockPlayerRepository.addPlayer(
          tournamentId: anyNamed('tournamentId'),
          request: anyNamed('request'),
        ),
      ).thenThrow(
        const AdminApiException(code: 'PARSE_ERROR', message: testErrorMessage),
      );

      // invoke メソッドを実行し、例外がスローされることを確認する。
      expect(
        () => useCase.invoke(
          tournamentId: testTournamentId,
          name: testName,
          playerNumber: testPlayerNumber,
          userId: testUserId,
        ),
        throwsA(isA<FailureStatusException>()),
      );
    });

    test('AdminApiException (UNAUTHENTICATED) が発生した場合、 '
        'GeneralFailureExceptionをスローする。', () async {
      // AdminApiException をスローするスタブを用意する。
      when(
        mockPlayerRepository.addPlayer(
          tournamentId: anyNamed('tournamentId'),
          request: anyNamed('request'),
        ),
      ).thenThrow(
        const AdminApiException(code: 'UNAUTHENTICATED', message: '認証が必要です'),
      );

      // invoke メソッドを実行し、例外がスローされることを確認する。
      expect(
        () => useCase.invoke(
          tournamentId: testTournamentId,
          name: testName,
          playerNumber: testPlayerNumber,
          userId: testUserId,
        ),
        throwsA(isA<GeneralFailureException>()),
      );
    });

    test('AdminApiException (AUTH_ERROR) が発生した場合、 '
        'GeneralFailureExceptionをスローする。', () async {
      // AdminApiException をスローするスタブを用意する。
      when(
        mockPlayerRepository.addPlayer(
          tournamentId: anyNamed('tournamentId'),
          request: anyNamed('request'),
        ),
      ).thenThrow(
        const AdminApiException(code: 'AUTH_ERROR', message: '認証エラー'),
      );

      // invoke メソッドを実行し、例外がスローされることを確認する。
      expect(
        () => useCase.invoke(
          tournamentId: testTournamentId,
          name: testName,
          playerNumber: testPlayerNumber,
          userId: testUserId,
        ),
        throwsA(isA<GeneralFailureException>()),
      );
    });

    test('AdminApiException (NETWORK_ERROR) が発生した場合、 '
        'GeneralFailureException(noConnectionError)をスローする。', () async {
      // AdminApiException をスローするスタブを用意する。
      when(
        mockPlayerRepository.addPlayer(
          tournamentId: anyNamed('tournamentId'),
          request: anyNamed('request'),
        ),
      ).thenThrow(
        const AdminApiException(code: 'NETWORK_ERROR', message: 'ネットワークエラー'),
      );

      // invoke メソッドを実行する。
      try {
        await useCase.invoke(
          tournamentId: testTournamentId,
          name: testName,
          playerNumber: testPlayerNumber,
          userId: testUserId,
        );
        fail('例外がスローされるべき');
      } on GeneralFailureException catch (e) {
        expect(e.reason, GeneralFailureReason.noConnectionError);
      }
    });

    test('AdminApiException (その他) が発生した場合、 '
        'GeneralFailureExceptionをスローする。', () async {
      // AdminApiException をスローするスタブを用意する。
      when(
        mockPlayerRepository.addPlayer(
          tournamentId: anyNamed('tournamentId'),
          request: anyNamed('request'),
        ),
      ).thenThrow(
        const AdminApiException(code: 'UNKNOWN_ERROR', message: '不明なエラー'),
      );

      // invoke メソッドを実行し、例外がスローされることを確認する。
      expect(
        () => useCase.invoke(
          tournamentId: testTournamentId,
          name: testName,
          playerNumber: testPlayerNumber,
          userId: testUserId,
        ),
        throwsA(isA<GeneralFailureException>()),
      );
    });
  });
}
