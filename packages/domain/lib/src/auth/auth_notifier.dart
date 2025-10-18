// 将来の実装のため、テストカバレッジから除外する。
// coverage:ignore-file

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_repository.dart';
import 'auth_user.dart';
import 'get_current_user_use_case.dart';
import 'send_password_reset_email_use_case.dart';
import 'sign_in_with_email_use_case.dart';
import 'sign_in_with_google_use_case.dart';
import 'sign_out_use_case.dart';
import 'sign_up_with_email_use_case.dart';

part 'auth_notifier.g.dart';

/// 認証状態を管理するNotifier
@riverpod
class AuthNotifier extends _$AuthNotifier {
  late final SignInWithEmailUseCase _signInWithEmailUseCase;
  late final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  late final SignUpWithEmailUseCase _signUpWithEmailUseCase;
  late final SignOutUseCase _signOutUseCase;
  late final GetCurrentUserUseCase _getCurrentUserUseCase;
  late final SendPasswordResetEmailUseCase _sendPasswordResetEmailUseCase;

  @override
  Future<AuthUser?> build() async {
    final repository = ref.watch(authRepositoryProvider);
    _signInWithEmailUseCase = SignInWithEmailUseCase(repository);
    _signInWithGoogleUseCase = SignInWithGoogleUseCase(repository);
    _signUpWithEmailUseCase = SignUpWithEmailUseCase(repository);
    _signOutUseCase = SignOutUseCase(repository);
    _getCurrentUserUseCase = GetCurrentUserUseCase(repository);
    _sendPasswordResetEmailUseCase = SendPasswordResetEmailUseCase(repository);

    // 初期化時に現在のユーザーを取得
    return _getCurrentUserUseCase.call();
  }

  /// メールアドレスとパスワードでサインインする。
  ///
  /// Parameters:
  /// - [email]: メールアドレス
  /// - [password]: パスワード
  ///
  /// Throws: [AuthException] 認証失敗時
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = await _signInWithEmailUseCase.call(
        email: email,
        password: password,
      );
      return user;
    });
  }

  /// Googleアカウントでサインインする。
  ///
  /// Throws: [AuthException] 認証失敗時
  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = await _signInWithGoogleUseCase.call();
      return user;
    });
  }

  /// メールアドレスとパスワードで新規登録する。
  ///
  /// Parameters:
  /// - [email]: メールアドレス
  /// - [password]: パスワード
  ///
  /// Throws: [AuthException] 登録失敗時
  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = await _signUpWithEmailUseCase.call(
        email: email,
        password: password,
      );
      return user;
    });
  }

  /// サインアウトする。
  ///
  /// Throws: [AuthException] サインアウト失敗時
  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _signOutUseCase.call();
      return null;
    });
  }

  /// パスワードリセットメールを送信する。
  ///
  /// Parameters:
  /// - [email]: メールアドレス
  ///
  /// Throws: [AuthException] 送信失敗時
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _sendPasswordResetEmailUseCase.call(email: email);
  }
}

/// AuthRepositoryのプロバイダー（実装はInjectionレイヤーでオーバーライド）
@riverpod
AuthRepository authRepository(Ref ref) {
  throw UnimplementedError('AuthRepository must be overridden');
}
