import 'package:base_ui/base_ui.dart';
import 'package:flutter/material.dart';

/// 最終順位を表示するページ。
class FinalRankingPage extends StatefulWidget {
  /// [FinalRankingPage]のコンストラクタ。
  const FinalRankingPage({super.key});

  @override
  State<FinalRankingPage> createState() => _FinalRankingPageState();
}

class _FinalRankingPageState extends State<FinalRankingPage> {
  @override
  Widget build(BuildContext context) {
    final currentPlayer = MockData.finalRanking
        .firstWhere((player) => player.isCurrentPlayer);
    
    return Scaffold(
      backgroundColor: AppColors.adminPrimary, // Scaffoldの背景色を設定
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.3, 1.0],
            colors: [
              AppColors.gradientGreen,
              AppColors.textBlack,
              AppColors.adminPrimary,
            ],
          ),
        ),
        child: SafeArea(
          bottom: false, // 下部のSafeAreaを無効にして背景を底まで表示
          child: Column(
          children: [
            // ヘッダー
            Container(
              height: 89,
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 57,
              ),
              child: Row(
                children: [
                  // ロゴ
                  SizedBox(
                    height: 28.121,
                    width: 139,
                    child: Center(
                      child: Text(
                        'マチサポ',
                        style: AppTextStyles.headlineLarge.copyWith(
                          color: AppColors.white,
                          fontSize: 20, // Figmaに準拠
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  // 戻るボタン
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.white),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.keyboard_arrow_left,
                            size: 24,
                            color: AppColors.white,
                          ),
                          Text(
                            '前のラウンドへ',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                              itemCount: MockData.finalRanking.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 1,
                                child: ColoredBox(
                                  color: AppColors.whiteAlpha,
                                ),
                              ),
                              itemBuilder: (context, index) {
                                final player = MockData.finalRanking[index];
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
      // フローティングボタン
      floatingActionButton: SizedBox(
        width: 342,
        child: AppButton(
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
                backgroundColor: AppColors.primary,
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
