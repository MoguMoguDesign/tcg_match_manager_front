// 将来の実装のため、テストカバレッジから除外する。
// coverage:ignore-file

import 'auth_repository.dart';

/// サインアウトするユースケース
class SignOutUseCase {
  /// [SignOutUseCase]のコンストラクタ。
  const SignOutUseCase(this._repository);

  final AuthRepository _repository;

  /// サインアウトする。
  ///
  /// Throws: [AuthException] サインアウト失敗時
  Future<void> call() async {
    return _repository.signOut();
  }
}
