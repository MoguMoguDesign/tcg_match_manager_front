import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import 'dialog_buttons.dart';

/// 確認用ダイアログウィジェット。
///
/// Figma の ConfirmDialog（node-id: 86-7764）に準拠し、
/// ユーザーの意思確認を行うダイアログを表示する。
class ConfirmDialog extends StatelessWidget {
  /// [ConfirmDialog] のコンストラクタ。
  ///
  /// [title] は必須パラメータ。
  /// [message] はオプション（指定時は2行表示）。
  /// [confirmText] と [cancelText] はデフォルト値を持つ。
  const ConfirmDialog({
    super.key,
    required this.title,
    this.message,
    this.confirmText = '決定',
    this.cancelText = 'キャンセル',
    this.onConfirm,
    this.onCancel,
  });

  /// ダイアログのタイトル。
  final String title;

  /// ダイアログのメッセージ内容（オプション）。
  final String? message;

  /// 確認ボタンのテキスト。
  final String confirmText;

  /// キャンセルボタンのテキスト。
  final String cancelText;

  /// 確認ボタンタップ時のコールバック。
  final VoidCallback? onConfirm;

  /// キャンセルボタンタップ時のコールバック。
  final VoidCallback? onCancel;

  /// ダイアログを表示する静的メソッド。
  ///
  /// 戻り値は確認されたかどうかの [bool] 値。
  /// 確認ボタンが押された場合は true、キャンセルまたは外側タップで false。
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    String? message,
    String confirmText = '決定',
    String cancelText = 'キャンセル',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 30, 24, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // タイトル
            Text(
              title,
              style: AppTextStyles.headlineLarge.copyWith(
                color: AppColors.textBlack,
                fontSize: 20,
                height: 1,
              ),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: 24),
              // メッセージ
              Text(
                message!,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textBlack,
                  fontSize: 14,
                  height: 1,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),
            // ボタン群
            SizedBox(
              width: 314,
              child: DialogButtons(
                primaryText: confirmText,
                onPrimaryPressed: () {
                  Navigator.of(context).pop(true);
                  onConfirm?.call();
                },
                secondaryText: cancelText,
                onSecondaryPressed: () {
                  Navigator.of(context).pop(false);
                  onCancel?.call();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
