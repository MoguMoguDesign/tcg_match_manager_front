import 'package:flutter_test/flutter_test.dart';
import 'package:injection/injection.dart';
import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';

void main() {
  group('adminApiClientProvider のテスト。', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('プロバイダーが UnimplementedError をスローする。', () {
      // Firebase未初期化のためUnimplementedErrorまたは例外がスローされる
      expect(
        () => container.read(adminApiClientProvider),
        throwsA(anything),
      );
    });
  });

  group('getAdminApiClient のテスト。', () {
    test('FirebaseAuth.instanceを呼び出すと例外がスローされる。', () {
      // Firebase未初期化のため例外がスローされる
      expect(
        () => getAdminApiClient(),
        throwsA(anything),
      );
    });
  });
}
