import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:repository/repository.dart' as repo;
import 'package:riverpod/riverpod.dart';

import 'get_published_matches_use_case_test.mocks.dart';

@GenerateNiceMocks([MockSpec<repo.MatchPlayerRepository>()])
void main() {
  late MockMatchPlayerRepository mockMatchPlayerRepository;
  late GetPublishedMatchesUseCase getPublishedMatchesUseCase;

  setUp(() {
    mockMatchPlayerRepository = MockMatchPlayerRepository();
    getPublishedMatchesUseCase = GetPublishedMatchesUseCase(
      matchPlayerRepository: mockMatchPlayerRepository,
    );

    // スタブされていないメソッドが呼び出された場合、unknown の失敗結果を返すようにする。
    provideDummy<repo.RepositoryResult<repo.MatchListResponse>>(
      repo.RepositoryResult<repo.MatchListResponse>.failure(
        Exception(),
        reason: repo.FailureRepositoryResultReason.unknown,
      ),
    );
  });

  group('getPublishedMatchesUseCaseProvider のテスト。', () {
    test('getPublishedMatchesUseCaseProvider が GetPublishedMatchesUseCase を返す。',
        () {
      final container = ProviderContainer(
        overrides: [
          // 依存する matchPlayerRepositoryProvider をモックで上書きする。
          repo.matchPlayerRepositoryProvider
              .overrideWithValue(mockMatchPlayerRepository),
        ],
      );
      addTearDown(container.dispose);
      expect(
        container.read(getPublishedMatchesUseCaseProvider),
        isA<GetPublishedMatchesUseCase>(),
      );
    });
  });

  group('GetPublishedMatchesUseCase のテスト。', () {
    group('invoke メソッドのテスト。', () {
      /// 公開対戦表を取得する。
      Future<List<Match>> getPublishedMatches() async {
        return getPublishedMatchesUseCase.invoke(
          baseUrl: 'https://example.com/',
          tournamentId: 'tournament123',
          roundId: 'round456',
          userId: 'user789',
        );
      }

      group('成功シナリオ。', () {
        test('公開対戦表の取得に成功した場合、Match エンティティのリストを返す。', () async {
          // スタブを用意する。
          when(
            mockMatchPlayerRepository.getPublishedMatches(
              baseUrl: anyNamed('baseUrl'),
              tournamentId: anyNamed('tournamentId'),
              roundId: anyNamed('roundId'),
              userId: anyNamed('userId'),
            ),
          ).thenAnswer(
            (_) async =>
                repo.RepositoryResult<repo.MatchListResponse>.success(
              [
                const repo.Match(
                  id: 'match1',
                  tableNumber: 1,
                  published: true,
                  player1: repo.MatchPlayer(
                    id: 'player1',
                    name: 'プレイヤー1',
                    matchingPoints: 3,
                  ),
                  player2: repo.MatchPlayer(
                    id: 'player2',
                    name: 'プレイヤー2',
                    matchingPoints: 3,
                  ),
                  isByeMatch: false,
                  result: null,
                  isMine: true,
                  meSide: 'player1',
                ),
                const repo.Match(
                  id: 'match2',
                  tableNumber: 2,
                  published: true,
                  player1: repo.MatchPlayer(
                    id: 'player3',
                    name: 'プレイヤー3',
                    matchingPoints: 0,
                  ),
                  player2: repo.MatchPlayer(
                    id: 'player4',
                    name: 'プレイヤー4',
                    matchingPoints: 3,
                  ),
                  isByeMatch: false,
                  result: repo.MatchResultDetail(
                    type: 'win',
                    winnerId: 'player4',
                    submittedAt: '2024-10-05T10:00:00Z',
                    submittedBy: 'player4',
                    submitterUserId: 'user456',
                  ),
                  isMine: false,
                ),
              ],
            ),
          );

          // 公開対戦表取得処理を実行後、返り値が Match エンティティのリストであることを確認する。
          final matches = await getPublishedMatches();
          expect(matches, isA<List<Match>>());
          expect(matches.length, 2);

          // 1つ目の Match の値を確認する。
          expect(matches[0].id, 'match1');
          expect(matches[0].tableNumber, 1);
          expect(matches[0].published, true);
          expect(matches[0].player1.id, 'player1');
          expect(matches[0].player1.name, 'プレイヤー1');
          expect(matches[0].player1.matchingPoints, 3);
          expect(matches[0].player2.id, 'player2');
          expect(matches[0].player2.name, 'プレイヤー2');
          expect(matches[0].isByeMatch, false);
          expect(matches[0].result, null);
          expect(matches[0].isMine, true);
          expect(matches[0].meSide, 'player1');

          // 2つ目の Match の値を確認する。
          expect(matches[1].id, 'match2');
          expect(matches[1].tableNumber, 2);
          expect(matches[1].result, isNotNull);
          expect(matches[1].result!.type, 'win');
          expect(matches[1].result!.winnerId, 'player4');
          expect(matches[1].isMine, false);
          expect(matches[1].meSide, null);
        });
      });

      group('失敗シナリオ。', () {
        /// どの引数で公開対戦表取得処理を実行しても失敗結果を返す。
        ///
        /// 各テスト内では、このメソッドを呼び出してスタブを用意する。
        void setupMockRepositoryGetPublishedMatches(
          repo.FailureRepositoryResult<repo.MatchListResponse> failureResult,
        ) {
          when(
            mockMatchPlayerRepository.getPublishedMatches(
              baseUrl: anyNamed('baseUrl'),
              tournamentId: anyNamed('tournamentId'),
              roundId: anyNamed('roundId'),
              userId: anyNamed('userId'),
            ),
          ).thenAnswer((_) async => failureResult);
        }

        test(
          'noConnection により失敗した場合、GeneralFailureException がスローされる。',
          () async {
            // noConnection により失敗するスタブを用意する。
            setupMockRepositoryGetPublishedMatches(
              repo.FailureRepositoryResult<repo.MatchListResponse>(
                Exception(),
                reason: repo.FailureRepositoryResultReason.noConnection,
              ),
            );

            // 公開対戦表取得処理の実行時、GeneralFailureException がスローされ、その例外の内容が正しいことを確認する。
            expect(
              getPublishedMatches,
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

        test('notFound により失敗した場合、GeneralFailureException がスローされる。', () async {
          // notFound により失敗するスタブを用意する。
          setupMockRepositoryGetPublishedMatches(
            repo.FailureRepositoryResult<repo.MatchListResponse>(
              Exception(),
              reason: repo.FailureRepositoryResultReason.notFound,
            ),
          );

          // 公開対戦表取得処理の実行時、GeneralFailureException がスローされ、その例外の内容が正しいことを確認する。
          expect(
            getPublishedMatches,
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

        test(
          'badResponse により失敗した場合、GeneralFailureException がスローされる。',
          () async {
            // badResponse により失敗するスタブを用意する。
            setupMockRepositoryGetPublishedMatches(
              repo.FailureRepositoryResult<repo.MatchListResponse>(
                Exception(),
                reason: repo.FailureRepositoryResultReason.badResponse,
                statusCode: 500,
              ),
            );

            // 公開対戦表取得処理の実行時、GeneralFailureException がスローされ、その例外の内容が正しいことを確認する。
            expect(
              getPublishedMatches,
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

        test('その他のエラーにより失敗した場合、GeneralFailureException がスローされる。', () async {
          // cancel により失敗するスタブを用意する。
          setupMockRepositoryGetPublishedMatches(
            repo.FailureRepositoryResult<repo.MatchListResponse>(
              Exception(),
              reason: repo.FailureRepositoryResultReason.cancel,
            ),
          );

          // 公開対戦表取得処理の実行時、GeneralFailureException がスローされ、その例外の内容が正しいことを確認する。
          expect(
            getPublishedMatches,
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
