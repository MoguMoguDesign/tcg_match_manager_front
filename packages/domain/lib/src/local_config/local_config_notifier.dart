import 'package:repository/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain.dart';

part 'local_config_notifier.g.dart';

/// [LocalConfig] を管理する Notifier.
@Riverpod(keepAlive: true)
class LocalConfigNotifier extends _$LocalConfigNotifier {
  /// リポジトリ。
  LocalConfigRepository get _repository =>
      ref.read(localConfigRepositoryProvider);

  @override
  LocalConfig build() {
    return LocalConfig(
      isLoggedIn: _repository.getBool(
        key: LocalConfigKey.isLoggedIn,
        defaultValue: LocalConfig.isLoggedInDefault,
      ),
    );
  }

  /// ログイン状態を更新する。
  ///
  /// [value] で指定されたログイン状態をローカル設定に保存し、[state] に反映する。
  Future<void> updateIsLoggedIn({required bool value}) async {
    await _repository.setBool(key: LocalConfigKey.isLoggedIn, value: value);
    state = state.copyWith(isLoggedIn: value);
  }
}
