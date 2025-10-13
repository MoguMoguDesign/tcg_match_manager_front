import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injection/injection.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';

import 'get_tournaments_use_case_test.mocks.dart';

@GenerateMocks([TournamentRepository])
void main() {
  late MockTournamentRepository mockRepository;

  setUp(() {
    mockRepository = MockTournamentRepository();
  });

  group('getTournamentsUseCaseProvider のテスト。', () {
    test('getTournamentsUseCaseProvider が GetTournamentsUseCase を返す。', () {
      final container = ProviderContainer(
        overrides: [
          tournamentRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      final result = container.read(getTournamentsUseCaseProvider);

      expect(result, isA<GetTournamentsUseCase>());

      container.dispose();
    });
  });

  group('GetTournamentsUseCase', () {
    late GetTournamentsUseCase useCase;

    setUp(() {
      useCase = GetTournamentsUseCase(
        tournamentRepository: mockRepository,
      );
    });

    group('invoke', () {
      const mockModel1 = TournamentModel(
        id: 'tournament-1',
        title: 'テスト大会1',
        description: 'テスト説明1',
        venue: 'テスト会場1',
        startDate: '2024-12-01T10:00:00Z',
        endDate: '2024-12-01T18:00:00Z',
        createdAt: '2024-12-01T09:00:00Z',
        updatedAt: '2024-12-01T09:00:00Z',
      );

      const mockModel2 = TournamentModel(
        id: 'tournament-2',
        title: 'テスト大会2',
        description: 'テスト説明2',
        venue: 'テスト会場2',
        startDate: '2024-12-02T10:00:00Z',
        endDate: '2024-12-02T18:00:00Z',
        createdAt: '2024-12-02T09:00:00Z',
        updatedAt: '2024-12-02T09:00:00Z',
      );

      test('トーナメント一覧取得が成功する場合', () async {
        // Arrange
        when(mockRepository.getTournaments())
            .thenAnswer((_) async => [mockModel1, mockModel2]);

        // Act
        final result = await useCase.invoke();

        // Assert
        expect(result, hasLength(2));
        expect(result[0].id, 'tournament-1');
        expect(result[0].title, 'テスト大会1');
        expect(result[1].id, 'tournament-2');
        expect(result[1].title, 'テスト大会2');
        verify(mockRepository.getTournaments()).called(1);
      });

      test('空のリストが返される場合', () async {
        // Arrange
        when(mockRepository.getTournaments())
            .thenAnswer((_) async => []);

        // Act
        final result = await useCase.invoke();

        // Assert
        expect(result, isEmpty);
        verify(mockRepository.getTournaments()).called(1);
      });

      test('複数件のトーナメントが正しく変換される', () async {
        // Arrange
        when(mockRepository.getTournaments())
            .thenAnswer((_) async => [mockModel1, mockModel2]);

        // Act
        final result = await useCase.invoke();

        // Assert
        expect(result, everyElement(isA<Tournament>()));
        expect(result[0].id, mockModel1.id);
        expect(result[0].title, mockModel1.title);
        expect(result[1].id, mockModel2.id);
        expect(result[1].title, mockModel2.title);
      });

      test('INVALID_RESPONSE エラーの場合、FailureStatusException をスローする',
          () async {
        // Arrange
        when(mockRepository.getTournaments())
            .thenThrow(
          const AdminApiException(
            code: 'INVALID_RESPONSE',
            message: '不正なレスポンス',
          ),
        );

        // Act & Assert
        expect(
          () => useCase.invoke(),
          throwsA(
            isA<FailureStatusException>()
                .having((e) => e.message, 'message', '不正なレスポンス'),
          ),
        );
      });

      test('PARSE_ERROR エラーの場合、FailureStatusException をスローする', () async {
        // Arrange
        when(mockRepository.getTournaments())
            .thenThrow(
          const AdminApiException(
            code: 'PARSE_ERROR',
            message: 'パースエラー',
          ),
        );

        // Act & Assert
        expect(
          () => useCase.invoke(),
          throwsA(
            isA<FailureStatusException>()
                .having((e) => e.message, 'message', 'パースエラー'),
          ),
        );
      });

      test('UNAUTHENTICATED エラーの場合、GeneralFailureException をスローする',
          () async {
        // Arrange
        when(mockRepository.getTournaments())
            .thenThrow(
          const AdminApiException(
            code: 'UNAUTHENTICATED',
            message: '認証エラー',
          ),
        );

        // Act & Assert
        expect(
          () => useCase.invoke(),
          throwsA(
            isA<GeneralFailureException>()
                .having((e) => e.reason, 'reason', GeneralFailureReason.other)
                .having((e) => e.errorCode, 'errorCode', 'UNAUTHENTICATED'),
          ),
        );
      });

      test('AUTH_ERROR エラーの場合、GeneralFailureException をスローする', () async {
        // Arrange
        when(mockRepository.getTournaments())
            .thenThrow(
          const AdminApiException(
            code: 'AUTH_ERROR',
            message: '認証エラー',
          ),
        );

        // Act & Assert
        expect(
          () => useCase.invoke(),
          throwsA(
            isA<GeneralFailureException>()
                .having((e) => e.reason, 'reason', GeneralFailureReason.other)
                .having((e) => e.errorCode, 'errorCode', 'AUTH_ERROR'),
          ),
        );
      });

      test('NETWORK_ERROR エラーの場合、GeneralFailureException をスローする',
          () async {
        // Arrange
        when(mockRepository.getTournaments())
            .thenThrow(
          const AdminApiException(
            code: 'NETWORK_ERROR',
            message: 'ネットワークエラー',
          ),
        );

        // Act & Assert
        expect(
          () => useCase.invoke(),
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
        when(mockRepository.getTournaments())
            .thenThrow(
          const AdminApiException(
            code: 'UNKNOWN_ERROR',
            message: '不明なエラー',
          ),
        );

        // Act & Assert
        expect(
          () => useCase.invoke(),
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
