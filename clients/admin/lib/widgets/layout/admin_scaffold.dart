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
      body: Row(
        children: [
          // サイドナビゲーション
          Container(
            width: 240,
            decoration: const BoxDecoration(color: Color(0xFF000336)),
            child: Column(
              children: [
                // ロゴエリア
                Container(
                  height: 80,
                  padding: const EdgeInsets.all(20),
                  child: const Row(
                    children: [
                      Text(
                        'マチサポ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // ナビゲーションメニュー
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _buildNavItem(
                        context: context,
                        icon: Icons.home,
                        title: 'トーナメント一覧',
                        routeName: 'home',
                        isSelected:
                            GoRouterState.of(context).uri.path == '/home',
                      ),
                      _buildNavItem(
                        context: context,
                        icon: Icons.sports_esports,
                        title: '対戦表',
                        routeName: 'home',
                        isSelected: false,
                      ),
                      _buildNavItem(
                        context: context,
                        icon: Icons.people,
                        title: '参加者一覧',
                        routeName: 'home',
                        isSelected: false,
                      ),
                    ],
                  ),
                ),

                // 参加受付中カード（Figmaデザインに基づく）
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD8FF62),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF000336),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '参加受付中',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFD8FF62),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'トーナメントタイトル',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000336),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 16,
                            color: Color(0xFF000336),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '2025/08/31',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF000336),
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.people,
                            size: 16,
                            color: Color(0xFF000336),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '32',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF000336),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ラウンド作成ボタン
                Container(
                  margin: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3A44FB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'ラウンド作成',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // メインコンテンツエリア
          Expanded(
            child: Column(
              children: [
                // ヘッダー
                Container(
                  height: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (title != null)
                        Text(
                          title!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF000336),
                          ),
                        ),
                      const Spacer(),
                      if (actions != null) ...actions!,

                      // ユーザーメニュー
                      PopupMenuButton<String>(
                        child: const Row(
                          children: [
                            Icon(Icons.person, color: Color(0xFF000336)),
                            SizedBox(width: 8),
                            Text(
                              'ユーザー名',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF000336),
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Color(0xFF000336),
                            ),
                          ],
                        ),
                        onSelected: (value) {
                          if (value == 'logout') {
                            context.goNamed('login');
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'logout',
                            child: Text('ログアウト'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // メインコンテンツ
                Expanded(child: body),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String routeName,
    required bool isSelected,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? const Color(0xFFD8FF62) : Colors.white,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? const Color(0xFFD8FF62) : Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        selectedTileColor: Colors.white.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onTap: () {
          context.goNamed(routeName);
        },
      ),
    );
  }
}
