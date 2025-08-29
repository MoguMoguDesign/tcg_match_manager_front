import 'package:flutter_test/flutter_test.dart';
import 'package:injection/injection.dart';
import 'package:mockito/annotations.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:system/system.dart';

import 'shared_preferences_client_injection_test.mocks.dart';

// SharedPreferencesWithCache のモッククラスを生成する。
@GenerateNiceMocks([MockSpec<SharedPreferencesWithCache>()])
void main() {
  group('sharedPreferencesClientProvider のテスト。', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('プロバイダーが UnimplementedError をスローする。', () {
      expect(
        () => container.read(sharedPreferencesClientProvider),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });

  group('getSharedPreferencesClient のテスト。', () {
    late MockSharedPreferencesWithCache mockPrefsWithCache;

    setUp(() {
      mockPrefsWithCache = MockSharedPreferencesWithCache();
    });

    test('prefsWithCache が null の場合、例外がスローされる。', () async {
      // テスト環境では StateError が発生する。
      await expectLater(getSharedPreferencesClient, throwsA(isA<StateError>()));
    });
    test(
      'モックの SharedPreferencesWithCache を渡した場合、SharedPreferencesClient を生成する。',
      () async {
        final client = await getSharedPreferencesClient(
          prefsWithCache: mockPrefsWithCache,
        );
        // 実際の環境を再現するために、モックを使用して返り値を確認する。
        expect(client, isA<SharedPreferencesClient>());
      },
    );
  });
}
