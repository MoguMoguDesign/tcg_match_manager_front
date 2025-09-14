import 'dart:async';

import 'package:base_ui/base_ui.dart';
import 'package:flutter/material.dart';

import '../router.dart';

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
    // 背景テーマは Svg 背景へ統一。
    return Theme(
      data: Theme.of(context).copyWith(
        extensions: const <ThemeExtension<dynamic>>[kDefaultBackgroundGradient],
      ),
      child: SvgBackground(
        assetPath: 'packages/base_ui/assets/images/whole_background.svg',
        child: CommonScaffold(
          appbarText: '勝敗登録',
          enableHorizontalPadding: false,
          enableScrollView: false,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(),
                // 説明テキスト
                Column(
                  children: [
                    Text(
                      '※ あなたの結果を入力してください',
                      style: AppTextStyles.labelMedium.copyWith(fontSize: 14),
                    ),
                    Text(
                      '※ 勝者が入力してください',
                      style: AppTextStyles.labelMedium.copyWith(fontSize: 14),
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
      ),
    );
  }

  void _showConfirmDialog(String result) {
    unawaited(
      ConfirmDialog.show(
        context,
        title: '結果確認',
        message: '$resultで登録しますか？',
        confirmText: '確定',
        onConfirm: () {
          Navigator.pop(context); // ダイアログを閉じる
          if (!mounted) {
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$resultが登録されました'),
              backgroundColor: AppColors.userPrimary,
            ),
          );
          // 対戦表にリダイレクトする。
          context.goToMatchingTable();
        },
      ),
    );
  }
}
