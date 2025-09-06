import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

/// 確認用ダイアログウィジェット。
///
/// Figma の ConfirmDialog（node-id: 86-7764）に準拠し、
/// ユーザーの意思確認を行うダイアログを表示する。
class ConfirmDialog extends StatelessWidget {
  /// [ConfirmDialog] のコンストラクタ。
  ///
  /// [title] と [message] は必須パラメータ。
  /// [confirmText] と [cancelText] はデフォルト値を持つ。
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'OK',
    this.cancelText = 'キャンセル',
    this.onConfirm,
    this.onCancel,
  });

  /// ダイアログのタイトル。
  final String title;

  /// ダイアログのメッセージ内容。
  final String message;

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
    required String message,
    String confirmText = 'OK',
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
      backgroundColor: AppColors.textBlack,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.whiteAlpha),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // タイトル
            Text(
              title,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.userPrimary,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // メッセージ
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // ボタン群
            Row(
              children: [
                // キャンセルボタン
                Expanded(
                  child: _DialogButton(
                    text: cancelText,
                    style: _DialogButtonStyle.cancel,
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      onCancel?.call();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // 確認ボタン
                Expanded(
                  child: _DialogButton(
                    text: confirmText,
                    style: _DialogButtonStyle.confirm,
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      onConfirm?.call();
                    },
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

/// ダイアログ内で使用するボタンの内部ウィジェット。
class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.text,
    required this.style,
    required this.onPressed,
  });

  /// ボタンのテキスト。
  final String text;

  /// ボタンのスタイル。
  final _DialogButtonStyle style;

  /// ボタンタップ時のコールバック。
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = _getStyleColors(style);

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(22),
        border: colors.border,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(22),
          child: Center(
            child: Text(
              text,
              style: AppTextStyles.labelMedium.copyWith(
                color: colors.textColor,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _DialogButtonColors _getStyleColors(_DialogButtonStyle style) {
    switch (style) {
      case _DialogButtonStyle.cancel:
        return const _DialogButtonColors(
          backgroundColor: Colors.transparent,
          textColor: AppColors.white,
          border: Border.fromBorderSide(
            BorderSide(color: AppColors.whiteAlpha),
          ),
        );
      case _DialogButtonStyle.confirm:
        return const _DialogButtonColors(
          backgroundColor: AppColors.userPrimary,
          textColor: AppColors.textBlack,
        );
    }
  }
}

/// ダイアログボタンのスタイルを表す列挙型。
enum _DialogButtonStyle {
  /// キャンセルボタンのスタイル。
  cancel,

  /// 確認ボタンのスタイル。
  confirm,
}

/// ダイアログボタンの色情報を保持するクラス。
class _DialogButtonColors {
  const _DialogButtonColors({
    required this.backgroundColor,
    required this.textColor,
    this.border,
  });

  /// 背景色。
  final Color backgroundColor;

  /// テキスト色。
  final Color textColor;

  /// 枠線定義。不要な場合は null。
  final BoxBorder? border;
}
