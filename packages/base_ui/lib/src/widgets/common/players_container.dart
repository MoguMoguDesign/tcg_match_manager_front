import 'package:flutter/material.dart';

import 'player_container.dart';
import 'vs_container.dart';

/// 対戦する2人のプレイヤーを表示するコンテナウィジェット。
///
/// Figma の PlayersContainer（node-id: 253-5745）に準拠し、
/// プレイヤー情報とVSコンテナを組み合わせて表示する。
class PlayersContainer extends StatelessWidget {
  /// [PlayersContainer] のコンストラクタ。
  ///
  /// [player1Name] と [player2Name] は必須パラメータ。
  const PlayersContainer({
    super.key,
    required this.player1Name,
    required this.player2Name,
    this.player1Number,
    this.player2Number,
    this.player1IsWinner = false,
    this.player2IsWinner = false,
    this.playerStyle = PlayerContainerStyle.primary,
    this.vsStyle = VSContainerStyle.primary,
    this.vsSize = VSContainerSize.medium,
  });

  /// プレイヤー1の名前。
  final String player1Name;

  /// プレイヤー2の名前。
  final String player2Name;

  /// プレイヤー1の番号（オプション）。
  final int? player1Number;

  /// プレイヤー2の番号（オプション）。
  final int? player2Number;

  /// プレイヤー1が勝者かどうか。
  final bool player1IsWinner;

  /// プレイヤー2が勝者かどうか。
  final bool player2IsWinner;

  /// プレイヤーコンテナのスタイル。
  final PlayerContainerStyle playerStyle;

  /// VSコンテナのスタイル。
  final VSContainerStyle vsStyle;

  /// VSコンテナのサイズ。
  final VSContainerSize vsSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PlayerContainer(
          playerName: player1Name,
          playerNumber: player1Number,
          isWinner: player1IsWinner,
          style: playerStyle,
        ),
        const SizedBox(height: 8),
        VSContainer(
          style: vsStyle,
          size: vsSize,
        ),
        const SizedBox(height: 8),
        PlayerContainer(
          playerName: player2Name,
          playerNumber: player2Number,
          isWinner: player2IsWinner,
          style: playerStyle,
        ),
      ],
    );
  }
}
