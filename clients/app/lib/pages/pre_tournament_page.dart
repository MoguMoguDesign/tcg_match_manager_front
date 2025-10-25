import 'dart:async';

import 'package:base_ui/base_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// トーナメント開始前の待機ページを表示する。
///
/// トーナメント開始のカウントダウンと参加者情報を表示する。
class PreTournamentPage extends StatefulWidget {
  /// [PreTournamentPage] のコンストラクタ。
  const PreTournamentPage({super.key});

  @override
  State<PreTournamentPage> createState() => _PreTournamentPageState();
}

class _PreTournamentPageState extends State<PreTournamentPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    unawaited(_animationController.repeat(reverse: true));

    // 5秒後に自動でマッチング表画面に遷移（モック用）
    unawaited(
      Future.delayed(const Duration(seconds: 5), () async {
        if (mounted) {
          context.goNamed('matching-table');
        }
      }),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 背景テーマは Svg 背景へ統一。
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('開始待機'),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: SvgBackground(
        assetPath: 'packages/base_ui/assets/images/login_background.svg',
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 135),
                // ロゴ
                Container(
                  height: 28,
                  width: 139,
                  alignment: Alignment.center,
                  child: Text(
                    'バトサポ',
                    style: AppTextStyles.headlineLarge.copyWith(
                      color: AppColors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 59),
                // トーナメント情報カード
                TournamentInfoCard(
                  title: MockData.tournament.title,
                  date: MockData.tournament.date,
                  participantCount: MockData.tournament.participantCount,
                ),
                const Spacer(),
                // 待機メッセージとローディング
                Column(
                  children: [
                    Text(
                      'トーナメント開始をお待ちください',
                      style: AppTextStyles.labelMedium.copyWith(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '管理者が大会を開始するまでお待ちください\n画面は自動で更新されます',
                      style: AppTextStyles.bodyMedium.copyWith(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    // ローディングアニメーション
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.userPrimary.withValues(
                                alpha: 0.3,
                              ),
                              width: 4,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: CircularProgressIndicator(
                                  value: _animation.value,
                                  strokeWidth: 4,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                        AppColors.userPrimary,
                                      ),
                                ),
                              ),
                              const Center(
                                child: Icon(
                                  Icons.schedule,
                                  color: AppColors.userPrimary,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    // 参加者数表示
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.textBlack.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.whiteAlpha),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.people,
                            color: AppColors.userPrimary,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '参加者: ${MockData.tournament.participantCount}名',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.userPrimary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
