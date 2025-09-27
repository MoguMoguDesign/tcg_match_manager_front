import 'package:base_ui/base_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/tournament_display_data.dart';
import '../../widgets/layout/admin_scaffold.dart';
import '../../widgets/tournament/tournament_back_button.dart';
import '../../widgets/tournament/tournament_header_card.dart';

/// 最終順位画面（大会結果）
///
/// Figmaデザイン: https://www.figma.com/design/A4NEf0vCuJNuPfBMTEa4OO/%E3%83%9E%E3%83%81%E3%82%B5%E3%83%9D?node-id=550-5795&t=3LcouErPKHmLq3zh-4
class AdminFinalRankingPage extends StatefulWidget {
  /// 最終順位画面のコンストラクタ
  const AdminFinalRankingPage({super.key, required this.tournamentId});

  /// トーナメント ID
  final String tournamentId;

  @override
  State<AdminFinalRankingPage> createState() => _AdminFinalRankingPageState();
}

class _AdminFinalRankingPageState extends State<AdminFinalRankingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.index = 3; // 大会結果タブを選択
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tournament = _getTournamentDisplayData(widget.tournamentId);
    final rankings = _getRankingData();

    return AdminScaffold(
      title: '',
      actions: const [],
      body: Column(
        children: [
          // ヘッダー（戻る + トーナメントカード）
          Container(
            padding: const EdgeInsets.fromLTRB(40, 16, 40, 16),
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              children: [
                // 戻るボタン
                const TournamentBackButton(),
                const SizedBox(width: 24),
                // トーナメントカード（横に配置）
                Expanded(
                  child: TournamentHeaderCard(tournament: tournament),
                ),
              ],
            ),
          ),

          // タブバー
          DecoratedBox(
            decoration: const BoxDecoration(color: Colors.white),
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
                onTap: (index) {
                  // 他のタブが選択されたら適切な画面に遷移
                  switch (index) {
                    case 0:
                      context.go('/tournament/${widget.tournamentId}');
                    case 1:
                      context.go('/tournament/${widget.tournamentId}/participants');
                    case 2:
                      context.go('/tournament/${widget.tournamentId}/matches');
                    case 3:
                      // 現在の画面なので何もしない
                  }
                },
                tabs: const [
                  Tab(text: '大会概要'),
                  Tab(text: '参加者一覧'),
                  Tab(text: '対戦表'),
                  Tab(text: '大会結果'),
                ],
              ),
            ),
          ),

          // 大会結果コンテンツ
          Expanded(
            child: ColoredBox(
              color: AppColors.grayLight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 64,
                  vertical: 24,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F3FF), // admin-card color
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // ランキングリスト
                      Expanded(
                        child: ListView.builder(
                          itemCount: rankings.length,
                          itemBuilder: (context, index) {
                            final ranking = rankings[index];
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.withValues(alpha: 0.3),
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  // 順位
                                  SizedBox(
                                    width: 50,
                                    child: Text(
                                      '${ranking.rank}位',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textBlack,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // プレイヤー情報
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // プレイヤー名
                                        Text(
                                          ranking.playerName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textBlack,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        // 累計得点とOMW%
                                        Text(
                                          '累計得点 ${ranking.totalPoints}点 '
                                          'OMW% ${ranking.omwPercentage}%',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: AppColors.textBlack,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TournamentDisplayData _getTournamentDisplayData(String id) {
    // ダミーデータ（開催後の例）
    return const TournamentDisplayData(
      id: '1',
      title: 'トーナメントタイトル',
      description: '200文字の大会概要',
      date: '2025/08/31',
      time: '19:00-21:00',
      currentParticipants: 32,
      maxParticipants: 32,
      gameType: 'ポケカ',
      status: TournamentStatus.completed, // 開催後
      currentRound: 3, // 最終ラウンド
    );
  }

  List<PlayerRanking> _getRankingData() {
    // ダミーデータ（複数の1位タイを含む）
    return List.generate(12, (index) {
      return const PlayerRanking(
        rank: 1, // Figmaデザインでは全て1位として表示
        playerName: 'プレイヤー名1',
        totalPoints: 12,
        omwPercentage: 50,
      );
    });
  }
}

/// プレイヤーランキングデータクラス
class PlayerRanking {
  /// プレイヤーランキングのコンストラクタ
  const PlayerRanking({
    required this.rank,
    required this.playerName,
    required this.totalPoints,
    required this.omwPercentage,
  });

  /// 順位
  final int rank;

  /// プレイヤー名
  final String playerName;

  /// 累計得点
  final int totalPoints;

  /// OMW%
  final int omwPercentage;
}
