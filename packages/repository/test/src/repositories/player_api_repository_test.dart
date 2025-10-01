import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:repository/src/api_clients/admin_api_client.dart';
import 'package:repository/src/models/add_player_request.dart';
import 'package:repository/src/models/player_model.dart';
import 'package:repository/src/repositories/player_api_repository.dart';
import 'package:repository/src/repositories/player_repository.dart';

import 'player_api_repository_test.mocks.dart';

@GenerateMocks([Client, FirebaseAuth, User])
void main() {
  group('Player Repository - TDD', () {
    late MockClient mockHttpClient;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockUser;
    late AdminApiClient apiClient;
    late PlayerRepository repository;

    const baseUrl = 'https://api.example.com';
    const idToken = 'mock_id_token';
    const testTournamentId = 'test-tournament-id';

    // Helper methods
    AddPlayerRequest createTestRequest({
      String name = 'テストプレイヤー',
      int playerNumber = 42,
      String userId = 'test-user-id',
    }) {
      return AddPlayerRequest(
        name: name,
        playerNumber: playerNumber,
        userId: userId,
      );
    }

    setUp(() {
      mockHttpClient = MockClient();
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();

      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.getIdToken()).thenAnswer((_) async => idToken);

      apiClient = AdminApiClient(
        baseUrl: baseUrl,
        httpClient: mockHttpClient,
        firebaseAuth: mockFirebaseAuth,
      );
      repository = PlayerApiRepository(apiClient: apiClient);
    });

    group('addPlayer メソッドのテスト。', () {
      test('プレイヤー登録に成功した場合、PlayerModel を返す。', () async {
        final testRequest = createTestRequest();

        // POST request mock
        when(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer(
          (_) async => Response(
            '{"playerId": "p_1", "name": "テストプレイヤー", "playerNumber": 42, "status": "ACTIVE", "userId": "test-user-id"}',
            200,
            headers: {'content-type': 'application/json'},
          ),
        );

        // addPlayer メソッドを実行する。
        final result = await repository.addPlayer(
          tournamentId: testTournamentId,
          request: testRequest,
        );

        // 結果を確認する。
        expect(result, isA<PlayerModel>());
        expect(result.playerId, 'p_1');
        expect(result.name, 'テストプレイヤー');
        expect(result.playerNumber, 42);
        expect(result.status, 'ACTIVE');
        expect(result.userId, 'test-user-id');
      });

      test('HTTPエラーが発生した場合、AdminApiExceptionをスローする。', () async {
        final testRequest = createTestRequest();

        // POST request mock (error response)
        when(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer(
          (_) async => Response(
            '{"error": "Bad Request"}',
            400,
            headers: {'content-type': 'application/json'},
          ),
        );

        // addPlayer メソッドを実行し、例外がスローされることを確認する。
        expect(
          () => repository.addPlayer(
            tournamentId: testTournamentId,
            request: testRequest,
          ),
          throwsA(isA<AdminApiException>()),
        );
      });

      test('レスポンスのパースに失敗した場合、AdminApiExceptionをスローする。', () async {
        final testRequest = createTestRequest();

        // POST request mock (invalid JSON)
        when(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer(
          (_) async => Response(
            '{"invalidField": "value"}',
            200,
            headers: {'content-type': 'application/json'},
          ),
        );

        // addPlayer メソッドを実行し、例外がスローされることを確認する。
        expect(
          () => repository.addPlayer(
            tournamentId: testTournamentId,
            request: testRequest,
          ),
          throwsA(isA<AdminApiException>()),
        );
      });
    });

    group('getPlayers メソッドのテスト。', () {
      test('プレイヤー一覧の取得に成功した場合、PlayerModel のリストを返す。', () async {
        // GET request mock
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => Response(
            '{"players": [{"playerId": "p_1", "name": "テストプレイヤー1", "playerNumber": 1, "status": "ACTIVE", "userId": "user-1"}, {"playerId": "p_2", "name": "テストプレイヤー2", "playerNumber": 2, "status": "ACTIVE", "userId": "user-2"}]}',
            200,
            headers: {'content-type': 'application/json'},
          ),
        );

        // getPlayers メソッドを実行する。
        final result = await repository.getPlayers(
          tournamentId: testTournamentId,
        );

        // 結果を確認する。
        expect(result, isA<List<PlayerModel>>());
        expect(result.length, 2);
        expect(result[0].playerId, 'p_1');
        expect(result[0].name, 'テストプレイヤー1');
        expect(result[1].playerId, 'p_2');
        expect(result[1].name, 'テストプレイヤー2');
      });

      test('status パラメータを指定した場合、正しく動作する。', () async {
        // GET request mock
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => Response(
            '{"players": [{"playerId": "p_1", "name": "テストプレイヤー1", "playerNumber": 1, "status": "ACTIVE", "userId": "user-1"}]}',
            200,
            headers: {'content-type': 'application/json'},
          ),
        );

        // getPlayers メソッドを実行する。
        final result = await repository.getPlayers(
          tournamentId: testTournamentId,
          status: 'ACTIVE',
        );

        // 結果を確認する。
        expect(result, isA<List<PlayerModel>>());
        expect(result.length, 1);
      });

      test('空のプレイヤー一覧を取得した場合、空のリストを返す。', () async {
        // GET request mock
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => Response(
            '{"players": []}',
            200,
            headers: {'content-type': 'application/json'},
          ),
        );

        // getPlayers メソッドを実行する。
        final result = await repository.getPlayers(
          tournamentId: testTournamentId,
        );

        // 結果を確認する。
        expect(result, isA<List<PlayerModel>>());
        expect(result, isEmpty);
      });

      test('HTTPエラーが発生した場合、AdminApiExceptionをスローする。', () async {
        // GET request mock (error response)
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => Response(
            '{"error": "Not Found"}',
            404,
            headers: {'content-type': 'application/json'},
          ),
        );

        // getPlayers メソッドを実行し、例外がスローされることを確認する。
        expect(
          () => repository.getPlayers(tournamentId: testTournamentId),
          throwsA(isA<AdminApiException>()),
        );
      });

      test('レスポンスのパースに失敗した場合、AdminApiExceptionをスローする。', () async {
        // GET request mock (invalid JSON)
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => Response(
            '{"invalidField": "value"}',
            200,
            headers: {'content-type': 'application/json'},
          ),
        );

        // getPlayers メソッドを実行し、例外がスローされることを確認する。
        expect(
          () => repository.getPlayers(tournamentId: testTournamentId),
          throwsA(isA<AdminApiException>()),
        );
      });
    });
  });
}
