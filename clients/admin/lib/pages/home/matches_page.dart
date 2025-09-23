import 'package:base_ui/base_ui.dart' as base_ui;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ヘッダー部分
            SliverToBoxAdapter(
              child: ColoredBox(
                color: Colors.white,
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
            SliverFillRemaining(
              child: _buildTabContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // ユーザー情報と戻るボタン
          Row(
            children: [
              // 戻るボタン
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: IconButton(
                  onPressed: context.pop,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  color: const Color(0xFF000336),
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                '戻る',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF000336),
                ),
              ),
              const Spacer(),
              // ユーザー情報
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.person, size: 20),
                    SizedBox(width: 8),
                    Text('ユーザー名'),
                    SizedBox(width: 8),
                    Icon(Icons.keyboard_arrow_down, size: 20),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // トーナメント情報
          _buildTournamentInfo(),
        ],
      ),
    );
  }

  Widget _buildTournamentInfo() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'トーナメントタイトル',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000336),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // 日付
              const Row(
                children: [
                  Icon(Icons.access_time, size: 18, color: Color(0xFF6B7280)),
                  SizedBox(width: 8),
                  Text(
                    '2025/08/31',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              // 参加者数
              const Row(
                children: [
                  Icon(Icons.person, size: 18, color: Color(0xFF6B7280)),
                  SizedBox(width: 8),
                  Text(
                    '32',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              // ゲームタイプ
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'ポケカ',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
              const Spacer(),
              // 現在のラウンド
              const Text(
                'ラウンド3',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF000336),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabNavigation() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildTabItem('大会概要', 0),
          _buildTabItem('参加者一覧', 1),
          _buildTabItem('対戦表', 2),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF000336) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF000336)
                  : const Color(0xFFE2E8F0),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF6B7280),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return const Center(child: Text('大会概要'));
      case 1:
        return const Center(child: Text('参加者一覧'));
      case 2:
        return MatchesContent(tournamentId: widget.tournamentId);
      default:
        return const SizedBox();
    }
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
  final int _currentRound = 1;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF8F9FA),
      child: CustomScrollView(
        slivers: [
          // 対戦表ヘッダー
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        '対戦表',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000336),
                        ),
                      ),
                      const Spacer(),
                      // 右側のアクションボタン
                      Row(
                        children: [
                          SizedBox(
                            width: 192,
                            height: 56,
                            child: base_ui.CommonConfirmButton(
                              text: 'ラウンド取り消し',
                              style: base_ui.ConfirmButtonStyle.alertOutlined,
                              onPressed: _showCancelRoundDialog,
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(
                            width: 192,
                            height: 56,
                            child: base_ui.CommonConfirmButton(
                              text: 'ラウンドを進める',
                              style: base_ui.ConfirmButtonStyle.adminFilled,
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
                      base_ui.CommonSmallButton(
                        text: '前のラウンド',
                        style:
                            base_ui.SmallButtonStyle.adminOutlinedWithArrowLeft,
                        isEnabled: _currentRound > 1,
                        onPressed: _gotoPreviousRound,
                      ),
                      const Spacer(),
                      base_ui.CommonSmallButton(
                        text: '次のラウンド',
                        style:
                            base_ui.SmallButtonStyle
                                .adminOutlinedWithArrowRight,
                        isEnabled: _currentRound < _getRounds().length,
                        onPressed: _gotoNextRound,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // 対戦リスト
          SliverToBoxAdapter(
            child: _buildMatchesList(),
          ),
          // フッター
          SliverToBoxAdapter(
            child: _buildFooter(),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchesList() {
    final currentRoundData = _getRounds().firstWhere(
      (round) => round.roundNumber == _currentRound,
    );
    final matches = currentRoundData.matches;

    if (matches.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: const Center(
          child: Text(
            '対戦がありません',
            style: TextStyle(fontSize: 16, color: Color(0xFF7A7A83)),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
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
              color: Color(0xFF000336),
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
          child: base_ui.CommonSmallButton(
            text: '両者敗北',
            style: base_ui.SmallButtonStyle.whiteOutlined,
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
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF000336),
            ),
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
                color: isWin
                    ? const Color(0xFF22C55E)
                    : const Color(0xFF9CA3AF),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '勝利',
                style: TextStyle(
                  fontSize: 14,
                  color: isWin
                      ? const Color(0xFF22C55E)
                      : const Color(0xFF6B7280),
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
                color: isLose
                    ? const Color(0xFFEF4444)
                    : const Color(0xFF9CA3AF),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '敗北',
                style: TextStyle(
                  fontSize: 14,
                  color: isLose
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF6B7280),
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
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // 最大人数表示を右上に配置
          const Row(
            children: [
              Spacer(),
              Text(
                '最大人数: 32人',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 変更を反映ボタンを中央に配置
          Center(
            child: SizedBox(
              width: 192,
              height: 56,
              child: base_ui.CommonConfirmButton(
                text: '変更を反映',
                style: base_ui.ConfirmButtonStyle.adminFilled,
                onPressed: _confirmResults,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmResults() async {
    final confirmed = await base_ui.ConfirmDialog.show(
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
          backgroundColor: Color(0xFF38A169),
        ),
      );
    }
  }

  Future<void> _setBothPlayersLose(AdminMatchData match) async {
    final confirmed = await base_ui.ConfirmDialog.show(
      context,
      title: '両者敗北にしますか？',
      confirmText: '両者敗北',
      confirmButtonStyle: base_ui.DialogButtonStyle.admin,
    );
    if (!mounted) {
      return;
    }
    if (confirmed ?? false) {
      // TODO(admin): 実際の両者敗北処理を実装
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('両者敗北に設定しました'),
          backgroundColor: Color(0xFF38A169),
        ),
      );
    }
  }

  void _gotoPreviousRound() {
    // TODO(admin): 実際の前のラウンド移動処理を実装
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('前のラウンドに移動しました'),
        backgroundColor: Color(0xFF38A169),
      ),
    );
  }

  void _gotoNextRound() {
    // TODO(admin): 実際の次のラウンド移動処理を実装
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('次のラウンドに移動しました'),
        backgroundColor: Color(0xFF38A169),
      ),
    );
  }

  Future<void> _showCancelRoundDialog() async {
    final confirmed = await base_ui.ConfirmDialog.show(
      context,
      title: 'ラウンド取り消し',
      message: '現在のラウンドを取り消しますか？\nこの操作は元に戻すことができません。',
      confirmText: '取り消し',
      confirmButtonStyle: base_ui.DialogButtonStyle.alert,
    );
    if (!mounted) {
      return;
    }
    if (confirmed ?? false) {
      // TODO(admin): 実際のラウンド取り消し処理を実装
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ラウンドを取り消しました'),
          backgroundColor: Color(0xFF38A169),
        ),
      );
    }
  }

  Future<void> _showAdvanceRoundDialog() async {
    final confirmed = await base_ui.ConfirmDialog.show(
      context,
      title: 'ラウンドを進める',
      message: '次のラウンドに進めますか？\n現在の結果が確定されます。',
      confirmText: '進める',
      confirmButtonStyle: base_ui.DialogButtonStyle.admin,
    );
    if (!mounted) {
      return;
    }
    if (confirmed ?? false) {
      // TODO(admin): 実際のラウンド進行処理を実装
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('次のラウンドに進めました'),
          backgroundColor: Color(0xFF38A169),
        ),
      );
    }
  }


  void _updateMatchResult(AdminMatchData match, AdminMatchResult result) {
    // TODO(admin): 実際の結果更新処理を実装
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('結果を更新しました'),
        backgroundColor: Color(0xFF38A169),
      ),
    );
    setState(() {});
  }


  String _getParticipantName(String? participantId) {
    if (participantId == null) {
      return '不戦勝';
    }
    final participants = _getParticipants();
    final participant =
        participants.where((p) => p.id == participantId).firstOrNull;
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
        startedAt: DateTime.now().subtract(const Duration(hours: 2)),
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
        name: '決勝',
        matches: _getMatchesForRound(3),
      ),
    ];
  }

  List<AdminMatchData> _getMatchesForRound(int roundNumber) {
    final matchCount = roundNumber == 1
        ? 8
        : roundNumber == 2
            ? 4
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
            ? DateTime.now().subtract(Duration(minutes: 30 - index * 5))
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
        registeredAt: DateTime.now().subtract(Duration(days: index)),
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
