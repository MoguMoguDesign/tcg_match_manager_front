import 'dart:async';

import 'package:base_ui/base_ui.dart';
import 'package:flutter/material.dart';

/// 試合結果入力ページを表示する。
///
/// 対戦の勝敗を入力し、次のラウンドへ進む操作を提供する。
class ResultEntryPage extends StatefulWidget {
  /// [ResultEntryPage] のコンストラクタ。
  const ResultEntryPage({super.key});

  @override
  State<ResultEntryPage> createState() => _ResultEntryPageState();
}

class _ResultEntryPageState extends State<ResultEntryPage> {
  @override
  Widget build(BuildContext context) {
    final bg =
        Theme.of(context).extension<BackgroundGradientTheme>() ??
        kDefaultBackgroundGradient;
    return Theme(
      data: Theme.of(context).copyWith(
        extensions: const <ThemeExtension<dynamic>>[kDefaultBackgroundGradient],
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: DecoratedBox(
          decoration: BoxDecoration(gradient: bg.scaffoldGradient),
          child: SafeArea(
            child: Column(
              children: [
                // ヘッダー
                Container(
                  height: 89,
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 57),
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
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showConfirmDialog(String result) {
    unawaited(showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        title: Text(
          '結果確認',
          style: AppTextStyles.headlineLarge.copyWith(color: AppColors.primary),
        ),
        content: Text(
          '$resultで登録しますか？',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textBlack),
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
                      color: AppColors.textBlack,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // ダイアログを閉じる
                    Navigator.pop(context); // 勝敗登録画面を閉じる
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '$resultが登録されました',
                        ),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                  child: Text(
                    '確定',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.adminPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
