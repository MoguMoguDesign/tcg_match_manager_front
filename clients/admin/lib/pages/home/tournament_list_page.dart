import 'package:base_ui/base_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/layout/admin_scaffold.dart';
import '../../widgets/tournament/tournament_card.dart';
import '../dialogs/create_tournament_dialog.dart';

/// トーナメント一覧（ホーム）画面
///
/// Figmaデザイン: https://www.figma.com/design/A4NEf0vCuJNuPfBMTEa4OO/%E3%83%9E%E3%83%81%E3%82%B5%E3%83%9D?node-id=96-331&t=whDUBuHITxOChCST-4
class TournamentListPage extends StatefulWidget {
  /// トーナメント一覧画面のコンストラクタ
  const TournamentListPage({super.key});

  @override
  State<TournamentListPage> createState() => _TournamentListPageState();
}

class _TournamentListPageState extends State<TournamentListPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'トーナメント一覧',
      actions: [
        // 新規作成ボタン
        SizedBox(
          width: 140,
          child: CommonConfirmButton(
            text: '新規作成',
            style: ConfirmButtonStyle.adminFilled,
            onPressed: () => _showCreateTournamentDialog(context),
          ),
        ),
        const SizedBox(width: 16),
      ],
      body: Column(
        children: [
          // タブバー
          DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.borderLight,
                ),
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
                _buildTournamentList(_getUpcomingTournaments()),
                _buildTournamentList(_getOngoingTournaments()),
                _buildTournamentList(_getCompletedTournaments()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTournamentList(List<TournamentData> tournaments) {
    if (tournaments.isEmpty) {
      return const Center(
        child: Text(
          'トーナメントがありません',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.grayDark,
          ),
        ),
      );
    }

    // 開催中は専用の大型カードを表示
    if (tournaments.isNotEmpty &&
        tournaments.first.status == TournamentStatus.ongoing) {
      final tournament = tournaments.first;
      return ColoredBox(
        color: AppColors.grayLight,
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
        color: AppColors.grayLight,
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
                                  context.go('/tournament/${tournaments[i + 4].id}');
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
      color: AppColors.grayLight,
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
                                context.go('/tournament/${tournaments[i + 4].id}');
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
    return Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [
            AppColors.textBlack,
            AppColors.adminPrimary,
          ],
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
            child: Row(
              children: [
                // 左側：情報
                Expanded(
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
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // 日付と参加者数とカテゴリ
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            tournament.date,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(width: 20),
                          const Icon(
                            Icons.people,
                            size: 16,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${tournament.participants}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          if (tournament.gameType != null) ...[
                            const SizedBox(width: 20),
                            Text(
                              tournament.gameType!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // 右側：ボタン
                ElevatedButton(
                  onPressed: () {
                    context.go('/tournament/${tournament.id}');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.textBlack,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '対戦表を開く',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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

          // 「対戦表を開く」のアンダーライン
          Positioned(
            bottom: 10,
            left: 28,
            child: Text(
              '対戦表を開く',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.6),
                decoration: TextDecoration.underline,
                decorationColor: Colors.white.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showCreateTournamentDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) => const CreateTournamentDialog(),
    );
  }

  // ダミーデータ生成メソッド
  List<TournamentData> _getOngoingTournaments() {
    return [
      const TournamentData(
        id: '1',
        title: 'トーナメントタイトル',
        date: '2025/08/31',
        participants: 32,
        status: TournamentStatus.ongoing,
        round: 'ラウンド3',
        gameType: 'ポケカ',
      ),
    ];
  }

  List<TournamentData> _getUpcomingTournaments() {
    return List.generate(6, (index) {
      return TournamentData(
        id: 'upcoming_$index',
        title: 'トーナメントタイトル',
        date: '2025/08/31',
        participants: 32,
        status: TournamentStatus.upcoming,
        gameType: 'ポケカ',
      );
    });
  }

  List<TournamentData> _getCompletedTournaments() {
    return List.generate(8, (index) {
      return TournamentData(
        id: 'completed_$index',
        title: 'トーナメントタイトル',
        date: '2025/08/31',
        participants: 32,
        status: TournamentStatus.completed,
        gameType: 'ポケカ',
      );
    });
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
