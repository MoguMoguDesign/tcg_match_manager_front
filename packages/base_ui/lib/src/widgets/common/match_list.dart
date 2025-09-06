import 'package:flutter/material.dart';

import 'match_list_header.dart';
import 'match_row.dart';
import 'match_status_container.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showHeader) ...[
          MatchListHeader(
            style: _getHeaderStyle(style),
          ),
          const SizedBox(height: 8),
        ],
        ...matches.asMap().entries.map((entry) {
          final index = entry.key;
          final match = entry.value;
          
          return Column(
            children: [
              if (index > 0) const SizedBox(height: 8),
              MatchRow(
                tableNumber: match.tableNumber,
                player1Name: match.player1Name,
                player2Name: match.player2Name,
                status: match.status,
                player1Number: match.player1Number,
                player2Number: match.player2Number,
                player1IsWinner: match.player1IsWinner,
                player2IsWinner: match.player2IsWinner,
                style: _getRowStyle(style),
                onTap: onMatchTap != null ? () => onMatchTap!(match) : null,
              ),
            ],
          );
        }),
      ],
    );
  }

  MatchListHeaderStyle _getHeaderStyle(MatchListStyle style) {
    switch (style) {
      case MatchListStyle.primary:
        return MatchListHeaderStyle.primary;
      case MatchListStyle.secondary:
        return MatchListHeaderStyle.secondary;
      case MatchListStyle.admin:
        return MatchListHeaderStyle.admin;
    }
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
    this.player1Number,
    this.player2Number,
    this.player1IsWinner = false,
    this.player2IsWinner = false,
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

  /// プレイヤー1の番号（オプション）。
  final int? player1Number;

  /// プレイヤー2の番号（オプション）。
  final int? player2Number;

  /// プレイヤー1が勝者かどうか。
  final bool player1IsWinner;

  /// プレイヤー2が勝者かどうか。
  final bool player2IsWinner;

  /// マッチID（オプション）。
  final String? matchId;
}
