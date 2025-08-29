import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';

import 'login_use_case_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AccountRepository>()])
void main() {
  late MockAccountRepository mockAccountRepository;
  late LoginUseCase loginUseCase;

  setUp(() {
    mockAccountRepository = MockAccountRepository();
    loginUseCase = LoginUseCase(accountRepository: mockAccountRepository);

    // スタブされていないメソッドが呼び出された場合、unknown の失敗結果を返すようにする。
    provideDummy<RepositoryResult<AccountDto>>(
      RepositoryResult<AccountDto>.failure(
        Exception(),
        reason: FailureRepositoryResultReason.unknown,
        data: const AccountDto(isFailureStatus: true),
      ),
    );
  });

  group('loginUseCaseProvider のテスト。', () {
    test('loginUseCaseProvider が LoginUseCase を返す。', () {
      final container = ProviderContainer(
        overrides: [
          // 依存する accountRepositoryProvider をモックで上書きする。
          accountRepositoryProvider.overrideWithValue(mockAccountRepository),
        ],
      );
      addTearDown(container.dispose);
      expect(container.read(loginUseCaseProvider), isA<LoginUseCase>());
    });
  });
  group('LoginUseCase のテスト。', () {
    group('invoke メソッドのテスト。', () {
      /// ログインを行う。
      Future<Account> login() async {
        return loginUseCase.invoke(
          serverUrl: 'example.com',
          userName: 'testuser',
          password: 'password',
          isManualLogin: true,
          isGuest: false,
        );
      }

      group('成功シナリオ。', () {
        test('ログインに成功した場合、Account オブジェクトを返す。', () async {
          // ダミーの値から生成される想定の引数を元にスタブを用意する。
          when(
            mockAccountRepository.login(
              baseUrl: 'https://example.com/',
              username: 'testuser',
              password: anyNamed('password'),
            ),
          ).thenAnswer(
            (_) async => const RepositoryResult<AccountDto>.success(
              AccountDto(
                isFailureStatus: false,
                userId: 'user123',
                username: 'testuser',
                displayName: 'テストユーザー',
                email: 'test@example.com',
                accessToken: 'dummy_access_token',
                refreshToken: 'dummy_refresh_token',
                expiresAt: 1800000000,
              ),
            ),
          );

          // ログイン処理を実行後、返り値が Account オブジェクトであることを確認する。
          final account = await login();
          expect(account, isA<Account>());

          // Account の値を確認する。
          expect(account.userId, 'user123');
          expect(account.username, 'testuser');
          expect(account.displayName, 'テストユーザー');
          expect(account.email, 'test@example.com');
          expect(account.accessToken, 'dummy_access_token');
        });
      });

      group('失敗シナリオ。', () {
        /// どの引数でログイン処理を実行しても失敗結果を返す。
        ///
        /// 各テスト内では、このメソッドを呼び出してスタブを用意する。
        void setupMockRepositoryLogin(
          FailureRepositoryResult<AccountDto> failureResult,
        ) {
          when(
            mockAccountRepository.login(
              baseUrl: anyNamed('baseUrl'),
              username: anyNamed('username'),
              password: anyNamed('password'),
            ),
          ).thenAnswer((_) async => failureResult);
        }

        test(
          'failureStatus により失敗した場合、FailureStatusException がスローされる。',
          () async {
            // failureStatus により失敗するスタブを用意する。
            setupMockRepositoryLogin(
              const FailureRepositoryResult<AccountDto>(
                {'isFailureStatus': true, 'message': 'test'},
                reason: FailureRepositoryResultReason.failureStatus,
                data: AccountDto(isFailureStatus: true, message: 'test'),
              ),
            );

            // ログイン処理の実行時、FailureStatusException がスローされ、その例外メッセージが正しいことを確認する。
            expect(
              login,
              throwsA(
                isA<FailureStatusException>().having(
                  (e) => e.message,
                  'メッセージには AccountDto の message フィールドの値が格納される。',
                  'test',
                ),
              ),
            );
          },
        );

        test(
          'noConnection により失敗した場合、GeneralFailureException がスローされる。',
          () async {
            // noConnection により失敗するスタブを用意する。
            setupMockRepositoryLogin(
              FailureRepositoryResult<AccountDto>(
                Exception(),
                reason: FailureRepositoryResultReason.noConnection,
              ),
            );

            // ログイン処理の実行時、GeneralFailureException がスローされ、その例外の内容が正しいことを確認する。
            expect(
              login,
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
                      FailureRepositoryResultReason.noConnection.name,
                    ),
              ),
            );
          },
        );

        test('notFound により失敗した場合、GeneralFailureException がスローされる。', () async {
          // notFound により失敗するスタブを用意する。
          setupMockRepositoryLogin(
            FailureRepositoryResult<AccountDto>(
              Exception(),
              reason: FailureRepositoryResultReason.notFound,
            ),
          );

          // ログイン処理の実行時、GeneralFailureException がスローされ、その例外の内容が正しいことを確認する。
          expect(
            login,
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
                    FailureRepositoryResultReason.notFound.name,
                  ),
            ),
          );
        });

        test(
          'badResponse により失敗した場合、GeneralFailureException がスローされる。',
          () async {
            // badResponse により失敗するスタブを用意する。
            setupMockRepositoryLogin(
              FailureRepositoryResult<AccountDto>(
                Exception(),
                reason: FailureRepositoryResultReason.badResponse,
                statusCode: 500,
              ),
            );

            // ログイン処理の実行時、GeneralFailureException がスローされ、その例外の内容が正しいことを確認する。
            expect(
              login,
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
                      FailureRepositoryResultReason.badResponse.name,
                    )
                    .having((e) => e.statusCode, 'ステータスコードが設定される。', 500),
              ),
            );
          },
        );

        test('その他のエラーにより失敗した場合、GeneralFailureException がスローされる。', () async {
          // cancel により失敗するスタブを用意する。
          setupMockRepositoryLogin(
            FailureRepositoryResult<AccountDto>(
              Exception(),
              reason: FailureRepositoryResultReason.cancel,
            ),
          );

          // ログイン処理の実行時、GeneralFailureException がスローされ、その例外の内容が正しいことを確認する。
          expect(
            login,
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
                    FailureRepositoryResultReason.cancel.name,
                  ),
            ),
          );
        });
      });
    });

    group('normalizeServerUrl メソッドのテスト。', () {
      test('空文字の場合は assert エラーとなる。', () {
        // 空文字の場合、AssertionError がスローされることを確認する。
        expect(
          () => loginUseCase.normalizeServerUrl(''),
          throwsA(isA<AssertionError>()),
        );
      });

      const testDomain = 'example.com';
      test('空白がトリムされる。', () {
        const expectedUrl = 'https://$testDomain/';
        // 先頭と末尾の空白がトリムされることを確認する。
        final result = loginUseCase.normalizeServerUrl('  $testDomain  ');
        expect(result, expectedUrl);

        // 先頭のみ空白がある場合もトリムされることを確認する。
        final resultLeading = loginUseCase.normalizeServerUrl('  $testDomain');
        expect(resultLeading, expectedUrl);

        // 末尾のみ空白がある場合もトリムされることを確認する。
        final resultTrailing = loginUseCase.normalizeServerUrl('$testDomain  ');
        expect(resultTrailing, expectedUrl);
      });
      test('http:// で始まる場合はそのまま返す。', () {
        // http:// で始まる場合、プロトコルはそのままで末尾に / が付与されることを確認する。
        final result = loginUseCase.normalizeServerUrl('http://$testDomain');
        expect(result, 'http://$testDomain/');
      });
      test('https:// で始まる場合はそのまま返す。', () {
        // https:// で始まる場合、プロトコルはそのままで末尾に / が付与されることを確認する。
        final result = loginUseCase.normalizeServerUrl('https://$testDomain');
        expect(result, 'https://$testDomain/');
      });
      test('http:// や https:// で始まらない場合は https:// を付与する。', () {
        // http:// や https:// で始まらない場合、プロトコルは https:// になることを確認する。
        final result = loginUseCase.normalizeServerUrl(testDomain);
        expect(result, 'https://$testDomain/');
      });
      test('末尾に / がない場合は / を付与する。', () {
        // 末尾に / がない場合、末尾に / が付与されることを確認する。
        final result = loginUseCase.normalizeServerUrl('https://$testDomain');
        expect(result, 'https://$testDomain/');
      });
      test('末尾に / がある場合はそのまま返す。', () {
        // 末尾に / がある場合、そのまま返されることを確認する。
        final result = loginUseCase.normalizeServerUrl('https://$testDomain/');
        expect(result, 'https://$testDomain/');
      });
    });
  });
}
