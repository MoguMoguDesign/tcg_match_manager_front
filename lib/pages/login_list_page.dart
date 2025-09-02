import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/mock_data.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_text_field.dart';
import '../widgets/common/tournament_info_card.dart';

/// ログインリストページを表示する。
///
/// 参加者のニックネームを選択し、トーナメントに復帰する導線を提供する。
class LoginListPage extends StatefulWidget {
  /// [LoginListPage] のコンストラクタ。
  const LoginListPage({super.key});

  @override
  State<LoginListPage> createState() => _LoginListPageState();
}

class _LoginListPageState extends State<LoginListPage> {
  String? selectedPlayer;

  void _showPlayerList() {
    unawaited(showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.textBlack,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('ニックネームを選択', style: AppTextStyles.labelMedium),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: MockData.players.length,
                  itemBuilder: (context, index) {
                    final player = MockData.players[index];
                    return ListTile(
                      title: Text(player.name, style: AppTextStyles.bodyMedium),
                      onTap: () {
                        setState(() {
                          selectedPlayer = player.name;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB4EF03),
              AppColors.textBlack,
              AppColors.adminPrimary,
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 135),
                          // ロゴ
                          Container(
                            height: 28,
                            width: 139,
                            alignment: Alignment.center,
                            child: Text(
                              'マチサポ',
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
                            participantCount:
                                MockData.tournament.participantCount,
                          ),
                          const SizedBox(height: 32),
                          // 選択フォーム
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '参加者リストからあなたの\nニックネームを選んでください',
                                style: AppTextStyles.labelMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'ニックネーム',
                                style: AppTextStyles.labelMedium,
                              ),
                              const SizedBox(height: 9),
                              AppDropdownField(
                                hintText: selectedPlayer ?? 'リストから選択',
                                onTap: _showPlayerList,
                              ),
                              const SizedBox(height: 16),
                              AppButton(
                                text: 'トーナメントに復帰する',
                                onPressed: () {
                                  unawaited(Navigator.pushNamed(
                                    context,
                                    '/matching-table',
                                  ));
                                },
                                isEnabled: selectedPlayer != null,
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                      // 登録に戻る（画面下に配置）
                      SmallButton(
                        text: '参加登録に戻る',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
