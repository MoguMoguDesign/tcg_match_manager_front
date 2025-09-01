import 'package:base_ui/base_ui.dart';
import 'package:flutter/material.dart';

/// 参加登録ページを表示する。
class RegistrationPage extends StatefulWidget {
  /// [RegistrationPage] のコンストラクタ。
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _nicknameController = TextEditingController();

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.gradientGreen,
              AppColors.textBlack,
              AppColors.adminPrimary,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 135),
                  // ロゴコンテナ - Figma完全準拠
                  SizedBox(
                    height: 28.121,
                    width: 139,
                    child: Center(
                      child: Text(
                        'マチサポ',
                        style: AppTextStyles.headlineLarge.copyWith(
                          color: AppColors.white,
                          fontSize: 20, // Figmaに準拠
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 59), // Figma間隔準拠
                  // メインコンテナ - 幅342px固定
                  SizedBox(
                    width: 342,
                    child: Column(
                      children: [
                        // トーナメント情報カード
                        TournamentInfoCard(
                          title: MockData.tournament.title,
                          date: MockData.tournament.date,
                          participantCount:
                              MockData.tournament.participantCount,
                        ),
                        const SizedBox(height: 32),
                        // 入力フォームコンテナ
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                '大会で表示するニックネームを入力してください',
                                style: AppTextStyles.labelMedium.copyWith(
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'ニックネーム',
                              style: AppTextStyles.labelMedium.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8), // Figma準拠の間隔調整
                            AppTextField(
                              hintText: 'ニックネームを入力',
                              onChanged: (value) {
                                _nicknameController.text = value;
                                setState(() {});
                              },
                            ),
                            const SizedBox(height: 16),
                            // ボタンコンテナ - Figma寸法準拠
                            SizedBox(
                              width: 342,
                              height: 56,
                              child: AppButton(
                                text: '参加に進む',
                                onPressed: () async {
                                  await Navigator.pushNamed(
                                    context,
                                    '/pre-tournament',
                                  );
                                },
                                isEnabled: _nicknameController.text.isNotEmpty,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40), // Figmaのスペーサー調整
                        // 接続問題コンテナ
                        Column(
                          children: [
                            Text(
                              '接続が切れましたか？',
                              style: AppTextStyles.bodySmall.copyWith(
                                fontSize: 12,
                                color: AppColors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 15),
                            SmallButton(
                              text: 'トーナメントに復帰する',
                              onPressed: () async {
                                await Navigator.pushNamed(
                                  context,
                                  '/login-list',
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 40), // 底辺マージン
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
