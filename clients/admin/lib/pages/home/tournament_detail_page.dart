import 'dart:async';

import 'package:base_ui/base_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/tournament_display_data.dart';
import '../../widgets/layout/admin_scaffold.dart';
import '../../widgets/ranking/final_ranking_content.dart';
import '../../widgets/tournament/tournament_back_button.dart';
import '../../widgets/tournament/tournament_header_card.dart';
import '../dialogs/edit_tournament_dialog.dart';
import 'matches_page.dart';
import 'participants_page.dart';

/// トーナメント詳細画面。
///
/// Figma デザイン: https://www.figma.com/design/A4NEf0vCuJNuPfBMTEa4OO/%E3%83%9E%E3%83%81%E3%82%B5%E3%83%9D?node-id=512-13828&t=whDUBuHITxOChCST-4。
class TournamentDetailPage extends ConsumerStatefulWidget {
  /// トーナメント詳細画面のコンストラクタ
  const TournamentDetailPage({required this.tournamentId, super.key});

  /// トーナメントID
  final String tournamentId;

  @override
  ConsumerState<TournamentDetailPage> createState() =>
      _TournamentDetailPageState();
}

class _TournamentDetailPageState extends ConsumerState<TournamentDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentRound = 0; // ラウンド状態を管理

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Firestore からトーナメントデータを読み込み
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(
        ref
            .read(tournamentDetailNotifierProvider.notifier)
            .loadTournament(widget.tournamentId),
      );
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TournamentDetailNotifier からデータを取得
    final tournamentDetailState = ref.watch(tournamentDetailNotifierProvider);

    // ローディング中の表示
    if (tournamentDetailState.state == TournamentDetailState.loading) {
      return const AdminScaffold(
        title: '',
        actions: [],
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // エラー時の表示
    if (tournamentDetailState.state == TournamentDetailState.error) {
      return AdminScaffold(
        title: '',
        actions: const [],
        body: Center(
          child: Text('エラー: ${tournamentDetailState.errorMessage ?? "不明なエラー"}'),
        ),
      );
    }

    // データがない場合
    if (tournamentDetailState.tournament == null) {
      return const AdminScaffold(
        title: '',
        actions: [],
        body: Center(child: Text('データがありません')),
      );
    }

    // Tournament から TournamentDisplayData に変換
    final tournamentModel = tournamentDetailState.tournament!;
    final tournament = _convertToDisplayData(tournamentModel);

    return AdminScaffold(
      title: '',
      actions: const [],
      body: Column(
        children: [
          // ヘッダー（戻る + トーナメントカード + ラウンド進行ボタン）
          Container(
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
          ),

          // タブバー
          DecoratedBox(
            decoration: const BoxDecoration(color: AppColors.white),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TabBar(
                controller: _tabController,
                labelColor: AppColors.adminPrimary,
                unselectedLabelColor: AppColors.gray,
                indicatorColor: AppColors.adminPrimary,
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: const TextStyle(fontSize: 20),
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(text: '大会概要'),
                  Tab(text: '参加者一覧'),
                  Tab(text: '対戦表'),
                  Tab(text: '大会結果'),
                ],
              ),
            ),
          ),

          // タブビュー
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 大会概要タブ
                _buildOverviewTab(_getTournamentData(tournamentModel)),
                // 参加者一覧タブ
                ParticipantsContent(tournamentId: widget.tournamentId),
                // 対戦表タブ
                MatchesContent(
                  tournamentId: widget.tournamentId,
                  currentRound: _currentRound,
                  onRoundChanged: (newRound) {
                    setState(() {
                      _currentRound = newRound;
                    });
                  },
                  onTabSwitch: (tabIndex) {
                    _tabController.animateTo(tabIndex);
                  },
                ),
                // 大会結果タブ
                _buildFinalRankingTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 大会編集ダイアログを表示
  Future<void> _showEditTournamentDialog() async {
    if (!mounted) {
      return;
    }

    // 現在表示中のトーナメントデータを取得
    final tournamentDetailState = ref.read(tournamentDetailNotifierProvider);

    // データが取得できていない場合はエラーメッセージを表示
    if (tournamentDetailState.tournament == null) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('トーナメントデータの取得に失敗しました'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Tournament を TournamentDetailData に変換
    final tournament = _getTournamentData(tournamentDetailState.tournament!);

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

  Widget _buildOverviewTab(TournamentDetailData tournament) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(height: 16),
          // 大会の説明
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 80),
            decoration: BoxDecoration(
              color: AppColors.backgroundBlue,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '大会の説明',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textBlack,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tournament.description.isNotEmpty
                      ? tournament.description
                      : '-',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textBlack,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 情報カード: 大会カテゴリ / 開催日 / 参加者上限 / 最大ラウンド / 引き分け処理
          IntrinsicHeight(
            child: Row(
              children: [
                // 大会カテゴリ
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.adminPrimary.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '大会カテゴリ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textBlack,
                          ),
                        ),
                        const SizedBox(height: 9),
                        Text(
                          tournament.category,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // 開催日
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.adminPrimary.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '開催日',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textBlack,
                          ),
                        ),
                        const SizedBox(height: 9),
                        Text(
                          tournament.date,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textBlack,
                          ),
                        ),
                        Text(
                          tournament.time,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // 参加者上限
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.adminPrimary.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '参加者上限',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textBlack,
                          ),
                        ),
                        const SizedBox(height: 9),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.person,
                              size: 20,
                              color: AppColors.textBlack,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              '${tournament.maxParticipants}',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textBlack,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '人',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textBlack,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // 最大ラウンド
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.adminPrimary.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '最大ラウンド',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textBlack,
                          ),
                        ),
                        const SizedBox(height: 9),
                        Text(
                          tournament.maxRounds.contains('なるまで')
                              ? '勝者が一人に\nなるまで'
                              : tournament.maxRounds,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textBlack,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // 引き分け処理
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.adminPrimary.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '引き分け処理',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textBlack,
                          ),
                        ),
                        const SizedBox(height: 9),
                        Text(
                          tournament.drawHandling,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 備考
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 80),
            decoration: BoxDecoration(
              color: AppColors.adminPrimary.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '備考',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textBlack,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tournament.remarks.isNotEmpty ? tournament.remarks : '-',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textBlack,
                    height: 1.5,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 右上のラウンドピル表示に統一したため、ステータス色/文言関数は不要になった。

  // 旧 UI の情報行は廃止した。

  // ヘッダー刷新に伴い、QR ダイアログ機能は削除した。

  /// Tournament モデルから TournamentDisplayData に変換する。
  TournamentDisplayData _convertToDisplayData(Tournament tournament) {
    // ステータスを変換
    TournamentStatus status;
    if (tournament.isCompleted) {
      status = TournamentStatus.completed;
    } else if (tournament.isStarted) {
      status = TournamentStatus.ongoing;
    } else {
      status = TournamentStatus.upcoming;
    }

    // 日付を ISO 8601 形式から YYYY/MM/DD 形式に変換
    var formattedDate = '';
    if (tournament.startDate != null) {
      try {
        final dateTime = DateTime.parse(tournament.startDate!);
        final month = dateTime.month.toString().padLeft(2, '0');
        final day = dateTime.day.toString().padLeft(2, '0');
        formattedDate = '${dateTime.year}/$month/$day';
      } on FormatException {
        formattedDate = tournament.startDate ?? '';
      }
    }

    // 時間を HH:mm-HH:mm 形式に変換
    final startTime = tournament.startTime ?? '';
    final endTime = tournament.endTime ?? '';
    final timeRange = '$startTime-$endTime';

    return TournamentDisplayData(
      id: tournament.id,
      title: tournament.title,
      description: tournament.description,
      date: formattedDate,
      time: timeRange,
      currentParticipants: tournament.expectedPlayers ?? 0,
      maxParticipants: tournament.expectedPlayers ?? 0,
      gameType: tournament.category ?? '',
      status: status,
      currentRound: tournament.currentRound > 0
          ? tournament.currentRound
          : null,
    );
  }

  /// Tournament モデルから TournamentDetailData に変換する。
  TournamentDetailData _getTournamentData(Tournament tournament) {
    // ステータスを変換
    TournamentStatus status;
    if (tournament.isCompleted) {
      status = TournamentStatus.completed;
    } else if (tournament.isStarted) {
      status = TournamentStatus.ongoing;
    } else {
      status = TournamentStatus.upcoming;
    }

    // 日付を ISO 8601 形式から YYYY/MM/DD 形式に変換
    var formattedDate = '';
    if (tournament.startDate != null) {
      try {
        final dateTime = DateTime.parse(tournament.startDate!);
        final month = dateTime.month.toString().padLeft(2, '0');
        final day = dateTime.day.toString().padLeft(2, '0');
        formattedDate = '${dateTime.year}/$month/$day';
      } on FormatException {
        formattedDate = tournament.startDate ?? '';
      }
    }

    // 時間を HH:mm-HH:mm 形式に変換
    final startTime = tournament.startTime ?? '';
    final endTime = tournament.endTime ?? '';
    final timeRange = '$startTime-$endTime';

    // 最大ラウンド数を文字列に変換（tournamentMode に基づく）
    final maxRoundsStr = tournament.tournamentMode == 'ELIMINATION'
        ? '勝者が1人になるまで'
        : tournament.maxRounds != null
        ? '${tournament.maxRounds}ラウンド'
        : '勝者が1人になるまで';

    // 引き分け処理を文字列に変換（0点 = 両者敗北、1点 = 引き分け）
    final drawHandlingStr = tournament.drawPoints == 1 ? '引き分け' : '両者敗北';

    return TournamentDetailData(
      id: tournament.id,
      title: tournament.title,
      description: tournament.description ?? '',
      category: tournament.category ?? '',
      date: formattedDate,
      time: timeRange,
      maxParticipants: tournament.expectedPlayers ?? 0,
      currentParticipants: tournament.expectedPlayers ?? 0,
      maxRounds: maxRoundsStr,
      drawHandling: drawHandlingStr,
      remarks: tournament.remarks ?? '', // Firestoreのremarksフィールドを参照
      status: status,
      currentRound: tournament.currentRound > 0
          ? tournament.currentRound
          : null,
    );
  }
}

/// トーナメント詳細データクラス
class TournamentDetailData {
  /// トーナメント詳細データのコンストラクタ
  const TournamentDetailData({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.time,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.maxRounds,
    required this.drawHandling,
    required this.remarks,
    required this.status,
    this.currentRound,
  });

  /// ID
  final String id;

  /// タイトル
  final String title;

  /// 説明
  final String description;

  /// カテゴリ（例: "Pokemon Card", "スタンダード"）
  final String category;

  /// 日付
  final String date;

  /// 時間
  final String time;

  /// 最大参加者数
  final int maxParticipants;

  /// 現在の参加者数
  final int currentParticipants;

  /// 最大ラウンド
  final String maxRounds;

  /// 引き分け処理
  final String drawHandling;

  /// 備考
  final String remarks;

  /// ステータス
  final TournamentStatus status;

  /// 現在のラウンド（開催中のみ）
  final int? currentRound;
}

extension _TournamentDetailPageStateExtension on _TournamentDetailPageState {
  /// 大会結果タブの内容を構築
  Widget _buildFinalRankingTab() {
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
