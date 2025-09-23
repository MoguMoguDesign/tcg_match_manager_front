import 'package:base_ui/base_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 管理者ログイン画面
///
/// Figmaデザイン: https://www.figma.com/design/A4NEf0vCuJNuPfBMTEa4OO/%E3%83%9E%E3%83%81%E3%82%B5%E3%83%9D?node-id=96-271&t=whDUBuHITxOChCST-4
class AdminLoginPage extends StatefulWidget {
  /// 管理者ログイン画面のコンストラクタ
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  color: Colors.white,
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
                            controller: _emailController,
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
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: AppColors.grayDark,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
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

                        // ログインボタン
                        CommonConfirmButton(
                          text: 'ログイン',
                          style: ConfirmButtonStyle.adminFilled,
                          onPressed: () {
                            context.goNamed('tournaments');
                          },
                        ),
                        const SizedBox(height: 16),

                        // Googleログインボタン
                        CommonConfirmButton(
                          text: 'Googleアカウントでログイン',
                          style: ConfirmButtonStyle.adminOutlined,
                          onPressed: () {
                            // Google ログイン処理は未実装。
                          },
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
                            Colors.transparent,
                            AppColors.borderLight,
                            Colors.transparent,
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
                            color: Colors.black,
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
