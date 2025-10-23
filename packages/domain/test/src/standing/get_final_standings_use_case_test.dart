import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:repository/repository.dart' as repo;
import 'package:riverpod/riverpod.dart';

import 'get_final_standings_use_case_test.mocks.dart';

// StandingPlayerRepository のモッククラスを生成する。
@GenerateNiceMocks([MockSpec<repo.StandingPlayerRepository>()])
void main() {
  late MockStandingPlayerRepository mockStandingPlayerRepository;
  late GetFinalStandingsUseCase getFinalStandingsUseCase;

  setUp(() {
    mockStandingPlayerRepository = MockStandingPlayerRepository();
    getFinalStandingsUseCase = GetFinalStandingsUseCase(
      standingPlayerRepository: mockStandingPlayerRepository,
    );

    // スタブされていないメソッドが呼び出された場合、適切な失敗結果を返すようにする。
    provideDummy<repo.RepositoryResult<repo.StandingResponse>>(
      repo.RepositoryResult<repo.StandingResponse>.failure(
        Exception(),
        reason: repo.FailureRepositoryResultReason.unknown,
      ),
    );
  });

  group('getFinalStandingsUseCaseProvider のテスト。', () {
    test('getFinalStandingsUseCaseProvider が GetFinalStandingsUseCase を返す。',
        () {
      final container = ProviderContainer(
        overrides: [
          // 依存するプロバイダーをモックで置き換える。
          repo.standingPlayerRepositoryProvider
              .overrideWithValue(mockStandingPlayerRepository),
        ],
      );
      addTearDown(container.dispose);
      expect(
        container.read(getFinalStandingsUseCaseProvider),
        isA<GetFinalStandingsUseCase>(),
      );
    });
  });

  group('GetFinalStandingsUseCase のテスト。', () {
    group('invoke メソッドのテスト。', () {
      /// ダミーの値を用いて処理を実行する。
      Future<Standing> invoke() async {
        return getFinalStandingsUseCase.invoke(
          baseUrl: 'https://example.com/',
          tournamentId: 'tournament-123',
          userId: 'user-001',
        );
      }

      group('成功シナリオ。', () {
        test('処理に成功した場合、Standing オブジェクトを返す。', () async {
          // ダミーの値から生成される想定の引数を元にスタブを用意する。
          when(
            mockStandingPlayerRepository.getFinalStandings(
              baseUrl: anyNamed('baseUrl'),
              tournamentId: anyNamed('tournamentId'),
              userId: anyNamed('userId'),
            ),
          ).thenAnswer(
            (_) async => const repo.RepositoryResult<
                repo.StandingResponse>.success(
              repo.StandingResponse(
                calculatedAt: '2025-10-05T15:00:00Z',
                rankings: [
                  repo.Ranking(
                    rank: 1,
                    playerName: 'Player A',
                    matchPoints: 9,
                    omwPercentage: 0.6667,
                  ),
                  repo.Ranking(
                    rank: 2,
                    playerName: 'Player B',
                    matchPoints: 6,
                    omwPercentage: 0.5556,
                  ),
                  repo.Ranking(
                    rank: 3,
                    playerName: 'Player C',
                    matchPoints: 3,
                    omwPercentage: 0.4444,
                  ),
                ],
              ),
            ),
          );

          // 処理実行後、返り値が Standing オブジェクトであることを確認する。
          final result = await invoke();
          expect(result, isA<Standing>());

          // Standing の値を確認する。
          expect(result.calculatedAt, '2025-10-05T15:00:00Z');
          expect(result.rankings, hasLength(3));

          // 1位のプレイヤーを確認する。
          expect(result.rankings[0], isA<RankingDetail>());
          expect(result.rankings[0].rank, 1);
          expect(result.rankings[0].playerName, 'Player A');
          expect(result.rankings[0].matchPoints, 9);
          expect(result.rankings[0].omwPercentage, 0.6667);

          // 2位のプレイヤーを確認する。
          expect(result.rankings[1].rank, 2);
          expect(result.rankings[1].playerName, 'Player B');
          expect(result.rankings[1].matchPoints, 6);
          expect(result.rankings[1].omwPercentage, 0.5556);

          // 3位のプレイヤーを確認する。
          expect(result.rankings[2].rank, 3);
          expect(result.rankings[2].playerName, 'Player C');
          expect(result.rankings[2].matchPoints, 3);
          expect(result.rankings[2].omwPercentage, 0.4444);

          // リポジトリのメソッドが正しい引数で呼び出されることを確認する。
          final captured = verify(
            mockStandingPlayerRepository.getFinalStandings(
              baseUrl: captureAnyNamed('baseUrl'),
              tournamentId: captureAnyNamed('tournamentId'),
              userId: captureAnyNamed('userId'),
            ),
          ).captured;

          expect(captured[0], 'https://example.com/');
          expect(captured[1], 'tournament-123');
          expect(captured[2], 'user-001');
        });
      });

      group('失敗シナリオ。', () {
        /// どの引数で処理を実行しても失敗結果を返す。
        ///
        /// 各テスト内では、このメソッドを呼び出してスタブを用意する。
        void setupMockRepositoryMethod(
          repo.FailureRepositoryResult<repo.StandingResponse> failureResult,
        ) {
          when(
            mockStandingPlayerRepository.getFinalStandings(
              baseUrl: anyNamed('baseUrl'),
              tournamentId: anyNamed('tournamentId'),
              userId: anyNamed('userId'),
            ),
          ).thenAnswer((_) async => failureResult);
        }

        test(
          'noConnection により失敗した場合、GeneralFailureException がスローされる。',
          () async {
            // noConnection により失敗するスタブを用意する。
            setupMockRepositoryMethod(
              repo.FailureRepositoryResult<repo.StandingResponse>(
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
              repo.FailureRepositoryResult<repo.StandingResponse>(
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
            repo.FailureRepositoryResult<repo.StandingResponse>(
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
            repo.FailureRepositoryResult<repo.StandingResponse>(
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
              repo.FailureRepositoryResult<repo.StandingResponse>(
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
            repo.FailureRepositoryResult<repo.StandingResponse>(
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
