import 'package:flutter_test/flutter_test.dart';
import 'package:injection/injection.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:system/system.dart';

import 'player_registration_repository_test.mocks.dart';

// HttpClient のモッククラスを生成する。
@GenerateNiceMocks([MockSpec<HttpClient>()])
void main() {
  late MockHttpClient mockHttpClient;
  late PlayerRegistrationRepository repository;

  setUp(() {
    mockHttpClient = MockHttpClient();
    repository = PlayerRegistrationRepository(httpClient: mockHttpClient);
    // スタブされていないメソッドが呼び出された場合、ErrorStatus.unknown の失敗レスポンスを返すようにする。
    provideDummy<HttpResponse>(
      HttpResponse.failure(e: Exception(), status: ErrorStatus.unknown),
    );
  });

  group('playerRegistrationRepositoryProvider のテスト。', () {
    test('playerRegistrationRepositoryProvider が PlayerRegistrationRepository を返す。',
        () {
      final container = ProviderContainer(
        // 依存する httpClientProvider をモックで上書きする。
        overrides: [httpClientProvider.overrideWithValue(mockHttpClient)],
      );
      addTearDown(container.dispose);

      expect(
        container.read(playerRegistrationRepositoryProvider),
        isA<PlayerRegistrationRepository>(),
      );
    });
  });

  group('PlayerRegistrationRepository のテスト。', () {
    group('registerPlayer メソッドのテスト。', () {
      /// ダミーの値を用いて処理を実行する。
      ///
      /// 成功した場合は、SuccessRepositoryResult を返す。
      /// 失敗した場合は、FailureRepositoryResult を返す。
      Future<RepositoryResult<PlayerRegistrationResponse>> registerPlayer() async {
        return repository.registerPlayer(
          baseUrl: 'https://example.com/',
          tournamentId: 't_abc123',
          request: const PlayerRegistrationRequest(name: '山田太郎'),
        );
      }

      /// ダミー値から生成される想定の URL.
      const url =
          'https://example.com/player/api/v1/tournaments/t_abc123/players';

      group('成功シナリオ。', () {
        test('成功した場合、SuccessRepositoryResult を返す。', () async {
          // ダミーの値から生成される想定の URL を元にスタブを用意する。
          when(mockHttpClient.postUri(Uri.parse(url), any)).thenAnswer((_) async {
            return const SuccessHttpResponse(
              jsonData: {
                'playerId': 'p_1',
                'playerNumber': 42,
                'status': 'ACTIVE',
                'userId': 'uuid-v4-string',
              },
              headers: {},
            );
          });

          // 処理実行時、成功レスポンスが返ってくることを確認する。
          final result = await registerPlayer();
          expect(result, isA<SuccessRepositoryResult<PlayerRegistrationResponse>>());

          // 各フィールドの値が正しいことを確認する。
          final response =
              (result as SuccessRepositoryResult<PlayerRegistrationResponse>).data;
          expect(response.playerId, 'p_1');
          expect(response.playerNumber, 42);
          expect(response.status, 'ACTIVE');
          expect(response.userId, 'uuid-v4-string');
        });
      });

      group('失敗シナリオ。', () {
        test('失敗した場合、FailureRepositoryResult を返す。', () async {
          // どの URL の場合でも 404 が返ってくるスタブを用意する。
          when(mockHttpClient.postUri(any, any)).thenAnswer((_) async {
            return FailureHttpResponse(
              e: Exception(),
              status: ErrorStatus.notFound,
              statusCode: 404,
            );
          });

          // 処理実行時、失敗レスポンスが返ってくることを確認する。
          final result = await registerPlayer();
          expect(result, isA<FailureRepositoryResult<PlayerRegistrationResponse>>());

          final failureResult =
              result as FailureRepositoryResult<PlayerRegistrationResponse>;
          // reason が FailureRepositoryResultReason.notFound であることを確認する。
          expect(failureResult.reason, FailureRepositoryResultReason.notFound);
          // statusCode が 404 であることを確認する。
          expect(failureResult.statusCode, 404);
        });
      });
    });
  });
}
