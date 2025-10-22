import 'dart:async';

import 'package:base_ui/base_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/layout/admin_scaffold.dart';
import '../../widgets/tournament/tournament_card.dart';
import '../dialogs/create_tournament_dialog.dart';

/// トーナメント一覧（ホーム）画面
///
/// Figmaデザイン: https://www.figma.com/design/A4NEf0vCuJNuPfBMTEa4OO/%E3%83%9E%E3%83%81%E3%82%B5%E3%83%9D?node-id=96-331&t=whDUBuHITxOChCST-4
class TournamentListPage extends ConsumerStatefulWidget {
  /// トーナメント一覧画面のコンストラクタ
  const TournamentListPage({super.key});

  @override
  ConsumerState<TournamentListPage> createState() => _TournamentListPageState();
}

class _TournamentListPageState extends ConsumerState<TournamentListPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // 初期化時にトーナメント一覧を読み込む
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(
        ref.read(tournamentListNotifierProvider.notifier).loadTournaments(),
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
    final tournamentListData = ref.watch(tournamentListNotifierProvider);

    return AdminScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100),
        child: Column(
          children: [
            // タイトルと新規作成ボタンのセクション
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: const BoxDecoration(color: AppColors.white),
              child: Row(
                children: [
                  const Text(
                    'トーナメント一覧',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 192,
                    height: 56,
                    child: CommonConfirmButton(
                      text: '大会作成',
                      style: ConfirmButtonStyle.adminFilled,
                      onPressed: () => _showCreateTournamentDialog(context),
                    ),
                  ),
                ],
              ),
            ),
            // タブバー
            DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.white,
                border: Border(
                  bottom: BorderSide(color: AppColors.borderLight),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 64),
                child: SizedBox(
                  width: double.infinity,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: AppColors.adminPrimary,
                    unselectedLabelColor: AppColors.gray,
                    indicatorColor: AppColors.adminPrimary,
                    indicatorWeight: 3,
                    labelStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: const [
                      Tab(text: '開催前'),
                      Tab(text: '開催中'),
                      Tab(text: '開催後'),
                    ],
                  ),
                ),
              ),
            ),
            // タブビュー
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTournamentList(
                    tournamentListData,
                    TournamentStatus.upcoming,
                  ),
                  _buildTournamentList(
                    tournamentListData,
                    TournamentStatus.ongoing,
                  ),
                  _buildTournamentList(
                    tournamentListData,
                    TournamentStatus.completed,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTournamentList(
    TournamentListData tournamentListData,
    TournamentStatus statusFilter,
  ) {
    // ローディング状態
    if (tournamentListData.state == TournamentListState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    // エラー状態
    if (tournamentListData.state == TournamentListState.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'エラーが発生しました',
              style: TextStyle(fontSize: 16, color: AppColors.grayDark),
            ),
            if (tournamentListData.errorMessage != null)
              Text(
                tournamentListData.errorMessage!,
                style: const TextStyle(fontSize: 14, color: AppColors.grayDark),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                unawaited(
                  ref
                      .read(tournamentListNotifierProvider.notifier)
                      .refreshTournaments(),
                );
              },
              child: const Text('再試行'),
            ),
          ],
        ),
      );
    }

    // Domain層のTournamentをUI用のTournamentDataに変換
    final tournaments = tournamentListData.tournaments
        .map(_convertToTournamentData)
        .where((tournament) => tournament.status == statusFilter)
        .toList();

    if (tournaments.isEmpty) {
      return const Center(
        child: Text(
          'トーナメントがありません',
          style: TextStyle(fontSize: 16, color: AppColors.grayDark),
        ),
      );
    }

    // 開催中は専用の大型カードを表示
    if (tournaments.isNotEmpty &&
        tournaments.first.status == TournamentStatus.ongoing) {
      final tournament = tournaments.first;
      return ColoredBox(
        color: AppColors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 24),
          child: Align(
            alignment: Alignment.topCenter,
            child: _buildOngoingTournamentCard(tournament),
          ),
        ),
      );
    }

    // 開催前は特別なレイアウト（1行目4個、2行目2個）
    if (tournaments.isNotEmpty &&
        tournaments.first.status == TournamentStatus.upcoming) {
      return ColoredBox(
        color: AppColors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 24),
          child: Column(
            children: [
              // 1行目：4個のカード
              if (tournaments.isNotEmpty)
                Row(
                  children: [
                    for (int i = 0; i < 4 && i < tournaments.length; i++) ...[
                      Expanded(
                        child: TournamentCard(
                          tournament: tournaments[i],
                          onTap: () async {
                            context.go('/tournament/${tournaments[i].id}');
                          },
                        ),
                      ),
                      if (i < 3 && i < tournaments.length - 1)
                        const SizedBox(width: 16),
                    ],
                  ],
                ),
              const SizedBox(height: 16),

              // 2行目：残りのカード（最大4個、実際のカード数に応じて表示）
              if (tournaments.length > 4)
                Row(
                  children: [
                    for (int i = 0; i < 4; i++) ...[
                      Expanded(
                        child: (i + 4 < tournaments.length)
                            ? TournamentCard(
                                tournament: tournaments[i + 4],
                                onTap: () {
                                  context.go(
                                    '/tournament/${tournaments[i + 4].id}',
                                  );
                                },
                              )
                            : const SizedBox(),
                      ),
                      if (i < 3) const SizedBox(width: 16),
                    ],
                  ],
                ),
            ],
          ),
        ),
      );
    }

    // その他（開催後）は開催前と同じレイアウト（1行目4個、2行目2個）
    return ColoredBox(
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 24),
        child: Column(
          children: [
            // 1行目：4個のカード
            if (tournaments.isNotEmpty)
              Row(
                children: [
                  for (int i = 0; i < 4 && i < tournaments.length; i++) ...[
                    Expanded(
                      child: TournamentCard(
                        tournament: tournaments[i],
                        onTap: () {
                          context.go('/tournament/${tournaments[i].id}');
                        },
                      ),
                    ),
                    if (i < 3 && i < tournaments.length - 1)
                      const SizedBox(width: 16),
                  ],
                ],
              ),
            const SizedBox(height: 16),

            // 2行目：残りのカード（最大4個、実際のカード数に応じて表示）
            if (tournaments.length > 4)
              Row(
                children: [
                  for (int i = 0; i < 4; i++) ...[
                    Expanded(
                      child: (i + 4 < tournaments.length)
                          ? TournamentCard(
                              tournament: tournaments[i + 4],
                              onTap: () {
                                context.go(
                                  '/tournament/${tournaments[i + 4].id}',
                                );
                              },
                            )
                          : const SizedBox(),
                    ),
                    if (i < 3) const SizedBox(width: 16),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }

  // 開催中トーナメント専用カード
  Widget _buildOngoingTournamentCard(TournamentData tournament) {
    return InkWell(
      onTap: () {
        context.go('/tournament/${tournament.id}');
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [AppColors.textBlack, AppColors.adminPrimary],
          ),
        ),
        child: Stack(
          children: [
            // 下部の黄色い波線
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 6,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  color: AppColors.warning,
                ),
              ),
            ),

            // メインコンテンツ
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // タイトル
                  Text(
                    tournament.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 日付と参加者数とカテゴリ
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: AppColors.white70,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        tournament.date,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.white70,
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Icon(
                        Icons.people,
                        size: 16,
                        color: AppColors.white70,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${tournament.participants}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.white70,
                        ),
                      ),
                      if (tournament.gameType != null) ...[
                        const SizedBox(width: 20),
                        Text(
                          tournament.gameType!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.white70,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // ラウンドラベル
            if (tournament.round != null)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 5,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.userPrimary,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    tournament.round!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCreateTournamentDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) => const CreateTournamentDialog(),
    );

    // ダイアログが閉じられた後、トーナメント一覧を更新
    unawaited(
      ref.read(tournamentListNotifierProvider.notifier).refreshTournaments(),
    );
  }

  // Domain層のTournamentをUI用のTournamentDataに変換
  TournamentData _convertToTournamentData(Tournament tournament) {
    // 日付文字列をパース（ISO 8601形式からYYYY/MM/DD形式に変換）
    String formatDate(String isoDate) {
      try {
        final dateTime = DateTime.parse(isoDate);
        return '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}';
      } on FormatException {
        return isoDate; // パースに失敗した場合はそのまま返す
      }
    }

    // Domain層のstatusフィールドを基準にステータスを決定
    final status = switch (tournament.status) {
      'PREPARING' => TournamentStatus.upcoming,
      'IN_PROGRESS' => TournamentStatus.ongoing,
      'COMPLETED' => TournamentStatus.completed,
      _ => TournamentStatus.upcoming, // デフォルトは開催前
    };

    return TournamentData(
      id: tournament.id,
      title: tournament.title,
      date: tournament.startDate != null
          ? formatDate(tournament.startDate!)
          : '日付未設定',
      // プレイヤー数は今後実装予定
      participants: 0,
      status: status,
      // 実際のラウンド情報は今後取得予定
      round: status == TournamentStatus.ongoing ? 'ラウンド1' : null,
      // ゲーム種別は今後取得予定
      gameType: 'ポケカ',
    );
  }
}

/// トーナメントデータクラス
class TournamentData {
  /// トーナメントデータのコンストラクタ
  const TournamentData({
    required this.id,
    required this.title,
    required this.date,
    required this.participants,
    required this.status,
    this.round,
    this.gameType,
  });

  /// トーナメントID
  final String id;

  /// タイトル
  final String title;

  /// 開催日
  final String date;

  /// 参加者数
  final int participants;

  /// ステータス
  final TournamentStatus status;

  /// ラウンド（開催中のみ）
  final String? round;

  /// ゲーム種別
  final String? gameType;
}

/// トーナメントステータス
enum TournamentStatus {
  /// 開催中
  ongoing,

  /// 開催前
  upcoming,

  /// 開催済
  completed,
}

/// 参加者データクラス
class ParticipantData {
  /// 参加者データのコンストラクタ
  const ParticipantData({
    required this.id,
    required this.name,
    required this.tournamentId,
    this.isDeleted = false,
    this.registeredAt,
  });

  /// 参加者ID
  final String id;

  /// 参加者名
  final String name;

  /// 所属トーナメントID
  final String tournamentId;

  /// 削除フラグ
  final bool isDeleted;

  /// 登録日時
  final DateTime? registeredAt;
}

/// 対戦結果
enum MatchResult {
  /// 未確定
  pending,

  /// プレイヤー1勝利
  player1Win,

  /// プレイヤー2勝利
  player2Win,

  /// 引き分け（両者敗北）
  draw,
}

/// 対戦データクラス
class MatchData {
  /// 対戦データのコンストラクタ
  const MatchData({
    required this.id,
    required this.tournamentId,
    required this.roundNumber,
    required this.tableNumber,
    this.player1Id,
    this.player2Id,
    this.result = MatchResult.pending,
    this.finishedAt,
  });

  /// 対戦ID
  final String id;

  /// 所属トーナメントID
  final String tournamentId;

  /// ラウンド番号
  final int roundNumber;

  /// テーブル番号
  final int tableNumber;

  /// プレイヤー1ID
  final String? player1Id;

  /// プレイヤー2ID
  final String? player2Id;

  /// 対戦結果
  final MatchResult result;

  /// 終了日時
  final DateTime? finishedAt;
}

/// ラウンドデータクラス
class RoundData {
  /// ラウンドデータのコンストラクタ
  const RoundData({
    required this.id,
    required this.tournamentId,
    required this.roundNumber,
    required this.name,
    required this.matches,
    this.isCompleted = false,
    this.startedAt,
    this.finishedAt,
  });

  /// ラウンドID
  final String id;

  /// 所属トーナメントID
  final String tournamentId;

  /// ラウンド番号
  final int roundNumber;

  /// ラウンド名
  final String name;

  /// このラウンドの対戦リスト
  final List<MatchData> matches;

  /// 完了フラグ
  final bool isCompleted;

  /// 開始日時
  final DateTime? startedAt;

  /// 終了日時
  final DateTime? finishedAt;
}
