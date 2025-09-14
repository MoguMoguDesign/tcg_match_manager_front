import 'package:base_ui/base_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';

/// 最終ランキングページを表示する。
///
/// トーナメント終了後の最終順位と各プレイヤーの戦績を表示する。
class FinalRankingPage extends StatefulWidget {
  /// [FinalRankingPage] のコンストラクタ。
  const FinalRankingPage({super.key});

  @override
  State<FinalRankingPage> createState() => _FinalRankingPageState();
}

class _FinalRankingPageState extends State<FinalRankingPage> {
  @override
  Widget build(BuildContext context) {
    final currentPlayer = MockRankingData.finalRanking.firstWhere(
      (player) => player.isCurrentPlayer,
    );

    final bg =
        Theme.of(context).extension<BackgroundGradientTheme>() ??
        kDefaultBackgroundGradient;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('最終順位'),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.white,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: bg.scaffoldGradient),
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
                        title: MockData.tournament.title,
                        date: MockData.tournament.date,
                        participantCount: MockData.tournament.participantCount,
                      ),
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
                          RankingCard(player: currentPlayer),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // 対戦結果セクション
                      Expanded(
                        child: Column(
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
                            Expanded(
                              child: ListView.separated(
                                itemCount: MockRankingData.finalRanking.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 16),
                                itemBuilder: (context, index) {
                                  final player =
                                      MockRankingData.finalRanking[index];
                                  return RankingCard(player: player);
                                },
                              ),
                            ),
                          ],
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
