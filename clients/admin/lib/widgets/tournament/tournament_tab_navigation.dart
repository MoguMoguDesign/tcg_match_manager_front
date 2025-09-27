import 'package:base_ui/base_ui.dart';
import 'package:flutter/material.dart';

/// タブ選択時のコールバック型
typedef OnTabSelected = void Function(int index);

/// トーナメント画面用のタブナビゲーション
class TournamentTabNavigation extends StatelessWidget {
  /// タブナビゲーションのコンストラクタ
  const TournamentTabNavigation({
    required this.selectedIndex,
    required this.onTabSelected,
    this.tabs = const ['大会概要', '参加者一覧', '対戦表', '大会結果'],
    super.key,
  });

  /// 現在選択されているタブのインデックス
  final int selectedIndex;

  /// タブが選択された時のコールバック
  final OnTabSelected onTabSelected;

  /// タブのタイトルリスト
  final List<String> tabs;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          for (int index = 0; index < tabs.length; index++)
            Expanded(child: _buildTabItem(tabs[index], index)),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onTabSelected(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.textBlack : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.textBlack : AppColors.borderGray,
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textGray,
          ),
        ),
      ),
    );
  }
}
