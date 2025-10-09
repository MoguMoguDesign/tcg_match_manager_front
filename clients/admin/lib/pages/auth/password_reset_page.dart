import 'package:base_ui/base_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// パスワード再設定画面
///
/// Figmaデザイン: https://www.figma.com/design/A4NEf0vCuJNuPfBMTEa4OO/%E3%83%9E%E3%83%81%E3%82%B5%E3%83%9D?node-id=169-169&t=whDUBuHITxOChCST-4
class AdminPasswordResetPage extends StatefulWidget {
  /// パスワード再設定画面のコンストラクタ
  const AdminPasswordResetPage({super.key});

  @override
  State<AdminPasswordResetPage> createState() => _AdminPasswordResetPageState();
}

class _AdminPasswordResetPageState extends State<AdminPasswordResetPage> {
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
                    // 戻るボタン
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back),
                        color: AppColors.textBlack,
                      ),
                    ),

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
                        'パスワードを再設定',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                      ),
                    ),

                    // 説明文
                    Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      child: const Text(
                        '登録されたメールアドレスに再設定用のリンクを送信します。',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.grayDark,
                        ),
                        textAlign: TextAlign.center,
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

                        // 送信ボタン
                        CommonConfirmButton(
                          text: 'リンクを送信',
                          style: ConfirmButtonStyle.adminFilled,
                          onPressed: () {
                            //
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('パスワード再設定リンクを送信しました'),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        // キャンセルボタン
                        CommonConfirmButton(
                          text: 'キャンセル',
                          style: ConfirmButtonStyle.adminOutlined,
                          onPressed: () {
                            context.pop();
                          },
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
