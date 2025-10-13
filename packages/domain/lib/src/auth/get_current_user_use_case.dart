// 将来の実装のため、テストカバレッジから除外する。
// coverage:ignore-file

import 'auth_repository.dart';
import 'auth_user.dart';

/// 現在の認証済みユーザーを取得するユースケース
class GetCurrentUserUseCase {
  /// [GetCurrentUserUseCase]のコンストラクタ。
  const GetCurrentUserUseCase(this._repository);

  final AuthRepository _repository;

  /// 現在の認証済みユーザーを取得する。
  ///
  /// Returns: 認証済みユーザー。未認証の場合はnull。
  Future<AuthUser?> call() async {
    return _repository.getCurrentUser();
  }
}
