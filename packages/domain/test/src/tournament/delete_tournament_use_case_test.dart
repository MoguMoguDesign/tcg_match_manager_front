import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injection/injection.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:repository/repository.dart' as repository;
import 'package:riverpod/riverpod.dart';

import 'delete_tournament_use_case_test.mocks.dart';

@GenerateMocks([repository.TournamentRepository])
void main() {
  late MockTournamentRepository mockRepository;

  setUp(() {
    mockRepository = MockTournamentRepository();
  });

  group('deleteTournamentUseCaseProvider のテスト。', () {
    test('deleteTournamentUseCaseProvider が DeleteTournamentUseCase を返す。', () {
      final container = ProviderContainer(
        overrides: [
          tournamentRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      final result = container.read(deleteTournamentUseCaseProvider);

      expect(result, isA<DeleteTournamentUseCase>());

      container.dispose();
    });
  });

  group('DeleteTournamentUseCase', () {
    late DeleteTournamentUseCase useCase;

    setUp(() {
      useCase = DeleteTournamentUseCase(tournamentRepository: mockRepository);
    });

    group('invoke', () {
      const tournamentId = 'tournament-123';

      test('トーナメント削除が成功する場合', () async {
        // Arrange
        when(
          mockRepository.deleteTournament(tournamentId),
        ).thenAnswer((_) async => Future<void>.value());

        // Act
        await useCase.invoke(id: tournamentId);

        // Assert
        verify(mockRepository.deleteTournament(tournamentId)).called(1);
      });

      test('INVALID_ARGUMENT エラーの場合、FailureStatusException をスローする', () async {
        // Arrange
        when(mockRepository.deleteTournament(tournamentId)).thenThrow(
          const repository.AdminApiException(
            code: 'INVALID_ARGUMENT',
            message: '不正なIDです',
          ),
        );

        // Act & Assert
        expect(
          () => useCase.invoke(id: tournamentId),
          throwsA(
            isA<FailureStatusException>().having(
              (e) => e.message,
              'message',
              '不正なIDです',
            ),
          ),
        );
      });

      test('NOT_FOUND エラーの場合、FailureStatusException をスローする', () async {
        // Arrange
        when(mockRepository.deleteTournament(tournamentId)).thenThrow(
          const repository.AdminApiException(
            code: 'NOT_FOUND',
            message: 'トーナメントが見つかりません',
          ),
        );

        // Act & Assert
        expect(
          () => useCase.invoke(id: tournamentId),
          throwsA(
            isA<FailureStatusException>().having(
              (e) => e.message,
              'message',
              '指定されたトーナメントが見つかりません',
            ),
          ),
        );
      });

      test('CONFLICT エラーの場合、FailureStatusException をスローする', () async {
        // Arrange
        when(mockRepository.deleteTournament(tournamentId)).thenThrow(
          const repository.AdminApiException(
            code: 'CONFLICT',
            message: '競合が発生しました',
          ),
        );

        // Act & Assert
        expect(
          () => useCase.invoke(id: tournamentId),
          throwsA(
            isA<FailureStatusException>().having(
              (e) => e.message,
              'message',
              '削除できません: 競合が発生しました',
            ),
          ),
        );
      });

      test('TOURNAMENT_HAS_ACTIVE_MATCHES エラーの場合、 '
          'FailureStatusException をスローする', () async {
        // Arrange
        when(mockRepository.deleteTournament(tournamentId)).thenThrow(
          const repository.AdminApiException(
            code: 'TOURNAMENT_HAS_ACTIVE_MATCHES',
            message: 'アクティブなマッチがあります',
          ),
        );

        // Act & Assert
        expect(
          () => useCase.invoke(id: tournamentId),
          throwsA(
            isA<FailureStatusException>().having(
              (e) => e.message,
              'message',
              '削除できません: アクティブなマッチがあります',
            ),
          ),
        );
      });

      test(
        'BUSINESS_RULE_VIOLATION エラーの場合、FailureStatusException をスローする',
        () async {
          // Arrange
          when(mockRepository.deleteTournament(tournamentId)).thenThrow(
            const repository.AdminApiException(
              code: 'BUSINESS_RULE_VIOLATION',
              message: 'ビジネスルール違反',
            ),
          );

          // Act & Assert
          expect(
            () => useCase.invoke(id: tournamentId),
            throwsA(
              isA<FailureStatusException>().having(
                (e) => e.message,
                'message',
                '削除できません: ビジネスルール違反',
              ),
            ),
          );
        },
      );

      test('UNAUTHENTICATED エラーの場合、GeneralFailureException をスローする', () async {
        // Arrange
        when(mockRepository.deleteTournament(tournamentId)).thenThrow(
          const repository.AdminApiException(
            code: 'UNAUTHENTICATED',
            message: '認証エラー',
          ),
        );

        // Act & Assert
        expect(
          () => useCase.invoke(id: tournamentId),
          throwsA(
            isA<GeneralFailureException>()
                .having((e) => e.reason, 'reason', GeneralFailureReason.other)
                .having((e) => e.errorCode, 'errorCode', 'UNAUTHENTICATED'),
          ),
        );
      });

      test('AUTH_ERROR エラーの場合、GeneralFailureException をスローする', () async {
        // Arrange
        when(mockRepository.deleteTournament(tournamentId)).thenThrow(
          const repository.AdminApiException(
            code: 'AUTH_ERROR',
            message: '認証エラー',
          ),
        );

        // Act & Assert
        expect(
          () => useCase.invoke(id: tournamentId),
          throwsA(
            isA<GeneralFailureException>()
                .having((e) => e.reason, 'reason', GeneralFailureReason.other)
                .having((e) => e.errorCode, 'errorCode', 'AUTH_ERROR'),
          ),
        );
      });

      test('NETWORK_ERROR エラーの場合、GeneralFailureException をスローする', () async {
        // Arrange
        when(mockRepository.deleteTournament(tournamentId)).thenThrow(
          const repository.AdminApiException(
            code: 'NETWORK_ERROR',
            message: 'ネットワークエラー',
          ),
        );

        // Act & Assert
        expect(
          () => useCase.invoke(id: tournamentId),
          throwsA(
            isA<GeneralFailureException>()
                .having(
                  (e) => e.reason,
                  'reason',
                  GeneralFailureReason.noConnectionError,
                )
                .having((e) => e.errorCode, 'errorCode', 'NETWORK_ERROR'),
          ),
        );
      });

      test('その他のエラーの場合、GeneralFailureException をスローする', () async {
        // Arrange
        when(mockRepository.deleteTournament(tournamentId)).thenThrow(
          const repository.AdminApiException(
            code: 'UNKNOWN_ERROR',
            message: '不明なエラー',
          ),
        );

        // Act & Assert
        expect(
          () => useCase.invoke(id: tournamentId),
          throwsA(
            isA<GeneralFailureException>()
                .having((e) => e.reason, 'reason', GeneralFailureReason.other)
                .having((e) => e.errorCode, 'errorCode', 'UNKNOWN_ERROR'),
          ),
        );
      });
    });
  });
}
