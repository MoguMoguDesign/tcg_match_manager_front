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
    this.player1Score = '累計得点 0点',
    this.player2Score = '累計得点 0点',
    this.player1State = PlayerState.progress,
    this.player2State = PlayerState.progress,
    this.player1IsCurrentUser = false,
    this.player2IsCurrentUser = false,
    this.vsStyle = VSContainerStyle.primary,
    this.vsSize = VSContainerSize.medium,
  });

  /// プレイヤー1の名前。
  final String player1Name;

  /// プレイヤー2の名前。
  final String player2Name;

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

  /// VSコンテナのスタイル（廃止予定）。
  @Deprecated('Use player states instead')
  final VSContainerStyle vsStyle;

  /// VSコンテナのサイズ。
  final VSContainerSize vsSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PlayerContainer(
          playerName: player1Name,
          score: player1Score,
          state: player1State,
          isCurrentUser: player1IsCurrentUser,
        ),
        const SizedBox(height: 8),
        VSContainer(
          state: _getVSContainerState(),
          currentUserPosition: _getCurrentUserPosition(),
          size: vsSize,
        ),
        const SizedBox(height: 8),
        PlayerContainer(
          playerName: player2Name,
          score: player2Score,
          state: player2State,
          isCurrentUser: player2IsCurrentUser,
        ),
      ],
    );
  }

  /// プレイヤーの状態からVSContainerの状態を決定する。
  VSContainerState _getVSContainerState() {
    // プレイヤー1が勝利している場合
    if (player1State == PlayerState.win) {
      return VSContainerState.leftPlayerWin;
    }
    // プレイヤー1が敗北している場合
    if (player1State == PlayerState.lose) {
      return VSContainerState.leftPlayerLose;
    }
    // 進行中またはその他の状態
    return VSContainerState.progress;
  }

  /// 現在のユーザーの位置を決定する。
  VSContainerUserPosition _getCurrentUserPosition() {
    if (player1IsCurrentUser) {
      return VSContainerUserPosition.left;
    }
    if (player2IsCurrentUser) {
      return VSContainerUserPosition.right;
    }
    return VSContainerUserPosition.none;
  }
}
