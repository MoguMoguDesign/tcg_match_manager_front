import 'package:flutter_test/flutter_test.dart';
import 'package:injection/injection.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:system/system.dart';

import 'match_player_repository_test.mocks.dart';

// HttpClient のモッククラスを生成する。
@GenerateNiceMocks([MockSpec<HttpClient>()])
void main() {
  late MockHttpClient mockHttpClient;
  late MatchPlayerRepository repository;

  setUp(() {
    mockHttpClient = MockHttpClient();
    repository = MatchPlayerRepository(httpClient: mockHttpClient);
    // スタブされていないメソッドが呼び出された場合、ErrorStatus.unknown の失敗レスポンスを返すようにする。
    provideDummy<HttpResponse>(
      HttpResponse.failure(e: Exception(), status: ErrorStatus.unknown),
    );
  });

  group('matchPlayerRepositoryProvider のテスト。', () {
    test('matchPlayerRepositoryProvider が MatchPlayerRepository を返す。',
        () {
      final container = ProviderContainer(
        // 依存する httpClientProvider をモックで上書きする。
        overrides: [httpClientProvider.overrideWithValue(mockHttpClient)],
      );
      addTearDown(container.dispose);

      expect(
        container.read(matchPlayerRepositoryProvider),
        isA<MatchPlayerRepository>(),
      );
    });
  });

  group('MatchPlayerRepository のテスト。', () {
    group('getPublishedMatches メソッドのテスト。', () {
      /// ダミーの値を用いて処理を実行する。
      ///
      /// 成功した場合は、SuccessRepositoryResult を返す。
      /// 失敗した場合は、FailureRepositoryResult を返す。
      Future<RepositoryResult<MatchListResponse>> getPublishedMatches() async {
        return repository.getPublishedMatches(
          baseUrl: 'https://example.com/',
          tournamentId: 't_abc123',
          roundId: 'r_1',
          userId: 'uuid-v4-string',
        );
      }

      /// ダミー値から生成される想定の URL.
      const url =
          'https://example.com/player/api/v1/tournaments/t_abc123/rounds/r_1/matches?published=true&userId=uuid-v4-string';

      group('成功シナリオ。', () {
        test('成功した場合、SuccessRepositoryResult を返す。', () async {
          // ダミーの値から生成される想定の URL を元にスタブを用意する。
          when(mockHttpClient.getUri(Uri.parse(url))).thenAnswer((_) async {
            return const SuccessHttpResponse(
              jsonData: [
                {
                  'id': 'm_1',
                  'tableNumber': 15,
                  'published': true,
                  'player1': {'id': 'p1', 'name': '山田太郎', 'matchingPoints': 6},
                  'player2': {'id': 'p2', 'name': '鈴木花子', 'matchingPoints': 6},
                  'isByeMatch': false,
                  'result': null,
                  'isMine': true,
                  'meSide': 'player1',
                }
              ],
              headers: {},
            );
          });

          // 処理実行時、成功レスポンスが返ってくることを確認する。
          final result = await getPublishedMatches();
          expect(result, isA<SuccessRepositoryResult<MatchListResponse>>());

          // 各フィールドの値が正しいことを確認する。
          final response =
              (result as SuccessRepositoryResult<MatchListResponse>).data;
          expect(response.length, 1);
          expect(response[0].id, 'm_1');
          expect(response[0].tableNumber, 15);
          expect(response[0].published, true);
          expect(response[0].player1.id, 'p1');
          expect(response[0].player1.name, '山田太郎');
          expect(response[0].player1.matchingPoints, 6);
          expect(response[0].player2.id, 'p2');
          expect(response[0].player2.name, '鈴木花子');
          expect(response[0].isByeMatch, false);
          expect(response[0].result, null);
          expect(response[0].isMine, true);
          expect(response[0].meSide, 'player1');
        });
      });

      group('失敗シナリオ。', () {
        test('失敗した場合、FailureRepositoryResult を返す。', () async {
          // どの URL の場合でも 404 が返ってくるスタブを用意する。
          when(mockHttpClient.getUri(argThat(anything)))
              .thenAnswer((_) async {
            return FailureHttpResponse(
              e: Exception(),
              status: ErrorStatus.badResponse,
              statusCode: 404,
            );
          });

          // 処理実行時、失敗レスポンスが返ってくることを確認する。
          final result = await getPublishedMatches();
          expect(result, isA<FailureRepositoryResult<MatchListResponse>>());

          final failureResult =
              result as FailureRepositoryResult<MatchListResponse>;
          // reason が FailureRepositoryResultReason.badResponse であることを確認する。
          expect(
            failureResult.reason,
            FailureRepositoryResultReason.badResponse,
          );
          // statusCode が 404 であることを確認する。
          expect(failureResult.statusCode, 404);
        });
      });
    });

    group('submitMatchResult メソッドのテスト。', () {
      /// ダミーの値を用いて処理を実行する。
      ///
      /// 成功した場合は、SuccessRepositoryResult を返す。
      /// 失敗した場合は、FailureRepositoryResult を返す。
      Future<RepositoryResult<MatchSubmitResultResponse>>
          submitMatchResult() async {
        return repository.submitMatchResult(
          baseUrl: 'https://example.com/',
          tournamentId: 't_abc123',
          roundId: 'r_1',
          matchId: 'm_1',
          request: const MatchSubmitResultRequest(
            type: 'PLAYER1_WIN',
            winnerId: 'p1',
            userId: 'uuid-v4-string',
          ),
        );
      }

      /// ダミー値から生成される想定の URL.
      const url =
          'https://example.com/player/api/v1/tournaments/t_abc123/rounds/r_1/matches/m_1:submitResult';

      group('成功シナリオ。', () {
        test('成功した場合、SuccessRepositoryResult を返す。', () async {
          // ダミーの値から生成される想定の URL を元にスタブを用意する。
          when(mockHttpClient.postUri(Uri.parse(url), any))
              .thenAnswer((_) async {
            return const SuccessHttpResponse(
              jsonData: {
                'result': {
                  'type': 'PLAYER1_WIN',
                  'winnerId': 'p1',
                  'submittedAt': '2025-09-01T10:20:00Z',
                  'submittedBy': 'p1',
                  'submitterUserId': 'uuid-v4-string',
                }
              },
              headers: {},
            );
          });

          // 処理実行時、成功レスポンスが返ってくることを確認する。
          final result = await submitMatchResult();
          expect(
            result,
            isA<SuccessRepositoryResult<MatchSubmitResultResponse>>(),
          );

          // 各フィールドの値が正しいことを確認する。
          final response =
              (result as SuccessRepositoryResult<MatchSubmitResultResponse>)
                  .data;
          expect(response.result.type, 'PLAYER1_WIN');
          expect(response.result.winnerId, 'p1');
          expect(response.result.submittedAt, '2025-09-01T10:20:00Z');
          expect(response.result.submittedBy, 'p1');
          expect(response.result.submitterUserId, 'uuid-v4-string');
        });
      });

      group('失敗シナリオ。', () {
        test('失敗した場合、FailureRepositoryResult を返す。', () async {
          // どの URL の場合でも 400 が返ってくるスタブを用意する。
          when(mockHttpClient.postUri(argThat(anything), any))
              .thenAnswer((_) async {
            return FailureHttpResponse(
              e: Exception(),
              status: ErrorStatus.badResponse,
              statusCode: 400,
            );
          });

          // 処理実行時、失敗レスポンスが返ってくることを確認する。
          final result = await submitMatchResult();
          expect(
            result,
            isA<FailureRepositoryResult<MatchSubmitResultResponse>>(),
          );

          final failureResult =
              result as FailureRepositoryResult<MatchSubmitResultResponse>;
          // reason が FailureRepositoryResultReason.badResponse であることを確認する。
          expect(
            failureResult.reason,
            FailureRepositoryResultReason.badResponse,
          );
          // statusCode が 400 であることを確認する。
          expect(failureResult.statusCode, 400);
        });
      });
    });
  });
}
