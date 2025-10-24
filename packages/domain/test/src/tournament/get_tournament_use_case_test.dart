import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injection/injection.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';

import 'get_tournament_use_case_test.mocks.dart';

@GenerateMocks([TournamentRepository])
void main() {
  late MockTournamentRepository mockRepository;

  setUp(() {
    mockRepository = MockTournamentRepository();
  });

  group('getTournamentUseCaseProvider のテスト。', () {
    test('getTournamentUseCaseProvider が GetTournamentUseCase を返す。', () {
      final container = ProviderContainer(
        overrides: [
          tournamentRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      final result = container.read(getTournamentUseCaseProvider);

      expect(result, isA<GetTournamentUseCase>());

      container.dispose();
    });
  });

  group('GetTournamentUseCase', () {
    late GetTournamentUseCase useCase;

    setUp(() {
      useCase = GetTournamentUseCase(tournamentRepository: mockRepository);
    });

    group('invoke', () {
      const tournamentId = 'tournament-123';
      const mockModel = TournamentModel(
        id: tournamentId,
        title: 'テスト大会',
        description: 'テスト説明',
        startDate: '2024-12-01T10:00:00Z',
        endDate: '2024-12-01T18:00:00Z',
        createdAt: '2024-12-01T09:00:00Z',
        updatedAt: '2024-12-01T09:00:00Z',
      );

      test('トーナメント詳細取得が成功する場合', () async {
        // Arrange
        when(
          mockRepository.getTournament(tournamentId),
        ).thenAnswer((_) async => mockModel);

        // Act
        final result = await useCase.invoke(id: tournamentId);

        // Assert
        expect(result.id, tournamentId);
        expect(result.title, 'テスト大会');
        expect(result.description, 'テスト説明');
        expect(result.tournamentMode, 'FIXED_ROUNDS');
        verify(mockRepository.getTournament(tournamentId)).called(1);
      });

      test('Tournament.fromModel 変換が正しく行われる', () async {
        // Arrange
        when(
          mockRepository.getTournament(tournamentId),
        ).thenAnswer((_) async => mockModel);

        // Act
        final result = await useCase.invoke(id: tournamentId);

        // Assert
        expect(result, isA<Tournament>());
        expect(result.id, mockModel.id);
        expect(result.title, mockModel.title);
        expect(result.description, mockModel.description);
        expect(result.tournamentMode, mockModel.tournamentMode);
        expect(result.startDate, mockModel.startDate);
        expect(result.endDate, mockModel.endDate);
        expect(result.createdAt, mockModel.createdAt);
        expect(result.updatedAt, mockModel.updatedAt);
      });

      test('INVALID_ARGUMENT エラーの場合、FailureStatusException をスローする', () async {
        // Arrange
        when(mockRepository.getTournament(tournamentId)).thenThrow(
          const AdminApiException(code: 'INVALID_ARGUMENT', message: '不正なIDです'),
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

      test('PARSE_ERROR エラーの場合、FailureStatusException をスローする', () async {
        // Arrange
        when(mockRepository.getTournament(tournamentId)).thenThrow(
          const AdminApiException(code: 'PARSE_ERROR', message: 'パースエラー'),
        );

        // Act & Assert
        expect(
          () => useCase.invoke(id: tournamentId),
          throwsA(
            isA<FailureStatusException>().having(
              (e) => e.message,
              'message',
              'パースエラー',
            ),
          ),
        );
      });

      test('NOT_FOUND エラーの場合、FailureStatusException をスローする', () async {
        // Arrange
        when(mockRepository.getTournament(tournamentId)).thenThrow(
          const AdminApiException(code: 'NOT_FOUND', message: 'トーナメントが見つかりません'),
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

      test('UNAUTHENTICATED エラーの場合、GeneralFailureException をスローする', () async {
        // Arrange
        when(mockRepository.getTournament(tournamentId)).thenThrow(
          const AdminApiException(code: 'UNAUTHENTICATED', message: '認証エラー'),
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
        when(mockRepository.getTournament(tournamentId)).thenThrow(
          const AdminApiException(code: 'AUTH_ERROR', message: '認証エラー'),
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
        when(mockRepository.getTournament(tournamentId)).thenThrow(
          const AdminApiException(code: 'NETWORK_ERROR', message: 'ネットワークエラー'),
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
        when(mockRepository.getTournament(tournamentId)).thenThrow(
          const AdminApiException(code: 'UNKNOWN_ERROR', message: '不明なエラー'),
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
