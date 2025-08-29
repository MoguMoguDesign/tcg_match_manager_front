import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_config.freezed.dart';

/// アプリのローカル設定用エンティティクラス。
///
/// アプリの初回起動時には各フィールドの値はシステムに設定されていないため、ここに定義した初期値が使用される。
@freezed
abstract class LocalConfig with _$LocalConfig {
  /// [LocalConfig] を生成する。
  const factory LocalConfig({
    /// ログイン状態。
    required bool isLoggedIn,
  }) = _LocalConfig;

  /// [isLoggedIn] の初期値。
  static const isLoggedInDefault = false;
}
