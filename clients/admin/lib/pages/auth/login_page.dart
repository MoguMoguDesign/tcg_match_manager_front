import 'package:base_ui/base_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 管理者ログイン画面
///
/// Figmaデザイン: https://www.figma.com/design/A4NEf0vCuJNuPfBMTEa4OO/%E3%83%9E%E3%83%81%E3%82%B5%E3%83%9D?node-id=96-271&t=whDUBuHITxOChCST-4
class AdminLoginPage extends HookConsumerWidget {
  /// 管理者ログイン画面のコンストラクタ
  const AdminLoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isPasswordVisible = useState(false);
    final isLoading = useState(false);
    final errorMessage = useState<String?>(null);

    // 認証Notifier取得
    final authNotifier = ref.read(authNotifierProvider.notifier);

    // 認証状態の変更を監視
    ref.listen<AsyncValue<AuthUser?>>(authNotifierProvider, (previous, next) {
      // ローディング中は何もしない
      if (next.isLoading) {
        return;
      }

      // エラーがある場合
      if (next.hasError) {
        isLoading.value = false;
        final error = next.error;
        if (error is AuthException) {
          errorMessage.value = error.message;
        } else {
          errorMessage.value = 'ログインに失敗しました';
        }
        return;
      }

      // 成功した場合（ユーザーが存在する）
      if (next.hasValue && next.value != null) {
        isLoading.value = false;
        errorMessage.value = null;
        if (context.mounted) {
          context.goNamed('tournaments');
        }
      }
    });

    Future<void> handleSignIn() async {
      if (isLoading.value) {
        return;
      }

      // 入力バリデーション
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (email.isEmpty) {
        errorMessage.value = 'メールアドレスを入力してください';
        return;
      }

      if (password.isEmpty) {
        errorMessage.value = 'パスワードを入力してください';
        return;
      }

      errorMessage.value = null;
      isLoading.value = true;

      // 認証処理を実行（結果はref.listenで処理される）
      await authNotifier.signInWithEmail(email: email, password: password);
    }

    Future<void> handleGoogleSignIn() async {
      if (isLoading.value) {
        return;
      }

      errorMessage.value = null;
      isLoading.value = true;

      // 認証処理を実行（結果はref.listenで処理される）
      await authNotifier.signInWithGoogle();
    }

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.gradientLightGreen, // ライトグリーン
              AppColors.textBlack, // ダークブルー
              AppColors.adminPrimary, // ブルー
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: SizedBox(
            width: 500,
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gradientLightGreen.withValues(
                        alpha: 0.5,
                      ),
                      blurRadius: 20,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ロゴ
                    Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      child: const Text(
                        'マチサポ',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                      ),
                    ),

                    // タイトル
                    Container(
                      margin: const EdgeInsets.only(bottom: 40),
                      child: const Text(
                        '管理者アカウントでログイン',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                      ),
                    ),

                    // フォーム
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // メールアドレス
                        const Text(
                          'メールアドレス',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.grayDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.grayLight,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: TextField(
                            controller: emailController,
                            enabled: !isLoading.value,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // パスワード
                        const Text(
                          'パスワード',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.grayDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.grayLight,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: TextField(
                            controller: passwordController,
                            enabled: !isLoading.value,
                            obscureText: !isPasswordVisible.value,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: AppColors.grayDark,
                                ),
                                onPressed: () {
                                  isPasswordVisible.value =
                                      !isPasswordVisible.value;
                                },
                              ),
                            ),
                          ),
                        ),

                        // パスワードを忘れた
                        Container(
                          alignment: Alignment.centerRight,
                          margin: const EdgeInsets.only(top: 8, bottom: 16),
                          child: GestureDetector(
                            onTap: () async {
                              await context.pushNamed('password-reset');
                            },
                            child: const Text(
                              'パスワードを忘れた',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.adminPrimary,
                              ),
                            ),
                          ),
                        ),

                        // エラーメッセージ表示
                        if (errorMessage.value != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.errorContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              errorMessage.value!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontSize: 14,
                              ),
                            ),
                          ),

                        // ログインボタン
                        CommonConfirmButton(
                          text: isLoading.value ? 'ログイン中...' : 'ログイン',
                          style: ConfirmButtonStyle.adminFilled,
                          onPressed: isLoading.value ? () {} : handleSignIn,
                        ),
                        const SizedBox(height: 16),

                        // Googleログインボタン
                        CommonConfirmButton(
                          text: 'Googleアカウントでログイン',
                          style: ConfirmButtonStyle.adminOutlined,
                          onPressed: isLoading.value
                              ? () {}
                              : handleGoogleSignIn,
                        ),
                      ],
                    ),

                    // 区切り線
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 24),
                      height: 1,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.transparent,
                            AppColors.borderLight,
                            AppColors.transparent,
                          ],
                        ),
                      ),
                    ),

                    // サインアップ
                    Column(
                      children: [
                        const Text(
                          'アカウントがありませんか？',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 40,
                          child: OutlinedButton(
                            onPressed: () async {
                              await context.pushNamed('signup');
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: AppColors.textBlack,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            child: const Text(
                              '新規登録',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textBlack,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
