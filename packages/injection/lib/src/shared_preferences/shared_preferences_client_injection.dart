import 'package:meta/meta.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:system/system.dart';

part 'shared_preferences_client_injection.g.dart';

/// [SharedPreferencesClient] を生成する。
///
/// アプリやテストの起動時に環境に応じて適切な [SharedPreferencesClient] を注入して使用される。
@Riverpod(keepAlive: true)
SharedPreferencesClient sharedPreferencesClient(Ref ref) =>
    throw UnimplementedError();

/// [SharedPreferencesClient] を取得する。
///
/// [SharedPreferencesWithCache] の初期化を行なった上で [SharedPreferencesClient] を生成する。
///
/// テスト時には [prefsWithCache] へモックの [SharedPreferencesWithCache] が渡される。
Future<SharedPreferencesClient> getSharedPreferencesClient({
  @visibleForTesting SharedPreferencesWithCache? prefsWithCache,
}) async {
  final prefs =
      prefsWithCache ??
      await SharedPreferencesWithCache.create(
        cacheOptions: SharedPreferencesWithCacheOptions(
          // SharedPreferencesKey のみ読み書きを許可する。
          allowList: SharedPreferencesKey.values.map((e) => e.name).toSet(),
        ),
      );
  return SharedPreferencesClient(prefs);
}
