import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:repository/repository.dart';

import 'tournament_firestore_repository_test.mocks.dart';

// モック生成用のアノテーション
@GenerateMocks([
  FirebaseFirestore,
  FirebaseAuth,
  User,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
  QueryDocumentSnapshot,
  QuerySnapshot,
  Query,
])
void main() {
  group('TournamentFirestoreRepository のテスト。', () {
    late MockFirebaseFirestore mockFirestore;
    late MockFirebaseAuth mockAuth;
    late MockUser mockUser;
    late MockCollectionReference<Map<String, dynamic>> mockCollection;
    late TournamentFirestoreRepository repository;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockAuth = MockFirebaseAuth();
      mockUser = MockUser();
      mockCollection = MockCollectionReference<Map<String, dynamic>>();
      repository = TournamentFirestoreRepository(
        firestore: mockFirestore,
        auth: mockAuth,
      );

      // デフォルトでコレクション参照を返すようにモック
      when(mockFirestore.collection('tournaments')).thenReturn(mockCollection);
    });

    group('getTournaments のテスト。', () {
      test('未ログインの場合、例外がスローされる。', () async {
        // Arrange
        when(mockAuth.currentUser).thenReturn(null);

        // Act & Assert
        expect(() => repository.getTournaments(), throwsA(isA<Exception>()));
      });

      test('トーナメント一覧を正しく取得できる。', () async {
        // Arrange
        const uid = 'test-uid';
        when(mockAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn(uid);

        final mockQuery = MockQuery<Map<String, dynamic>>();
        final mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
        final mockDoc = MockQueryDocumentSnapshot<Map<String, dynamic>>();

        when(
          mockCollection.where('adminUid', isEqualTo: uid),
        ).thenReturn(mockQuery);
        when(
          mockQuery.orderBy('createdAt', descending: true),
        ).thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([mockDoc]);

        when(mockDoc.id).thenReturn('tournament-id');
        when(mockDoc.data()).thenReturn({
          'name': 'Test Tournament', // maps to title
          'overview': 'Test Description', // maps to description
          'venue': 'Test Venue',
          'date': '2025-01-01T00:00:00Z', // maps to startDate
          'endDate': '2025-01-01T23:59:59Z',
          'drawPoints': 0,
          'adminUid': uid,
        });

        // Act
        final result = await repository.getTournaments();

        // Assert
        expect(result, isA<List<TournamentModel>>());
        expect(result.length, 1);
        expect(result.first.title, 'Test Tournament');
      });

      test('Firestoreエラーが発生した場合、例外がスローされる。', () async {
        // Arrange
        const uid = 'test-uid';
        when(mockAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn(uid);

        final mockQuery = MockQuery<Map<String, dynamic>>();
        when(
          mockCollection.where('adminUid', isEqualTo: uid),
        ).thenReturn(mockQuery);
        when(
          mockQuery.orderBy('createdAt', descending: true),
        ).thenReturn(mockQuery);
        when(mockQuery.get()).thenThrow(Exception('Firestore error'));

        // Act & Assert
        expect(() => repository.getTournaments(), throwsA(isA<Exception>()));
      });
    });

    group('getTournament のテスト。', () {
      test('IDが空の場合、例外がスローされる。', () async {
        // Act & Assert
        expect(() => repository.getTournament(''), throwsA(isA<Exception>()));
      });

      test('トーナメントを正しく取得できる。', () async {
        // Arrange
        const tournamentId = 'tournament-id';
        final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
        final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();

        when(mockCollection.doc(tournamentId)).thenReturn(mockDocRef);
        when(mockDocRef.get()).thenAnswer((_) async => mockDoc);
        when(mockDoc.exists).thenReturn(true);
        when(mockDoc.id).thenReturn(tournamentId);
        when(mockDoc.data()).thenReturn({
          'name': 'Test Tournament',
          'overview': 'Test Description',
          'venue': 'Test Venue',
          'date': '2025-01-01T00:00:00Z',
          'endDate': '2025-01-01T23:59:59Z',
          'drawPoints': 0,
          'adminUid': 'test-uid',
        });

        // Act
        final result = await repository.getTournament(tournamentId);

        // Assert
        expect(result, isA<TournamentModel>());
        expect(result.id, tournamentId);
        expect(result.title, 'Test Tournament');
      });

      test('ドキュメントが存在しない場合、例外がスローされる。', () async {
        // Arrange
        const tournamentId = 'non-existent-id';
        final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
        final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();

        when(mockCollection.doc(tournamentId)).thenReturn(mockDocRef);
        when(mockDocRef.get()).thenAnswer((_) async => mockDoc);
        when(mockDoc.exists).thenReturn(false);

        // Act & Assert
        expect(
          () => repository.getTournament(tournamentId),
          throwsA(isA<Exception>()),
        );
      });

      test('Firestoreエラーが発生した場合、例外がスローされる。', () async {
        // Arrange
        const tournamentId = 'tournament-id';
        final mockDocRef = MockDocumentReference<Map<String, dynamic>>();

        when(mockCollection.doc(tournamentId)).thenReturn(mockDocRef);
        when(mockDocRef.get()).thenThrow(Exception('Firestore error'));

        // Act & Assert
        expect(
          () => repository.getTournament(tournamentId),
          throwsA(isA<Exception>()),
        );
      });

      test('ドキュメントのdataがnullの場合、例外がスローされる。', () async {
        // Arrange
        const tournamentId = 'tournament-id';
        final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
        final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();

        when(mockCollection.doc(tournamentId)).thenReturn(mockDocRef);
        when(mockDocRef.get()).thenAnswer((_) async => mockDoc);
        when(mockDoc.exists).thenReturn(true);
        when(mockDoc.data()).thenReturn(null);

        // Act & Assert
        expect(
          () => repository.getTournament(tournamentId),
          throwsA(isA<Exception>()),
        );
      });

      test('Timestampフィールドが正しく変換される。', () async {
        // Arrange
        const tournamentId = 'tournament-id';
        final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
        final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();
        final timestamp = Timestamp.fromDate(DateTime(2025));

        when(mockCollection.doc(tournamentId)).thenReturn(mockDocRef);
        when(mockDocRef.get()).thenAnswer((_) async => mockDoc);
        when(mockDoc.exists).thenReturn(true);
        when(mockDoc.id).thenReturn(tournamentId);
        when(mockDoc.data()).thenReturn({
          'name': 'Test Tournament',
          'overview': 'Test Description',
          'venue': 'Test Venue',
          'date': '2025-01-01T00:00:00Z',
          'endDate': '2025-01-01T23:59:59Z',
          'drawPoints': 0,
          'adminUid': 'test-uid',
          'createdAt': timestamp,
          'updatedAt': timestamp,
        });

        // Act
        final result = await repository.getTournament(tournamentId);

        // Assert
        expect(result.createdAt, isA<String>());
        expect(result.updatedAt, isA<String>());
      });

      test('Timestampフィールドが文字列の場合、そのまま返される。', () async {
        // Arrange
        const tournamentId = 'tournament-id';
        final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
        final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();

        when(mockCollection.doc(tournamentId)).thenReturn(mockDocRef);
        when(mockDocRef.get()).thenAnswer((_) async => mockDoc);
        when(mockDoc.exists).thenReturn(true);
        when(mockDoc.id).thenReturn(tournamentId);
        when(mockDoc.data()).thenReturn({
          'name': 'Test Tournament',
          'overview': 'Test Description',
          'venue': 'Test Venue',
          'date': '2025-01-01T00:00:00Z',
          'endDate': '2025-01-01T23:59:59Z',
          'drawPoints': 0,
          'adminUid': 'test-uid',
          'createdAt': '2025-01-01T00:00:00.000Z',
          'updatedAt': '2025-01-01T00:00:00.000Z',
        });

        // Act
        final result = await repository.getTournament(tournamentId);

        // Assert
        expect(result.createdAt, '2025-01-01T00:00:00.000Z');
        expect(result.updatedAt, '2025-01-01T00:00:00.000Z');
      });

      test('Timestampフィールドが不明な型の場合、現在時刻が使用される。', () async {
        // Arrange
        const tournamentId = 'tournament-id';
        final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
        final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();

        when(mockCollection.doc(tournamentId)).thenReturn(mockDocRef);
        when(mockDocRef.get()).thenAnswer((_) async => mockDoc);
        when(mockDoc.exists).thenReturn(true);
        when(mockDoc.id).thenReturn(tournamentId);
        when(mockDoc.data()).thenReturn({
          'name': 'Test Tournament',
          'overview': 'Test Description',
          'venue': 'Test Venue',
          'date': '2025-01-01T00:00:00Z',
          'endDate': '2025-01-01T23:59:59Z',
          'drawPoints': 0,
          'adminUid': 'test-uid',
          'createdAt': 12345, // int型（不明な型）
          'updatedAt': 67890, // int型（不明な型）
        });

        // Act
        final result = await repository.getTournament(tournamentId);

        // Assert
        expect(result.createdAt, isA<String>());
        expect(result.updatedAt, isA<String>());
        // 現在時刻が使用されるので、形式は正しいはず
        expect(result.createdAt, contains('T'));
        expect(result.updatedAt, contains('T'));
      });

      test('データのパースに失敗した場合、例外がスローされる。', () async {
        // Arrange
        const tournamentId = 'tournament-id';
        final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
        final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();

        when(mockCollection.doc(tournamentId)).thenReturn(mockDocRef);
        when(mockDocRef.get()).thenAnswer((_) async => mockDoc);
        when(mockDoc.exists).thenReturn(true);
        when(mockDoc.id).thenReturn(tournamentId);
        when(mockDoc.data()).thenReturn({
          // 必須フィールドが欠けている不正なデータ
          'invalid': 'data',
        });

        // Act & Assert
        expect(
          () => repository.getTournament(tournamentId),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('createTournament のテスト。', () {
      test('未ログインの場合、例外がスローされる。', () async {
        // Arrange
        when(mockAuth.currentUser).thenReturn(null);
        const request = CreateTournamentRequest(
          title: 'Test Tournament',
          description: 'Test Description',
          venue: 'Test Venue',
          startDate: '2025-01-01T00:00:00Z',
          endDate: '2025-01-01T23:59:59Z',
        );

        // Act & Assert
        expect(
          () => repository.createTournament(request),
          throwsA(isA<Exception>()),
        );
      });

      test('トーナメントを正しく作成できる。', () async {
        // Arrange
        const uid = 'test-uid';
        when(mockAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn(uid);

        final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
        final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();

        when(mockCollection.doc()).thenReturn(mockDocRef);
        when(mockDocRef.set(any)).thenAnswer((_) async => {});
        when(mockDocRef.get()).thenAnswer((_) async => mockDoc);
        when(mockDoc.id).thenReturn('new-tournament-id');
        when(mockDoc.data()).thenReturn({
          'name': 'Test Tournament',
          'overview': 'Test Description',
          'venue': 'Test Venue',
          'date': '2025-01-01T00:00:00Z',
          'endDate': '2025-01-01T23:59:59Z',
          'drawPoints': 0,
          'adminUid': uid,
        });

        const request = CreateTournamentRequest(
          title: 'Test Tournament',
          description: 'Test Description',
          venue: 'Test Venue',
          startDate: '2025-01-01T00:00:00Z',
          endDate: '2025-01-01T23:59:59Z',
        );

        // Act
        final result = await repository.createTournament(request);

        // Assert
        expect(result, isA<TournamentModel>());
        expect(result.title, 'Test Tournament');
        verify(mockDocRef.set(any)).called(1);
      });

      test('Firestoreエラーが発生した場合、例外がスローされる。', () async {
        // Arrange
        const uid = 'test-uid';
        when(mockAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn(uid);

        final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
        when(mockCollection.doc()).thenReturn(mockDocRef);
        when(mockDocRef.set(any)).thenThrow(Exception('Firestore error'));

        const request = CreateTournamentRequest(
          title: 'Test Tournament',
          description: 'Test Description',
          venue: 'Test Venue',
          startDate: '2025-01-01T00:00:00Z',
          endDate: '2025-01-01T23:59:59Z',
        );

        // Act & Assert
        expect(
          () => repository.createTournament(request),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('updateTournament のテスト。', () {
      test('IDが空の場合、例外がスローされる。', () async {
        // Arrange
        const request = UpdateTournamentRequest(name: 'Updated');

        // Act & Assert
        expect(
          () => repository.updateTournament('', request),
          throwsA(isA<Exception>()),
        );
      });

      test('更新フィールドが指定されていない場合、例外がスローされる。', () async {
        // Arrange
        const tournamentId = 'tournament-id';
        const request = UpdateTournamentRequest();

        // Act & Assert
        expect(
          () => repository.updateTournament(tournamentId, request),
          throwsA(isA<Exception>()),
        );
      });

      test('トーナメントを正しく更新できる。', () async {
        // Arrange
        const tournamentId = 'tournament-id';
        final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
        final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();

        when(mockCollection.doc(tournamentId)).thenReturn(mockDocRef);
        when(mockDocRef.get()).thenAnswer((_) async => mockDoc);
        when(mockDoc.exists).thenReturn(true);
        when(mockDocRef.update(any)).thenAnswer((_) async => {});
        when(mockDoc.id).thenReturn(tournamentId);
        when(mockDoc.data()).thenReturn({
          'name': 'Updated Tournament',
          'overview': 'Test Description',
          'venue': 'Test Venue',
          'date': '2025-01-01T00:00:00Z',
          'endDate': '2025-01-01T23:59:59Z',
          'drawPoints': 0,
          'adminUid': 'test-uid',
        });

        const request = UpdateTournamentRequest(name: 'Updated Tournament');

        // Act
        final result = await repository.updateTournament(tournamentId, request);

        // Assert
        expect(result, isA<TournamentModel>());
        verify(mockDocRef.update(any)).called(1);
      });

      test('ドキュメントが存在しない場合、例外がスローされる。', () async {
        // Arrange
        const tournamentId = 'non-existent-id';
        final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
        final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();

        when(mockCollection.doc(tournamentId)).thenReturn(mockDocRef);
        when(mockDocRef.get()).thenAnswer((_) async => mockDoc);
        when(mockDoc.exists).thenReturn(false);

        const request = UpdateTournamentRequest(name: 'Updated');

        // Act & Assert
        expect(
          () => repository.updateTournament(tournamentId, request),
          throwsA(isA<Exception>()),
        );
      });

      test('Firestoreエラーが発生した場合、例外がスローされる。', () async {
        // Arrange
        const tournamentId = 'tournament-id';
        final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
        final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();

        when(mockCollection.doc(tournamentId)).thenReturn(mockDocRef);
        when(mockDocRef.get()).thenAnswer((_) async => mockDoc);
        when(mockDoc.exists).thenReturn(true);
        when(mockDocRef.update(any)).thenThrow(Exception('Firestore error'));

        const request = UpdateTournamentRequest(name: 'Updated');

        // Act & Assert
        expect(
          () => repository.updateTournament(tournamentId, request),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('deleteTournament のテスト。', () {
      test('IDが空の場合、例外がスローされる。', () async {
        // Act & Assert
        expect(
          () => repository.deleteTournament(''),
          throwsA(isA<Exception>()),
        );
      });

      test('トーナメントを正しく削除できる。', () async {
        // Arrange
        const tournamentId = 'tournament-id';
        final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
        final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();

        when(mockCollection.doc(tournamentId)).thenReturn(mockDocRef);
        when(mockDocRef.get()).thenAnswer((_) async => mockDoc);
        when(mockDoc.exists).thenReturn(true);
        when(mockDocRef.delete()).thenAnswer((_) async => {});

        // Act
        await repository.deleteTournament(tournamentId);

        // Assert
        verify(mockDocRef.delete()).called(1);
      });

      test('ドキュメントが存在しない場合、例外がスローされる。', () async {
        // Arrange
        const tournamentId = 'non-existent-id';
        final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
        final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();

        when(mockCollection.doc(tournamentId)).thenReturn(mockDocRef);
        when(mockDocRef.get()).thenAnswer((_) async => mockDoc);
        when(mockDoc.exists).thenReturn(false);

        // Act & Assert
        expect(
          () => repository.deleteTournament(tournamentId),
          throwsA(isA<Exception>()),
        );
      });

      test('Firestoreエラーが発生した場合、例外がスローされる。', () async {
        // Arrange
        const tournamentId = 'tournament-id';
        final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
        final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();

        when(mockCollection.doc(tournamentId)).thenReturn(mockDocRef);
        when(mockDocRef.get()).thenAnswer((_) async => mockDoc);
        when(mockDoc.exists).thenReturn(true);
        when(mockDocRef.delete()).thenThrow(Exception('Firestore error'));

        // Act & Assert
        expect(
          () => repository.deleteTournament(tournamentId),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
