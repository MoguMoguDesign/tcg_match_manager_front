import 'auth_repository.dart';
import 'auth_user.dart';

/// メールアドレスとパスワードでサインインするユースケース
class SignInWithEmailUseCase {
  /// [SignInWithEmailUseCase]のコンストラクタ。
  const SignInWithEmailUseCase(this._repository);

  final AuthRepository _repository;

  /// メールアドレスとパスワードでサインインする。
  ///
  /// Parameters:
  /// - [email]: メールアドレス
  /// - [password]: パスワード
  ///
  /// Returns: 認証済みユーザー
  /// Throws:
  /// - [ArgumentError] メールアドレスまたはパスワードが空の場合
  /// - [AuthException] 認証失敗時
  Future<AuthUser> call({
    required String email,
    required String password,
  }) async {
    // バリデーション
    if (email.trim().isEmpty) {
      throw ArgumentError('メールアドレスは必須です');
    }
    if (password.trim().isEmpty) {
      throw ArgumentError('パスワードは必須です');
    }

    // サインイン実行
    return _repository.signInWithEmail(
      email: email.trim(),
      password: password,
    );
  }
}
