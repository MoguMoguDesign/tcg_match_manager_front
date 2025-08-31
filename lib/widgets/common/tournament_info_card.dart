import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

class TournamentInfoCard extends StatelessWidget {
  const TournamentInfoCard({
    super.key,
    required this.title,
    required this.date,
    required this.participantCount,
  });

  final String title;
  final String date;
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
            color: const Color(0xFFD8FF62).withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 背景装飾
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primaryAlpha,
                    Colors.transparent,
                  ],
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
              Container(
                height: 1,
                color: AppColors.primary,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.access_time,
                    color: AppColors.primary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    date,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontSize: 14,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 16,
                    color: AppColors.primary,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  const Icon(
                    Icons.person,
                    color: AppColors.primary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    participantCount.toString(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
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