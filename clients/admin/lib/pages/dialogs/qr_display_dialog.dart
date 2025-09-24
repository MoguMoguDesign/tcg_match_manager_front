import 'package:base_ui/base_ui.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

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

    return Stack(
      children: [
        // 半透明背景オーバーレイ
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withValues(alpha: 0.2),
        ),
        // ダイアログ本体
        Center(
          child: Container(
            width: 450,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 右上のクローズボタン
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.close,
                      size: 24,
                      color: AppColors.textBlack,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // QRコード表示エリア
                Container(
                  width: 288,
                  height: 288,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: QrImageView(
                    data: participationUrl,
                    size: 288,
                    backgroundColor: Colors.white,
                    dataModuleStyle: const QrDataModuleStyle(
                      color: AppColors.textBlack,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // 印刷するボタン
                SizedBox(
                  width: 342,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _printQRCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.adminPrimary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ).copyWith(
                      overlayColor: WidgetStateProperty.all(
                        Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: const Text(
                      '印刷する',
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
        ),
      ],
    );
  }

  Future<void> _printQRCode() async {
    // TODO(admin): 印刷機能の実装
    // printing パッケージを使用した印刷処理を実装予定
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
