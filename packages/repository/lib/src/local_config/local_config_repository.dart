import 'package:injection/injection.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:system/system.dart';

part 'local_config_repository.g.dart';

/// [LocalConfigRepository] で利用するキーを表す列挙型。
///
/// [SharedPreferencesKey] と１対１で対応している。
enum LocalConfigKey {
  /// ログインしているかどうか。
  isLoggedIn,
}

/// [LocalConfigRepository] を生成する。
@riverpod
LocalConfigRepository localConfigRepository(Ref ref) {
  return LocalConfigRepository(
    client: ref.watch(sharedPreferencesClientProvider),
  );
}

/// アプリのローカル設定を管理するリポジトリ。
class LocalConfigRepository {
  /// [LocalConfigRepository] を生成する。
  ///
  /// [client] は、[SharedPreferencesClient] のインスタンス。
  LocalConfigRepository({required SharedPreferencesClient client})
    : _client = client;

  final SharedPreferencesClient _client;

  /// [bool] 型の値を保存する。
  Future<void> setBool({
    required LocalConfigKey key,
    required bool value,
  }) async {
    await _client.setBool(key: _toPrefsKey(key), value: value);
  }

  /// [bool] 型の値を取得する。
  ///
  /// 値が存在しない場合、[defaultValue] を返す。
  ///
  /// [defaultValue] には、State クラスの初期値と同じ値を指定する。
  bool getBool({required LocalConfigKey key, required bool defaultValue}) {
    return _client.getBool(key: _toPrefsKey(key)) ?? defaultValue;
  }

  /// [LocalConfigKey] を [SharedPreferencesKey] に変換する。
  SharedPreferencesKey _toPrefsKey(LocalConfigKey key) {
    return SharedPreferencesKey.values.byName(key.name);
  }
}
