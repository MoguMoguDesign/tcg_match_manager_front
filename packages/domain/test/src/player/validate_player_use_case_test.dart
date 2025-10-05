import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';

import 'validate_player_use_case_test.mocks.dart';

@GenerateNiceMocks([MockSpec<PlayerAuthRepository>()])
void main() {
  late MockPlayerAuthRepository mockPlayerAuthRepository;
  late ValidatePlayerUseCase validatePlayerUseCase;

  setUp(() {
    mockPlayerAuthRepository = MockPlayerAuthRepository();
    validatePlayerUseCase = ValidatePlayerUseCase(
      playerAuthRepository: mockPlayerAuthRepository,
    );

    // スタブされていないメソッドが呼び出された場合、unknown の失敗結果を返すようにする。
    provideDummy<RepositoryResult<PlayerAuthResponse>>(
      RepositoryResult<PlayerAuthResponse>.failure(
        Exception(),
        reason: FailureRepositoryResultReason.unknown,
      ),
    );
  });

  group('validatePlayerUseCaseProvider のテスト。', () {
    test('validatePlayerUseCaseProvider が ValidatePlayerUseCase を返す。', () {
      final container = ProviderContainer(
        overrides: [
          // 依存する playerAuthRepositoryProvider をモックで上書きする。
          playerAuthRepositoryProvider
              .overrideWithValue(mockPlayerAuthRepository),
        ],
      );
      addTearDown(container.dispose);
      expect(
        container.read(validatePlayerUseCaseProvider),
        isA<ValidatePlayerUseCase>(),
      );
    });
  });

  group('ValidatePlayerUseCase のテスト。', () {
    group('invoke メソッドのテスト。', () {
      /// プレイヤー認証を行う。
      Future<PlayerSession> validatePlayer() async {
        return validatePlayerUseCase.invoke(
          baseUrl: 'https://example.com/',
          tournamentId: 'tournament123',
          userId: 'user456',
        );
      }

      group('成功シナリオ。', () {
        test('プレイヤー認証に成功した場合、PlayerSession オブジェクトを返す。', () async {
          // スタブを用意する。
          when(
            mockPlayerAuthRepository.validatePlayer(
              baseUrl: anyNamed('baseUrl'),
              tournamentId: anyNamed('tournamentId'),
              request: anyNamed('request'),
            ),
          ).thenAnswer(
            (_) async => const RepositoryResult<PlayerAuthResponse>.success(
              PlayerAuthResponse(
                valid: true,
                playerId: 'player123',
                playerName: 'テストプレイヤー',
              ),
            ),
          );

          // プレイヤー認証処理を実行後、返り値が PlayerSession オブジェクトであることを確認する。
          final session = await validatePlayer();
          expect(session, isA<PlayerSession>());

          // PlayerSession の値を確認する。
          expect(session.playerId, 'player123');
          expect(session.userId, 'user456');
          expect(session.tournamentId, 'tournament123');
          expect(session.playerName, 'テストプレイヤー');

          // セッション有効期限が24時間後に設定されていることを確認する。
          final now = DateTime.now();
          final expectedExpiry = now.add(const Duration(hours: 24));
          expect(
            session.expiresAt.difference(expectedExpiry).inMinutes.abs(),
            lessThan(1),
          );
        });
      });

      group('失敗シナリオ。', () {
        /// どの引数でプレイヤー認証処理を実行しても失敗結果を返す。
        ///
        /// 各テスト内では、このメソッドを呼び出してスタブを用意する。
        void setupMockRepositoryValidatePlayer(
          FailureRepositoryResult<PlayerAuthResponse> failureResult,
        ) {
          when(
            mockPlayerAuthRepository.validatePlayer(
              baseUrl: anyNamed('baseUrl'),
              tournamentId: anyNamed('tournamentId'),
              request: anyNamed('request'),
            ),
          ).thenAnswer((_) async => failureResult);
        }

        test(
          'noConnection により失敗した場合、GeneralFailureException がスローされる。',
          () async {
            // noConnection により失敗するスタブを用意する。
            setupMockRepositoryValidatePlayer(
              FailureRepositoryResult<PlayerAuthResponse>(
                Exception(),
                reason: FailureRepositoryResultReason.noConnection,
              ),
            );

            // プレイヤー認証処理の実行時、GeneralFailureException がスローされ、その例外の内容が正しいことを確認する。
            expect(
              validatePlayer,
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
          setupMockRepositoryValidatePlayer(
            FailureRepositoryResult<PlayerAuthResponse>(
              Exception(),
              reason: FailureRepositoryResultReason.notFound,
            ),
          );

          // プレイヤー認証処理の実行時、GeneralFailureException がスローされ、その例外の内容が正しいことを確認する。
          expect(
            validatePlayer,
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
            setupMockRepositoryValidatePlayer(
              FailureRepositoryResult<PlayerAuthResponse>(
                Exception(),
                reason: FailureRepositoryResultReason.badResponse,
                statusCode: 500,
              ),
            );

            // プレイヤー認証処理の実行時、GeneralFailureException がスローされ、その例外の内容が正しいことを確認する。
            expect(
              validatePlayer,
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
          setupMockRepositoryValidatePlayer(
            FailureRepositoryResult<PlayerAuthResponse>(
              Exception(),
              reason: FailureRepositoryResultReason.cancel,
            ),
          );

          // プレイヤー認証処理の実行時、GeneralFailureException がスローされ、その例外の内容が正しいことを確認する。
          expect(
            validatePlayer,
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
  });
}
