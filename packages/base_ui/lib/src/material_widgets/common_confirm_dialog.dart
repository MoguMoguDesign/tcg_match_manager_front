import 'package:flutter/material.dart';

import '../../base_ui.dart';

/// アプリ内で共通で用いられる [AlertDialog].
///
/// [show] メソッドを呼び出すことで利用する。
class CommonAlertDialog extends StatelessWidget {
  const CommonAlertDialog._({
    required this.contentString,
    this.titleString,
    required this.declineButtonLabel,
    required this.confirmButtonLabel,
    this.onConfirmed,
    required this.hasDeclineButton,
    required this.shouldPopOnConfirmed,
  });

  /// ダイアログのタイトル用文字列。
  final String? titleString;

  /// ダイアログの中身用文字列。
  final String contentString;

  /// 否定用ボタンのラベル。
  ///
  /// 「キャンセル」「いいえ」「閉じる」などを意味する文字列が入る。
  ///
  /// null の場合、[L10n] クラスに定義された labelOkay が適用される。
  final String? declineButtonLabel;

  /// 肯定用ボタンのラベル。
  ///
  /// 「OK」「はい」「確認」などを意味する文字列が入る。
  ///
  /// null の場合、[L10n] クラスに定義された labelCancel が適用される。
  final String? confirmButtonLabel;

  /// 肯定ボタン押下後の挙動。
  final VoidCallback? onConfirmed;

  /// 否定用ボタンを表示するかどうか。
  final bool hasDeclineButton;

  /// [onConfirmed] 完了後にダイアログを閉じるかどうか。
  ///
  /// 強制アップデート等で画面の状態が更新されるまでダイアログを閉じたくない場合に利用する。
  final bool shouldPopOnConfirmed;

  /// [CommonAlertDialog] を表示する。
  ///
  /// 各引数の詳細は、同一名のインスタンスフィールドを参照。
  static Future<void> show(
    BuildContext context, {
    String? titleString,
    required String contentString,
    String? declineButtonLabel,
    String? confirmButtonLabel,
    VoidCallback? onConfirmed,
    bool hasCancelButton = false,
    bool shouldPopOnConfirmed = true,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return CommonAlertDialog._(
          titleString: titleString,
          contentString: contentString,
          declineButtonLabel: declineButtonLabel,
          confirmButtonLabel: confirmButtonLabel,
          onConfirmed: onConfirmed,
          hasDeclineButton: hasCancelButton,
          shouldPopOnConfirmed: shouldPopOnConfirmed,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final textTheme = Theme.of(context).textTheme;
    return AlertDialog(
      titleTextStyle: textTheme.titleMedium,
      contentTextStyle: textTheme.bodyLarge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: titleString == null ? null : Center(child: Text(titleString!)),
      content: SingleChildScrollView(child: Text(contentString)),
      actions: [
        if (hasDeclineButton)
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              declineButtonLabel ?? l10n.labelCancel,
              style: textTheme.labelLarge,
            ),
          ),
        TextButton(
          onPressed: () {
            onConfirmed?.call();
            if (shouldPopOnConfirmed) {
              Navigator.of(context).pop();
            }
          },
          child: Text(confirmButtonLabel ?? l10n.labelOkay),
        ),
      ],
    );
  }
}
