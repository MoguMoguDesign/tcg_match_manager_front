import 'package:flutter/material.dart';

import 'common_small_button.dart';

/// ラウンド変更ボタン行を表示するウィジェット。
///
/// Figma の MatchListTitleCards に準拠し、左右 2 つのボタンのみを表示する。
///
/// タイトルやサブタイトルは表示しない。背景は透明とする。
class RoundChangeButtonRow extends StatelessWidget {
  /// 最初のラウンド用の構成を表示する。
  ///
  /// 左: 「前へ」（無効/半透明）。右: 「次へ」。
  const RoundChangeButtonRow.first({
    super.key,
    this.onPressedPrev,
    this.onPressedNext,
  }) : _variant = _Variant.first,
       onPressedShowFinal = null;

  /// 中間ラウンド用の構成を表示する。
  ///
  /// 左: 「前へ」（無効/半透明）。右: 「次へ」。
  const RoundChangeButtonRow.medium({
    super.key,
    this.onPressedPrev,
    this.onPressedNext,
  }) : _variant = _Variant.medium,
       onPressedShowFinal = null;

  /// 最後のラウンド用の構成を表示する。
  ///
  /// 左: 「前へ」。右: 「最終順位」。
  const RoundChangeButtonRow.last({
    super.key,
    this.onPressedPrev,
    this.onPressedShowFinal,
  }) : _variant = _Variant.last,
       onPressedNext = null;

  /// 内部バリアント。
  final _Variant _variant;

  /// 「前へ」ボタンの押下時に呼び出すコールバック。
  final VoidCallback? onPressedPrev;

  /// 「次へ」ボタンの押下時に呼び出すコールバック。
  final VoidCallback? onPressedNext;

  /// 「最終順位」ボタンの押下時に呼び出すコールバック。
  final VoidCallback? onPressedShowFinal;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.transparent,
      child: _buildActions(),
    );
  }

  /// ラウンド種別に応じてアクションボタン群を構築する。
  Widget _buildActions() {
    switch (_variant) {
      case _Variant.first:
        return LayoutBuilder(
          builder: (context, constraints) {
            // Equal size buttons: (total width - gap) / 2
            final buttonWidth = (constraints.maxWidth - 8) / 2;
            return Row(
              children: [
                SizedBox(
                  width: buttonWidth,
                  child: CommonSmallButton.leadingIcon(
                    text: '前へ',
                    icon: const Icon(Icons.chevron_left),
                    isEnabled: false,
                    onPressed: onPressedPrev ?? () {},
                    style: SmallButtonStyle.neutralOutlined,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: buttonWidth,
                  child: CommonSmallButton.trailingIcon(
                    text: '次へ',
                    icon: const Icon(Icons.chevron_right),
                    onPressed: onPressedNext ?? () {},
                    style: SmallButtonStyle.neutralOutlined,
                  ),
                ),
              ],
            );
          },
        );
      case _Variant.medium:
        return LayoutBuilder(
          builder: (context, constraints) {
            // Equal size buttons: (total width - gap) / 2
            final buttonWidth = (constraints.maxWidth - 8) / 2;
            return Row(
              children: [
                SizedBox(
                  width: buttonWidth,
                  child: CommonSmallButton.leadingIcon(
                    text: '前へ',
                    icon: const Icon(Icons.chevron_left),
                    isEnabled: false,
                    onPressed: onPressedPrev ?? () {},
                    style: SmallButtonStyle.neutralOutlined,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: buttonWidth,
                  child: CommonSmallButton.trailingIcon(
                    text: '次へ',
                    icon: const Icon(Icons.chevron_right),
                    onPressed: onPressedNext ?? () {},
                    style: SmallButtonStyle.neutralOutlined,
                  ),
                ),
              ],
            );
          },
        );
      case _Variant.last:
        return LayoutBuilder(
          builder: (context, constraints) {
            // Equal size buttons: (total width - gap) / 2
            final buttonWidth = (constraints.maxWidth - 8) / 2;
            return Row(
              children: [
                SizedBox(
                  width: buttonWidth,
                  child: CommonSmallButton.leadingIcon(
                    text: '前へ',
                    icon: const Icon(Icons.chevron_left),
                    onPressed: onPressedPrev ?? () {},
                    style: SmallButtonStyle.neutralOutlined,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: buttonWidth,
                  child: CommonSmallButton(
                    text: '最終順位',
                    onPressed: onPressedShowFinal ?? () {},
                    style: SmallButtonStyle.secondary,
                  ),
                ),
              ],
            );
          },
        );
    }
  }
}

/// 内部用の表示バリアント。
enum _Variant { first, medium, last }
