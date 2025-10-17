import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injection/injection.dart';
import 'package:mockito/annotations.dart';
import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';

import 'tournament_repository_injection_test.mocks.dart';

// FirebaseFirestore と FirebaseAuth のモッククラスを生成する。
@GenerateNiceMocks([MockSpec<FirebaseFirestore>(), MockSpec<FirebaseAuth>()])
void main() {
  group('tournamentRepositoryProvider のテスト。', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('プロバイダーが UnimplementedError をスローする。', () {
      expect(
        () => container.read(tournamentRepositoryProvider),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });

  group('getTournamentRepository のテスト。', () {
    late MockFirebaseFirestore mockFirestore;
    late MockFirebaseAuth mockAuth;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockAuth = MockFirebaseAuth();
    });

    test('firestore と auth が null の場合、例外がスローされる。', () {
      // Firebase未初期化のため例外がスローされる
      expect(getTournamentRepository, throwsA(anything));
    });

    test('firestore のみモックを渡した場合、例外がスローされる。', () {
      // auth が null のため Firebase.instance にアクセスして例外がスローされる
      expect(
        () => getTournamentRepository(firestore: mockFirestore),
        throwsA(anything),
      );
    });

    test('auth のみモックを渡した場合、例外がスローされる。', () {
      // firestore が null のため FirebaseFirestore.instance にアクセスして例外がスローされる
      expect(() => getTournamentRepository(auth: mockAuth), throwsA(anything));
    });

    test('モックの FirebaseFirestore と FirebaseAuth を渡した場合、 '
        'TournamentRepository を生成する。', () {
      final repository = getTournamentRepository(
        firestore: mockFirestore,
        auth: mockAuth,
      );
      expect(repository, isA<TournamentRepository>());
      expect(repository, isA<TournamentFirestoreRepository>());
    });
  });
}
