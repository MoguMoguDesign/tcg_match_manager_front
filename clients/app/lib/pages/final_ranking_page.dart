import 'dart:async';

import 'package:base_ui/base_ui.dart';
import 'package:domain/domain.dart' as domain;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 最終ランキングページを表示する。
///
/// トーナメント終了後の最終順位と各プレイヤーの戦績を表示する。
class FinalRankingPage extends HookConsumerWidget {
  /// [FinalRankingPage] のコンストラクタ。
  ///
  /// - [tournamentId] は、トーナメントID。
  const FinalRankingPage({super.key, this.tournamentId});

  /// トーナメントID。
  final String? tournamentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Notifier とセッション情報を取得する。
    final standingListNotifier = ref.read(
      domain.standingListNotifierProvider.notifier,
    );
    final standingListState = ref.watch(domain.standingListNotifierProvider);
    final sessionState = ref.watch(domain.playerSessionNotifierProvider);
    final tournamentDetailNotifier = ref.read(
      domain.tournamentDetailNotifierProvider.notifier,
    );
    final tournamentDetailState = ref.watch(
      domain.tournamentDetailNotifierProvider,
    );

    /// 最終順位を取得する。
    Future<void> fetchStandings() async {
      final session = sessionState;

      // TODO(user): baseUrl は QR コードスキャンまたは
      // ルートパラメータから取得する。
      const baseUrl = 'https://example.com/';
      await standingListNotifier.fetchStandings(
        baseUrl: baseUrl,
        tournamentId: session.tournamentId,
        userId: session.userId,
      );
    }

    // 初回ロード時にトーナメント情報と最終順位を取得する。
    useEffect(() {
      final session = sessionState;
      // TODO(user): tournamentId は QR コードスキャンまたは
      // ルートパラメータから取得する。
      unawaited(tournamentDetailNotifier.loadTournament(session.tournamentId));
      unawaited(fetchStandings());
      return null;
    }, []);

    // 背景テーマは Svg 背景へ統一。
    return Scaffold(
      backgroundColor: AppColors.transparent,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('最終順位'),
        backgroundColor: AppColors.transparent,
        foregroundColor: AppColors.white,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SvgBackground(
        assetPath: 'packages/base_ui/assets/images/whole_background.svg',
        child: SafeArea(
          top: false,
          child: standingListState.when(
            data: (standing) {
              if (standing == null || standing.rankings.isEmpty) {
                return const Center(
                  child: Text(
                    '最終順位が取得できませんでした',
                    style: AppTextStyles.bodyMedium,
                  ),
                );
              }

              // 自分の順位を取得する。
              final session = sessionState;
              final currentPlayerRanking = standing.rankings.firstWhere(
                (ranking) => ranking.playerName == session.playerName,
                orElse: () => standing.rankings.first,
              );

              return Column(
                children: [
                  // メインコンテンツ
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // トーナメント情報
                          if (tournamentDetailState.state ==
                              domain.TournamentDetailState.loaded)
                            TournamentInfoCard(
                              title: tournamentDetailState.tournament!.title,
                              date:
                                  tournamentDetailState.tournament!.startDate ??
                                  '',
                              participantCount:
                                  tournamentDetailState
                                      .tournament!
                                      .playerCount ??
                                  0,
                            )
                          else if (tournamentDetailState.state ==
                              domain.TournamentDetailState.loading)
                            const SizedBox(
                              height: 100,
                              child: Center(child: CircularProgressIndicator()),
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
                          // 最終順位タイトル
                          Text(
                            '最終順位',
                            style: AppTextStyles.headlineLarge.copyWith(
                              color: AppColors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          // 自分の順位セクション
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  '自分の順位',
                                  style: AppTextStyles.labelMedium,
                                ),
                              ),
                              const SizedBox(height: 16),
                              RankingRow(
                                leftLabel: currentPlayerRanking.playerName,
                                rightValue:
                                    '${currentPlayerRanking.matchPoints}点',
                                type: RankingRowType.currentUser,
                                rankNumber: currentPlayerRanking.rank,
                                metaLeft:
                                    '累計得点 ${currentPlayerRanking.matchPoints}点',
                                metaRight:
                                    // OMW%の表示フォーマットのため、80文字制限を無視する。
                                    // ignore: lines_longer_than_80_chars
                                    'OMW% ${currentPlayerRanking.omwPercentage.toStringAsFixed(2)}%',
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          // 対戦結果セクション
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  '対戦結果',
                                  style: AppTextStyles.labelMedium,
                                ),
                              ),
                              const SizedBox(height: 16),
                              RankingContainer(
                                currentUserId: session.playerName,
                                rankings: standing.rankings
                                    .map(
                                      (ranking) => RankingData(
                                        userId: ranking.playerName,
                                        playerName: ranking.playerName,
                                        score: '${ranking.matchPoints}点',
                                        rank: ranking.rank,
                                        metaLeft:
                                            '累計得点 ${ranking.matchPoints}点',
                                        metaRight:
                                            // OMW%の表示フォーマットのため、80文字制限を無視する。
                                            // ignore: lines_longer_than_80_chars
                                            'OMW% ${ranking.omwPercentage.toStringAsFixed(2)}%',
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Text(
                'エラーが発生しました: $error',
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.red),
              ),
            ),
          ),
        ),
      ),
      // フローティングボタン（共通ボタンへ置換）
      floatingActionButton: SizedBox(
        width: 342,
        child: CommonConfirmButton(
          text: 'ラウンドごとの戦績を見る',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'ラウンド詳細画面（未実装）',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textBlack,
                  ),
                ),
                backgroundColor: AppColors.userPrimary,
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
