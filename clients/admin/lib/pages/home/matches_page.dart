import 'package:base_ui/base_ui.dart' as base_ui;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/layout/admin_scaffold.dart';
import 'tournament_list_page.dart';

/// 対戦表画面
///
/// Figmaデザイン: https://www.figma.com/design/A4NEf0vCuJNuPfBMTEa4OO/%E3%83%9E%E3%83%81%E3%82%B5%E3%83%9D?node-id=512-5817&t=whDUBuHITxOChCST-4
class MatchesPage extends StatefulWidget {
  /// 対戦表画面のコンストラクタ
  const MatchesPage({required this.tournamentId, super.key});

  /// トーナメントID
  final String tournamentId;

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: '対戦表',
      actions: [
        IconButton(
          onPressed: context.pop,
          icon: const Icon(Icons.arrow_back),
          color: const Color(0xFF000336),
        ),
        const Spacer(),
      ],
      body: MatchesContent(tournamentId: widget.tournamentId),
    );
  }
}

/// 対戦表コンテンツ。
///
/// AdminScaffold を含まない、タブ内などで再利用するためのコンテンツ部分を提供する。
class MatchesContent extends StatefulWidget {
  /// 対戦表コンテンツのコンストラクタ。
  const MatchesContent({required this.tournamentId, super.key});

  /// トーナメント ID。
  final String tournamentId;

  @override
  State<MatchesContent> createState() => _MatchesContentState();
}

