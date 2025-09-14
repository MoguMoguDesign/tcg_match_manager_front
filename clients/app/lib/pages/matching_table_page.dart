import 'package:base_ui/base_ui.dart';
import 'package:domain/domain.dart' as domain;
import 'package:flutter/material.dart';

import '../router.dart';

// 背景は BackgroundGradientTheme に統一する。

/// マッチング表ページを表示する。
///
/// 現在のラウンドの対戦表やラウンド移動の操作を提供する。
class MatchingTablePage extends StatefulWidget {
  /// [MatchingTablePage] のコンストラクタ。
  const MatchingTablePage({super.key});

  @override
  State<MatchingTablePage> createState() => _MatchingTablePageState();
}

class _MatchingTablePageState extends State<MatchingTablePage> {
  int currentRound = 1;
  late List<domain.Match> matches;

  @override
  void initState() {
    super.initState();
    matches = domain.MockData.getRoundMatches(currentRound);
  }

  void _previousRound() {
    if (currentRound > 1) {
      setState(() {
        currentRound--;
        matches = domain.MockData.getRoundMatches(currentRound);
      });
    }
  }

  Future<void> _nextRound() async {
    if (currentRound >= 4) {
      if (!mounted) return;
      context.goToFinalRanking();
      return;
    }
    setState(() {
      currentRound++;
      matches = domain.MockData.getRoundMatches(currentRound);
    });
  }

  /// ドメインの [domain.Match] のリストを UI 表示用の [MatchData] のリストへ変換する。
  List<MatchData> _toMatchData(List<domain.Match> domainMatches) {
    return domainMatches.map((m) {
      final uiStatus = switch (m.status) {
        domain.MatchStatus.ongoing => MatchStatus.playing,
        domain.MatchStatus.completed => MatchStatus.finished,
      };

      PlayerState player1State;
      PlayerState player2State;
      if (m.status == domain.MatchStatus.completed) {
        final player1IsWinner = identical(m.winner, m.player1);
        player1State = player1IsWinner ? PlayerState.win : PlayerState.lose;
        player2State = player1IsWinner ? PlayerState.lose : PlayerState.win;
      } else {
        player1State = PlayerState.progress;
        player2State = PlayerState.progress;
      }

      return MatchData(
        tableNumber: m.tableNumber,
        player1Name: m.player1.name,
        player2Name: m.player2.name,
        status: uiStatus,
        player1Score: '累計得点 ${m.player1.score}点',
        player2Score: '累計得点 ${m.player2.score}点',
        player1State: player1State,
        player2State: player2State,
        player1IsCurrentUser: m.player1.isCurrentPlayer,
        player2IsCurrentUser: m.player2.isCurrentPlayer,
      );
    }).toList();
  }

  // 勝敗登録は別ページ（ResultEntryPage）へ遷移する仕様。

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('マッチング表'),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.white,
        elevation: 0,
        toolbarHeight: 0,
      ),
      backgroundColor: Colors.transparent,
      body: SvgBackground(
        assetPath: 'packages/base_ui/assets/images/whole_background.svg',
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // メインコンテンツ
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // トーナメント情報
                      TournamentInfoCard(
                        title: domain.MockData.tournament.title,
                        date: domain.MockData.tournament.date,
                        participantCount:
                            domain.MockData.tournament.participantCount,
                      ),
                      const SizedBox(height: 32),
                      // ラウンドナビゲーション
                      if (currentRound >= 4)
                        RoundChangeButtonRow.last(
                          onPressedPrev: currentRound > 1
                              ? _previousRound
                              : null,
                          onPressedShowFinal: () {
                            context.goToFinalRanking();
                          },
                        )
                      else
                        RoundChangeButtonRow.medium(
                          onPressedPrev: currentRound > 1
                              ? _previousRound
                              : null,
                          onPressedNext: _nextRound,
                        ),
                      const SizedBox(height: 16),
                      // ラウンド情報
                      Expanded(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.textBlack,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              // ラウンドヘッダー
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                decoration: const BoxDecoration(
                                  color: AppColors.userPrimaryAlpha,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'ラウンド$currentRound',
                                    style: AppTextStyles.headlineLarge,
                                  ),
                                ),
                              ),
                              // ラウンド詳細
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '対戦表',
                                      style: AppTextStyles.labelMedium,
                                    ),
                                    Spacer(),
                                    Text(
                                      '最大6ラウンド',
                                      style: AppTextStyles.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              // マッチリスト（共通コンポーネント）
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: matches.isNotEmpty
                                      ? MatchList(
                                          matches: _toMatchData(matches),
                                          showHeader: false,
                                          onMatchTap: (matchData) {
                                            context.goToResultEntry();
                                          },
                                        )
                                      : const Center(
                                          child: Text(
                                            'このラウンドの対戦はありません',
                                            style: AppTextStyles.bodyMedium,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goToResultEntry();
        },
        backgroundColor: AppColors.userPrimary,
        shape: const CircleBorder(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '勝敗',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textBlack,
                fontSize: 16,
                height: 1,
              ),
            ),
            Text(
              '登録',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textBlack,
                fontSize: 16,
                height: 1,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
