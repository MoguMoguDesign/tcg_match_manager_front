import 'package:flutter_test/flutter_test.dart';
import 'package:injection/injection.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:system/system.dart';

import 'tournament_info_repository_test.mocks.dart';

// HttpClient のモッククラスを生成する。
@GenerateNiceMocks([MockSpec<HttpClient>()])
void main() {
  late MockHttpClient mockHttpClient;
  late TournamentInfoRepository repository;

  setUp(() {
    mockHttpClient = MockHttpClient();
    repository = TournamentInfoRepository(httpClient: mockHttpClient);
    // スタブされていないメソッドが呼び出された場合、ErrorStatus.unknown の失敗レスポンスを返すようにする。
    provideDummy<HttpResponse>(
      HttpResponse.failure(e: Exception(), status: ErrorStatus.unknown),
    );
  });

  group('tournamentInfoRepositoryProvider のテスト。', () {
    test('tournamentInfoRepositoryProvider が TournamentInfoRepository を返す。',
        () {
      final container = ProviderContainer(
        // 依存する httpClientProvider をモックで上書きする。
        overrides: [httpClientProvider.overrideWithValue(mockHttpClient)],
      );
      addTearDown(container.dispose);

      expect(
        container.read(tournamentInfoRepositoryProvider),
        isA<TournamentInfoRepository>(),
      );
    });
  });

  group('TournamentInfoRepository のテスト。', () {
    group('getTournamentInfo メソッドのテスト。', () {
      /// ダミーの値を用いて処理を実行する。
      ///
      /// 成功した場合は、SuccessRepositoryResult を返す。
      /// 失敗した場合は、FailureRepositoryResult を返す。
      Future<RepositoryResult<TournamentInfoResponse>>
          getTournamentInfo() async {
        return repository.getTournamentInfo(
          baseUrl: 'https://example.com/',
          tournamentId: 't_abc123',
        );
      }

      /// ダミー値から生成される想定の URL.
      const url =
          'https://example.com/player/api/v1/tournaments/t_abc123';

      group('成功シナリオ。', () {
        test('成功した場合、SuccessRepositoryResult を返す。', () async {
          // ダミーの値から生成される想定の URL を元にスタブを用意する。
          when(mockHttpClient.getUri(Uri.parse(url))).thenAnswer((_) async {
            return const SuccessHttpResponse(
              jsonData: {
                'id': 't_abc123',
                'name': '第5回TCG大会',
                'status': 'IN_PROGRESS',
                'schedule': {'mode': 'FIXED', 'totalRounds': 7},
                'currentRound': 3,
              },
              headers: {},
            );
          });

          // 処理実行時、成功レスポンスが返ってくることを確認する。
          final result = await getTournamentInfo();
          expect(
            result,
            isA<SuccessRepositoryResult<TournamentInfoResponse>>(),
          );

          // 各フィールドの値が正しいことを確認する。
          final response =
              (result as SuccessRepositoryResult<TournamentInfoResponse>).data;
          expect(response.id, 't_abc123');
          expect(response.name, '第5回TCG大会');
          expect(response.status, 'IN_PROGRESS');
          expect(response.schedule.mode, 'FIXED');
          expect(response.schedule.totalRounds, 7);
          expect(response.currentRound, 3);
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
          final result = await getTournamentInfo();
          expect(
            result,
            isA<FailureRepositoryResult<TournamentInfoResponse>>(),
          );

          final failureResult =
              result as FailureRepositoryResult<TournamentInfoResponse>;
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
