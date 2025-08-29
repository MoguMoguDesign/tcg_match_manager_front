import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';

import 'local_config_notifier_test.mocks.dart';

// LocalConfigRepository のモッククラスを生成する。
@GenerateNiceMocks([MockSpec<LocalConfigRepository>()])
void main() {
  late MockLocalConfigRepository mockLocalConfigRepository;
  late ProviderContainer container;

  setUp(() {
    mockLocalConfigRepository = MockLocalConfigRepository();
    container = ProviderContainer(
      overrides: [
        localConfigRepositoryProvider.overrideWithValue(
          mockLocalConfigRepository,
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('localConfigNotifierProvider のテスト。', () {
    test('localConfigNotifierProvider が LocalConfigNotifier を返す。', () {
      // デフォルト値を返すスタブを用意する。
      when(
        mockLocalConfigRepository.getBool(
          key: anyNamed('key'),
          defaultValue: anyNamed('defaultValue'),
        ),
      ).thenReturn(false);

      expect(
        container.read(localConfigNotifierProvider.notifier),
        isA<LocalConfigNotifier>(),
      );
    });
  });

  group('LocalConfigNotifier のテスト。', () {
    group('build メソッドのテスト。', () {
      test('リポジトリから取得したデータで LocalConfig を生成する。', () {
        const testIsLoggedIn = true;

        // getBool メソッドが指定された値を返すスタブを用意する。
        when(
          mockLocalConfigRepository.getBool(
            key: LocalConfigKey.isLoggedIn,
            defaultValue: LocalConfig.isLoggedInDefault,
          ),
        ).thenReturn(testIsLoggedIn);

        // state を取得し、期待する値が設定されていることを確認する。
        final state = container.read(localConfigNotifierProvider);

        expect(state, isA<LocalConfig>());
        expect(state.isLoggedIn, testIsLoggedIn);

        // リポジトリのメソッドが正しい引数で呼び出されることを確認する。
        verify(
          mockLocalConfigRepository.getBool(
            key: LocalConfigKey.isLoggedIn,
            defaultValue: LocalConfig.isLoggedInDefault,
          ),
        ).called(1);
      });

      test('リポジトリから値が取得できない場合、デフォルト値で LocalConfig を生成する。', () {
        // getBool メソッドがデフォルト値を返すスタブを用意する。
        when(
          mockLocalConfigRepository.getBool(
            key: LocalConfigKey.isLoggedIn,
            defaultValue: LocalConfig.isLoggedInDefault,
          ),
        ).thenReturn(LocalConfig.isLoggedInDefault);

        // state を取得し、デフォルト値が設定されていることを確認する。
        final state = container.read(localConfigNotifierProvider);

        expect(state, isA<LocalConfig>());
        expect(state.isLoggedIn, LocalConfig.isLoggedInDefault);
      });
    });

    group('updateIsLoggedIn メソッドのテスト。', () {
      test('ログイン状態を正常に更新し、state に反映される。', () async {
        const initialIsLoggedIn = false;
        const updatedIsLoggedIn = true;

        // 初期値を返すスタブを用意する。
        when(
          mockLocalConfigRepository.getBool(
            key: LocalConfigKey.isLoggedIn,
            defaultValue: LocalConfig.isLoggedInDefault,
          ),
        ).thenReturn(initialIsLoggedIn);

        // setBool メソッドが正常に完了するスタブを用意する。
        when(
          mockLocalConfigRepository.setBool(
            key: LocalConfigKey.isLoggedIn,
            value: updatedIsLoggedIn,
          ),
        ).thenAnswer((_) async => Future<void>.value());

        final notifier = container.read(localConfigNotifierProvider.notifier);

        // 初期 state を確認する。
        var state = container.read(localConfigNotifierProvider);
        expect(state.isLoggedIn, initialIsLoggedIn);

        // updateIsLoggedIn メソッドを実行する。
        await notifier.updateIsLoggedIn(value: updatedIsLoggedIn);

        // state が更新されていることを確認する。
        state = container.read(localConfigNotifierProvider);
        expect(state.isLoggedIn, updatedIsLoggedIn);

        // リポジトリの setBool メソッドが正しい引数で呼び出されることを確認する。
        verify(
          mockLocalConfigRepository.setBool(
            key: LocalConfigKey.isLoggedIn,
            value: updatedIsLoggedIn,
          ),
        ).called(1);
      });
    });
  });
}
