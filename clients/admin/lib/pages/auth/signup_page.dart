import 'package:base_ui/base_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 管理者サインアップ画面
///
/// Figmaデザイン: https://www.figma.com/design/A4NEf0vCuJNuPfBMTEa4OO/%E3%83%9E%E3%83%81%E3%82%B5%E3%83%9D?node-id=169-126&t=whDUBuHITxOChCST-4
class AdminSignupPage extends StatefulWidget {
  /// 管理者サインアップ画面のコンストラクタ
  const AdminSignupPage({super.key});

  @override
  State<AdminSignupPage> createState() => _AdminSignupPageState();
}

class _AdminSignupPageState extends State<AdminSignupPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
                        '管理者アカウントを新規登録',
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
                        const SizedBox(height: 24),

                        // 確認コード送信ボタン
                        CommonConfirmButton(
                          text: '確認コードを送信',
                          style: ConfirmButtonStyle.adminFilled,
                          onPressed: () {},
                        ),
                        const SizedBox(height: 16),

                        // Googleサインアップボタン
                        CommonConfirmButton(
                          text: 'Googleアカウントで新規登録',
                          style: ConfirmButtonStyle.adminOutlined,
                          onPressed: () {},
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

                    // ログイン
                    Column(
                      children: [
                        const Text(
                          'アカウントをお持ちですか？',
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
                            onPressed: () {
                              context.goNamed('login');
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
                              'ログイン',
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
