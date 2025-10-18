import 'package:base_ui/base_ui.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/tournament_display_data.dart';
import '../../widgets/ranking/final_ranking_content.dart';
import '../../widgets/tournament/tournament_back_button.dart';
import '../../widgets/tournament/tournament_header_card.dart';
import '../../widgets/tournament/tournament_tab_navigation.dart';
import '../dialogs/edit_tournament_dialog.dart';
import 'tournament_detail_page.dart';

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
  int _selectedTabIndex = 2; // 対戦表タブを初期選択
  int _currentRound = 0; // ラウンド状態を親で管理

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ヘッダー部分
            SliverToBoxAdapter(
              child: ColoredBox(
                color: AppColors.white,
                child: Column(
                  children: [
                    // ユーザー情報とトーナメント情報
                    _buildHeader(),
                    // タブナビゲーション
                    _buildTabNavigation(),
                  ],
                ),
              ),
            ),
            // コンテンツ部分
            SliverFillRemaining(child: _buildTabContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    // ダミーデータ
    final tournament = _getTournamentDisplayData();

    return Container(
      padding: const EdgeInsets.fromLTRB(40, 16, 40, 16),
      decoration: const BoxDecoration(color: AppColors.white),
      child: Row(
        children: [
          // 戻るボタン
          const TournamentBackButton(),
          const SizedBox(width: 24),
          // トーナメントカード（横に配置）
          Expanded(child: TournamentHeaderCard(tournament: tournament)),
        ],
      ),
    );
  }

  Widget _buildTabNavigation() {
    return TournamentTabNavigation(
      selectedIndex: _selectedTabIndex,
      onTabSelected: (index) {
        // 他のタブが選択されたら適切な画面に遷移
        switch (index) {
          case 0:
            context.go('/tournament/${widget.tournamentId}');
          case 1:
            context.go('/tournament/${widget.tournamentId}/participants');
          case 2:
            // 現在の画面なので何もしない
            setState(() {
              _selectedTabIndex = index;
            });
          case 3:
            setState(() {
              _selectedTabIndex = index;
            });
        }
      },
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildOverviewContent();
      case 1:
        return _buildParticipantsContent();
      case 2:
        return MatchesContent(
          tournamentId: widget.tournamentId,
          currentRound: _currentRound,
          onRoundChanged: (newRound) {
            setState(() {
              _currentRound = newRound;
            });
          },
          onTabSwitch: (tabIndex) {
            setState(() {
              _selectedTabIndex = tabIndex;
            });
          },
        );
      case 3:
        return _buildFinalRankingContent();
      default:
        return const SizedBox();
    }
  }

  /// 大会概要タブの内容
  Widget _buildOverviewContent() {
    return ColoredBox(
      color: AppColors.backgroundLight,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // ヘッダー行（ラウンド状況カード + 編集ボタン）
            Row(
              children: [
                Expanded(child: _buildRoundStatusCard()),
                const SizedBox(width: 16),
                // 編集ボタン
                SizedBox(
                  width: 120,
                  height: 40,
                  child: CommonSmallButton(
                    text: '編集',
                    style: SmallButtonStyle.whiteOutlined,
                    onPressed: _showEditTournamentDialog,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Expanded(
              child: Center(
                child: Text(
                  '大会概要の内容がここに表示されます',
                  style: TextStyle(fontSize: 16, color: AppColors.textGray),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 参加者一覧タブの内容
  Widget _buildParticipantsContent() {
    return ColoredBox(
      color: AppColors.backgroundLight,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildRoundStatusCard(),
            const SizedBox(height: 24),
            const Expanded(
              child: Center(
                child: Text(
                  '参加者一覧の内容がここに表示されます',
                  style: TextStyle(fontSize: 16, color: AppColors.textGray),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 大会編集ダイアログを表示
  Future<void> _showEditTournamentDialog() async {
    if (!mounted) {
      return;
    }

    final displayData = _getTournamentDisplayData();

    // TournamentDisplayData を TournamentDetailData に変換
    final tournament = TournamentDetailData(
      id: displayData.id,
      title: displayData.title,
      description: displayData.description ?? '',
      category: 'Pokemon Card', // デフォルト値（実際にはAPIから取得すべき）
      date: displayData.date,
      time: displayData.time,
      maxParticipants: displayData.maxParticipants,
      currentParticipants: displayData.currentParticipants,
      maxRounds: '5ラウンド', // デフォルト値
      drawHandling: 'あり', // デフォルト値
      notes: '', // デフォルト値
      status: displayData.status,
      currentRound: displayData.currentRound,
    );

    if (!mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (context) => EditTournamentDialog(tournament: tournament),
    );
  }

  /// 現在のラウンド状況を表示するカード
  Widget _buildRoundStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderGray),
      ),
      child: Row(
        children: [
          const Icon(Icons.timeline, color: AppColors.adminPrimary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '現在の進行状況',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlack,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _currentRound == 0
                      ? '準備中 - トーナメント開始待ち'
                      : _currentRound == 4
                      ? '最終ラウンド完了 - 結果表示可能'
                      : 'ラウンド$_currentRound進行中',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _currentRound == 0
                        ? AppColors.textGray
                        : _currentRound == 4
                        ? AppColors.successActive
                        : AppColors.adminPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TournamentDisplayData _getTournamentDisplayData() {
    return const TournamentDisplayData(
      id: '1',
      title: 'トーナメントタイトル',
      date: '2025/08/31',
      time: '19:00-21:00',
      currentParticipants: 32,
      maxParticipants: 32,
      gameType: 'ポケカ',
      status: TournamentStatus.ongoing,
      currentRound: 3,
    );
  }

  /// 大会結果タブの内容を構築
  Widget _buildFinalRankingContent() {
    // ラウンド4完了後は最終順位を表示
    if (_currentRound >= 4) {
      return const FinalRankingContent();
    }

    // まだラウンド4に到達していない場合はプレースホルダーを表示
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 64,
            color: AppColors.textGray,
          ),
          SizedBox(height: 16),
          Text(
            '最終ラウンド完了後に結果が表示されます',
            style: TextStyle(fontSize: 16, color: AppColors.textGray),
          ),
        ],
      ),
    );
  }
}

/// 対戦表コンテンツ。
///
/// AdminScaffold を含まない、タブ内などで再利用するためのコンテンツ部分を提供する。
class MatchesContent extends StatefulWidget {
  /// 対戦表コンテンツのコンストラクタ。
  const MatchesContent({
    required this.tournamentId,
    required this.currentRound,
    required this.onRoundChanged,
    this.onTabSwitch,
    super.key,
  });

  /// トーナメント ID。
  final String tournamentId;

  /// 現在のラウンド番号。
  final int currentRound;

  /// ラウンド変更コールバック。
  final void Function(int newRound) onRoundChanged;

  /// タブ切り替えコールバック。
  final void Function(int tabIndex)? onTabSwitch;

  @override
  State<MatchesContent> createState() => _MatchesContentState();
}

class _MatchesContentState extends State<MatchesContent> {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.backgroundLight,
      child: CustomScrollView(
        slivers: [
          SliverList.list(
            children: [
              // 対戦表ヘッダー
              Container(
                color: AppColors.white,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // const Text(
                        //   '対戦表',
                        //   style: TextStyle(
                        //     fontSize: 24,
                        //     fontWeight: FontWeight.bold,
                        //     color: AppColors.textBlack,
                        //   ),
                        // ),
                        const Spacer(),
                        // 右側のアクションボタン
                        Row(
                          children: [
                            SizedBox(
                              width: 192,
                              height: 56,
                              child: CommonConfirmButton(
                                text: 'ラウンド取り消し',
                                style: ConfirmButtonStyle.alertOutlined,
                                onPressed: _showCancelRoundDialog,
                              ),
                            ),
                            const SizedBox(width: 16),
                            SizedBox(
                              width: 192,
                              height: 56,
                              child: CommonConfirmButton(
                                text: 'ラウンドを進める',
                                style: ConfirmButtonStyle.adminFilled,
                                onPressed: _showAdvanceRoundDialog,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // ナビゲーションボタン行
                    Row(
                      children: [
                        CommonSmallButton(
                          text: '前のラウンド',
                          style: SmallButtonStyle.adminOutlinedWithArrowLeft,
                          isEnabled: widget.currentRound > 0,
                          onPressed: _gotoPreviousRound,
                        ),
                        const Spacer(),
                        // 現在のラウンド表示
                        if (widget.currentRound > 0)
                          Text(
                            'ラウンド${widget.currentRound}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textBlack,
                            ),
                          )
                        else
                          const Text(
                            '準備中',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textGray,
                            ),
                          ),
                        const Spacer(),
                        CommonSmallButton(
                          text: widget.currentRound == 4 ? '最終順位を表示' : '次のラウンド',
                          style: widget.currentRound == 4
                              ? SmallButtonStyle.admin
                              : SmallButtonStyle.adminOutlinedWithArrowRight,
                          isEnabled:
                              widget.currentRound < _getRounds().length ||
                              widget.currentRound == 4,
                          onPressed: widget.currentRound == 4
                              ? _showFinalRanking
                              : _gotoNextRound,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // 対戦リスト
              _buildMatchesList(),
              // フッター
              _buildFooter(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMatchesList() {
    // 初期状態（currentRound = 0）では準備中メッセージを表示
    if (widget.currentRound == 0) {
      return Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderGray),
        ),
        child: const Center(
          child: Text(
            '対戦表の準備中です。「次のラウンド」ボタンを押してください。',
            style: TextStyle(fontSize: 16, color: AppColors.grayDark),
          ),
        ),
      );
    }

    final rounds = _getRounds();
    final currentRoundData = rounds
        .where((round) => round.roundNumber == widget.currentRound)
        .firstOrNull;

    if (currentRoundData == null) {
      return Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderGray),
        ),
        child: const Center(
          child: Text(
            '対戦がありません',
            style: TextStyle(fontSize: 16, color: AppColors.grayDark),
          ),
        ),
      );
    }

    final matches = currentRoundData.matches;

    if (matches.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderGray),
        ),
        child: const Center(
          child: Text(
            '対戦がありません',
            style: TextStyle(fontSize: 16, color: AppColors.grayDark),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderGray),
      ),
      child: Column(
        children: [
          for (int index = 0; index < matches.length; index++) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildMatchItem(matches[index], index + 1),
            ),
            if (index < matches.length - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }

  Widget _buildMatchItem(AdminMatchData match, int matchNumber) {
    final player1Name = _getParticipantName(match.player1Id);
    final player2Name = _getParticipantName(match.player2Id);

    return Row(
      children: [
        // マッチ番号
        SizedBox(
          width: 32,
          child: Text(
            matchNumber.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack,
            ),
          ),
        ),
        const SizedBox(width: 16),
        // 対戦内容
        Expanded(
          child: Column(
            children: [
              // プレイヤー1
              _buildPlayerRow(
                player1Name,
                match.result == AdminMatchResult.player1Win,
                match.result == AdminMatchResult.player2Win,
                () => _updateMatchResult(match, AdminMatchResult.player1Win),
                () => _updateMatchResult(match, AdminMatchResult.player2Win),
              ),
              const SizedBox(height: 8),
              // プレイヤー2
              _buildPlayerRow(
                player2Name,
                match.result == AdminMatchResult.player2Win,
                match.result == AdminMatchResult.player1Win,
                () => _updateMatchResult(match, AdminMatchResult.player2Win),
                () => _updateMatchResult(match, AdminMatchResult.player1Win),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // 操作ボタン
        SizedBox(
          width: 160,
          height: 40,
          child: CommonSmallButton(
            text: '両者敗北',
            style: SmallButtonStyle.whiteOutlined,
            onPressed: () => _setBothPlayersLose(match),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerRow(
    String playerName,
    bool isWin,
    bool isLose,
    VoidCallback onWinTap,
    VoidCallback onLoseTap,
  ) {
    return Row(
      children: [
        // プレイヤー名
        Expanded(
          child: Text(
            playerName,
            style: const TextStyle(fontSize: 16, color: AppColors.textBlack),
          ),
        ),
        const SizedBox(width: 16),
        // 勝利ラジオボタン
        GestureDetector(
          onTap: onWinTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isWin
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isWin ? AppColors.successActive : AppColors.textDisabled,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '勝利',
                style: TextStyle(
                  fontSize: 14,
                  color: isWin ? AppColors.successActive : AppColors.textGray,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        // 敗北ラジオボタン
        GestureDetector(
          onTap: onLoseTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isLose
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isLose ? AppColors.error : AppColors.textDisabled,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '敗北',
                style: TextStyle(
                  fontSize: 14,
                  color: isLose ? AppColors.error : AppColors.textGray,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // 最大人数表示を右上に配置
          const Row(
            children: [
              Spacer(),
              Text(
                '最大人数: 32人',
                style: TextStyle(fontSize: 14, color: AppColors.textGray),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 変更を反映ボタンを中央に配置
          Center(
            child: SizedBox(
              width: 192,
              height: 56,
              child: CommonConfirmButton(
                text: '変更を反映',
                style: ConfirmButtonStyle.adminFilled,
                onPressed: _confirmResults,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmResults() async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: '結果確定',
      message: '現在の結果を確定しますか？',
      confirmText: '確定',
    );
    if (!mounted) {
      return;
    }
    if (confirmed ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('結果を確定しました'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Future<void> _setBothPlayersLose(AdminMatchData match) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: '両者敗北にしますか？',
      confirmText: '両者敗北',
      confirmButtonStyle: DialogButtonStyle.admin,
    );
    if (!mounted) {
      return;
    }
    if (confirmed ?? false) {
      // 実際の両者敗北処理を実装する必要があります
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('両者敗北に設定しました'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _gotoPreviousRound() {
    final newRound = widget.currentRound - 1;
    widget.onRoundChanged(newRound);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ラウンド$newRoundに移動しました'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _gotoNextRound() {
    final newRound = widget.currentRound + 1;
    widget.onRoundChanged(newRound);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ラウンド$newRoundに移動しました'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _showFinalRanking() {
    // 常にタブ内遷移を使用（コールバックは必ず提供されているはず）
    widget.onTabSwitch?.call(3); // 大会結果タブ（index: 3）に切り替え
  }

  Future<void> _showCancelRoundDialog() async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'ラウンド取り消し',
      message: '現在のラウンドを取り消しますか？\nこの操作は元に戻すことができません。',
      confirmText: '取り消し',
      confirmButtonStyle: DialogButtonStyle.alert,
    );
    if (!mounted) {
      return;
    }
    if (confirmed ?? false) {
      // 実際のラウンド取り消し処理を実装する必要があります
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ラウンドを取り消しました'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Future<void> _showAdvanceRoundDialog() async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'ラウンドを進める',
      message: '次のラウンドに進めますか？\n現在の結果が確定されます。',
      confirmText: '進める',
      confirmButtonStyle: DialogButtonStyle.admin,
    );
    if (!mounted) {
      return;
    }
    if (confirmed ?? false) {
      // 実際のラウンド進行処理を実装する必要があります
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('次のラウンドに進めました'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _updateMatchResult(AdminMatchData match, AdminMatchResult result) {
    // 実際の結果更新処理を実装する必要があります
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('結果を更新しました'),
        backgroundColor: AppColors.success,
      ),
    );
    setState(() {});
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

  // ダミーデータ生成メソッド
  List<AdminRoundData> _getRounds() {
    return [
      AdminRoundData(
        id: 'round_1',
        tournamentId: widget.tournamentId,
        roundNumber: 1,
        name: 'ラウンド1',
        matches: _getMatchesForRound(1),
        startedAt: clock.now().subtract(const Duration(hours: 2)),
      ),
      AdminRoundData(
        id: 'round_2',
        tournamentId: widget.tournamentId,
        roundNumber: 2,
        name: 'ラウンド2',
        matches: _getMatchesForRound(2),
      ),
      AdminRoundData(
        id: 'round_3',
        tournamentId: widget.tournamentId,
        roundNumber: 3,
        name: 'ラウンド3',
        matches: _getMatchesForRound(3),
      ),
      AdminRoundData(
        id: 'round_4',
        tournamentId: widget.tournamentId,
        roundNumber: 4,
        name: '決勝',
        matches: _getMatchesForRound(4),
      ),
    ];
  }

  List<AdminMatchData> _getMatchesForRound(int roundNumber) {
    final matchCount = roundNumber == 1
        ? 8
        : roundNumber == 2
        ? 4
        : roundNumber == 3
        ? 2
        : 1;
    return List.generate(matchCount, (index) {
      final tableNumber = index + 1;
      return AdminMatchData(
        id: 'match_${roundNumber}_$index',
        tournamentId: widget.tournamentId,
        roundNumber: roundNumber,
        tableNumber: tableNumber,
        player1Id: 'participant_${index * 2}',
        player2Id: 'participant_${index * 2 + 1}',
        result: roundNumber == 1 && index < 4
            ? AdminMatchResult.player1Win
            : AdminMatchResult.pending,
        finishedAt: roundNumber == 1 && index < 4
            ? clock.now().subtract(Duration(minutes: 30 - index * 5))
            : null,
      );
    });
  }

  List<AdminParticipantData> _getParticipants() {
    return List.generate(16, (index) {
      return AdminParticipantData(
        id: 'participant_$index',
        name: 'プレイヤー名${index + 1}',
        tournamentId: widget.tournamentId,
        registeredAt: clock.now().subtract(Duration(days: index)),
      );
    });
  }
}

/// 管理画面用の参加者データクラス。
class AdminParticipantData {
  /// 管理画面用の参加者データのコンストラクタ。
  const AdminParticipantData({
    required this.id,
    required this.name,
    required this.tournamentId,
    this.isDeleted = false,
    this.registeredAt,
  });

  /// 参加者 ID。
  final String id;

  /// 参加者名。
  final String name;

  /// 所属トーナメント ID。
  final String tournamentId;

  /// 削除フラグ。
  final bool isDeleted;

  /// 登録日時。
  final DateTime? registeredAt;
}

/// 管理画面用の対戦結果。
enum AdminMatchResult {
  /// 未確定。
  pending,

  /// プレイヤー1勝利。
  player1Win,

  /// プレイヤー2勝利。
  player2Win,

  /// 引き分け（両者敗北）。
  draw,
}

/// 管理画面用の対戦データクラス。
class AdminMatchData {
  /// 管理画面用の対戦データのコンストラクタ。
  const AdminMatchData({
    required this.id,
    required this.tournamentId,
    required this.roundNumber,
    required this.tableNumber,
    this.player1Id,
    this.player2Id,
    this.result = AdminMatchResult.pending,
    this.finishedAt,
  });

  /// 対戦 ID。
  final String id;

  /// 所属トーナメント ID。
  final String tournamentId;

  /// ラウンド番号。
  final int roundNumber;

  /// テーブル番号。
  final int tableNumber;

  /// プレイヤー1 ID。
  final String? player1Id;

  /// プレイヤー2 ID。
  final String? player2Id;

  /// 対戦結果。
  final AdminMatchResult result;

  /// 終了日時。
  final DateTime? finishedAt;
}

/// 管理画面用のラウンドデータクラス。
class AdminRoundData {
  /// 管理画面用のラウンドデータのコンストラクタ。
  const AdminRoundData({
    required this.id,
    required this.tournamentId,
    required this.roundNumber,
    required this.name,
    required this.matches,
    this.isCompleted = false,
    this.startedAt,
    this.finishedAt,
  });

  /// ラウンド ID。
  final String id;

  /// 所属トーナメント ID。
  final String tournamentId;

  /// ラウンド番号。
  final int roundNumber;

  /// ラウンド名。
  final String name;

  /// このラウンドの対戦リスト。
  final List<AdminMatchData> matches;

  /// 完了フラグ。
  final bool isCompleted;

  /// 開始日時。
  final DateTime? startedAt;

  /// 終了日時。
  final DateTime? finishedAt;
}
