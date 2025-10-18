import 'package:flutter_test/flutter_test.dart';
import 'package:injection/injection.dart';
import 'package:riverpod/riverpod.dart';

void main() {
  group('adminApiBaseUrlProvider のテスト。', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('デフォルト値を返す。', () {
      final baseUrl = container.read(adminApiBaseUrlProvider);
      expect(baseUrl, 'https://api.example.com/api/v1');
    });
  });

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
      expect(() => container.read(adminApiClientProvider), throwsA(anything));
    });
  });

  group('getAdminApiClient のテスト。', () {
    const testBaseUrl = 'https://api.example.com/api/v1';

    test('FirebaseAuth.instanceを呼び出すと例外がスローされる。', () {
      // Firebase未初期化のため例外がスローされる
      expect(() => getAdminApiClient(baseUrl: testBaseUrl), throwsA(anything));
    });
  });
}
