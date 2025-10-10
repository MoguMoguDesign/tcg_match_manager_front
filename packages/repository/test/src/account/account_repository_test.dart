import 'package:flutter_test/flutter_test.dart';
import 'package:injection/injection.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:system/system.dart';

import 'account_repository_test.mocks.dart';

// HttpClient のモッククラスを生成する。
@GenerateNiceMocks([MockSpec<HttpClient>()])
void main() {
  late MockHttpClient mockHttpClient;
  late AccountRepository accountRepository;

  setUp(() {
    mockHttpClient = MockHttpClient();
    accountRepository = AccountRepository(httpClient: mockHttpClient);
    // スタブされていないメソッドが呼び出された場合、ErrorStatus.unknown の失敗レスポンスを返すようにする。
    provideDummy<HttpResponse>(
      HttpResponse.failure(e: Exception(), status: ErrorStatus.unknown),
    );
  });

  group('accountRepositoryProvider のテスト。', () {
    test('accountRepositoryProvider が AccountRepository を返す。', () {
      final container = ProviderContainer(
        // 依存する httpClientProvider をモックで上書きする。
        overrides: [httpClientProvider.overrideWithValue(mockHttpClient)],
      );
      addTearDown(container.dispose);

      expect(
        container.read(accountRepositoryProvider),
        isA<AccountRepository>(),
      );
    });
  });

  group('AccountRepository のテスト。', () {
    group('login メソッドのテスト。', () {
      /// ダミーの値を用いて処理を実行する。
      ///
      /// 成功した場合は、SuccessRepositoryResult を返す。
      /// 失敗した場合は、FailureRepositoryResult を返す。
      Future<RepositoryResult<AccountDto>> login() async {
        return accountRepository.login(
          baseUrl: 'https://api.example.com',
          username: 'testuser',
          password: 'password123',
        );
      }

      /// ダミー値から生成される想定の URL。
      const url = 'https://api.example.com/api/v1/auth/login';

      /// リクエストボディ。
      const requestBody = {
        'username': 'testuser',
        'password': 'password123',
        'api_version': 7,
      };

      group('成功シナリオ。', () {
        test('成功した場合、SuccessRepositoryResult を返す。', () async {
          // ダミーの値から生成される想定の URL を元にスタブを用意する。
          when(mockHttpClient.postUri(Uri.parse(url), requestBody)).thenAnswer((
            _,
          ) async {
            return const SuccessHttpResponse(
              jsonData: {
                'STATUS': '0',
                'SUB': 0,
                'MESSAGE': 'ログイン成功',
                'user_id': 'user123',
                'username': 'testuser',
                'display_name': 'Test User',
                'email': 'test@example.com',
                'api_version': 1,
                'access_token': 'dummy_access_token',
                'refresh_token': 'dummy_refresh_token',
                'expires_at': 1800000000,
              },
              headers: {},
            );
          });

          // 処理実行時、成功レスポンスが返ってくることを確認する。
          final result = await login();
          expect(result, isA<SuccessRepositoryResult<AccountDto>>());

          // 各フィールドの値が正しいことを確認する。
          final accountDto =
              (result as SuccessRepositoryResult<AccountDto>).data;
          expect(accountDto.isFailureStatus, false);
          expect(accountDto.sub, 0);
          expect(accountDto.message, 'ログイン成功');
          expect(accountDto.userId, 'user123');
          expect(accountDto.username, 'testuser');
          expect(accountDto.displayName, 'Test User');
          expect(accountDto.email, 'test@example.com');
          expect(accountDto.apiVersion, 1);
          expect(accountDto.accessToken, 'dummy_access_token');
          expect(accountDto.refreshToken, 'dummy_refresh_token');
          expect(accountDto.expiresAt, 1800000000);
        });
      });

      group('失敗シナリオ。', () {
        test('SuccessHttpResponse のステータスにより失敗と判断された場合、'
            ' FailureRepositoryResult を返す。', () async {
          // ダミーの値から生成される想定の URL を元にスタブを用意する。
          when(mockHttpClient.postUri(Uri.parse(url), requestBody)).thenAnswer((
            _,
          ) async {
            return const SuccessHttpResponse(
              jsonData: {'STATUS': '1', 'MESSAGE': 'ログイン失敗'},
              headers: {},
            );
          });

          // 処理実行時、失敗レスポンスが返ってくることを確認する。
          final result = await login();
          expect(result, isA<FailureRepositoryResult<AccountDto>>());

          // 失敗理由が failureStatus であることを確認する。
          final reason = (result as FailureRepositoryResult<AccountDto>).reason;
          expect(reason, FailureRepositoryResultReason.failureStatus);

          // AccountDto の isFailureStatus が true であることを確認する。
          final accountDto = result.data;
          expect(accountDto, isNotNull);
          expect(accountDto!.isFailureStatus, true);
          expect(accountDto.message, 'ログイン失敗');
        });

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
          final result = await login();
          expect(result, isA<FailureRepositoryResult<AccountDto>>());

          final failureResult = result as FailureRepositoryResult<AccountDto>;
          // reason が FailureRepositoryResultReason.notFound であることを確認する。
          expect(failureResult.reason, FailureRepositoryResultReason.notFound);
          // statusCode が 404 であることを確認する。
          expect(failureResult.statusCode, 404);
        });
      });
    });
  });
}
