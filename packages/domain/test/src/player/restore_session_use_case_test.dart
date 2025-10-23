import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';

import 'restore_session_use_case_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ValidatePlayerUseCase>(),
])
void main() {
  late MockValidatePlayerUseCase mockValidatePlayerUseCase;
  late ProviderContainer container;

  setUp(() {
    mockValidatePlayerUseCase = MockValidatePlayerUseCase();
    container = ProviderContainer(
      overrides: [
        // 依存する validatePlayerUseCaseProvider をモックで上書きする。
        validatePlayerUseCaseProvider
            .overrideWithValue(mockValidatePlayerUseCase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('restoreSessionUseCaseProvider のテスト。', () {
    test('restoreSessionUseCaseProvider が RestoreSessionUseCase を返す。', () {
      expect(
        container.read(restoreSessionUseCaseProvider),
        isA<RestoreSessionUseCase>(),
      );
    });
  });

  group('RestoreSessionUseCase のテスト。', () {
    group('invoke メソッドのテスト。', () {
      /// セッション復旧を行う。
      Future<PlayerSession> restoreSession(PlayerSession currentSession) async {
        final useCase = container.read(restoreSessionUseCaseProvider);
        return useCase.invoke(
          baseUrl: 'https://example.com/',
          currentSession: currentSession,
        );
      }

      group('成功シナリオ。', () {
        test('セッション有効期限内で認証成功した場合、PlayerSession オブジェクトを返す。', () async {
          final now = DateTime.now();
          final validSession = PlayerSession(
            playerId: 'player123',
            playerNumber: 5,
            userId: 'user456',
            tournamentId: 'tournament123',
            playerName: 'テストプレイヤー',
            createdAt: now.subtract(const Duration(hours: 1)),
            expiresAt: now.add(const Duration(hours: 23)),
          );

          // ValidatePlayerUseCase が認証成功を返すスタブを用意する。
          final newSession = PlayerSession(
            playerId: 'player123',
            playerNumber: 5,
            userId: 'user456',
            tournamentId: 'tournament123',
            playerName: 'テストプレイヤー',
            createdAt: now,
            expiresAt: now.add(const Duration(hours: 24)),
          );
          when(
            mockValidatePlayerUseCase.invoke(
              baseUrl: anyNamed('baseUrl'),
              tournamentId: anyNamed('tournamentId'),
              userId: anyNamed('userId'),
            ),
          ).thenAnswer((_) async => newSession);

          // セッション復旧処理を実行後、返り値が PlayerSession オブジェクトであることを確認する。
          final session = await restoreSession(validSession);
          expect(session, isA<PlayerSession>());

          // PlayerSession の値を確認する。
          expect(session.playerId, 'player123');
          expect(session.userId, 'user456');
          expect(session.tournamentId, 'tournament123');
          expect(session.playerName, 'テストプレイヤー');

          // ValidatePlayerUseCase が正しい引数で呼び出されることを確認する。
          verify(
            mockValidatePlayerUseCase.invoke(
              baseUrl: 'https://example.com/',
              tournamentId: 'tournament123',
              userId: 'user456',
            ),
          ).called(1);
        });
      });

      group('失敗シナリオ。', () {
        test('セッション有効期限切れの場合、GeneralFailureException がスローされる。', () async {
          final now = DateTime.now();
          final expiredSession = PlayerSession(
            playerId: 'player123',
            playerNumber: 5,
            userId: 'user456',
            tournamentId: 'tournament123',
            playerName: 'テストプレイヤー',
            createdAt: now.subtract(const Duration(hours: 25)),
            expiresAt: now.subtract(const Duration(hours: 1)),
          );

          // セッション復旧処理の実行時、GeneralFailureException がスローされることを確認する。
          expect(
            () => restoreSession(expiredSession),
            throwsA(
              isA<GeneralFailureException>().having(
                (e) => e.reason,
                '失敗理由には sessionExpired が設定される。',
                GeneralFailureReason.sessionExpired,
              ),
            ),
          );

          // ValidatePlayerUseCase は呼び出されないことを確認する。
          verifyNever(
            mockValidatePlayerUseCase.invoke(
              baseUrl: anyNamed('baseUrl'),
              tournamentId: anyNamed('tournamentId'),
              userId: anyNamed('userId'),
            ),
          );
        });

        test('ValidatePlayerUseCase で例外が発生した場合、例外がリスローされる。', () async {
          final now = DateTime.now();
          final validSession = PlayerSession(
            playerId: 'player123',
            playerNumber: 5,
            userId: 'user456',
            tournamentId: 'tournament123',
            playerName: 'テストプレイヤー',
            createdAt: now.subtract(const Duration(hours: 1)),
            expiresAt: now.add(const Duration(hours: 23)),
          );

          final testException = GeneralFailureException(
            reason: GeneralFailureReason.noConnectionError,
            errorCode: 'noConnection',
          );

          // ValidatePlayerUseCase が例外をスローするスタブを用意する。
          when(
            mockValidatePlayerUseCase.invoke(
              baseUrl: anyNamed('baseUrl'),
              tournamentId: anyNamed('tournamentId'),
              userId: anyNamed('userId'),
            ),
          ).thenThrow(testException);

          // セッション復旧処理の実行時、例外がリスローされることを確認する。
          await expectLater(
            restoreSession(validSession),
            throwsA(testException),
          );

          // ValidatePlayerUseCase が呼び出されることを確認する。
          verify(
            mockValidatePlayerUseCase.invoke(
              baseUrl: 'https://example.com/',
              tournamentId: 'tournament123',
              userId: 'user456',
            ),
          ).called(1);
        });
      });
    });
  });
}
