import 'package:base_ui/base_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 管理者アプリケーション用の共通レイアウト
class AdminScaffold extends HookConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    // 認証Notifier取得
    final authNotifier = ref.read(authNotifierProvider.notifier);

    Future<void> handleLogout() async {
      // サインアウト処理を実行
      await authNotifier.signOut();

      // ログイン画面に遷移
      if (context.mounted) {
        context.goNamed('login');
      }
    }
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          // ヘッダー
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: const BoxDecoration(
              color: AppColors.white,
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
                  onSelected: (value) async {
                    if (value == 'logout') {
                      await handleLogout();
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
