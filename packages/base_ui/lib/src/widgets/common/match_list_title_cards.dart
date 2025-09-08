import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import 'common_small_button.dart';

/// 試合一覧のタイトルカードを表示するウィジェット。
///
/// Figma の MatchListTitleCards に準拠し、左右 2 つのボタンのみを表示する。
///
/// タイトルやサブタイトルは表示しない。背景は透明とする。
class MatchListTitleCards extends StatelessWidget {
  /// 最初のラウンド用の構成を表示する。
  ///
  /// 左: 「前のラウンド」（無効/半透明）。右: 「次のラウンド」。
  const MatchListTitleCards.first({
    super.key,
    this.onPressedPrev,
    this.onPressedNext,
  }) : _variant = _Variant.first,
       onPressedShowFinal = null;

  /// 中間ラウンド用の構成を表示する。
  ///
  /// 左: 「前のラウンド」（無効/半透明）。右: 「次のラウンド」。
  const MatchListTitleCards.medium({
    super.key,
    this.onPressedPrev,
    this.onPressedNext,
  }) : _variant = _Variant.medium,
       onPressedShowFinal = null;

  /// 最後のラウンド用の構成を表示する。
  ///
  /// 左: 「前のラウンド」。右: 「最終順位を表示」。
  const MatchListTitleCards.last({
    super.key,
    this.onPressedPrev,
    this.onPressedShowFinal,
  }) : _variant = _Variant.last,
       onPressedNext = null;

  /// 内部バリアント。
  final _Variant _variant;

  /// 「前のラウンド」ボタンの押下時に呼び出すコールバック。
  final VoidCallback? onPressedPrev;

  /// 「次のラウンド」ボタンの押下時に呼び出すコールバック。
  final VoidCallback? onPressedNext;

  /// 「最終順位を表示」ボタンの押下時に呼び出すコールバック。
  final VoidCallback? onPressedShowFinal;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.transparent,
      child: _buildActions(),
    );
  }

  /// ラウンド種別に応じてアクションボタン群を構築する。
  Widget _buildActions() {
    switch (_variant) {
      case _Variant.first:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 160,
              child: Opacity(
                opacity: 0.3,
                child: CommonSmallButton.leadingIcon(
                  text: '前のラウンド',
                  icon: const Icon(Icons.chevron_left, color: AppColors.white),
                  isEnabled: false,
                  onPressed: onPressedPrev ?? () {},
                  style: SmallButtonStyle.neutralOutlined,
                ),
              ),
            ),
            SizedBox(
              width: 160,
              child: CommonSmallButton.trailingIcon(
                text: '次のラウンド',
                icon: const Icon(Icons.chevron_right, color: AppColors.white),
                onPressed: onPressedNext ?? () {},
                style: SmallButtonStyle.neutralOutlined,
              ),
            ),
          ],
        );
      case _Variant.medium:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 160,
              child: CommonSmallButton.leadingIcon(
                text: '前のラウンド',
                icon: const Icon(Icons.chevron_left, color: AppColors.white),
                isEnabled: false,
                onPressed: onPressedPrev ?? () {},
                style: SmallButtonStyle.neutralOutlined,
              ),
            ),
            SizedBox(
              width: 160,
              child: CommonSmallButton.trailingIcon(
                text: '次のラウンド',
                icon: const Icon(Icons.chevron_right, color: AppColors.white),
                onPressed: onPressedNext ?? () {},
                style: SmallButtonStyle.neutralOutlined,
              ),
            ),
          ],
        );
      case _Variant.last:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 160,
              child: CommonSmallButton.leadingIcon(
                text: '前のラウンド',
                icon: const Icon(Icons.chevron_left, color: AppColors.white),
                onPressed: onPressedPrev ?? () {},
                style: SmallButtonStyle.neutralOutlined,
              ),
            ),
            SizedBox(
              width: 160,
              child: CommonSmallButton.leadingIcon(
                text: '最終順位を表示',
                icon: const Icon(
                  Icons.emoji_events,
                  color: AppColors.userPrimary,
                ),
                onPressed: onPressedShowFinal ?? () {},
                style: SmallButtonStyle.secondary,
              ),
            ),
          ],
        );
    }
  }
}

/// 内部用の表示バリアント。
enum _Variant { first, medium, last }
