import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injection/injection.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:repository/repository.dart' as repository;
import 'package:riverpod/riverpod.dart';

import 'create_tournament_use_case_test.mocks.dart';

@GenerateMocks([repository.TournamentRepository])
void main() {
  late MockTournamentRepository mockRepository;

  setUp(() {
    mockRepository = MockTournamentRepository();
  });

  group('createTournamentUseCaseProvider のテスト。', () {
    test('createTournamentUseCaseProvider が CreateTournamentUseCase を返す。', () {
      final container = ProviderContainer(
        overrides: [
          tournamentRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      final result = container.read(createTournamentUseCaseProvider);

      expect(result, isA<CreateTournamentUseCase>());

      container.dispose();
    });
  });

  group('CreateTournamentUseCase', () {
    late CreateTournamentUseCase useCase;

    setUp(() {
      useCase = CreateTournamentUseCase(tournamentRepository: mockRepository);
    });

    group('call', () {
      const validRequest = CreateTournamentRequest(
        title: 'テスト大会',
        description: 'テスト説明',
        category: 'ポケモンカード',
        venue: 'テスト会場',
        startDate: '2024-12-01T10:00:00Z',
        endDate: '2024-12-01T18:00:00Z',
        drawPoints: 1,
        maxRounds: 3,
        expectedPlayers: 8,
      );

      const mockModel = repository.TournamentModel(
        id: 'tournament-123',
        title: 'テスト大会',
        description: 'テスト説明',
        category: 'ポケモンカード',
        venue: 'テスト会場',
        startDate: '2024-12-01T10:00:00Z',
        endDate: '2024-12-01T18:00:00Z',
        createdAt: '2024-12-01T09:00:00Z',
        updatedAt: '2024-12-01T09:00:00Z',
      );

      test('トーナメント作成が成功する場合', () async {
        // Arrange
        when(
          mockRepository.createTournament(any),
        ).thenAnswer((_) async => mockModel);

        // Act
        final result = await useCase.call(validRequest);

        // Assert
        expect(result, isA<Tournament>());
        expect(result.id, 'tournament-123');
        expect(result.title, 'テスト大会');
        expect(result.description, 'テスト説明');
        expect(result.venue, 'テスト会場');
        verify(mockRepository.createTournament(any)).called(1);
      });

      test('ラウンド数が指定されていない場合、自動計算される', () async {
        // Arrange
        const requestWithoutMaxRounds = CreateTournamentRequest(
          title: 'テスト大会',
          description: 'テスト説明',
          category: 'ポケモンカード',
          venue: 'テスト会場',
          startDate: '2024-12-01T10:00:00Z',
          endDate: '2024-12-01T18:00:00Z',
          drawPoints: 1,
          expectedPlayers: 8,
        );

        when(
          mockRepository.createTournament(any),
        ).thenAnswer((_) async => mockModel);

        // Act
        await useCase.call(requestWithoutMaxRounds);

        // Assert
        final captured =
            verify(mockRepository.createTournament(captureAny)).captured.single
                as repository.CreateTournamentRequest;

        // expectedPlayers=8 の場合、ceil(log2(8))=3 になる
        expect(captured.maxRounds, 3);
      });

      test('タイトルが空の場合、ArgumentError がスローされる', () async {
        // Arrange
        const invalidRequest = CreateTournamentRequest(
          title: '',
          description: 'テスト説明',
          category: 'ポケモンカード',
          venue: 'テスト会場',
          startDate: '2024-12-01T10:00:00Z',
          endDate: '2024-12-01T18:00:00Z',
          drawPoints: 1,
          expectedPlayers: 8,
        );

        // Act & Assert
        expect(
          () => useCase.call(invalidRequest),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              '大会タイトルは必須です',
            ),
          ),
        );
      });

      test('会場が空の場合、ArgumentError がスローされる', () async {
        // Arrange
        const invalidRequest = CreateTournamentRequest(
          title: 'テスト大会',
          description: 'テスト説明',
          category: 'ポケモンカード',
          venue: '',
          startDate: '2024-12-01T10:00:00Z',
          endDate: '2024-12-01T18:00:00Z',
          drawPoints: 1,
          expectedPlayers: 8,
        );

        // Act & Assert
        expect(
          () => useCase.call(invalidRequest),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              '開催会場は必須です',
            ),
          ),
        );
      });

      test('終了日時が開始日時より前の場合、ArgumentError がスローされる', () async {
        // Arrange
        const invalidRequest = CreateTournamentRequest(
          title: 'テスト大会',
          description: 'テスト説明',
          category: 'ポケモンカード',
          venue: 'テスト会場',
          startDate: '2024-12-01T18:00:00Z',
          endDate: '2024-12-01T10:00:00Z',
          drawPoints: 1,
          expectedPlayers: 8,
        );

        // Act & Assert
        expect(
          () => useCase.call(invalidRequest),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              '終了日時は開始日時より後である必要があります',
            ),
          ),
        );
      });

      test('日時の形式が不正な場合、ArgumentError がスローされる', () async {
        // Arrange
        const invalidRequest = CreateTournamentRequest(
          title: 'テスト大会',
          description: 'テスト説明',
          category: 'ポケモンカード',
          venue: 'テスト会場',
          startDate: 'invalid-date',
          endDate: '2024-12-01T18:00:00Z',
          drawPoints: 1,
          expectedPlayers: 8,
        );

        // Act & Assert
        expect(
          () => useCase.call(invalidRequest),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              '日時の形式が正しくありません（ISO 8601形式が必要です）',
            ),
          ),
        );
      });

      test('引き分け得点が0未満の場合、ArgumentError がスローされる', () async {
        // Arrange
        const invalidRequest = CreateTournamentRequest(
          title: 'テスト大会',
          description: 'テスト説明',
          category: 'ポケモンカード',
          venue: 'テスト会場',
          startDate: '2024-12-01T10:00:00Z',
          endDate: '2024-12-01T18:00:00Z',
          drawPoints: -1,
          expectedPlayers: 8,
        );

        // Act & Assert
        expect(
          () => useCase.call(invalidRequest),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              '引き分け得点は0点または1点である必要があります',
            ),
          ),
        );
      });

      test('引き分け得点が1より大きい場合、ArgumentError がスローされる', () async {
        // Arrange
        const invalidRequest = CreateTournamentRequest(
          title: 'テスト大会',
          description: 'テスト説明',
          category: 'ポケモンカード',
          venue: 'テスト会場',
          startDate: '2024-12-01T10:00:00Z',
          endDate: '2024-12-01T18:00:00Z',
          drawPoints: 2,
          expectedPlayers: 8,
        );

        // Act & Assert
        expect(
          () => useCase.call(invalidRequest),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              '引き分け得点は0点または1点である必要があります',
            ),
          ),
        );
      });

      test('ラウンド数が1未満の場合、ArgumentError がスローされる', () async {
        // Arrange
        const invalidRequest = CreateTournamentRequest(
          title: 'テスト大会',
          description: 'テスト説明',
          category: 'ポケモンカード',
          venue: 'テスト会場',
          startDate: '2024-12-01T10:00:00Z',
          endDate: '2024-12-01T18:00:00Z',
          drawPoints: 1,
          maxRounds: 0,
          expectedPlayers: 8,
        );

        // Act & Assert
        expect(
          () => useCase.call(invalidRequest),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'ラウンド数は1以上である必要があります',
            ),
          ),
        );
      });

      test('予定参加者数が2未満の場合、ArgumentError がスローされる', () async {
        // Arrange
        const invalidRequest = CreateTournamentRequest(
          title: 'テスト大会',
          description: 'テスト説明',
          category: 'ポケモンカード',
          venue: 'テスト会場',
          startDate: '2024-12-01T10:00:00Z',
          endDate: '2024-12-01T18:00:00Z',
          drawPoints: 1,
          expectedPlayers: 1,
        );

        // Act & Assert
        expect(
          () => useCase.call(invalidRequest),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              '予定参加者数は2名以上である必要があります',
            ),
          ),
        );
      });

      test('ラウンド数未指定かつ予定参加者数未指定の場合、ArgumentError がスローされる', () async {
        // Arrange
        const invalidRequest = CreateTournamentRequest(
          title: 'テスト大会',
          description: 'テスト説明',
          category: 'ポケモンカード',
          venue: 'テスト会場',
          startDate: '2024-12-01T10:00:00Z',
          endDate: '2024-12-01T18:00:00Z',
          drawPoints: 1,
        );

        // Act & Assert
        expect(
          () => useCase.call(invalidRequest),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'ラウンド数を自動計算する場合、予定参加者数の入力が必要です',
            ),
          ),
        );
      });

      test('INVALID_ARGUMENT エラーの場合、FailureStatusException をスローする', () async {
        // Arrange
        when(mockRepository.createTournament(any)).thenThrow(
          const repository.AdminApiException(
            code: 'INVALID_ARGUMENT',
            message: '不正な引数です',
          ),
        );

        // Act & Assert
        expect(
          () => useCase.call(validRequest),
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
        when(mockRepository.createTournament(any)).thenThrow(
          const repository.AdminApiException(
            code: 'PARSE_ERROR',
            message: 'パースエラー',
          ),
        );

        // Act & Assert
        expect(
          () => useCase.call(validRequest),
          throwsA(
            isA<FailureStatusException>().having(
              (e) => e.message,
              'message',
              'パースエラー',
            ),
          ),
        );
      });

      test('UNAUTHENTICATED エラーの場合、GeneralFailureException をスローする', () async {
        // Arrange
        when(mockRepository.createTournament(any)).thenThrow(
          const repository.AdminApiException(
            code: 'UNAUTHENTICATED',
            message: '認証エラー',
          ),
        );

        // Act & Assert
        expect(
          () => useCase.call(validRequest),
          throwsA(
            isA<GeneralFailureException>()
                .having((e) => e.reason, 'reason', GeneralFailureReason.other)
                .having((e) => e.errorCode, 'errorCode', 'UNAUTHENTICATED'),
          ),
        );
      });

      test('AUTH_ERROR エラーの場合、GeneralFailureException をスローする', () async {
        // Arrange
        when(mockRepository.createTournament(any)).thenThrow(
          const repository.AdminApiException(
            code: 'AUTH_ERROR',
            message: '認証エラー',
          ),
        );

        // Act & Assert
        expect(
          () => useCase.call(validRequest),
          throwsA(
            isA<GeneralFailureException>()
                .having((e) => e.reason, 'reason', GeneralFailureReason.other)
                .having((e) => e.errorCode, 'errorCode', 'AUTH_ERROR'),
          ),
        );
      });

      test('NETWORK_ERROR エラーの場合、GeneralFailureException をスローする', () async {
        // Arrange
        when(mockRepository.createTournament(any)).thenThrow(
          const repository.AdminApiException(
            code: 'NETWORK_ERROR',
            message: 'ネットワークエラー',
          ),
        );

        // Act & Assert
        expect(
          () => useCase.call(validRequest),
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
        when(mockRepository.createTournament(any)).thenThrow(
          const repository.AdminApiException(
            code: 'UNKNOWN_ERROR',
            message: '不明なエラー',
          ),
        );

        // Act & Assert
        expect(
          () => useCase.call(validRequest),
          throwsA(
            isA<GeneralFailureException>()
                .having((e) => e.reason, 'reason', GeneralFailureReason.other)
                .having((e) => e.errorCode, 'errorCode', 'UNKNOWN_ERROR'),
          ),
        );
      });
    });

    group('getRecommendedRounds', () {
      test('予定参加者数が8の場合、3ラウンドを返す', () {
        final result = useCase.getRecommendedRounds(8);
        expect(result, 3);
      });

      test('予定参加者数が16の場合、4ラウンドを返す', () {
        final result = useCase.getRecommendedRounds(16);
        expect(result, 4);
      });

      test('予定参加者数が32の場合、5ラウンドを返す', () {
        final result = useCase.getRecommendedRounds(32);
        expect(result, 5);
      });

      test('予定参加者数が7の場合、3ラウンドを返す（切り上げ）', () {
        final result = useCase.getRecommendedRounds(7);
        expect(result, 3);
      });

      test('予定参加者数が2の場合、1ラウンドを返す', () {
        final result = useCase.getRecommendedRounds(2);
        expect(result, 1);
      });

      test('予定参加者数が1の場合、1ラウンドを返す', () {
        final result = useCase.getRecommendedRounds(1);
        expect(result, 1);
      });

      test('予定参加者数が0以下の場合、1ラウンドを返す', () {
        final result = useCase.getRecommendedRounds(0);
        expect(result, 1);
      });
    });
  });
}
