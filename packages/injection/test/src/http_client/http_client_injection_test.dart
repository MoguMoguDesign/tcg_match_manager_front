import 'package:flutter_test/flutter_test.dart';
import 'package:injection/injection.dart';
import 'package:riverpod/riverpod.dart';
import 'package:system/system.dart';

void main() {
  group('httpClientProvider のテスト。', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('プロバイダーが UnimplementedError をスローする。', () {
      expect(
        () => container.read(httpClientProvider),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });

  group('getHttpClient のテスト。', () {
    test('HttpClient を返す。', () {
      final client = getHttpClient();
      expect(client, isA<HttpClient>());
    });
  });
}
