import 'package:base_ui/base_ui.dart';
import 'package:flutter/material.dart';

/// ユーザー削除確認ダイアログ
///
/// Figmaデザイン: https://www.figma.com/design/A4NEf0vCuJNuPfBMTEa4OO/%E3%83%9E%E3%83%81%E3%82%B5%E3%83%9D?node-id=512-18760&t=whDUBuHITxOChCST-4
class UserDeleteDialog extends StatelessWidget {
  /// ユーザー削除確認ダイアログのコンストラクタ
  const UserDeleteDialog({
    required this.userName,
    super.key,
  });

  /// 削除対象のユーザー名
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        width: 480,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // タイトル
            const Text(
              '本当にこのユーザーを削除しますか？',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000336),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // ユーザー名表示
            Text(
              userName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000336),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // ボタンエリア
            Row(
              children: [
                // キャンセルボタン
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: CommonConfirmButton(
                      text: 'キャンセル',
                      style: ConfirmButtonStyle.adminOutlined,
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // 削除ボタン
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: CommonConfirmButton(
                      text: '削除',
                      style: ConfirmButtonStyle.alertFilled,
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// ユーザー削除確認ダイアログを表示する関数
Future<bool?> showUserDeleteDialog(
  BuildContext context, {
  required String userName,
}) async {
  return showDialog<bool>(
    context: context,
    builder: (context) => UserDeleteDialog(
      userName: userName,
    ),
  );
}
