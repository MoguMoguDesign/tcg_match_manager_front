import 'package:base_ui/base_ui.dart';
import 'package:flutter/material.dart';

/// 勝敗登録画面。
/// 
/// プレイヤーが自分の勝利または引き分けを登録する画面。
/// 結果を選択すると確認ダイアログが表示され、
/// 確定後に前の画面に戻る。
class ResultEntryPage extends StatefulWidget {
  /// [ResultEntryPage]のコンストラクタ。
  const ResultEntryPage({super.key});

  @override
  State<ResultEntryPage> createState() => _ResultEntryPageState();
}

class _ResultEntryPageState extends State<ResultEntryPage> {
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
                      const Spacer(),
                      // タイトル
                      Text(
                        '勝敗登録',
                        style: AppTextStyles.headlineLarge.copyWith(
                          color: AppColors.white,
                          fontSize: 20,
                        ),
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
                          ),
                          Text(
                            '※ 勝者が入力してください',
                            style: AppTextStyles.labelMedium.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // ボタン群
                      Column(
                        children: [
                          SizedBox(
                            width: 342,
                            child: AppButton(
                              text: '勝利',
                              onPressed: () => _showConfirmDialog('勝利'),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: 342,
                            child: AppButton(
                              text: '引き分け(両者敗北)',
                              onPressed: () => _showConfirmDialog('引き分け'),
                              isPrimary: false,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
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

  Future<void> _showConfirmDialog(String result) async {
    await showDialog<void>(
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
        ),
        content: Text(
          '$resultで登録しますか？',
          style: AppTextStyles.bodyMedium,
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
