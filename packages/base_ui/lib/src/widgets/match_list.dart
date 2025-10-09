import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'match_list_header.dart';
import 'match_row.dart';
import 'match_status_container.dart';
import 'player_container.dart';

/// マッチリスト全体を表示するウィジェット。
///
/// Figma の MatchList（node-id: 253-6796）に準拠し、
/// ヘッダー付きのマッチ一覧を縦並びで表示する。
class MatchList extends StatelessWidget {
  /// [MatchList] のコンストラクタ。
  ///
  /// [matches] は必須パラメータ。
  const MatchList({
    super.key,
    required this.matches,
    this.style = MatchListStyle.primary,
    this.onMatchTap,
    this.showHeader = true,
  });

  /// マッチデータのリスト。
  final List<MatchData> matches;

  /// リストのスタイル。
  final MatchListStyle style;

  /// マッチタップ時のコールバック。
  final void Function(MatchData match)? onMatchTap;

  /// ヘッダーを表示するかどうか。
  final bool showHeader;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.textBlack,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showHeader) ...[
            const MatchListHeader(
              roundNumber: 1,
            ),
            const SizedBox(height: 16),
          ],
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
            child: Column(
              children: matches.asMap().entries.expand((entry) {
                  final index = entry.key;
                  final match = entry.value;
                  
                  final matchRow = MatchRow(
                    tableNumber: match.tableNumber,
                    player1Name: match.player1Name,
                    player2Name: match.player2Name,
                    status: match.status,
                    player1Score: match.player1Score,
                    player2Score: match.player2Score,
                    player1State: match.player1State,
                    player2State: match.player2State,
                    player1IsCurrentUser: match.player1IsCurrentUser,
                    player2IsCurrentUser: match.player2IsCurrentUser,
                    style: _getRowStyle(style),
                    onTap: onMatchTap != null ? () => onMatchTap!(match) : null,
                  );
                  
                  if (index == 0) {
                    return [matchRow];
                  } else {
                    return [
                      const SizedBox(height: 8),
                      _buildDivider(),
                      const SizedBox(height: 8),
                      matchRow,
                    ];
                  }
                }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.transparent,
            AppColors.gray.withValues(alpha: 0.3),
            AppColors.transparent,
          ],
        ),
      ),
    );
  }


  MatchRowStyle _getRowStyle(MatchListStyle style) {
    switch (style) {
      case MatchListStyle.primary:
        return MatchRowStyle.primary;
      case MatchListStyle.secondary:
        return MatchRowStyle.secondary;
      case MatchListStyle.admin:
        return MatchRowStyle.admin;
    }
  }
}

/// [MatchList] のスタイルを表す列挙型。
enum MatchListStyle {
  /// プライマリスタイル。
  primary,

  /// セカンダリスタイル。
  secondary,

  /// 管理者スタイル。
  admin,
}

/// マッチデータを保持するクラス。
class MatchData {
  /// [MatchData] のコンストラクタ。
  ///
  /// [tableNumber], [player1Name], [player2Name], [status] は必須パラメータ。
  const MatchData({
    required this.tableNumber,
    required this.player1Name,
    required this.player2Name,
    required this.status,
    this.player1Score = '累計得点 0点',
    this.player2Score = '累計得点 0点',
    this.player1State = PlayerState.progress,
    this.player2State = PlayerState.progress,
    this.player1IsCurrentUser = false,
    this.player2IsCurrentUser = false,
    this.matchId,
  });

  /// テーブル番号。
  final int tableNumber;

  /// プレイヤー1の名前。
  final String player1Name;

  /// プレイヤー2の名前。
  final String player2Name;

  /// マッチステータス。
  final MatchStatus status;

  /// プレイヤー1のスコア。
  final String player1Score;

  /// プレイヤー2のスコア。
  final String player2Score;

  /// プレイヤー1の状態。
  final PlayerState player1State;

  /// プレイヤー2の状態。
  final PlayerState player2State;

  /// プレイヤー1が現在のユーザーかどうか。
  final bool player1IsCurrentUser;

  /// プレイヤー2が現在のユーザーかどうか。
  final bool player2IsCurrentUser;

  /// マッチID（オプション）。
  final String? matchId;
}
