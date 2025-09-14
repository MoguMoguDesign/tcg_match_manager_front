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
        ElevatedButton.icon(
          onPressed: () => _showCreateTournamentDialog(context),
          icon: const Icon(Icons.add),
          label: const Text('新規作成'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3A44FB),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
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
                  color: Color(0xFFE0E0E0),
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF000336),
              unselectedLabelColor: const Color(0xFF7A7A83),
              indicatorColor: const Color(0xFF3A44FB),
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
              tabs: const [
                Tab(text: '開催中'),
                Tab(text: '開催前'),
                Tab(text: '開催済'),
              ],
            ),
          ),
          
          // タブビュー
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTournamentList(_getOngoingTournaments()),
                _buildTournamentList(_getUpcomingTournaments()),
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
            color: Color(0xFF7A7A83),
          ),
        ),
      );
    }

    return ColoredBox(
      color: const Color(0xFFF5F5F5),
      child: GridView.builder(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: 1.5,
        ),
        itemCount: tournaments.length,
        itemBuilder: (context, index) {
          final tournament = tournaments[index];
          return TournamentCard(
            tournament: tournament,
            onTap: () async {
              await context.pushNamed(
                'tournament-detail',
                pathParameters: {'id': tournament.id},
              );
            },
          );
        },
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
