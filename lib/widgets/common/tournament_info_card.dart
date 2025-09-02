import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

/// トーナメント情報を表示するカードウィジェット。
///
/// トーナメントのタイトル、開催日、参加者数を表示する。
class TournamentInfoCard extends StatelessWidget {
  /// [TournamentInfoCard] のコンストラクタ。
  ///
  /// [title]、[date]、[participantCount] はすべて必須パラメータ。
  const TournamentInfoCard({
    super.key,
    required this.title,
    required this.date,
    required this.participantCount,
  });

  /// トーナメントのタイトル。
  final String title;
  
  /// トーナメントの開催日。
  final String date;
  
  /// トーナメントの参加者数。
  final int participantCount;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.textBlack,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        border: Border.fromBorderSide(BorderSide(color: AppColors.whiteAlpha)),
        boxShadow: [
          BoxShadow(
            color: Color(0x80D8FF62),
            blurRadius: 20,
          ),
        ],
      ),
      child: SizedBox(
        height: 100,
        child: Padding(
          padding: const EdgeInsets.all(16),
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
              const DecoratedBox(
                decoration: BoxDecoration(color: AppColors.primary),
                child: SizedBox(height: 1, width: double.infinity),
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
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: const BoxDecoration(color: AppColors.primary),
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
        ),
      ),
    );
  }
}
