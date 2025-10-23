import 'package:flutter_test/flutter_test.dart';
import 'package:injection/injection.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:system/system.dart';

import 'player_auth_repository_test.mocks.dart';

// HttpClient のモッククラスを生成する。
@GenerateNiceMocks([MockSpec<HttpClient>()])
void main() {
  late MockHttpClient mockHttpClient;
  late PlayerAuthRepository repository;

  setUp(() {
    mockHttpClient = MockHttpClient();
    repository = PlayerAuthRepository(httpClient: mockHttpClient);
    // スタブされていないメソッドが呼び出された場合、ErrorStatus.unknown の失敗レスポンスを返すようにする。
    provideDummy<HttpResponse>(
      HttpResponse.failure(e: Exception(), status: ErrorStatus.unknown),
    );
  });

  group('playerAuthRepositoryProvider のテスト。', () {
    test('playerAuthRepositoryProvider が PlayerAuthRepository を返す。', () {
      final container = ProviderContainer(
        // 依存する httpClientProvider をモックで上書きする。
        overrides: [httpClientProvider.overrideWithValue(mockHttpClient)],
      );
      addTearDown(container.dispose);

      expect(
        container.read(playerAuthRepositoryProvider),
        isA<PlayerAuthRepository>(),
      );
    });
  });

  group('PlayerAuthRepository のテスト。', () {
    group('validatePlayer メソッドのテスト。', () {
      /// ダミーの値を用いて処理を実行する。
      ///
      /// 成功した場合は、SuccessRepositoryResult を返す。
      /// 失敗した場合は、FailureRepositoryResult を返す。
      Future<RepositoryResult<PlayerAuthResponse>> validatePlayer() async {
        return repository.validatePlayer(
          baseUrl: 'https://example.com/',
          tournamentId: 't_abc123',
          request: const PlayerAuthRequest(
            tournamentId: 't_abc123',
            userId: 'uuid-v4-string',
          ),
        );
      }

      /// ダミー値から生成される想定の URL.
      const url =
          'https://example.com/player/api/v1/tournaments/t_abc123/auth/validate';

      group('成功シナリオ。', () {
        test('成功した場合、SuccessRepositoryResult を返す。', () async {
          // ダミーの値から生成される想定の URL を元にスタブを用意する。
          when(mockHttpClient.postUri(Uri.parse(url), any))
              .thenAnswer((_) async {
            return const SuccessHttpResponse(
              jsonData: {
                'valid': true,
                'playerId': 'p_1',
                'playerName': '山田太郎',
              },
              headers: {},
            );
          });

          // 処理実行時、成功レスポンスが返ってくることを確認する。
          final result = await validatePlayer();
          expect(result, isA<SuccessRepositoryResult<PlayerAuthResponse>>());

          // 各フィールドの値が正しいことを確認する。
          final response =
              (result as SuccessRepositoryResult<PlayerAuthResponse>).data;
          expect(response.valid, true);
          expect(response.playerId, 'p_1');
          expect(response.playerName, '山田太郎');
        });
      });

      group('失敗シナリオ。', () {
        test('失敗した場合、FailureRepositoryResult を返す。', () async {
          // どの URL の場合でも 401 が返ってくるスタブを用意する。
          when(mockHttpClient.postUri(any, any)).thenAnswer((_) async {
            return FailureHttpResponse(
              e: Exception(),
              status: ErrorStatus.badResponse,
              statusCode: 401,
            );
          });

          // 処理実行時、失敗レスポンスが返ってくることを確認する。
          final result = await validatePlayer();
          expect(result, isA<FailureRepositoryResult<PlayerAuthResponse>>());

          final failureResult =
              result as FailureRepositoryResult<PlayerAuthResponse>;
          // reason が FailureRepositoryResultReason.badResponse であることを確認する。
          expect(
            failureResult.reason,
            FailureRepositoryResultReason.badResponse,
          );
          // statusCode が 401 であることを確認する。
          expect(failureResult.statusCode, 401);
        });
      });
    });
  });
}
