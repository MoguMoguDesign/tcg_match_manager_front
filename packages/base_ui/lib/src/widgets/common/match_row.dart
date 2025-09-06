import 'package:flutter/material.dart';

import 'match_status_container.dart';
import 'player_container.dart';
import 'players_container.dart';
import 'table_number_column.dart';

/// マッチ行を表示するウィジェット。
///
/// Figma の MatchRow（node-id: 253-6227）に準拠し、
/// テーブル番号、プレイヤー情報、ステータスを横並びで表示する。
class MatchRow extends StatelessWidget {
  /// [MatchRow] のコンストラクタ。
  ///
  /// [tableNumber], [player1Name], [player2Name], [status] は必須パラメータ。
  const MatchRow({
    super.key,
    required this.tableNumber,
    required this.player1Name,
    required this.player2Name,
    required this.status,
    this.player1Number,
    this.player2Number,
    this.player1IsWinner = false,
    this.player2IsWinner = false,
    this.onTap,
    this.style = MatchRowStyle.primary,
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

  /// タップ時のコールバック。
  final VoidCallback? onTap;

  /// 行のスタイル。
  final MatchRowStyle style;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _getBackgroundColor(style),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getBorderColor(style),
          ),
        ),
        child: Row(
          children: [
            TableNumberColumn(
              tableNumber: tableNumber,
              style: _getTableNumberStyle(style),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: PlayersContainer(
                player1Name: player1Name,
                player2Name: player2Name,
                player1Number: player1Number,
                player2Number: player2Number,
                player1IsWinner: player1IsWinner,
                player2IsWinner: player2IsWinner,
                playerStyle: _getPlayerContainerStyle(style),
              ),
            ),
            const SizedBox(width: 16),
            MatchStatusContainer(status: status),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor(MatchRowStyle style) {
    switch (style) {
      case MatchRowStyle.primary:
        return Colors.transparent;
      case MatchRowStyle.secondary:
        return Colors.grey.shade50;
      case MatchRowStyle.admin:
        return Colors.blue.shade50;
    }
  }

  Color _getBorderColor(MatchRowStyle style) {
    switch (style) {
      case MatchRowStyle.primary:
        return Colors.grey.shade300;
      case MatchRowStyle.secondary:
        return Colors.grey.shade200;
      case MatchRowStyle.admin:
        return Colors.blue.shade200;
    }
  }

  TableNumberStyle _getTableNumberStyle(MatchRowStyle style) {
    switch (style) {
      case MatchRowStyle.primary:
        return TableNumberStyle.primary;
      case MatchRowStyle.secondary:
        return TableNumberStyle.secondary;
      case MatchRowStyle.admin:
        return TableNumberStyle.admin;
    }
  }

  PlayerContainerStyle _getPlayerContainerStyle(MatchRowStyle style) {
    switch (style) {
      case MatchRowStyle.primary:
        return PlayerContainerStyle.primary;
      case MatchRowStyle.secondary:
        return PlayerContainerStyle.secondary;
      case MatchRowStyle.admin:
        return PlayerContainerStyle.secondary;
    }
  }
}

/// [MatchRow] のスタイルを表す列挙型。
enum MatchRowStyle {
  /// プライマリスタイル。
  primary,

  /// セカンダリスタイル。
  secondary,

  /// 管理者スタイル。
  admin,
}