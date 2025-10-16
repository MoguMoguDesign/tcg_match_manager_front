import 'package:flutter/material.dart';

import 'match_list.dart';
import 'match_list_header.dart';
import 'round_change_button_row.dart';

/// 試合結果を表示するコンテナウィジェット。
///
/// Figma の ResultContainer（node-id: 255-2469）に準拠し、
/// RoundChangeButtonRow と MatchList を組み合わせて表示する。
class ResultContainer extends StatelessWidget {
  /// [ResultContainer] のコンストラクタ。
  const ResultContainer({
    super.key,
    required this.matches,
    this.roundNumber = 1,
    this.maxRounds = 6,
    this.onPressedPrev,
    this.onPressedNext,
    this.onPressedShowFinal,
    this.onMatchTap,
    this.roundButtonType = RoundButtonType.first,
  });

  /// マッチデータのリスト。
  final List<MatchData> matches;

  /// ラウンド番号。
  final int roundNumber;

  /// 最大ラウンド数。
  final int maxRounds;

  /// 「前のラウンド」ボタン押下時のコールバック。
  final VoidCallback? onPressedPrev;

  /// 「次のラウンド」ボタン押下時のコールバック。
  final VoidCallback? onPressedNext;

  /// 「最終順位を表示」ボタン押下時のコールバック。
  final VoidCallback? onPressedShowFinal;

  /// マッチタップ時のコールバック。
  final void Function(MatchData match)? onMatchTap;

  /// ラウンドボタンの種類。
  final RoundButtonType roundButtonType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // RoundChangeButtonRow
        _buildRoundChangeButtonRow(),
        const SizedBox(height: 16),
        // MatchList with Header
        Column(
          children: [
            MatchListHeader(roundNumber: roundNumber, maxRounds: maxRounds),
            const SizedBox(height: 16),
            MatchList(
              matches: matches,
              showHeader: false,
              onMatchTap: onMatchTap,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoundChangeButtonRow() {
    switch (roundButtonType) {
      case RoundButtonType.first:
        return RoundChangeButtonRow.first(
          onPressedPrev: onPressedPrev,
          onPressedNext: onPressedNext,
        );
      case RoundButtonType.medium:
        return RoundChangeButtonRow.medium(
          onPressedPrev: onPressedPrev,
          onPressedNext: onPressedNext,
        );
      case RoundButtonType.last:
        return RoundChangeButtonRow.last(
          onPressedPrev: onPressedPrev,
          onPressedShowFinal: onPressedShowFinal,
        );
    }
  }
}

/// ラウンドボタンの種類を表す列挙型。
enum RoundButtonType {
  /// 最初のラウンド（前のラウンドボタンが無効）。
  first,

  /// 中間ラウンド（前・次のラウンドボタンが有効）。
  medium,

  /// 最後のラウンド（最終順位表示ボタン）。
  last,
}
