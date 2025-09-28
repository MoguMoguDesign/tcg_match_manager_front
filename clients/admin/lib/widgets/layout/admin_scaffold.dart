import 'package:base_ui/base_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 管理者アプリケーション用の共通レイアウト
class AdminScaffold extends StatelessWidget {
  /// レイアウトのコンストラクタ
  const AdminScaffold({
    required this.body,
    super.key,
    this.title,
    this.actions,
  });

  /// メインコンテンツ
  final Widget body;

  /// ページタイトル
  final String? title;

  /// アクションボタン
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ヘッダー
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: AppColors.borderLight)),
            ),
            child: Row(
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                const Spacer(),
                if (actions != null) ...actions!,

                // ユーザーメニュー
                PopupMenuButton<String>(
                  child: const Row(
                    children: [
                      Icon(Icons.person, color: AppColors.textBlack),
                      SizedBox(width: 8),
                      Text(
                        'ユーザー名',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.textBlack,
                      ),
                    ],
                  ),
                  onSelected: (value) {
                    if (value == 'logout') {
                      context.goNamed('login');
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'logout', child: Text('ログアウト')),
                  ],
                ),
              ],
            ),
          ),

          // メインコンテンツ
          Expanded(child: body),
        ],
      ),
    );
  }
}
