import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:system/src/local_config/shared_preferences_client.dart';

import 'shared_preferences_client_test.mocks.dart';

// SharedPreferencesWithCache のモッククラスを生成する。
@GenerateNiceMocks([MockSpec<SharedPreferencesWithCache>()])
void main() {
  late MockSharedPreferencesWithCache mockSharedPreferencesWithCache;
  late SharedPreferencesClient client;

  setUp(() {
    mockSharedPreferencesWithCache = MockSharedPreferencesWithCache();
    client = SharedPreferencesClient(mockSharedPreferencesWithCache);
  });

  group('SharedPreferencesClient のテスト。', () {
    group('setBool メソッドのテスト。', () {
      test('SharedPreferencesWithCache の setBool メソッドを呼び出す。', () async {
        const key = SharedPreferencesKey.isLoggedIn;
        const value = true;

        // setBool メソッドが正常に完了するスタブを用意する。
        when(
          mockSharedPreferencesWithCache.setBool(key.name, value),
        ).thenAnswer((_) async => true);

        // setBool を実行する。
        await client.setBool(key: key, value: value);

        // SharedPreferencesWithCache の setBool メソッドが正しい引数で呼び出されることを確認する。
        verify(
          mockSharedPreferencesWithCache.setBool(key.name, value),
        ).called(1);
      });

      test('例外が発生した場合、例外が適切に伝播される。', () async {
        const key = SharedPreferencesKey.isLoggedIn;
        const value = false;
        final testException = Exception('SharedPreferences error');

        // setBool メソッドで例外が発生するスタブを用意する。
        when(
          mockSharedPreferencesWithCache.setBool(key.name, value),
        ).thenThrow(testException);

        // 処理実行時、例外が適切に伝播されることを確認する。
        await expectLater(
          client.setBool(key: key, value: value),
          throwsA(testException),
        );

        // SharedPreferencesWithCache の setBool メソッドが呼び出されることを確認する。
        verify(
          mockSharedPreferencesWithCache.setBool(key.name, value),
        ).called(1);
      });
    });

    group('getBool メソッドのテスト。', () {
      test('SharedPreferencesWithCache の getBool メソッドを呼び出し、値を返す。', () {
        const key = SharedPreferencesKey.isLoggedIn;
        const expectedValue = true;

        // getBool メソッドが値を返すスタブを用意する。
        when(
          mockSharedPreferencesWithCache.getBool(key.name),
        ).thenReturn(expectedValue);

        // getBool を実行する。
        final result = client.getBool(key: key);

        // 期待する値が返されることを確認する。
        expect(result, expectedValue);

        // SharedPreferencesWithCache の getBool メソッドが正しい引数で呼び出されることを確認する。
        verify(mockSharedPreferencesWithCache.getBool(key.name)).called(1);
      });

      test('値が保存されていない場合、null を返す。', () {
        const key = SharedPreferencesKey.isLoggedIn;

        // getBool メソッドが null を返すスタブを用意する。
        when(mockSharedPreferencesWithCache.getBool(key.name)).thenReturn(null);

        // getBool を実行する。
        final result = client.getBool(key: key);

        // null が返されることを確認する。
        expect(result, isNull);

        // SharedPreferencesWithCache の getBool メソッドが正しい引数で呼び出されることを確認する。
        verify(mockSharedPreferencesWithCache.getBool(key.name)).called(1);
      });
    });
  });
}
