import 'auth_repository.dart';
import 'auth_user.dart';

/// Googleアカウントでサインインするユースケース
class SignInWithGoogleUseCase {
  /// [SignInWithGoogleUseCase]のコンストラクタ。
  const SignInWithGoogleUseCase(this._repository);

  final AuthRepository _repository;

  /// Googleアカウントでサインインする。
  ///
  /// Returns: 認証済みユーザー
  /// Throws: [AuthException] 認証失敗時
  Future<AuthUser> call() async {
    return _repository.signInWithGoogle();
  }
}
