import 'package:flutter_test/flutter_test.dart';
import 'package:injection/injection.dart';
import 'package:riverpod/riverpod.dart';

void main() {
  group('tournamentRepositoryProvider のテスト。', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('プロバイダーの読み取りで例外がスローされる。', () {
      // adminApiClientProviderに依存しており、Firebase未初期化のため例外がスローされる
      expect(
        () => container.read(tournamentRepositoryProvider),
        throwsA(anything),
      );
    });
  });
}
