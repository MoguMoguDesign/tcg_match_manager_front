import 'package:base_ui/base_ui.dart';
import 'package:flutter/material.dart';

class MatchingTablePage extends StatefulWidget {
  const MatchingTablePage({super.key});

  @override
  State<MatchingTablePage> createState() => _MatchingTablePageState();
}

class _MatchingTablePageState extends State<MatchingTablePage> {
  int currentRound = 1;
  late List<Match> matches;

  @override
  void initState() {
    super.initState();
    matches = MockData.getRoundMatches(currentRound);
  }

  void _previousRound() {
    if (currentRound > 1) {
      setState(() {
        currentRound--;
        matches = MockData.getRoundMatches(currentRound);
      });
    }
  }

  void _nextRound() {
    // 4ラウンド終了後は最終順位表に遷移
    if (currentRound >= MockData.currentTournament.totalRounds) {
      Navigator.pushReplacementNamed(context, '/final-ranking');
      return;
    }

    setState(() {
      currentRound++;
      matches = MockData.getRoundMatches(currentRound);
      MockData.nextRound();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ヘッダー
            Container(
              height: 89,
              padding: const EdgeInsets.only(left: 16, right: 16, top: 57),
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
                  Container(
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
                    // ラウンドナビゲーション
                    Row(
                      children: [
                        // 前のラウンド
                        Opacity(
                          opacity: currentRound <= 1 ? 0.2 : 1.0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.textBlack,
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: AppColors.white,
                                width: 2,
                              ),
                            ),
                            child: GestureDetector(
                              onTap: currentRound > 1 ? _previousRound : null,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.keyboard_arrow_left,
                                    color: AppColors.white,
                                    size: 24,
                                  ),
                                  Text(
                                    '前のラウンド',
                                    style: AppTextStyles.labelMedium.copyWith(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        // 次のラウンド
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.textBlack,
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: AppColors.white,
                              width: 2,
                            ),
                          ),
                          child: GestureDetector(
                            onTap: _nextRound,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  currentRound >=
                                          MockData.currentTournament.totalRounds
                                      ? '最終順位表'
                                      : '次のラウンド',
                                  style: AppTextStyles.labelMedium.copyWith(
                                    fontSize: 14,
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_right,
                                  color: AppColors.white,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // ラウンド情報
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.textBlack,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            // ラウンドヘッダー
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.primaryAlpha,
                                borderRadius: const BorderRadius.only(
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
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Row(
                                children: [
                                  Text('対戦表', style: AppTextStyles.labelMedium),
                                  const Spacer(),
                                  Text(
                                    '最大6ラウンド',
                                    style: AppTextStyles.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            // マッチリスト
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: matches.isNotEmpty
                                    ? ListView.separated(
                                        itemCount: matches.length,
                                        separatorBuilder: (context, index) =>
                                            Container(
                                              height: 1,
                                              color: AppColors.whiteAlpha,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 8,
                                                  ),
                                            ),
                                        itemBuilder: (context, index) {
                                          return MatchCard(
                                            match: matches[index],
                                            onResultTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                '/result-entry',
                                              );
                                            },
                                          );
                                        },
                                      )
                                    : Center(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/result-entry');
        },
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '勝敗',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textBlack,
                fontSize: 16,
                height: 1.0,
              ),
            ),
            Text(
              '登録',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textBlack,
                fontSize: 16,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
