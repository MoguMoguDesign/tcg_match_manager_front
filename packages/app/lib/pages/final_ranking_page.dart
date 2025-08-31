import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/ranking_card.dart';
import '../widgets/common/tournament_info_card.dart';
import '../models/mock_data.dart';
import '../models/ranking.dart';

class FinalRankingPage extends StatefulWidget {
  const FinalRankingPage({super.key});

  @override
  State<FinalRankingPage> createState() => _FinalRankingPageState();
}

class _FinalRankingPageState extends State<FinalRankingPage> {
  @override
  Widget build(BuildContext context) {
    final currentPlayer = MockRankingData.finalRanking
        .firstWhere((player) => player.isCurrentPlayer);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
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
                  Container(
                    height: 14,
                    width: 69,
                    alignment: Alignment.center,
                    child: Text(
                      'マチサポ',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.textBlack,
                        fontSize: 12,
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
                        border: Border.all(color: AppColors.textBlack),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.keyboard_arrow_left,
                            size: 24,
                            color: AppColors.textBlack,
                          ),
                          Text(
                            '前のラウンドへ',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.textBlack,
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
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    // 自分の順位セクション
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '対戦結果',
                              style: AppTextStyles.labelMedium,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView.separated(
                              itemCount: MockRankingData.finalRanking.length,
                              separatorBuilder: (context, index) => Container(
                                height: 1,
                                color: AppColors.whiteAlpha,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                              ),
                              itemBuilder: (context, index) {
                                final player = MockRankingData.finalRanking[index];
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
      // フローティングボタン
      floatingActionButton: Container(
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