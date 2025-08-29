import 'package:flutter/material.dart';

/// アプリ内で共通で用いられる [FilledButton].
class CommonFilledButton extends StatelessWidget {
  /// [CommonFilledButton] を生成する。
  const CommonFilledButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  /// ボタン押下時の処理。
  final VoidCallback onPressed;

  /// ボタンの子要素となるウィジェット。
  ///
  /// 通常は [Text] ウィジェットを指定する。
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: child,
    );
  }
}
