import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../widgets/common/app_button.dart';

class ResultEntryPage extends StatefulWidget {
  const ResultEntryPage({super.key});

  @override
  State<ResultEntryPage> createState() => _ResultEntryPageState();
}

class _ResultEntryPageState extends State<ResultEntryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB4EF03),
              AppColors.textBlack,
              AppColors.adminPrimary,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ヘッダー
              Container(
                height: 89,
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 57,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.keyboard_arrow_left,
                        color: AppColors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              // メインコンテンツ
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const Spacer(flex: 1),
                      // タイトル
                      Text(
                        '勝敗登録',
                        style: AppTextStyles.headlineLarge.copyWith(
                          color: AppColors.white,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      // 説明テキスト
                      Column(
                        children: [
                          Text(
                            '※ あなたの結果を入力してください',
                            style: AppTextStyles.labelMedium.copyWith(
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '※ 勝者が入力してください',
                            style: AppTextStyles.labelMedium.copyWith(
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const Spacer(flex: 2),
                      // ボタン群
                      Column(
                        children: [
                          SizedBox(
                            width: 342,
                            child: AppButton(
                              text: '勝利',
                              onPressed: () {
                                _showConfirmDialog('勝利');
                              },
                              isPrimary: true,
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: 342,
                            child: AppButton(
                              text: '引き分け(両者敗北)',
                              onPressed: () {
                                _showConfirmDialog('引き分け');
                              },
                              isPrimary: false,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(flex: 1),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmDialog(String result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.textBlack,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          '結果確認',
          style: AppTextStyles.headlineLarge.copyWith(
            color: AppColors.primary,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          '$resultで登録しますか？',
          style: AppTextStyles.bodyMedium,
          textAlign: TextAlign.center,
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'キャンセル',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context); // ダイアログを閉じる
                    Navigator.pop(context); // 勝敗登録画面を閉じる
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '$resultが登録されました',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textBlack,
                          ),
                        ),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                  child: Text(
                    '確定',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}