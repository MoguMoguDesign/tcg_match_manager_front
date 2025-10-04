import 'package:flutter_test/flutter_test.dart';
import 'package:injection/injection.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:system/system.dart';

import 'standing_player_repository_test.mocks.dart';

// HttpClient のモッククラスを生成する。
@GenerateNiceMocks([MockSpec<HttpClient>()])
void main() {
  late MockHttpClient mockHttpClient;
  late StandingPlayerRepository repository;

  setUp(() {
    mockHttpClient = MockHttpClient();
    repository = StandingPlayerRepository(httpClient: mockHttpClient);
    // スタブされていないメソッドが呼び出された場合、ErrorStatus.unknown の失敗レスポンスを返すようにする。
    provideDummy<HttpResponse>(
      HttpResponse.failure(e: Exception(), status: ErrorStatus.unknown),
    );
  });

  group('standingPlayerRepositoryProvider のテスト。', () {
    test('standingPlayerRepositoryProvider が StandingPlayerRepository を返す。',
        () {
      final container = ProviderContainer(
        // 依存する httpClientProvider をモックで上書きする。
        overrides: [httpClientProvider.overrideWithValue(mockHttpClient)],
      );
      addTearDown(container.dispose);

      expect(
        container.read(standingPlayerRepositoryProvider),
        isA<StandingPlayerRepository>(),
      );
    });
  });

  group('StandingPlayerRepository のテスト。', () {
    group('getFinalStandings メソッドのテスト。', () {
      /// ダミーの値を用いて処理を実行する。
      ///
      /// 成功した場合は、SuccessRepositoryResult を返す。
      /// 失敗した場合は、FailureRepositoryResult を返す。
      Future<RepositoryResult<StandingResponse>> getFinalStandings() async {
        return repository.getFinalStandings(
          baseUrl: 'https://example.com/',
          tournamentId: 't_abc123',
          userId: 'uuid-v4-string',
        );
      }

      /// ダミー値から生成される想定の URL.
      const url =
          'https://example.com/player/api/v1/tournaments/t_abc123/standings:final?userId=uuid-v4-string';

      group('成功シナリオ。', () {
        test('成功した場合、SuccessRepositoryResult を返す。', () async {
          // ダミーの値から生成される想定の URL を元にスタブを用意する。
          when(mockHttpClient.getUri(Uri.parse(url))).thenAnswer((_) async {
            return const SuccessHttpResponse(
              jsonData: {
                'calculatedAt': '2025-09-01T17:00:00Z',
                'rankings': [
                  {
                    'rank': 1,
                    'playerName': '山田太郎',
                    'matchPoints': 21,
                    'omwPercentage': 58.6,
                  },
                  {
                    'rank': 2,
                    'playerName': '鈴木花子',
                    'matchPoints': 21,
                    'omwPercentage': 57.2,
                  },
                ]
              },
              headers: {},
            );
          });

          // 処理実行時、成功レスポンスが返ってくることを確認する。
          final result = await getFinalStandings();
          expect(result, isA<SuccessRepositoryResult<StandingResponse>>());

          // 各フィールドの値が正しいことを確認する。
          final response =
              (result as SuccessRepositoryResult<StandingResponse>).data;
          expect(response.calculatedAt, '2025-09-01T17:00:00Z');
          expect(response.rankings.length, 2);
          expect(response.rankings[0].rank, 1);
          expect(response.rankings[0].playerName, '山田太郎');
          expect(response.rankings[0].matchPoints, 21);
          expect(response.rankings[0].omwPercentage, 58.6);
          expect(response.rankings[1].rank, 2);
          expect(response.rankings[1].playerName, '鈴木花子');
          expect(response.rankings[1].matchPoints, 21);
          expect(response.rankings[1].omwPercentage, 57.2);
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
          final result = await getFinalStandings();
          expect(result, isA<FailureRepositoryResult<StandingResponse>>());

          final failureResult =
              result as FailureRepositoryResult<StandingResponse>;
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
  });
}
