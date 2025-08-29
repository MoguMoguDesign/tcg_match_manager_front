import 'package:flutter_test/flutter_test.dart';
import 'package:injection/injection.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:system/system.dart';

import 'local_config_repository_test.mocks.dart';

// SharedPreferencesClient のモッククラスを生成する。
@GenerateNiceMocks([MockSpec<SharedPreferencesClient>()])
void main() {
  late MockSharedPreferencesClient mockSharedPreferencesClient;
  late LocalConfigRepository localConfigRepository;

  setUp(() {
    mockSharedPreferencesClient = MockSharedPreferencesClient();
    localConfigRepository = LocalConfigRepository(
      client: mockSharedPreferencesClient,
    );
  });

  group('localConfigRepositoryProvider のテスト。', () {
    test('localConfigRepositoryProvider が LocalConfigRepository を返す。', () {
      final container = ProviderContainer(
        // 依存する sharedPreferencesClientProvider をモックで上書きする。
        overrides: [
          sharedPreferencesClientProvider.overrideWithValue(
            mockSharedPreferencesClient,
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(localConfigRepositoryProvider),
        isA<LocalConfigRepository>(),
      );
    });
  });

  group('LocalConfigRepository のテスト。', () {
    group('setBool メソッドのテスト。', () {
      test('isLoggedIn キーで値を正しく設定する。', () async {
        const testValue = true;
        const testKey = LocalConfigKey.isLoggedIn;

        // setBool メソッドが正常に完了するスタブを用意する。
        when(
          mockSharedPreferencesClient.setBool(
            key: SharedPreferencesKey.isLoggedIn,
            value: testValue,
          ),
        ).thenAnswer((_) async => Future<void>.value());

        // メソッドを実行する。
        await localConfigRepository.setBool(key: testKey, value: testValue);

        // SharedPreferencesClient の setBool メソッドが正しい引数で呼び出されることを確認する。
        verify(
          mockSharedPreferencesClient.setBool(
            key: SharedPreferencesKey.isLoggedIn,
            value: testValue,
          ),
        ).called(1);
      });

      test('setBool メソッドで例外が発生した場合、例外が再発生する。', () async {
        const testValue = false;
        const testKey = LocalConfigKey.isLoggedIn;
        final testException = Exception('setBool failed');

        // setBool メソッドで例外が発生するスタブを用意する。
        when(
          mockSharedPreferencesClient.setBool(
            key: SharedPreferencesKey.isLoggedIn,
            value: testValue,
          ),
        ).thenThrow(testException);

        // メソッドを実行し、例外が再発生することを確認する。
        await expectLater(
          localConfigRepository.setBool(key: testKey, value: testValue),
          throwsA(testException),
        );

        // SharedPreferencesClient の setBool メソッドが呼び出されることを確認する。
        verify(
          mockSharedPreferencesClient.setBool(
            key: SharedPreferencesKey.isLoggedIn,
            value: testValue,
          ),
        ).called(1);
      });
    });

    group('getBool メソッドのテスト。', () {
      test('isLoggedIn キーで値が存在する場合、その値を返す。', () {
        const testKey = LocalConfigKey.isLoggedIn;
        const storedValue = true;
        const defaultValue = false;

        // getBool メソッドが値を返すスタブを用意する。
        when(
          mockSharedPreferencesClient.getBool(
            key: SharedPreferencesKey.isLoggedIn,
          ),
        ).thenReturn(storedValue);

        // メソッドを実行する。
        final result = localConfigRepository.getBool(
          key: testKey,
          defaultValue: defaultValue,
        );

        // 期待する値が返されることを確認する。
        expect(result, storedValue);

        // SharedPreferencesClient の getBool メソッドが正しい引数で呼び出されることを確認する。
        verify(
          mockSharedPreferencesClient.getBool(
            key: SharedPreferencesKey.isLoggedIn,
          ),
        ).called(1);
      });

      test('isLoggedIn キーで値が存在しない場合、デフォルト値を返す。', () {
        const testKey = LocalConfigKey.isLoggedIn;
        const defaultValue = false;

        // getBool メソッドが null を返すスタブを用意する。
        when(
          mockSharedPreferencesClient.getBool(
            key: SharedPreferencesKey.isLoggedIn,
          ),
        ).thenReturn(null);

        // メソッドを実行する。
        final result = localConfigRepository.getBool(
          key: testKey,
          defaultValue: defaultValue,
        );

        // デフォルト値が返されることを確認する。
        expect(result, defaultValue);

        // SharedPreferencesClient の getBool メソッドが正しい引数で呼び出されることを確認する。
        verify(
          mockSharedPreferencesClient.getBool(
            key: SharedPreferencesKey.isLoggedIn,
          ),
        ).called(1);
      });
    });
  });
}
