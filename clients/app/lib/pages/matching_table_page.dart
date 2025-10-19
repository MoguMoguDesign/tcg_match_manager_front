import 'dart:async';

import 'package:base_ui/base_ui.dart';
import 'package:domain/domain.dart' as domain;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../router.dart';

// 背景は BackgroundGradientTheme に統一する。

/// マッチング表ページを表示する。
///
/// 現在のラウンドの対戦表やラウンド移動の操作を提供する。
class MatchingTablePage extends HookConsumerWidget {
  /// [MatchingTablePage] のコンストラクタ。
  const MatchingTablePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRound = useState(1);

    // Notifier とセッション情報を取得する。
    final matchListNotifier =
        ref.read(domain.matchListNotifierProvider.notifier);
    final matchListState = ref.watch(domain.matchListNotifierProvider);
    final sessionState = ref.watch(domain.playerSessionNotifierProvider);
    final tournamentDetailNotifier =
        ref.read(domain.tournamentDetailNotifierProvider.notifier);
    final tournamentDetailState =
        ref.watch(domain.tournamentDetailNotifierProvider);

    /// マッチリストを取得する。
    Future<void> fetchMatches() async {
      final session = sessionState;

      // TODO(user): baseUrl と roundId は QR コードスキャンまたは
      // ルートパラメータから取得する。
      const baseUrl = 'https://example.com/';
      await matchListNotifier.fetchMatches(
        baseUrl: baseUrl,
        tournamentId: session.tournamentId,
        roundId: 'round-${currentRound.value}',
        userId: session.userId,
      );
    }

    // 初回ロード時にトーナメント情報とマッチリストを取得する。
    useEffect(
      () {
        final session = sessionState;
        // TODO(user): tournamentId は QR コードスキャンまたは
        // ルートパラメータから取得する。
        unawaited(
          tournamentDetailNotifier.loadTournament(session.tournamentId),
        );
        unawaited(fetchMatches());
        return null;
      },
      [currentRound.value],
    );

    /// 前のラウンドに移動する。
    void previousRound() {
      if (currentRound.value > 1) {
        currentRound.value--;
      }
    }

    /// 次のラウンドに移動する。
    Future<void> nextRound() async {
      if (currentRound.value >= 4) {
        if (!context.mounted) {
          return;
        }
        context.goToFinalRanking();
        return;
      }
      currentRound.value++;
    }

    /// ドメインの [domain.Match] のリストを UI 表示用の [MatchData] のリストへ変換する。
    List<MatchData> toMatchData(List<domain.Match> domainMatches) {
      return domainMatches.map((m) {
        // 結果が存在するかどうかで状態を判定する。
        final hasResult = m.result != null;
        final uiStatus = hasResult ? MatchStatus.finished : MatchStatus.playing;

        PlayerState player1State;
        PlayerState player2State;

        if (hasResult) {
          // 勝者IDでプレイヤーの状態を判定する。
          final player1IsWinner = m.result!.winnerId == m.player1.id;
          final player2IsWinner = m.result!.winnerId == m.player2.id;

          if (player1IsWinner) {
            player1State = PlayerState.win;
            player2State = PlayerState.lose;
          } else if (player2IsWinner) {
            player1State = PlayerState.lose;
            player2State = PlayerState.win;
          } else {
            // 引き分け（winnerId が null の場合）。
            player1State = PlayerState.lose;
            player2State = PlayerState.lose;
          }
        } else {
          player1State = PlayerState.progress;
          player2State = PlayerState.progress;
        }

        return MatchData(
          tableNumber: m.tableNumber,
          player1Name: m.player1.name,
          player2Name: m.player2.name,
          status: uiStatus,
          player1Score: '累計得点 ${m.player1.matchingPoints}点',
          player2Score: '累計得点 ${m.player2.matchingPoints}点',
          player1State: player1State,
          player2State: player2State,
          player1IsCurrentUser: m.isMine && m.meSide == 'player1',
          player2IsCurrentUser: m.isMine && m.meSide == 'player2',
        );
      }).toList();
    }

    // 勝敗登録は別ページ（ResultEntryPage）へ遷移する仕様。
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('マッチング表'),
        backgroundColor: AppColors.transparent,
        foregroundColor: AppColors.white,
        elevation: 0,
        toolbarHeight: 0,
      ),
      backgroundColor: AppColors.transparent,
      body: SvgBackground(
        assetPath: 'packages/base_ui/assets/images/whole_background.svg',
        child: SafeArea(
          top: false,
          child:
              // メインコンテンツ
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // トーナメント情報
                      if (tournamentDetailState.state ==
                          domain.TournamentDetailState.loaded)
                        TournamentInfoCard(
                          title: tournamentDetailState.tournament!.title,
                          date: tournamentDetailState.tournament!.startDate ??
                              '',
                          participantCount:
                              tournamentDetailState.tournament!.playerCount ??
                                  0,
                        )
                      else if (tournamentDetailState.state ==
                          domain.TournamentDetailState.loading)
                        const SizedBox(
                          height: 100,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (tournamentDetailState.state ==
                          domain.TournamentDetailState.error)
                        Container(
                          height: 100,
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              tournamentDetailState.errorMessage ??
                                  'エラーが発生しました',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      else
                        const SizedBox(height: 100),
                      const SizedBox(height: 32),
                      // ラウンドナビゲーション
                      if (currentRound.value >= 4)
                        RoundChangeButtonRow.last(
                          onPressedPrev:
                              currentRound.value > 1 ? previousRound : null,
                          onPressedShowFinal: () {
                            context.goToFinalRanking();
                          },
                        )
                      else
                        RoundChangeButtonRow.medium(
                          onPressedPrev:
                              currentRound.value > 1 ? previousRound : null,
                          onPressedNext: nextRound,
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
                                    'ラウンド${currentRound.value}',
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
                                  child: matchListState.when(
                                    data: (matches) {
                                      if (matches.isEmpty) {
                                        return const Center(
                                          child: Text(
                                            'このラウンドの対戦はありません',
                                            style: AppTextStyles.bodyMedium,
                                          ),
                                        );
                                      }
                                      return MatchList(
                                        matches: toMatchData(matches),
                                        showHeader: false,
                                        onMatchTap: (matchData) {
                                          context.goToResultEntry();
                                        },
                                      );
                                    },
                                    loading: () => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    error: (error, _) => Center(
                                      child: Text(
                                        'エラーが発生しました: $error',
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(color: Colors.red),
                                      ),
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
