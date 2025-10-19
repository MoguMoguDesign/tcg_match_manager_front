import 'dart:async';
import 'dart:convert';

import 'package:base_ui/base_ui.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../router.dart';

/// QRコードスキャンページを表示する。
///
/// トーナメントIDをQRコードから読み取り、登録ページに遷移する。
class QRScanPage extends StatefulWidget {
  /// [QRScanPage] のコンストラクタ。
  const QRScanPage({super.key});

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isProcessing = false;

  @override
  void dispose() {
    unawaited(_controller.dispose());
    super.dispose();
  }

  /// QRコードを処理する。
  ///
  /// - [barcodeCapture] は、スキャンされたバーコード情報。
  void _handleBarcode(BarcodeCapture barcodeCapture) {
    if (_isProcessing) {
      return;
    }

    final barcode = barcodeCapture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    final rawValue = barcode.rawValue!;

    try {
      // JSON形式のQRコードを解析する。
      // 期待される形式: {"tournamentId": "xxx"}
      final data = jsonDecode(rawValue) as Map<String, dynamic>;
      final tournamentId = data['tournamentId'] as String?;

      if (tournamentId == null || tournamentId.isEmpty) {
        _showError('トーナメントIDが見つかりませんでした');
        return;
      }

      // 登録ページに遷移する。
      if (mounted) {
        context.goToRegistration(tournamentId: tournamentId);
      }
    } on FormatException {
      // JSON形式でない場合は、そのままtournamentIdとして扱う。
      if (rawValue.isNotEmpty) {
        if (mounted) {
          context.goToRegistration(tournamentId: rawValue);
        }
      } else {
        _showError('無効なQRコードです');
      }
    } on Exception catch (e) {
      _showError('QRコードの読み取りに失敗しました: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  /// エラーメッセージを表示する。
  ///
  /// - [message] は、表示するエラーメッセージ。
  void _showError(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );

    setState(() {
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QRコードをスキャン', style: AppTextStyles.labelLarge),
        backgroundColor: AppColors.userPrimary,
        foregroundColor: AppColors.textBlack,
      ),
      body: Stack(
        children: [
          MobileScanner(controller: _controller, onDetect: _handleBarcode),
          // スキャンエリアのオーバーレイ
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          // 説明テキスト
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Text(
                'QRコードを枠内に収めてスキャンしてください',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.white,
                  backgroundColor: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
