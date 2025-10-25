import 'package:base_ui/base_ui.dart';
import 'package:flutter/material.dart';

/// 大会削除確認ダイアログ。
class DeleteTournamentDialog extends StatelessWidget {
  /// 大会削除確認ダイアログのコンストラクタ。
  const DeleteTournamentDialog({required this.tournamentTitle, super.key});

  /// 削除対象の大会タイトル。
  final String tournamentTitle;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: 480,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // タイトル
            const Text(
              '本当にこの大会を削除しますか？',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // 大会タイトル表示
            Text(
              tournamentTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
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

/// 大会削除確認ダイアログを表示する関数。
Future<bool?> showDeleteTournamentDialog(
  BuildContext context, {
  required String tournamentTitle,
}) async {
  return showDialog<bool>(
    context: context,
    builder: (context) =>
        DeleteTournamentDialog(tournamentTitle: tournamentTitle),
  );
}
