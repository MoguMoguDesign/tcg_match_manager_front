import 'package:flutter/material.dart';

/// アプリ内で共通で用いられる [ElevatedButton].
class CommonElevatedButton extends StatelessWidget {
  /// [CommonElevatedButton] を生成する。
  const CommonElevatedButton({
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
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: child,
    );
  }
}
