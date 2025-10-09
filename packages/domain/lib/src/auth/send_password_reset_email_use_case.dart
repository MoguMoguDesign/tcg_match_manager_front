import 'auth_repository.dart';

/// パスワードリセットメールを送信するユースケース
class SendPasswordResetEmailUseCase {
  /// [SendPasswordResetEmailUseCase]のコンストラクタ。
  const SendPasswordResetEmailUseCase(this._repository);

  final AuthRepository _repository;

  /// パスワードリセットメールを送信する。
  ///
  /// Parameters:
  /// - [email]: メールアドレス
  ///
  /// Throws:
  /// - [ArgumentError] メールアドレスが空の場合
  /// - [AuthException] 送信失敗時
  Future<void> call({required String email}) async {
    // バリデーション
    if (email.trim().isEmpty) {
      throw ArgumentError('メールアドレスは必須です');
    }

    // パスワードリセットメール送信
    return _repository.sendPasswordResetEmail(email: email.trim());
  }
}
