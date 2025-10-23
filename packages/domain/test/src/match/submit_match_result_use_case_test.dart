import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:repository/repository.dart' as repo;
import 'package:riverpod/riverpod.dart';

import 'submit_match_result_use_case_test.mocks.dart';

// MatchPlayerRepository のモッククラスを生成する。
@GenerateNiceMocks([MockSpec<repo.MatchPlayerRepository>()])
void main() {
  late MockMatchPlayerRepository mockMatchPlayerRepository;
  late SubmitMatchResultUseCase submitMatchResultUseCase;

  setUp(() {
    mockMatchPlayerRepository = MockMatchPlayerRepository();
    submitMatchResultUseCase = SubmitMatchResultUseCase(
      matchPlayerRepository: mockMatchPlayerRepository,
    );

    // スタブされていないメソッドが呼び出された場合、適切な失敗結果を返すようにする。
    provideDummy<repo.RepositoryResult<repo.MatchSubmitResultResponse>>(
      repo.RepositoryResult<repo.MatchSubmitResultResponse>.failure(
        Exception(),
        reason: repo.FailureRepositoryResultReason.unknown,
      ),
    );
  });

  group('submitMatchResultUseCaseProvider のテスト。', () {
    test('submitMatchResultUseCaseProvider が SubmitMatchResultUseCase を返す。',
        () {
      final container = ProviderContainer(
        overrides: [
          // 依存するプロバイダーをモックで置き換える。
          repo.matchPlayerRepositoryProvider
              .overrideWithValue(mockMatchPlayerRepository),
        ],
      );
      addTearDown(container.dispose);
      expect(
        container.read(submitMatchResultUseCaseProvider),
        isA<SubmitMatchResultUseCase>(),
      );
    });
  });

  group('SubmitMatchResultUseCase のテスト。', () {
    group('invoke メソッドのテスト。', () {
      /// ダミーの値を用いて処理を実行する。
      Future<MatchResultDetail> invoke() async {
        return submitMatchResultUseCase.invoke(
          baseUrl: 'https://example.com/',
          tournamentId: 'tournament-123',
          roundId: 'round-456',
          matchId: 'match-789',
          resultType: 'PLAYER1_WIN',
          winnerId: 'player-001',
          userId: 'user-001',
        );
      }

      group('成功シナリオ。', () {
        test('処理に成功した場合、MatchResultDetail オブジェクトを返す。', () async {
          // ダミーの値から生成される想定の引数を元にスタブを用意する。
          when(
            mockMatchPlayerRepository.submitMatchResult(
              baseUrl: anyNamed('baseUrl'),
              tournamentId: anyNamed('tournamentId'),
              roundId: anyNamed('roundId'),
              matchId: anyNamed('matchId'),
              request: anyNamed('request'),
            ),
          ).thenAnswer(
            (_) async => const repo.RepositoryResult<
                repo.MatchSubmitResultResponse>.success(
              repo.MatchSubmitResultResponse(
                result: repo.MatchResult(
                  type: 'PLAYER1_WIN',
                  winnerId: 'player-001',
                  submittedAt: '2025-10-05T12:00:00Z',
                  submittedBy: 'player-001',
                  submitterUserId: 'user-001',
                ),
              ),
            ),
          );

          // 処理実行後、返り値が MatchResultDetail オブジェクトであることを確認する。
          final result = await invoke();
          expect(result, isA<MatchResultDetail>());

          // MatchResultDetail の値を確認する。
          expect(result.type, 'PLAYER1_WIN');
          expect(result.winnerId, 'player-001');
          expect(result.submittedAt, '2025-10-05T12:00:00Z');
          expect(result.submittedBy, 'player-001');
          expect(result.submitterUserId, 'user-001');

          // リポジトリのメソッドが正しい引数で呼び出されることを確認する。
          final captured = verify(
            mockMatchPlayerRepository.submitMatchResult(
              baseUrl: captureAnyNamed('baseUrl'),
              tournamentId: captureAnyNamed('tournamentId'),
              roundId: captureAnyNamed('roundId'),
              matchId: captureAnyNamed('matchId'),
              request: captureAnyNamed('request'),
            ),
          ).captured;

          expect(captured[0], 'https://example.com/');
          expect(captured[1], 'tournament-123');
          expect(captured[2], 'round-456');
          expect(captured[3], 'match-789');
          expect(captured[4], isA<repo.MatchSubmitResultRequest>());
          final request = captured[4] as repo.MatchSubmitResultRequest;
          expect(request.type, 'PLAYER1_WIN');
          expect(request.winnerId, 'player-001');
          expect(request.userId, 'user-001');
        });
      });

      group('失敗シナリオ。', () {
        /// どの引数で処理を実行しても失敗結果を返す。
        ///
        /// 各テスト内では、このメソッドを呼び出してスタブを用意する。
        void setupMockRepositoryMethod(
          repo.FailureRepositoryResult<repo.MatchSubmitResultResponse>
              failureResult,
        ) {
          when(
            mockMatchPlayerRepository.submitMatchResult(
              baseUrl: anyNamed('baseUrl'),
              tournamentId: anyNamed('tournamentId'),
              roundId: anyNamed('roundId'),
              matchId: anyNamed('matchId'),
              request: anyNamed('request'),
            ),
          ).thenAnswer((_) async => failureResult);
        }

        test(
          'noConnection により失敗した場合、GeneralFailureException がスローされる。',
          () async {
            // noConnection により失敗するスタブを用意する。
            setupMockRepositoryMethod(
              repo.FailureRepositoryResult<repo.MatchSubmitResultResponse>(
                Exception(),
                reason: repo.FailureRepositoryResultReason.noConnection,
              ),
            );

            // 処理実行時、GeneralFailureException がスローされ、その例外の内容が正しいことを確認する。
            expect(
              invoke,
              throwsA(
                isA<GeneralFailureException>()
                    .having(
                      (e) => e.reason,
                      '失敗理由には noConnectionError が設定される。',
                      GeneralFailureReason.noConnectionError,
                    )
                    .having(
                      (e) => e.errorCode,
                      'エラーコードには noConnection の文字列が設定される。',
                      repo.FailureRepositoryResultReason.noConnection.name,
                    ),
              ),
            );
          },
        );

        test(
          'connectionTimeout により失敗した場合、GeneralFailureException がスローされる。',
          () async {
            // connectionTimeout により失敗するスタブを用意する。
            setupMockRepositoryMethod(
              repo.FailureRepositoryResult<repo.MatchSubmitResultResponse>(
                Exception(),
                reason: repo.FailureRepositoryResultReason.connectionTimeout,
              ),
            );

            // 処理実行時、GeneralFailureException がスローされ、その例外の内容が正しいことを確認する。
            expect(
              invoke,
              throwsA(
                isA<GeneralFailureException>()
                    .having(
                      (e) => e.reason,
                      '失敗理由には noConnectionError が設定される。',
                      GeneralFailureReason.noConnectionError,
                    )
                    .having(
                      (e) => e.errorCode,
                      'エラーコードには connectionTimeout の文字列が設定される。',
                      repo.FailureRepositoryResultReason.connectionTimeout.name,
                    ),
              ),
            );
          },
        );

        test('notFound により失敗した場合、GeneralFailureException がスローされる。',
            () async {
          // notFound により失敗するスタブを用意する。
          setupMockRepositoryMethod(
            repo.FailureRepositoryResult<repo.MatchSubmitResultResponse>(
              Exception(),
              reason: repo.FailureRepositoryResultReason.notFound,
            ),
          );

          // 処理実行時、GeneralFailureException がスローされ、その例外の内容が正しいことを確認する。
          expect(
            invoke,
            throwsA(
              isA<GeneralFailureException>()
                  .having(
                    (e) => e.reason,
                    '失敗理由には serverUrlNotFoundError が設定される。',
                    GeneralFailureReason.serverUrlNotFoundError,
                  )
                  .having(
                    (e) => e.errorCode,
                    'エラーコードには notFound の文字列が設定される。',
                    repo.FailureRepositoryResultReason.notFound.name,
                  ),
            ),
          );
        });

        test('connectionError により失敗した場合、GeneralFailureException がスローされる。',
            () async {
          // connectionError により失敗するスタブを用意する。
          setupMockRepositoryMethod(
            repo.FailureRepositoryResult<repo.MatchSubmitResultResponse>(
              Exception(),
              reason: repo.FailureRepositoryResultReason.connectionError,
            ),
          );

          // 処理実行時、GeneralFailureException がスローされ、その例外の内容が正しいことを確認する。
          expect(
            invoke,
            throwsA(
              isA<GeneralFailureException>()
                  .having(
                    (e) => e.reason,
                    '失敗理由には serverUrlNotFoundError が設定される。',
                    GeneralFailureReason.serverUrlNotFoundError,
                  )
                  .having(
                    (e) => e.errorCode,
                    'エラーコードには connectionError の文字列が設定される。',
                    repo.FailureRepositoryResultReason.connectionError.name,
                  ),
            ),
          );
        });

        test(
          'badResponse により失敗した場合、GeneralFailureException がスローされる。',
          () async {
            // badResponse により失敗するスタブを用意する。
            setupMockRepositoryMethod(
              repo.FailureRepositoryResult<repo.MatchSubmitResultResponse>(
                Exception(),
                reason: repo.FailureRepositoryResultReason.badResponse,
                statusCode: 500,
              ),
            );

            // 処理実行時、GeneralFailureException がスローされ、その例外の内容が正しいことを確認する。
            expect(
              invoke,
              throwsA(
                isA<GeneralFailureException>()
                    .having(
                      (e) => e.reason,
                      '失敗理由には badResponse が設定される。',
                      GeneralFailureReason.badResponse,
                    )
                    .having(
                      (e) => e.errorCode,
                      'エラーコードには badResponse の文字列が設定される。',
                      repo.FailureRepositoryResultReason.badResponse.name,
                    )
                    .having((e) => e.statusCode, 'ステータスコードが設定される。', 500),
              ),
            );
          },
        );

        test('その他のエラーにより失敗した場合、GeneralFailureException がスローされる。',
            () async {
          // cancel により失敗するスタブを用意する。
          setupMockRepositoryMethod(
            repo.FailureRepositoryResult<repo.MatchSubmitResultResponse>(
              Exception(),
              reason: repo.FailureRepositoryResultReason.cancel,
            ),
          );

          // 処理実行時、GeneralFailureException がスローされ、その例外の内容が正しいことを確認する。
          expect(
            invoke,
            throwsA(
              isA<GeneralFailureException>()
                  .having(
                    (e) => e.reason,
                    '失敗理由には other が設定される。',
                    GeneralFailureReason.other,
                  )
                  .having(
                    (e) => e.errorCode,
                    'エラーコードには cancel の文字列が設定される。',
                    repo.FailureRepositoryResultReason.cancel.name,
                  ),
            ),
          );
        });
      });
    });
  });
}
