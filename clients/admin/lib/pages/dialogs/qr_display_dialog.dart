import 'package:base_ui/base_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// QR表示ダイアログ
///
/// Figmaデザイン: https://www.figma.com/design/A4NEf0vCuJNuPfBMTEa4OO/%E3%83%9E%E3%83%81%E3%82%B5%E3%83%9D?node-id=512-4784&t=whDUBuHITxOChCST-4
class QRDisplayDialog extends StatelessWidget {
  /// QR表示ダイアログのコンストラクタ
  const QRDisplayDialog({
    required this.tournamentId,
    required this.tournamentTitle,
    super.key,
  });

  /// トーナメントID
  final String tournamentId;

  /// トーナメントタイトル
  final String tournamentTitle;

  @override
  Widget build(BuildContext context) {
    final participationUrl = 'https://tournament.app/join/$tournamentId';

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 480,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // タイトル
            const Text(
              'トーナメント参加用QRコード',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // サブタイトル
            Text(
              tournamentTitle,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.grayDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // QRコード表示エリア
            Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.borderLight, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.qr_code,
                    size: 120,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'QRコード',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 参加URL表示
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.backgroundField,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '参加URL:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.grayDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    participationUrl,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textBlack,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ボタンエリア
            DialogButtons(
              primaryText: '閉じる',
              onPrimaryPressed: () => Navigator.of(context).pop(),
              secondaryText: 'URLをコピー',
              onSecondaryPressed: () =>
                  _copyToClipboard(context, participationUrl),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _copyToClipboard(BuildContext context, String url) async {
    await Clipboard.setData(ClipboardData(text: url));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('URLをクリップボードにコピーしました'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}

/// QR表示ダイアログを表示する関数
Future<void> showQRDisplayDialog(
  BuildContext context, {
  required String tournamentId,
  required String tournamentTitle,
}) async {
  await showDialog<void>(
    context: context,
    builder: (context) => QRDisplayDialog(
      tournamentId: tournamentId,
      tournamentTitle: tournamentTitle,
    ),
  );
}