class _MatchesContentState extends State<MatchesContent> {
  int _currentRound = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 操作ボタン行
          Row(
            children: [
              SizedBox(
                width: 160,
                child: base_ui.CommonConfirmButton(
                  text: '大会終了',
                  style: base_ui.ConfirmButtonStyle.adminOutlined,
                  onPressed: _showEndTournamentDialog,
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 160,
                child: base_ui.CommonConfirmButton(
                  text: '次のラウンド',
                  style: base_ui.ConfirmButtonStyle.adminFilled,
                  onPressed: _showNextRoundDialog,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 対戦表
          Expanded(child: _buildMatchList()),
        ],
      ),
    );
  }

  Widget _buildMatchList() {
    final currentRoundData = _getRounds().firstWhere(
      (round) => round.roundNumber == _currentRound,
    );
    final matches = currentRoundData.matches;

    if (matches.isEmpty) {
      return const Center(
        child: Text(
          '対戦がありません',
          style: TextStyle(fontSize: 16, color: Color(0xFF7A7A83)),
        ),
      );
    }

    // Base UI の ResultContainer を使用
    return base_ui.ResultContainer(
      matches: _convertToBaseUIMatchData(matches),
      roundNumber: _currentRound,
      maxRounds: _getRounds().length,
      roundButtonType: _getRoundButtonType(),
      onPressedPrev: _currentRound > 1
          ? () => _changeRound(_currentRound - 1)
          : null,
      onPressedNext: _currentRound < _getRounds().length
          ? () => _changeRound(_currentRound + 1)
          : null,
      onPressedShowFinal: _currentRound == _getRounds().length
          ? _showFinalResults
          : null,
      onMatchTap: (match) => _showManualResultDialog(_getOriginalMatch(match)),
    );
  }

  /// Base UI の MatchData に変換する
  List<base_ui.MatchData> _convertToBaseUIMatchData(List<MatchData> matches) {
    return matches.map((match) {
      final player1Name = _getParticipantName(match.player1Id);
      final player2Name = _getParticipantName(match.player2Id);

      final status = match.result == MatchResult.pending
          ? base_ui.MatchStatus.playing
          : base_ui.MatchStatus.finished;

      final player1State = match.result == MatchResult.player1Win
          ? base_ui.PlayerState.win
          : match.result == MatchResult.player2Win
          ? base_ui.PlayerState.lose
          : match.result == MatchResult.draw
          ? base_ui.PlayerState.lose
          : base_ui.PlayerState.progress;

      final player2State = match.result == MatchResult.player2Win
          ? base_ui.PlayerState.win
          : match.result == MatchResult.player1Win
          ? base_ui.PlayerState.lose
          : match.result == MatchResult.draw
          ? base_ui.PlayerState.lose
          : base_ui.PlayerState.progress;

      return base_ui.MatchData(
        tableNumber: match.tableNumber,
        player1Name: player1Name,
        player2Name: player2Name,
        status: status,
        player1State: player1State,
        player2State: player2State,
        matchId: match.id,
      );
    }).toList();
  }

  /// Base UI の MatchData から元の MatchData を取得
  MatchData _getOriginalMatch(base_ui.MatchData baseMatch) {
    final currentRoundData = _getRounds().firstWhere(
      (round) => round.roundNumber == _currentRound,
    );
    final matches = currentRoundData.matches;
    return matches.firstWhere((m) => m.id == baseMatch.matchId);
  }

  /// ラウンドボタンの種類を決定
  base_ui.RoundButtonType _getRoundButtonType() {
    final maxRounds = _getRounds().length;
    if (_currentRound == 1) {
      return base_ui.RoundButtonType.first;
    } else if (_currentRound == maxRounds) {
      return base_ui.RoundButtonType.last;
    } else {
      return base_ui.RoundButtonType.medium;
    }
  }

  void _changeRound(int newRound) {
    setState(() {
      _currentRound = newRound;
    });
  }

  void _showFinalResults() {
    context.goNamed(
      'tournament-final',
      pathParameters: {'id': widget.tournamentId},
    );
  }

  String _getParticipantName(String? participantId) {
    if (participantId == null) {
      return '不戦勝';
    }
    final participants = _getParticipants();
    final participant = participants
        .where((p) => p.id == participantId)
        .firstOrNull;
    return participant?.name ?? '不明';
  }

  Future<void> _showManualResultDialog(MatchData match) async {
    final player1Name = _getParticipantName(match.player1Id);
    final player2Name = _getParticipantName(match.player2Id);

    await showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '勝敗入力',
                style: base_ui.AppTextStyles.headlineLarge.copyWith(
                  color: base_ui.AppColors.textBlack,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Table ${match.tableNumber}',
                style: base_ui.AppTextStyles.labelMedium.copyWith(
                  color: base_ui.AppColors.gray,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              base_ui.PlayersContainer(
                player1Name: player1Name,
                player2Name: player2Name,
                player1State: _toPlayerState(match, isPlayer1: true),
                player2State: _toPlayerState(match, isPlayer1: false),
              ),
              const SizedBox(height: 24),
              base_ui.DialogButtons(
                primaryText: '両者負け',
                onPrimaryPressed: () async {
                  final confirmed = await base_ui.ConfirmDialog.show(
                    context,
                    title: '両者負けにしますか？',
                    message: 'この操作は取り消せません。',
                  );
                  if (!mounted) {
                    return;
                  }
                  if (confirmed ?? false) {
                    _updateMatchResult(match, MatchResult.draw);
                  }
                },
                secondaryText: '手動で勝敗を選ぶ',
                onSecondaryPressed: () async {
                  Navigator.of(context).pop();
                  await _showSelectWinnerDialog(
                    match,
                    player1Name,
                    player2Name,
                  );
                },
                isVertical: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showSelectWinnerDialog(
    MatchData match,
    String player1Name,
    String player2Name,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '勝者を選択',
                style: base_ui.AppTextStyles.headlineLarge.copyWith(
                  color: base_ui.AppColors.textBlack,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              base_ui.DialogButtons(
                primaryText: player1Name,
                onPrimaryPressed: () {
                  Navigator.of(context).pop();
                  _updateMatchResult(match, MatchResult.player1Win);
                },
                secondaryText: player2Name,
                onSecondaryPressed: () {
                  Navigator.of(context).pop();
                  _updateMatchResult(match, MatchResult.player2Win);
                },
                isVertical: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  base_ui.PlayerState _toPlayerState(
    MatchData match, {
    required bool isPlayer1,
  }) {
    switch (match.result) {
      case MatchResult.player1Win:
        return isPlayer1 ? base_ui.PlayerState.win : base_ui.PlayerState.lose;
      case MatchResult.player2Win:
        return isPlayer1 ? base_ui.PlayerState.lose : base_ui.PlayerState.win;
      case MatchResult.draw:
        return base_ui.PlayerState.lose;
      case MatchResult.pending:
        return base_ui.PlayerState.progress;
    }
  }

  Future<void> _showNextRoundDialog() async {
    final confirmed = await base_ui.ConfirmDialog.show(
      context,
      title: 'ラウンド進行確認',
      message: 'ラウンド$_currentRoundを終了し、次のラウンドに進みますか？',
      confirmText: '次のラウンド',
    );
    if (!mounted) {
      return;
    }
    if (confirmed ?? false) {
      _proceedToNextRound();
    }
  }

  Future<void> _showEndTournamentDialog() async {
    final confirmed = await base_ui.ConfirmDialog.show(
      context,
      title: '大会終了確認',
      message: '大会を終了しますか？\nこの操作は取り消せません。',
      confirmText: '大会終了',
    );
    if (!mounted) {
      return;
    }
    if (confirmed ?? false) {
      _endTournament();
    }
  }

  void _updateMatchResult(MatchData match, MatchResult result) {
    // TODO(admin): 実際の結果更新処理を実装
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('結果を更新しました'),
        backgroundColor: Color(0xFF38A169),
      ),
    );
    setState(() {});
  }

  void _proceedToNextRound() {
    // TODO(admin): 実際のラウンド進行処理を実装
    setState(() {
      _currentRound++;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ラウンド$_currentRoundに進みました'),
        backgroundColor: const Color(0xFF38A169),
      ),
    );
  }

  void _endTournament() {
    // TODO(admin): 実際の大会終了処理を実装
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('大会を終了しました'),
        backgroundColor: Color(0xFF38A169),
      ),
    );
    context.pop();
  }

  // ダミーデータ生成メソッド
  List<RoundData> _getRounds() {
    return [
      RoundData(
        id: 'round_1',
        tournamentId: widget.tournamentId,
        roundNumber: 1,
        name: 'ラウンド1',
        matches: _getMatchesForRound(1),
        startedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      RoundData(
        id: 'round_2',
        tournamentId: widget.tournamentId,
        roundNumber: 2,
        name: 'ラウンド2',
        matches: _getMatchesForRound(2),
      ),
      RoundData(
        id: 'round_3',
        tournamentId: widget.tournamentId,
        roundNumber: 3,
        name: '決勝',
        matches: _getMatchesForRound(3),
      ),
    ];
  }

  List<MatchData> _getMatchesForRound(int roundNumber) {
    final matchCount = roundNumber == 1
        ? 8
        : roundNumber == 2
        ? 4
        : 1;
    return List.generate(matchCount, (index) {
      final tableNumber = index + 1;
      return MatchData(
        id: 'match_${roundNumber}_$index',
        tournamentId: widget.tournamentId,
        roundNumber: roundNumber,
        tableNumber: tableNumber,
        player1Id: 'participant_${index * 2}',
        player2Id: 'participant_${index * 2 + 1}',
        result: roundNumber == 1 && index < 4
            ? MatchResult.player1Win
            : MatchResult.pending,
        finishedAt: roundNumber == 1 && index < 4
            ? DateTime.now().subtract(Duration(minutes: 30 - index * 5))
            : null,
      );
    });
  }

  List<ParticipantData> _getParticipants() {
    return List.generate(16, (index) {
      return ParticipantData(
        id: 'participant_$index',
        name: '参加者${index + 1}',
        tournamentId: widget.tournamentId,
        registeredAt: DateTime.now().subtract(Duration(days: index)),
      );
    });
  }
}
