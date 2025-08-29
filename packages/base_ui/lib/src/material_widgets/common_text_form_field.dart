import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';

import '../../base_ui.dart';

/// アプリ内で共通で用いられる [TextFormField].
class CommonTextFormField extends StatelessWidget {
  /// [CommonTextFormField] を生成する。
  ///
  /// [isObscure] はデフォルト値 として false が適用される。
  /// [icon] は null が適用されるため、指定したい場合は [CommonTextFormField.withIcon] を利用する。
  const CommonTextFormField({
    super.key,
    this.hintText,
    this.isObscure = false,
    required this.onChanged,
    required this.controller,
    this.validator,
  }) : icon = null;

  /// アイコン付きの [CommonTextFormField] を生成する。
  ///
  /// [isObscure] はデフォルト値 として false が適用される。
  const CommonTextFormField.withIcon({
    super.key,
    this.hintText,
    this.isObscure = false,
    required this.onChanged,
    required this.controller,
    required this.icon,
    this.validator,
  });

  /// プレースホルダー文字列。
  ///
  /// null の場合、非表示になる。
  final String? hintText;

  /// テキストフィールド内に表示されるアイコン。
  ///
  /// null の場合、非表示になる。
  final IconData? icon;

  /// 入力内容を隠すかどうか。
  final bool isObscure;

  /// 入力内容変更時に呼び出される。
  ///
  /// 変更後の文字列がコールバックへ渡される。
  final ValueChanged<String> onChanged;

  /// [TextEditingController] インスタンス。
  ///
  /// 呼び出し側で [useTextEditingController] を使って生成する。
  final TextEditingController controller;

  /// バリデーション用のメソッド。
  ///
  /// 入力が無効な場合にはエラー文字列を返し、それ以外の場合は null を返す。
  ///
  /// 返すエラー文字列は、多言語対応のために [L10n] へ定義したものを利用する。
  final String? Function(String? value)? validator;

  @override
  Widget build(BuildContext context) {
    return Row(
      // エラーテキストの表示時に配置がずれないように、start から並べてアイコン上部には余白をつける。
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Padding(padding: const EdgeInsets.only(top: 12), child: Icon(icon)),
          const Gap(8),
        ],
        Expanded(
          child: TextFormField(
            controller: controller,
            obscureText: isObscure,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
            ),
            onChanged: onChanged,
            validator: validator,
          ),
        ),
      ],
    );
  }
}
