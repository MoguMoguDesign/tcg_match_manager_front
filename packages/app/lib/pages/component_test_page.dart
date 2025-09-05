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
              // Figma CommonConfirmButton (node-id: 86-7960)
              const Text(
                'CommonConfirmButton (Figma 86-7960)',
                style: AppTextStyles.labelLarge,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 12),
              // Default: userFilled
              CommonConfirmButton(
                text: '参加に進む',
                style: ConfirmButtonStyle.userFilled,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('userFilled: 参加に進む')),
                  );
                },
              ),
              const SizedBox(height: 16),
              // userOutlined
              CommonConfirmButton(
                text: '参加に進む',
                style: ConfirmButtonStyle.userOutlined,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('userOutlined: 参加に進む')),
                  );
                },
              ),
              const SizedBox(height: 16),
              // adminFilled
              CommonConfirmButton(
                text: 'ログイン',
                style: ConfirmButtonStyle.adminFilled,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('adminFilled: ログイン')),
                  );
                },
              ),
              const SizedBox(height: 16),
              // adminOutlined
              CommonConfirmButton(
                text: 'ログイン',
                style: ConfirmButtonStyle.adminOutlined,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('adminOutlined: ログイン')),
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
