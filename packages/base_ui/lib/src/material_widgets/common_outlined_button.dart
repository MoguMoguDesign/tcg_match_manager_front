import 'package:flutter/material.dart';

/// アプリ内で共通で用いられる [OutlinedButton].
class CommonOutlinedButton extends StatelessWidget {
  /// [CommonOutlinedButton] を生成する。
  const CommonOutlinedButton({
    super.key,
    required this.onPressed,
    required this.child,
  }) : icon = null,
       label = null;

  /// アイコン付きの [CommonOutlinedButton] を生成する。
  ///
  /// 内部的には [OutlinedButton.icon] を利用しているため、[icon] と [label] が必須となっている。
  const CommonOutlinedButton.icon({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
  }) : child = null;

  /// ボタン押下時の処理。
  final VoidCallback onPressed;

  /// ボタンの子要素となるウィジェット。
  ///
  /// 通常はラベル用に [Text] ウィジェットを指定する。
  final Widget? child;

  /// アイコン用ウィジェット。
  final Widget? icon;

  /// ラベル用ウィジェット。
  final Widget? label;

  /// アイコン付きボタンとして表示するかどうか。
  ///
  /// [icon] と [label] の両方が指定されている場合に true を返す。
  bool get _shouldShowIcon => icon != null && label != null;

  @override
  Widget build(BuildContext context) {
    final style = OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      iconSize: 30,
    );

    if (_shouldShowIcon) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        style: style,
        icon: icon,
        label: label!,
      );
    }

    return OutlinedButton(onPressed: onPressed, style: style, child: child);
  }
}
