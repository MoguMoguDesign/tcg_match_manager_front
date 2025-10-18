import 'package:flutter_test/flutter_test.dart';
import 'package:injection/src/auth_repository/auth_repository_injection.dart';
import 'package:riverpod/riverpod.dart';

void main() {
  group('authRepositoryProvider のテスト。', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('プロバイダーの読み取りで例外がスローされる。', () {
      // FirebaseAuthRepository内でFirebase未初期化のため例外がスローされる
      expect(() => container.read(authRepositoryProvider), throwsA(anything));
    });
  });
}
