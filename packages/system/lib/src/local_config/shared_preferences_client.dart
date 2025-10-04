import 'package:shared_preferences/shared_preferences.dart';

/// [SharedPreferencesClient] のキーを表す列挙型。
enum SharedPreferencesKey {
  /// ログインしているかどうか。
  isLoggedIn,

  /// プレイヤーセッション情報。
  playerSession,
}

/// [SharedPreferences] を操作するラッパークラス。
///
/// キャッシュから値を同期的に読み込むことの出来る [SharedPreferencesWithCache] をコンストラクタで受け取る。
///
/// 参考：
/// https://pub.dev/packages/shared_preferences#cache-and-async-or-sync-getters
class SharedPreferencesClient {
  /// [SharedPreferencesClient] を生成する。
  ///
  /// - [_prefs] には、初期化済みの [SharedPreferencesWithCache] を渡す。
  SharedPreferencesClient(this._prefs);

  final SharedPreferencesWithCache _prefs;

  /// [bool] 型の値を保存する。
  Future<void> setBool({
    required SharedPreferencesKey key,
    required bool value,
  }) async {
    await _prefs.setBool(key.name, value);
  }

  /// [bool] 型の値を読み込む。
  ///
  /// 値が保存されていない場合は null を返す。
  bool? getBool({required SharedPreferencesKey key}) {
    return _prefs.getBool(key.name);
  }

  /// [String] 型の値を保存する。
  Future<void> setString({
    required SharedPreferencesKey key,
    required String value,
  }) async {
    await _prefs.setString(key.name, value);
  }

  /// [String] 型の値を読み込む。
  ///
  /// 値が保存されていない場合は null を返す。
  String? getString({required SharedPreferencesKey key}) {
    return _prefs.getString(key.name);
  }
}
