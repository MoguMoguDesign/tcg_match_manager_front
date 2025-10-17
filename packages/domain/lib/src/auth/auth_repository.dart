// 将来の実装のため、テストカバレッジから除外する。
// coverage:ignore-file

import 'auth_user.dart';

/// 認証リポジトリのインターフェース
///
/// 認証に関する操作を定義する。
/// 実装はRepositoryレイヤーで行う。
abstract interface class AuthRepository {
  /// メールアドレスとパスワードでサインインする。
  ///
  /// Parameters:
  /// - [email]: メールアドレス
  /// - [password]: パスワード
  ///
  /// Returns: 認証済みユーザー
  /// Throws: [AuthException] 認証失敗時
  Future<AuthUser> signInWithEmail({
    required String email,
    required String password,
  });

  /// Googleアカウントでサインインする。
  ///
  /// Returns: 認証済みユーザー
  /// Throws: [AuthException] 認証失敗時
  Future<AuthUser> signInWithGoogle();

  /// メールアドレスとパスワードで新規登録する。
  ///
  /// Parameters:
  /// - [email]: メールアドレス
  /// - [password]: パスワード
  ///
  /// Returns: 認証済みユーザー
  /// Throws: [AuthException] 登録失敗時
  Future<AuthUser> signUpWithEmail({
    required String email,
    required String password,
  });

  /// サインアウトする。
  ///
  /// Throws: [AuthException] サインアウト失敗時
  Future<void> signOut();

  /// 現在の認証済みユーザーを取得する。
  ///
  /// Returns: 認証済みユーザー。未認証の場合はnull。
  Future<AuthUser?> getCurrentUser();

  /// パスワードリセットメールを送信する。
  ///
  /// Parameters:
  /// - [email]: メールアドレス
  ///
  /// Throws: [AuthException] 送信失敗時
  Future<void> sendPasswordResetEmail({required String email});
}

/// 認証処理で発生する例外
class AuthException implements Exception {
  /// [AuthException]のコンストラクタ。
  const AuthException({required this.code, required this.message});

  /// エラーコード
  final String code;

  /// エラーメッセージ
  final String message;

  @override
  String toString() => 'AuthException(code: $code, message: $message)';
}
