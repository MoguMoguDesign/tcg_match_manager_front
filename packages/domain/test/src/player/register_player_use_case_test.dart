import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';

import 'register_player_use_case_test.mocks.dart';

@GenerateNiceMocks([MockSpec<PlayerRegistrationRepository>()])
void main() {
  late MockPlayerRegistrationRepository mockPlayerRegistrationRepository;
  late RegisterPlayerUseCase registerPlayerUseCase;

  setUp(() {
    mockPlayerRegistrationRepository = MockPlayerRegistrationRepository();
    registerPlayerUseCase = RegisterPlayerUseCase(
      playerRegistrationRepository: mockPlayerRegistrationRepository,
    );

    // スタブされていないメソッドが呼び出された場合、unknown の失敗結果を返すようにする。
    provideDummy<RepositoryResult<PlayerRegistrationResponse>>(
      RepositoryResult<PlayerRegistrationResponse>.failure(
        Exception(),
        reason: FailureRepositoryResultReason.unknown,
      ),
    );
  });

  group('registerPlayerUseCaseProvider のテスト。', () {
    test('registerPlayerUseCaseProvider が RegisterPlayerUseCase を返す。', () {
      final container = ProviderContainer(
        overrides: [
          // 依存する playerRegistrationRepositoryProvider をモックで上書きする。
          playerRegistrationRepositoryProvider
              .overrideWithValue(mockPlayerRegistrationRepository),
        ],
      );
      addTearDown(container.dispose);
      expect(
        container.read(registerPlayerUseCaseProvider),
        isA<RegisterPlayerUseCase>(),
      );
    });
  });

  group('RegisterPlayerUseCase のテスト。', () {
    group('invoke メソッドのテスト。', () {
      /// プレイヤー登録を行う。
      Future<PlayerSession> registerPlayer() async {
        return registerPlayerUseCase.invoke(
          baseUrl: 'https://example.com/',
          tournamentId: 'tournament123',
          playerName: 'テストプレイヤー',
        );
      }

      group('成功シナリオ。', () {
        test('プレイヤー登録に成功した場合、PlayerSession オブジェクトを返す。', () async {
          // スタブを用意する。
          when(
            mockPlayerRegistrationRepository.registerPlayer(
              baseUrl: anyNamed('baseUrl'),
              tournamentId: anyNamed('tournamentId'),
              request: anyNamed('request'),
            ),
          ).thenAnswer(
            (_) async =>
                const RepositoryResult<PlayerRegistrationResponse>.success(
              PlayerRegistrationResponse(
                playerId: 'player123',
                playerNumber: 5,
                status: 'registered',
                userId: 'user456',
              ),
            ),
          );

          // プレイヤー登録処理を実行後、返り値が PlayerSession オブジェクトであることを確認する。
          final session = await registerPlayer();
          expect(session, isA<PlayerSession>());

          // PlayerSession の値を確認する。
          expect(session.playerId, 'player123');
          expect(session.playerNumber, 5);
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
        /// どの引数でプレイヤー登録処理を実行しても失敗結果を返す。
        ///
        /// 各テスト内では、このメソッドを呼び出してスタブを用意する。
        void setupMockRepositoryRegisterPlayer(
          FailureRepositoryResult<PlayerRegistrationResponse> failureResult,
        ) {
          when(
            mockPlayerRegistrationRepository.registerPlayer(
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
            setupMockRepositoryRegisterPlayer(
              FailureRepositoryResult<PlayerRegistrationResponse>(
                Exception(),
                reason: FailureRepositoryResultReason.noConnection,
              ),
            );

            // プレイヤー登録処理の実行時、GeneralFailureException がスローされ、その例外の内容が正しいことを確認する。
            expect(
              registerPlayer,
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
          setupMockRepositoryRegisterPlayer(
            FailureRepositoryResult<PlayerRegistrationResponse>(
              Exception(),
              reason: FailureRepositoryResultReason.notFound,
            ),
          );

          // プレイヤー登録処理の実行時、GeneralFailureException がスローされ、その例外の内容が正しいことを確認する。
          expect(
            registerPlayer,
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
            setupMockRepositoryRegisterPlayer(
              FailureRepositoryResult<PlayerRegistrationResponse>(
                Exception(),
                reason: FailureRepositoryResultReason.badResponse,
                statusCode: 500,
              ),
            );

            // プレイヤー登録処理の実行時、GeneralFailureException がスローされ、その例外の内容が正しいことを確認する。
            expect(
              registerPlayer,
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
          setupMockRepositoryRegisterPlayer(
            FailureRepositoryResult<PlayerRegistrationResponse>(
              Exception(),
              reason: FailureRepositoryResultReason.cancel,
            ),
          );

          // プレイヤー登録処理の実行時、GeneralFailureException がスローされ、その例外の内容が正しいことを確認する。
          expect(
            registerPlayer,
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
