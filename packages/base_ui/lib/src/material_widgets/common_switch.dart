import 'package:flutter/material.dart';

/// アプリ内共通で用いられる [Switch].
class CommonSwitch extends StatelessWidget {
  /// [CommonSwitch] を生成する。
  const CommonSwitch({super.key, required this.value, required this.onChanged});

  /// スイッチが ON かどうか。
  final bool value;

  /// スイッチの状態が変更された際に呼び出される。
  ///
  /// 変更後の bool 値がコールバックへ渡される。
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Switch(value: value, onChanged: onChanged);
  }
}
