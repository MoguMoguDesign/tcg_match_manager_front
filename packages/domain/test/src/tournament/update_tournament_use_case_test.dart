import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injection/injection.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:repository/repository.dart' as repository;
import 'package:riverpod/riverpod.dart';

import 'update_tournament_use_case_test.mocks.dart';

@GenerateMocks([repository.TournamentRepository])
void main() {
  late MockTournamentRepository mockRepository;

  setUp(() {
    mockRepository = MockTournamentRepository();
  });

  group('updateTournamentUseCaseProvider のテスト。', () {
    test('updateTournamentUseCaseProvider が UpdateTournamentUseCase を返す。', () {
      final container = ProviderContainer(
        overrides: [
          tournamentRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      final result = container.read(updateTournamentUseCaseProvider);

      expect(result, isA<UpdateTournamentUseCase>());

      container.dispose();
    });
  });

  group('UpdateTournamentUseCase', () {
    late UpdateTournamentUseCase useCase;

    setUp(() {
      useCase = UpdateTournamentUseCase(tournamentRepository: mockRepository);
    });

    group('invoke', () {
      const tournamentId = 'tournament-123';
      const mockModel = repository.TournamentModel(
        id: tournamentId,
        title: '更新後大会',
        description: '更新後説明',
        startDate: '2024-12-01T10:00:00Z',
        endDate: '2024-12-01T18:00:00Z',
        createdAt: '2024-12-01T09:00:00Z',
        updatedAt: '2024-12-01T10:00:00Z',
      );

      test('トーナメント更新が成功する場合（すべてのパラメータ指定）', () async {
        // Arrange
        // ステータスチェック用のgetTournamentをスタブする。
        when(
          mockRepository.getTournament(tournamentId),
        ).thenAnswer((_) async => mockModel.copyWith(status: 'PREPARING'));

        when(
          mockRepository.updateTournament(tournamentId, any),
        ).thenAnswer((_) async => mockModel);

        // Act
        final result = await useCase.invoke(
          id: tournamentId,
          name: '更新後大会',
          overview: '更新後説明',
          category: 'ポケモンカード',
          date: '2024-12-01',
          remarks: '備考',
        );

        // Assert
        expect(result, isA<Tournament>());
        expect(result.id, tournamentId);
        expect(result.title, '更新後大会');
        verify(mockRepository.getTournament(tournamentId)).called(1);
        verify(mockRepository.updateTournament(tournamentId, any)).called(1);
      });

      test('トーナメント更新が成功する場合（一部のパラメータのみ指定）', () async {
        // Arrange
        // ステータスチェック用のgetTournamentをスタブする。
        when(
          mockRepository.getTournament(tournamentId),
        ).thenAnswer((_) async => mockModel.copyWith(status: 'IN_PROGRESS'));

        when(
          mockRepository.updateTournament(tournamentId, any),
        ).thenAnswer((_) async => mockModel);

        // Act
        final result = await useCase.invoke(id: tournamentId, name: '更新後大会');

        // Assert
        expect(result, isA<Tournament>());
        expect(result.id, tournamentId);

        verify(mockRepository.getTournament(tournamentId)).called(1);

        final captured =
            verify(
                  mockRepository.updateTournament(tournamentId, captureAny),
                ).captured.single
                as repository.UpdateTournamentRequest;

        expect(captured.name, '更新後大会');
        expect(captured.overview, null);
        expect(captured.category, null);
        expect(captured.date, null);
        expect(captured.remarks, null);
      });

      test('Tournament.fromModel 変換が正しく行われる', () async {
        // Arrange
        // ステータスチェック用のgetTournamentをスタブする。
        when(
          mockRepository.getTournament(tournamentId),
        ).thenAnswer((_) async => mockModel.copyWith(status: 'PREPARING'));

        when(
          mockRepository.updateTournament(tournamentId, any),
        ).thenAnswer((_) async => mockModel);

        // Act
        final result = await useCase.invoke(id: tournamentId, name: '更新後大会');

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

      test('COMPLETED ステータスの場合、FailureStatusException をスローする', () async {
        // Arrange
        when(
          mockRepository.getTournament(tournamentId),
        ).thenAnswer((_) async => mockModel.copyWith(status: 'COMPLETED'));

        // Act & Assert
        expect(
          () => useCase.invoke(id: tournamentId, name: 'テスト'),
          throwsA(
            isA<FailureStatusException>().having(
              (e) => e.message,
              'message',
              '完了済みの大会は更新できません',
            ),
          ),
        );
        verify(mockRepository.getTournament(tournamentId)).called(1);
        verifyNever(mockRepository.updateTournament(any, any));
      });

      test('CANCELLED ステータスの場合、FailureStatusException をスローする', () async {
        // Arrange
        when(
          mockRepository.getTournament(tournamentId),
        ).thenAnswer((_) async => mockModel.copyWith(status: 'CANCELLED'));

        // Act & Assert
        expect(
          () => useCase.invoke(id: tournamentId, name: 'テスト'),
          throwsA(
            isA<FailureStatusException>().having(
              (e) => e.message,
              'message',
              'キャンセル済みの大会は更新できません',
            ),
          ),
        );
        verify(mockRepository.getTournament(tournamentId)).called(1);
        verifyNever(mockRepository.updateTournament(any, any));
      });

      test('INVALID_ARGUMENT エラーの場合、FailureStatusException をスローする', () async {
        // Arrange
        when(
          mockRepository.getTournament(tournamentId),
        ).thenAnswer((_) async => mockModel.copyWith(status: 'PREPARING'));
        when(mockRepository.updateTournament(tournamentId, any)).thenThrow(
          const repository.AdminApiException(
            code: 'INVALID_ARGUMENT',
            message: '不正な引数です',
          ),
        );

        // Act & Assert
        expect(
          () => useCase.invoke(id: tournamentId, name: 'テスト'),
          throwsA(
            isA<FailureStatusException>().having(
              (e) => e.message,
              'message',
              '不正な引数です',
            ),
          ),
        );
      });

      test('PARSE_ERROR エラーの場合、FailureStatusException をスローする', () async {
        // Arrange
        when(
          mockRepository.getTournament(tournamentId),
        ).thenAnswer((_) async => mockModel.copyWith(status: 'PREPARING'));
        when(mockRepository.updateTournament(tournamentId, any)).thenThrow(
          const repository.AdminApiException(
            code: 'PARSE_ERROR',
            message: 'パースエラー',
          ),
        );

        // Act & Assert
        expect(
          () => useCase.invoke(id: tournamentId, name: 'テスト'),
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
        when(
          mockRepository.getTournament(tournamentId),
        ).thenAnswer((_) async => mockModel.copyWith(status: 'PREPARING'));
        when(mockRepository.updateTournament(tournamentId, any)).thenThrow(
          const repository.AdminApiException(
            code: 'NOT_FOUND',
            message: 'トーナメントが見つかりません',
          ),
        );

        // Act & Assert
        expect(
          () => useCase.invoke(id: tournamentId, name: 'テスト'),
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
        when(
          mockRepository.getTournament(tournamentId),
        ).thenAnswer((_) async => mockModel.copyWith(status: 'PREPARING'));
        when(mockRepository.updateTournament(tournamentId, any)).thenThrow(
          const repository.AdminApiException(
            code: 'UNAUTHENTICATED',
            message: '認証エラー',
          ),
        );

        // Act & Assert
        expect(
          () => useCase.invoke(id: tournamentId, name: 'テスト'),
          throwsA(
            isA<GeneralFailureException>()
                .having((e) => e.reason, 'reason', GeneralFailureReason.other)
                .having((e) => e.errorCode, 'errorCode', 'UNAUTHENTICATED'),
          ),
        );
      });

      test('AUTH_ERROR エラーの場合、GeneralFailureException をスローする', () async {
        // Arrange
        when(
          mockRepository.getTournament(tournamentId),
        ).thenAnswer((_) async => mockModel.copyWith(status: 'PREPARING'));
        when(mockRepository.updateTournament(tournamentId, any)).thenThrow(
          const repository.AdminApiException(
            code: 'AUTH_ERROR',
            message: '認証エラー',
          ),
        );

        // Act & Assert
        expect(
          () => useCase.invoke(id: tournamentId, name: 'テスト'),
          throwsA(
            isA<GeneralFailureException>()
                .having((e) => e.reason, 'reason', GeneralFailureReason.other)
                .having((e) => e.errorCode, 'errorCode', 'AUTH_ERROR'),
          ),
        );
      });

      test('NETWORK_ERROR エラーの場合、GeneralFailureException をスローする', () async {
        // Arrange
        when(
          mockRepository.getTournament(tournamentId),
        ).thenAnswer((_) async => mockModel.copyWith(status: 'PREPARING'));
        when(mockRepository.updateTournament(tournamentId, any)).thenThrow(
          const repository.AdminApiException(
            code: 'NETWORK_ERROR',
            message: 'ネットワークエラー',
          ),
        );

        // Act & Assert
        expect(
          () => useCase.invoke(id: tournamentId, name: 'テスト'),
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
        when(
          mockRepository.getTournament(tournamentId),
        ).thenAnswer((_) async => mockModel.copyWith(status: 'PREPARING'));
        when(mockRepository.updateTournament(tournamentId, any)).thenThrow(
          const repository.AdminApiException(
            code: 'UNKNOWN_ERROR',
            message: '不明なエラー',
          ),
        );

        // Act & Assert
        expect(
          () => useCase.invoke(id: tournamentId, name: 'テスト'),
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
