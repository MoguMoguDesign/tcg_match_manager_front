import 'package:base_ui/base_ui.dart';
import 'package:flutter/material.dart';

/// コンポーネントテスト用のページを表示する。
///
/// 各種 UI コンポーネントの表示確認とテストを行う。
class ComponentTestPage extends StatelessWidget {
  /// [ComponentTestPage] のコンストラクタ。
  const ComponentTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('コンポーネントテスト'),
        backgroundColor: AppColors.adminPrimary,
        foregroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'UI コンポーネントテストページ',
                style: AppTextStyles.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              const Text(
                'ここに各種コンポーネントを追加してテストできます。',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Figma デザインボタン (86-7620)
              AppButton(
                text: '参加に進む',
                onPressed: () {
                  // テスト用のボタンアクション
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('参加に進むボタンがタップされました'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              // TODO(component): 他のコンポーネントのテスト要素をここに追加
            ],
          ),
        ),
      ),
    );
  }
}
