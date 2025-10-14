// 将来の実装のため、テストカバレッジから除外する。
// coverage:ignore-file

import 'package:domain/domain.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

/// FirebaseAuthenticationを使用した認証リポジトリの実装
class FirebaseAuthRepository implements AuthRepository {
  /// [FirebaseAuthRepository]のコンストラクタ。
  FirebaseAuthRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  final firebase_auth.FirebaseAuth _firebaseAuth;

  @override
  Future<AuthUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw const AuthException(
          code: 'AUTH_ERROR',
          message: 'ユーザー情報の取得に失敗しました',
        );
      }

      return _mapFirebaseUser(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    }
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    // Web環境ではGoogleAuthProviderを使用
    try {
      final googleProvider = firebase_auth.GoogleAuthProvider();
      final credential = await _firebaseAuth.signInWithPopup(googleProvider);

      final user = credential.user;
      if (user == null) {
        throw const AuthException(
          code: 'AUTH_ERROR',
          message: 'ユーザー情報の取得に失敗しました',
        );
      }

      return _mapFirebaseUser(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    }
  }

  @override
  Future<AuthUser> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw const AuthException(
          code: 'AUTH_ERROR',
          message: 'ユーザー情報の取得に失敗しました',
        );
      }

      // メール確認を送信
      await user.sendEmailVerification();

      return _mapFirebaseUser(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    }
  }

  @override
  Future<AuthUser?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return null;
    }

    return _mapFirebaseUser(user);
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    }
  }

  /// FirebaseUserをAuthUserにマッピングする。
  AuthUser _mapFirebaseUser(firebase_auth.User user) {
    return AuthUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      emailVerified: user.emailVerified,
    );
  }

  /// FirebaseAuthExceptionをAuthExceptionにマッピングする。
  AuthException _mapFirebaseAuthException(
    firebase_auth.FirebaseAuthException e,
  ) {
    switch (e.code) {
      case 'user-not-found':
        return const AuthException(
          code: 'USER_NOT_FOUND',
          message: 'ユーザーが見つかりません',
        );
      case 'wrong-password':
        return const AuthException(
          code: 'INVALID_CREDENTIALS',
          message: 'メールアドレスまたはパスワードが正しくありません',
        );
      case 'invalid-email':
        return const AuthException(
          code: 'INVALID_EMAIL',
          message: 'メールアドレスの形式が正しくありません',
        );
      case 'user-disabled':
        return const AuthException(
          code: 'USER_DISABLED',
          message: 'このアカウントは無効化されています',
        );
      case 'email-already-in-use':
        return const AuthException(
          code: 'EMAIL_ALREADY_IN_USE',
          message: 'このメールアドレスは既に使用されています',
        );
      case 'weak-password':
        return const AuthException(
          code: 'WEAK_PASSWORD',
          message: 'パスワードが弱すぎます',
        );
      case 'operation-not-allowed':
        return const AuthException(
          code: 'OPERATION_NOT_ALLOWED',
          message: 'この操作は許可されていません',
        );
      case 'too-many-requests':
        return const AuthException(
          code: 'TOO_MANY_REQUESTS',
          message: 'リクエストが多すぎます。しばらく時間をおいてから再試行してください',
        );
      case 'popup-closed-by-user':
        return const AuthException(
          code: 'POPUP_CLOSED',
          message: 'サインインがキャンセルされました',
        );
      case 'cancelled-popup-request':
        return const AuthException(
          code: 'POPUP_CLOSED',
          message: 'サインインがキャンセルされました',
        );
      default:
        return AuthException(
          code: 'AUTH_ERROR',
          message: e.message ?? '認証エラーが発生しました',
        );
    }
  }
}
