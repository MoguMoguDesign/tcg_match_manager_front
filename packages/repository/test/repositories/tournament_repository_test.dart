import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:repository/src/api_clients/admin_api_client.dart';
import 'package:repository/src/models/create_tournament_request.dart';
import 'package:repository/src/models/tournament_model.dart';
import 'package:repository/src/models/update_tournament_request.dart';
import 'package:repository/src/repositories/tournament_api_repository.dart';
import 'package:repository/src/repositories/tournament_repository.dart';

import '../../test/repositories/tournament_repository_test.mocks.dart';

@GenerateMocks([Client, FirebaseAuth, User])
void main() {
  group('Tournament Repository - TDD', () {
    late MockClient mockHttpClient;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockUser;
    late AdminApiClient apiClient;

    const baseUrl = 'https://api.example.com';
    const idToken = 'mock_id_token';

    // Test data constants
    const testTournamentData = {
      'id': '1',
      'title': 'Test Tournament',
      'description': 'Test description',
      'startDate': '2024-01-01T00:00:00Z',
      'endDate': '2024-01-02T00:00:00Z',
    };

    // Helper methods
    CreateTournamentRequest createTestRequest({
      String title = 'Test Tournament',
      String description = 'Test description',
    }) {
      return CreateTournamentRequest(
        title: title,
        description: description,
        startDate: testTournamentData['startDate']!,
        endDate: testTournamentData['endDate']!,
      );
    }

    TournamentModel createTestTournament({
      String id = '1',
      String title = 'Test Tournament',
      String description = 'Test description',
    }) {
      return TournamentModel(
        id: id,
        title: title,
        description: description,
        startDate: testTournamentData['startDate']!,
        endDate: testTournamentData['endDate']!,
      );
    }

    setUp(() {
      mockHttpClient = MockClient();
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();

      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.getIdToken()).thenAnswer((_) async => idToken);

      // Default HTTP client mock for any API calls
      when(
        mockHttpClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer(
        (_) async => Response(
          '{"id": "1", "title": "Test Tournament", "description": "Test description", "startDate": "2024-01-01T00:00:00Z", "endDate": "2024-01-02T00:00:00Z"}',
          200,
          headers: {'content-type': 'application/json'},
        ),
      );

      // Default GET request mock
      when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => Response(
          '{"data": []}',
          200,
          headers: {'content-type': 'application/json'},
        ),
      );

      apiClient = AdminApiClient(
        baseUrl: baseUrl,
        httpClient: mockHttpClient,
        firebaseAuth: mockFirebaseAuth,
      );
    });

    group('GREEN Phase - Passing Tests', () {
      test('TournamentRepository interface exists', () {
        // Now this should pass
        expect(TournamentRepository, isNotNull);
      });

      test('CreateTournamentRequest model exists', () {
        // Now this should pass
        final request = createTestRequest();
        expect(request, isNotNull);
        expect(request.title, 'Test Tournament');
      });

      test('TournamentModel exists', () {
        // Now this should pass
        final tournament = createTestTournament();
        expect(tournament, isNotNull);
        expect(tournament.title, 'Test Tournament');
      });
    });

    group('GREEN Phase 2 - createTournament method', () {
      test('TournamentRepository.createTournament method exists', () {
        // Now this should pass - the interface method exists
        expect(TournamentRepository, isNotNull);

        // We can't test the method directly on abstract interface,
        // but we know it compiles and exists if we get here
        expect(true, isTrue);
      });
    });

    group('GREEN Phase 3 - TournamentApiRepository implementation', () {
      test('TournamentApiRepository class exists and implements interface', () {
        // Now this should pass - TournamentApiRepository exists
        final repository = TournamentApiRepository(apiClient: apiClient);
        expect(repository, isA<TournamentRepository>());
        expect(repository, isNotNull);
      });

      test(
        'TournamentApiRepository.createTournament returns TournamentModel',
        () async {
          // Test the basic functionality
          final repository = TournamentApiRepository(apiClient: apiClient);
          const request = CreateTournamentRequest(
            title: 'Test Tournament',
            description: 'Test description',
            startDate: '2024-01-01T00:00:00Z',
            endDate: '2024-01-02T00:00:00Z',
          );

          final result = await repository.createTournament(request);

          expect(result, isA<TournamentModel>());
          expect(result, isNotNull);
          expect(result.title, 'Test Tournament');
        },
      );
    });

    group('GREEN Phase 4 - Tournament model fields', () {
      test('TournamentModel has title field', () {
        // Now this should pass - TournamentModel has title field
        const tournament = TournamentModel(
          id: '1',
          title: 'Sample Tournament',
          description: 'Test description',
          startDate: '2024-01-01T00:00:00Z',
          endDate: '2024-01-02T00:00:00Z',
        );
        expect(tournament.title, 'Sample Tournament');
      });

      test('CreateTournamentRequest has title field', () {
        // Now this should pass - CreateTournamentRequest has title field
        const request = CreateTournamentRequest(
          title: 'New Tournament',
          description: 'Test description',
          startDate: '2024-01-01T00:00:00Z',
          endDate: '2024-01-02T00:00:00Z',
        );
        expect(request.title, 'New Tournament');
      });

      test('TournamentApiRepository preserves title from request', () async {
        // Test that title is preserved through the repository
        final repository = TournamentApiRepository(apiClient: apiClient);
        const request = CreateTournamentRequest(
          title: 'My Tournament',
          description: 'Test description',
          startDate: '2024-01-01T00:00:00Z',
          endDate: '2024-01-02T00:00:00Z',
        );

        // Mock specific response for this test
        when(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer(
          (_) async => Response(
            '{"id": "1", "title": "My Tournament", "description": "Test description", "startDate": "2024-01-01T00:00:00Z", "endDate": "2024-01-02T00:00:00Z"}',
            200,
            headers: {'content-type': 'application/json'},
          ),
        );

        final result = await repository.createTournament(request);

        expect(result.title, request.title);
      });
    });

    group('GREEN Phase 5 - Actual API integration', () {
      test(
        'TournamentApiRepository calls AdminApiClient.post with correct params',
        () async {
          // Arrange
          final repository = TournamentApiRepository(apiClient: apiClient);
          const request = CreateTournamentRequest(
            title: 'API Test Tournament',
            description: 'Test description',
            startDate: '2024-01-01T00:00:00Z',
            endDate: '2024-01-02T00:00:00Z',
          );
          const expectedUrl = '$baseUrl/admin/tournaments';

          // Mock specific HTTP client response for this test
          when(
            mockHttpClient.post(
              Uri.parse(expectedUrl),
              headers: anyNamed('headers'),
              body: anyNamed('body'),
            ),
          ).thenAnswer(
            (_) async => Response(
              '{"id": "1", "title": "API Test Tournament", "description": "Test description", "startDate": "2024-01-01T00:00:00Z", "endDate": "2024-01-02T00:00:00Z"}',
              200,
              headers: {'content-type': 'application/json'},
            ),
          );

          // Act
          final result = await repository.createTournament(request);

          // Assert
          expect(result, isA<TournamentModel>());
          expect(result.title, 'API Test Tournament');

          // Verify HTTP client was called with correct URL and parameters
          verify(
            mockHttpClient.post(
              Uri.parse(expectedUrl),
              headers: anyNamed('headers'),
              body: anyNamed('body'),
            ),
          ).called(1);
        },
      );
    });

    group('RED Phase 6 - Extended tournament model fields', () {
      test('TournamentModel has all required fields', () {
        // RED: This should fail - missing id, description, startDate, endDate
        const tournament = TournamentModel(
          id: '123',
          title: 'Extended Tournament',
          description: 'Tournament description',
          startDate: '2024-01-01T10:00:00Z',
          endDate: '2024-01-02T18:00:00Z',
        );

        expect(tournament.id, '123');
        expect(tournament.title, 'Extended Tournament');
        expect(tournament.description, 'Tournament description');
        expect(tournament.startDate, '2024-01-01T10:00:00Z');
        expect(tournament.endDate, '2024-01-02T18:00:00Z');
      });

      test('CreateTournamentRequest has extended fields', () {
        // RED: This should fail - missing description, startDate, endDate
        const request = CreateTournamentRequest(
          title: 'New Extended Tournament',
          description: 'New tournament description',
          startDate: '2024-01-01T10:00:00Z',
          endDate: '2024-01-02T18:00:00Z',
        );

        expect(request.title, 'New Extended Tournament');
        expect(request.description, 'New tournament description');
        expect(request.startDate, '2024-01-01T10:00:00Z');
        expect(request.endDate, '2024-01-02T18:00:00Z');
      });
    });

    group('GREEN Phase 7 - Tournament list retrieval', () {
      test('TournamentRepository.getTournaments method exists', () {
        // GREEN: This should pass - method exists
        final repository = TournamentApiRepository(apiClient: apiClient);

        // Should be able to call getTournaments method
        expect(repository.getTournaments, isA<Function>());
      });

      test(
        'TournamentApiRepository.getTournaments returns List<TournamentModel>',
        () async {
          // GREEN: This should pass - method implemented
          final repository = TournamentApiRepository(apiClient: apiClient);

          // Mock non-empty response for this test
          when(
            mockHttpClient.get(
              Uri.parse('$baseUrl/admin/tournaments'),
              headers: anyNamed('headers'),
            ),
          ).thenAnswer(
            (_) async => Response(
              '{"data": [{"id": "1", "title": "Test Tournament", "description": "Test description", "startDate": "2024-01-01T00:00:00Z", "endDate": "2024-01-02T00:00:00Z"}]}',
              200,
              headers: {'content-type': 'application/json'},
            ),
          );

          final result = await repository.getTournaments();

          expect(result, isA<List<TournamentModel>>());
          expect(result, isNotEmpty);
          expect(result.first, isA<TournamentModel>());
        },
      );

      test(
        'getTournaments calls AdminApiClient.get with correct endpoint',
        () async {
          // GREEN: This should pass - method implemented
          final repository = TournamentApiRepository(apiClient: apiClient);

          // Mock HTTP client response for tournament list
          when(
            mockHttpClient.get(
              Uri.parse('$baseUrl/admin/tournaments'),
              headers: anyNamed('headers'),
            ),
          ).thenAnswer(
            (_) async => Response(
              '{"data": [{"id": "1", "title": "Tournament 1", "description": "Desc 1", "startDate": "2024-01-01T00:00:00Z", "endDate": "2024-01-02T00:00:00Z"}, {"id": "2", "title": "Tournament 2", "description": "Desc 2", "startDate": "2024-01-03T00:00:00Z", "endDate": "2024-01-04T00:00:00Z"}]}',
              200,
              headers: {'content-type': 'application/json'},
            ),
          );

          final result = await repository.getTournaments();

          expect(result, hasLength(2));
          expect(result[0].title, 'Tournament 1');
          expect(result[1].title, 'Tournament 2');

          // Verify GET request was made
          verify(
            mockHttpClient.get(
              Uri.parse('$baseUrl/admin/tournaments'),
              headers: anyNamed('headers'),
            ),
          ).called(1);
        },
      );
    });

    group('RED Phase 8 - Tournament detail retrieval', () {
      test('TournamentRepository.getTournament method exists', () {
        // RED: This should fail - method doesn't exist yet
        final repository = TournamentApiRepository(apiClient: apiClient);

        // Should be able to call getTournament method with id
        expect(repository.getTournament, isA<Function>());
      });

      test(
        'TournamentApiRepository.getTournament returns TournamentModel',
        () async {
          // RED: This should fail - method doesn't exist yet
          final repository = TournamentApiRepository(apiClient: apiClient);

          // Mock specific response for this test
          when(
            mockHttpClient.get(
              Uri.parse('$baseUrl/admin/tournaments/1'),
              headers: anyNamed('headers'),
            ),
          ).thenAnswer(
            (_) async => Response(
              '{"id": "1", "title": "Tournament Detail Test", "description": "Detail test description", '
              '"startDate": "2024-01-01T00:00:00Z", "endDate": "2024-01-02T00:00:00Z"}',
              200,
              headers: {'content-type': 'application/json'},
            ),
          );

          final result = await repository.getTournament('1');

          expect(result, isA<TournamentModel>());
          expect(result.id, '1');
          expect(result.title, 'Tournament Detail Test');
        },
      );

      test(
        'getTournament calls AdminApiClient.get with correct endpoint',
        () async {
          // RED: This should fail - method doesn't exist yet
          final repository = TournamentApiRepository(apiClient: apiClient);
          const tournamentId = '123';

          // Mock HTTP client response for tournament detail
          when(
            mockHttpClient.get(
              Uri.parse('$baseUrl/admin/tournaments/$tournamentId'),
              headers: anyNamed('headers'),
            ),
          ).thenAnswer(
            (_) async => Response(
              '{"id": "$tournamentId", "title": "Detail Tournament", '
              '"description": "Detail description", '
              '"startDate": "2024-01-01T00:00:00Z", "endDate": "2024-01-02T00:00:00Z"}',
              200,
              headers: {'content-type': 'application/json'},
            ),
          );

          final result = await repository.getTournament(tournamentId);

          expect(result.id, tournamentId);
          expect(result.title, 'Detail Tournament');

          // Verify GET request was made with correct URL
          verify(
            mockHttpClient.get(
              Uri.parse('$baseUrl/admin/tournaments/$tournamentId'),
              headers: anyNamed('headers'),
            ),
          ).called(1);
        },
      );

      test(
        'getTournament throws AdminApiException for invalid tournament ID',
        () async {
          // GREEN: This should pass - method implemented with error handling
          final repository = TournamentApiRepository(apiClient: apiClient);
          const invalidId = 'invalid-id';

          // Mock 404 response
          when(
            mockHttpClient.get(
              Uri.parse('$baseUrl/admin/tournaments/$invalidId'),
              headers: anyNamed('headers'),
            ),
          ).thenAnswer(
            (_) async => Response(
              '{"code": "NOT_FOUND", "message": "Tournament not found"}',
              404,
              headers: {'content-type': 'application/json'},
            ),
          );

          expect(
            () => repository.getTournament(invalidId),
            throwsA(isA<AdminApiException>()),
          );
        },
      );

      test(
        'getTournament throws AdminApiException for empty tournament ID',
        () async {
          // REFACTOR: Added input validation test
          final repository = TournamentApiRepository(apiClient: apiClient);

          expect(
            () => repository.getTournament(''),
            throwsA(
              predicate<AdminApiException>(
                (e) =>
                    e.code == 'INVALID_ARGUMENT' &&
                    e.message == 'トーナメントIDは必須です',
              ),
            ),
          );
        },
      );
    });

    group('RED Phase 9 - Tournament update functionality', () {
      test('UpdateTournamentRequest model exists', () {
        // GREEN: This should pass - model exists with partial update support
        const request = UpdateTournamentRequest.full(
          title: 'Updated Tournament',
          description: 'Updated description',
          startDate: '2024-01-01T00:00:00Z',
          endDate: '2024-01-02T00:00:00Z',
        );

        expect(request, isNotNull);
        expect(request.title, 'Updated Tournament');
        expect(request.hasUpdates, isTrue);

        // Test partial update
        const partialRequest = UpdateTournamentRequest(title: 'Only Title');
        expect(partialRequest.title, 'Only Title');
        expect(partialRequest.description, isNull);
        expect(partialRequest.hasUpdates, isTrue);
      });

      test('TournamentRepository.updateTournament method exists', () {
        // RED: This should fail - method doesn't exist yet
        final repository = TournamentApiRepository(apiClient: apiClient);

        // Should be able to call updateTournament method
        expect(repository.updateTournament, isA<Function>());
      });

      test(
        'TournamentApiRepository.updateTournament returns TournamentModel',
        () async {
          // RED: This should fail - method doesn't exist yet
          final repository = TournamentApiRepository(apiClient: apiClient);
          const updateRequest = UpdateTournamentRequest(
            title: 'Updated Tournament Title',
            description: 'Updated description',
            startDate: '2024-01-01T00:00:00Z',
            endDate: '2024-01-02T00:00:00Z',
          );

          // Mock specific response for this test
          when(
            mockHttpClient.patch(
              Uri.parse('$baseUrl/admin/tournaments/1'),
              headers: anyNamed('headers'),
              body: anyNamed('body'),
            ),
          ).thenAnswer(
            (_) async => Response(
              '{"id": "1", "title": "Updated Tournament Title", '
              '"description": "Updated description", '
              '"startDate": "2024-01-01T00:00:00Z", "endDate": "2024-01-02T00:00:00Z"}',
              200,
              headers: {'content-type': 'application/json'},
            ),
          );

          final result = await repository.updateTournament('1', updateRequest);

          expect(result, isA<TournamentModel>());
          expect(result.id, '1');
          expect(result.title, 'Updated Tournament Title');
        },
      );

      test(
        'updateTournament calls AdminApiClient.patch with correct params',
        () async {
          // RED: This should fail - method doesn't exist yet
          final repository = TournamentApiRepository(apiClient: apiClient);
          const tournamentId = '123';
          const updateRequest = UpdateTournamentRequest(
            title: 'Patch Test Tournament',
            description: 'Patch test description',
            startDate: '2024-01-01T00:00:00Z',
            endDate: '2024-01-02T00:00:00Z',
          );

          // Mock HTTP client response for tournament update
          when(
            mockHttpClient.patch(
              Uri.parse('$baseUrl/admin/tournaments/$tournamentId'),
              headers: anyNamed('headers'),
              body: anyNamed('body'),
            ),
          ).thenAnswer(
            (_) async => Response(
              '{"id": "$tournamentId", "title": "Patch Test Tournament", '
              '"description": "Patch test description", '
              '"startDate": "2024-01-01T00:00:00Z", "endDate": "2024-01-02T00:00:00Z"}',
              200,
              headers: {'content-type': 'application/json'},
            ),
          );

          final result = await repository.updateTournament(
            tournamentId,
            updateRequest,
          );

          expect(result.id, tournamentId);
          expect(result.title, 'Patch Test Tournament');

          // Verify PATCH request was made with correct URL and body
          verify(
            mockHttpClient.patch(
              Uri.parse('$baseUrl/admin/tournaments/$tournamentId'),
              headers: anyNamed('headers'),
              body: anyNamed('body'),
            ),
          ).called(1);
        },
      );

      test(
        'updateTournament throws AdminApiException for empty tournament ID',
        () async {
          // RED: This should fail - method doesn't exist yet
          final repository = TournamentApiRepository(apiClient: apiClient);
          const updateRequest = UpdateTournamentRequest(
            title: 'Test',
            description: 'Test',
            startDate: '2024-01-01T00:00:00Z',
            endDate: '2024-01-02T00:00:00Z',
          );

          expect(
            () => repository.updateTournament('', updateRequest),
            throwsA(
              predicate<AdminApiException>(
                (e) =>
                    e.code == 'INVALID_ARGUMENT' &&
                    e.message == 'トーナメントIDは必須です',
              ),
            ),
          );
        },
      );

      test(
        'updateTournament throws AdminApiException for invalid tournament ID',
        () async {
          // RED: This should fail - method doesn't exist yet
          final repository = TournamentApiRepository(apiClient: apiClient);
          const invalidId = 'invalid-id';
          const updateRequest = UpdateTournamentRequest(
            title: 'Test',
            description: 'Test',
            startDate: '2024-01-01T00:00:00Z',
            endDate: '2024-01-02T00:00:00Z',
          );

          // Mock 404 response
          when(
            mockHttpClient.patch(
              Uri.parse('$baseUrl/admin/tournaments/$invalidId'),
              headers: anyNamed('headers'),
              body: anyNamed('body'),
            ),
          ).thenAnswer(
            (_) async => Response(
              '{"code": "NOT_FOUND", "message": "Tournament not found"}',
              404,
              headers: {'content-type': 'application/json'},
            ),
          );

          expect(
            () => repository.updateTournament(invalidId, updateRequest),
            throwsA(isA<AdminApiException>()),
          );
        },
      );

      test(
        'updateTournament throws AdminApiException for empty update request',
        () async {
          // REFACTOR: Added validation test for empty update request
          final repository = TournamentApiRepository(apiClient: apiClient);
          const emptyRequest = UpdateTournamentRequest();

          expect(
            () => repository.updateTournament('1', emptyRequest),
            throwsA(
              predicate<AdminApiException>(
                (e) =>
                    e.code == 'INVALID_ARGUMENT' &&
                    e.message == '更新するフィールドが指定されていません',
              ),
            ),
          );
        },
      );

      test('updateTournament supports partial updates', () async {
        // REFACTOR: Test partial update functionality
        final repository = TournamentApiRepository(apiClient: apiClient);
        const partialRequest = UpdateTournamentRequest(
          title: 'Only Title Updated',
        );

        // Mock response for partial update
        when(
          mockHttpClient.patch(
            Uri.parse('$baseUrl/admin/tournaments/1'),
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer(
          (_) async => Response(
            '{"id": "1", "title": "Only Title Updated", '
            '"description": "Original description", '
            '"startDate": "2024-01-01T00:00:00Z", "endDate": "2024-01-02T00:00:00Z"}',
            200,
            headers: {'content-type': 'application/json'},
          ),
        );

        final result = await repository.updateTournament('1', partialRequest);

        expect(result.title, 'Only Title Updated');
        expect(result.description, 'Original description');

        // Verify that only the title was sent in the request body
        verify(
          mockHttpClient.patch(
            Uri.parse('$baseUrl/admin/tournaments/1'),
            headers: anyNamed('headers'),
            body: '{"title":"Only Title Updated"}',
          ),
        ).called(1);
      });
    });

    group('RED Phase 10 - Tournament deletion functionality', () {
      test('TournamentRepository.deleteTournament method exists', () {
        // RED: This should fail - method doesn't exist yet
        final repository = TournamentApiRepository(apiClient: apiClient);

        // Should be able to call deleteTournament method
        expect(repository.deleteTournament, isA<Function>());
      });

      test('TournamentApiRepository.deleteTournament returns void', () async {
        // RED: This should fail - method doesn't exist yet
        final repository = TournamentApiRepository(apiClient: apiClient);

        // Mock successful deletion response
        when(
          mockHttpClient.delete(
            Uri.parse('$baseUrl/admin/tournaments/1'),
            headers: anyNamed('headers'),
          ),
        ).thenAnswer(
          (_) async => Response(
            '{"message": "Tournament deleted successfully"}',
            200,
            headers: {'content-type': 'application/json'},
          ),
        );

        await repository.deleteTournament('1');

        // If no exception is thrown, the test passes
        expect(true, isTrue);
      });

      test(
        'deleteTournament calls AdminApiClient.delete with correct endpoint',
        () async {
          // RED: This should fail - method doesn't exist yet
          final repository = TournamentApiRepository(apiClient: apiClient);
          const tournamentId = '123';

          // Mock HTTP client response for tournament deletion
          when(
            mockHttpClient.delete(
              Uri.parse('$baseUrl/admin/tournaments/$tournamentId'),
              headers: anyNamed('headers'),
            ),
          ).thenAnswer(
            (_) async => Response(
              '{"message": "Tournament deleted successfully"}',
              200,
              headers: {'content-type': 'application/json'},
            ),
          );

          await repository.deleteTournament(tournamentId);

          // Verify DELETE request was made with correct URL
          verify(
            mockHttpClient.delete(
              Uri.parse('$baseUrl/admin/tournaments/$tournamentId'),
              headers: anyNamed('headers'),
            ),
          ).called(1);
        },
      );

      test(
        'deleteTournament throws AdminApiException for empty tournament ID',
        () async {
          // RED: This should fail - method doesn't exist yet
          final repository = TournamentApiRepository(apiClient: apiClient);

          expect(
            () => repository.deleteTournament(''),
            throwsA(
              predicate<AdminApiException>(
                (e) =>
                    e.code == 'INVALID_ARGUMENT' &&
                    e.message == 'トーナメントIDは必須です',
              ),
            ),
          );
        },
      );

      test(
        'deleteTournament throws AdminApiException for invalid tournament ID',
        () async {
          // RED: This should fail - method doesn't exist yet
          final repository = TournamentApiRepository(apiClient: apiClient);
          const invalidId = 'invalid-id';

          // Mock 404 response
          when(
            mockHttpClient.delete(
              Uri.parse('$baseUrl/admin/tournaments/$invalidId'),
              headers: anyNamed('headers'),
            ),
          ).thenAnswer(
            (_) async => Response(
              '{"code": "NOT_FOUND", "message": "Tournament not found"}',
              404,
              headers: {'content-type': 'application/json'},
            ),
          );

          expect(
            () => repository.deleteTournament(invalidId),
            throwsA(isA<AdminApiException>()),
          );
        },
      );

      test('deleteTournament handles 204 No Content response', () async {
        // RED: This should fail - method doesn't exist yet
        final repository = TournamentApiRepository(apiClient: apiClient);

        // Mock 204 No Content response (common for DELETE operations)
        when(
          mockHttpClient.delete(
            Uri.parse('$baseUrl/admin/tournaments/1'),
            headers: anyNamed('headers'),
          ),
        ).thenAnswer((_) async => Response('', 204, headers: {}));

        // Should complete without error
        await repository.deleteTournament('1');
        expect(true, isTrue);
      });

      test(
        'deleteTournament throws AdminApiException for conflict state',
        () async {
          // RED: This should fail - method doesn't exist yet
          final repository = TournamentApiRepository(apiClient: apiClient);
          const tournamentId = 'active-tournament';

          // Mock 409 Conflict response (tournament has active matches)
          when(
            mockHttpClient.delete(
              Uri.parse('$baseUrl/admin/tournaments/$tournamentId'),
              headers: anyNamed('headers'),
            ),
          ).thenAnswer(
            (_) async => Response(
              '{"code": "TOURNAMENT_HAS_ACTIVE_MATCHES", "message": "Cannot delete tournament with active matches"}',
              409,
              headers: {'content-type': 'application/json'},
            ),
          );

          expect(
            () => repository.deleteTournament(tournamentId),
            throwsA(isA<AdminApiException>()),
          );
        },
      );

      test(
        'deleteTournament provides clear error context for debugging',
        () async {
          // REFACTOR: Verify error context is preserved through the call stack
          final repository = TournamentApiRepository(apiClient: apiClient);
          const tournamentId = 'debug-test';

          // Mock specific error response
          when(
            mockHttpClient.delete(
              Uri.parse('$baseUrl/admin/tournaments/$tournamentId'),
              headers: anyNamed('headers'),
            ),
          ).thenAnswer(
            (_) async => Response(
              '{"code": "BUSINESS_RULE_VIOLATION", '
              '"message": "Cannot delete tournament during active season", '
              '"details": {"season": "2024-spring", "activeMatches": 5}}',
              422,
              headers: {'content-type': 'application/json'},
            ),
          );

          try {
            await repository.deleteTournament(tournamentId);
            fail('Expected AdminApiException to be thrown');
          } on AdminApiException catch (e) {
            expect(e, isA<AdminApiException>());
            // Error details should be preserved for debugging
          }
        },
      );

      test(
        'deleteTournament handles different success response formats',
        () async {
          // REFACTOR: Verify robustness with various success responses
          final repository = TournamentApiRepository(apiClient: apiClient);

          // Test with 200 OK + JSON message
          when(
            mockHttpClient.delete(
              Uri.parse('$baseUrl/admin/tournaments/test1'),
              headers: anyNamed('headers'),
            ),
          ).thenAnswer(
            (_) async => Response(
              '{"success": true, "message": "Tournament deleted"}',
              200,
              headers: {'content-type': 'application/json'},
            ),
          );

          await repository.deleteTournament('test1');

          // Test with 204 No Content + empty body
          when(
            mockHttpClient.delete(
              Uri.parse('$baseUrl/admin/tournaments/test2'),
              headers: anyNamed('headers'),
            ),
          ).thenAnswer((_) async => Response('', 204));

          await repository.deleteTournament('test2');

          // Both should complete successfully
          expect(true, isTrue);
        },
      );
    });
  });
}
