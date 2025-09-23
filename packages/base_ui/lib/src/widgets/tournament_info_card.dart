import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// トーナメント情報を表示するカードウィジェット。
///
/// タイトル、開催日、参加者数を美しくレイアウトして表示し、
/// グラデーション背景とグロー効果を持つ。
class TournamentInfoCard extends StatelessWidget {
  /// [TournamentInfoCard]のコンストラクタ。
  ///
  /// [title]、[date]、[participantCount]はすべて必須パラメータ。
  const TournamentInfoCard({
    super.key,
    required this.title,
    required this.date,
    required this.participantCount,
  });

  /// トーナメントのタイトル。
  final String title;

  /// 開催日の文字列表現。
  final String date;

  /// 参加者数。
  final int participantCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.textBlack,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.whiteAlpha),
        boxShadow: [
          BoxShadow(
            color: AppColors.gradientLightGreen.withValues(alpha: 0.5),
            blurRadius: 20,
          ),
        ],
      ),
      child: Stack(
        children: [
          // 背景装飾
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.userPrimaryAlpha, Colors.transparent],
                ),
              ),
            ),
          ),
          // コンテンツ
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: AppTextStyles.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(height: 1, color: AppColors.userPrimary),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.access_time,
                    color: AppColors.userPrimary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    date,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.userPrimary,
                      fontSize: 14,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 16,
                    color: AppColors.userPrimary,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  const Icon(
                    Icons.person,
                    color: AppColors.userPrimary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    participantCount.toString(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.userPrimary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
