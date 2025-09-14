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
                            CommonConfirmButton(
                              text: '勝利',
                              width: 342,
                              onPressed: () {
                                _showConfirmDialog('勝利');
                              },
                            ),
                            const SizedBox(height: 24),
                            CommonConfirmButton(
                              text: '引き分け(両者敗北)',
                              width: 342,
                              style: ConfirmButtonStyle.userOutlined,
                              onPressed: () {
                                _showConfirmDialog('引き分け');
                              },
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
    unawaited(ConfirmDialog.show(
      context,
      title: '結果確認',
      message: '$resultで登録しますか？',
      confirmText: '確定',
      onConfirm: () {
        Navigator.pop(context); // 勝敗登録画面を閉じる
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$resultが登録されました',
            ),
            backgroundColor: AppColors.userPrimary,
          ),
        );
      },
    ));
  }
}
