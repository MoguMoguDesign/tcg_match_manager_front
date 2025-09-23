import 'package:base_ui/base_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/layout/admin_scaffold.dart';
import 'matches_page.dart';
import 'participants_page.dart';

/// トーナメント詳細画面。
///
/// Figma デザイン: https://www.figma.com/design/A4NEf0vCuJNuPfBMTEa4OO/%E3%83%9E%E3%83%81%E3%82%B5%E3%83%9D?node-id=512-13828&t=whDUBuHITxOChCST-4。
class TournamentDetailPage extends StatefulWidget {
  /// トーナメント詳細画面のコンストラクタ
  const TournamentDetailPage({required this.tournamentId, super.key});

  /// トーナメントID
  final String tournamentId;

  @override
  State<TournamentDetailPage> createState() => _TournamentDetailPageState();
}

class _TournamentDetailPageState extends State<TournamentDetailPage>
    with SingleTickerProviderStateMixin {
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
    // ダミーデータ
    final tournament = _getTournamentData(widget.tournamentId);

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
                TextButton.icon(
                  onPressed: () => context.pop(),
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 24,
                    color: AppColors.textBlack,
                  ),
                  label: const Text(
                    '戻る',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    foregroundColor: AppColors.textBlack,
                  ),
                ),
                const SizedBox(width: 24),
                // トーナメントカード（横に配置）
                Expanded(
                  child: Stack(
                    children: [
                      // メインカード
                      Container(
                        height: 101,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment(-0.8, -1),
                            end: Alignment(1, 0.6),
                            colors: [
                              AppColors.gradientDarkBlue,
                              AppColors.gradientBlack,
                              AppColors.userPrimary,
                            ],
                            stops: [0.0, 0.8, 1.0],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(58, 68, 251, 0.1),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // タイトル
                              Text(
                                tournament.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const SizedBox(height: 6),
                              // メタ情報行（日時 / 参加者 / 種別）
                              Row(
                                children: [
                                  Flexible(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.access_time,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            tournament.date,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.person,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${tournament.maxParticipants}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 16),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // 種別のフレームアイコン
                                      const Icon(
                                        Icons.category_outlined,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'ポケカ',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // 右上のステータスラベル
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 5.5,
                          ),
                          decoration: const BoxDecoration(
                            color: AppColors.userPrimary,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(16),
                              bottomLeft: Radius.circular(8),
                            ),
                          ),
                          child: Text(
                            _getStatusText(tournament.status),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textBlack,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                tabs: const [
                  Tab(text: '大会概要'),
                  Tab(text: '参加者一覧'),
                  Tab(text: '対戦表'),
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
                _buildOverviewTab(tournament),
                // 参加者一覧タブ
                ParticipantsContent(tournamentId: widget.tournamentId),
                // 対戦表タブ
                MatchesContent(tournamentId: widget.tournamentId),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(TournamentStatus status) {
    switch (status) {
      case TournamentStatus.upcoming:
        return '開催前';
      case TournamentStatus.ongoing:
        return 'ラウンド進行中';
      case TournamentStatus.completed:
        return '開催済';
    }
  }

  Widget _buildOverviewTab(TournamentDetailData tournament) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 大会の説明
          Container(
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
                  tournament.description,
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

          // 4 カード（開催日 / 参加者上限 / 最大ラウンド / 引き分け処理）
          Row(
            children: [
              // 開催日
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(58, 68, 251, 0.04),
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
                    color: const Color.fromRGBO(58, 68, 251, 0.04),
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
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // 最大ラウンド
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(58, 68, 251, 0.04),
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
                    color: const Color.fromRGBO(58, 68, 251, 0.04),
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

          const SizedBox(height: 16),

          // 備考
          if (tournament.notes.isNotEmpty) ...[
            Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(58, 68, 251, 0.04),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    tournament.notes,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textBlack,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // 右上のラウンドピル表示に統一したため、ステータス色/文言関数は不要になった。

  // 旧 UI の情報行は廃止した。

  // ヘッダー刷新に伴い、QR ダイアログ機能は削除した。

  TournamentDetailData _getTournamentData(String id) {
    // ダミーデータ（開催中の例）
    return const TournamentDetailData(
      id: '1',
      title: 'トーナメントタイトル',
      description:
          '200文字の大会概要200文字の大会概要200文字の大会概要200文字の大会概要'
          '200文字の大会概要200文字の大会概要200文字の大会概要200文字の大会概要'
          '200文字の大会概要200文字の大会概要200文字の大会概要200文字の大会概要'
          '200文字の大会概要200文字の大会概要',
      date: '2025/08/31',
      time: '19:00-21:00',
      maxParticipants: 32,
      currentParticipants: 32,
      maxRounds: '勝者が1人になるまで',
      drawHandling: '両者敗北',
      notes:
          'テキストテキストテキストテキストテキストテキストテキストテキスト'
          'テキストテキストテキストテキストテキストテキストテキストテキスト'
          'テキストテキストテキストテキストテキスト',
      status: TournamentStatus.ongoing, // 開催中
      currentRound: 3, // 現在のラウンド
    );
  }
}

/// トーナメントステータス
enum TournamentStatus {
  /// 開催前
  upcoming,

  /// 開催中
  ongoing,

  /// 開催済
  completed,
}

/// トーナメント詳細データクラス
class TournamentDetailData {
  /// トーナメント詳細データのコンストラクタ
  const TournamentDetailData({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.maxRounds,
    required this.drawHandling,
    required this.notes,
    required this.status,
    this.currentRound,
  });

  /// ID
  final String id;

  /// タイトル
  final String title;

  /// 説明
  final String description;

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
  final String notes;

  /// ステータス
  final TournamentStatus status;

  /// 現在のラウンド（開催中のみ）
  final int? currentRound;
}
