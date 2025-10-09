import 'auth_repository.dart';
import 'auth_user.dart';

/// メールアドレスとパスワードで新規登録するユースケース
class SignUpWithEmailUseCase {
  /// [SignUpWithEmailUseCase]のコンストラクタ。
  const SignUpWithEmailUseCase(this._repository);

  final AuthRepository _repository;

  /// メールアドレスとパスワードで新規登録する。
  ///
  /// Parameters:
  /// - [email]: メールアドレス
  /// - [password]: パスワード
  ///
  /// Returns: 認証済みユーザー
  /// Throws:
  /// - [ArgumentError] メールアドレスまたはパスワードが空の場合
  /// - [AuthException] 登録失敗時
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
    if (password.length < 6) {
      throw ArgumentError('パスワードは6文字以上である必要があります');
    }

    // サインアップ実行
    return _repository.signUpWithEmail(
      email: email.trim(),
      password: password,
    );
  }
}
