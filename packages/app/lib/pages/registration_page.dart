import 'dart:async';

import 'package:base_ui/base_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';

import '../router.dart';

/// 参加者登録ページを表示する。
///
/// ニックネームの入力とトーナメントへの参加登録を行う。
class RegistrationPage extends StatefulWidget {
  /// [RegistrationPage] のコンストラクタ。
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _nicknameController = TextEditingController();

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
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
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        unawaited(context.goToComponentTest());
                      },
                      icon: const Icon(
                        Icons.settings,
                        color: AppColors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 95),
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
                  participantCount: MockData.tournament.participantCount,
                ),
                const SizedBox(height: 32),
                // 入力フォーム
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '大会で表示するニックネームを入力してください',
                      style: AppTextStyles.labelMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'ニックネーム',
                      style: AppTextStyles.labelMedium,
                    ),
                    const SizedBox(height: 9),
                    AppTextField(
                      hintText: 'ニックネームを入力',
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      text: '参加に進む',
                      onPressed: () {
                        // 画面遷移処理
                        unawaited(context.goToPreTournament());
                      },
                      isEnabled: _nicknameController.text.isNotEmpty,
                    ),
                  ],
                ),
                const Spacer(),
                // 接続問題の場合
                Column(
                  children: [
                    Text(
                      '接続が切れましたか？',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    SmallButton(
                      text: 'トーナメントに復帰する',
                      onPressed: () {
                        unawaited(context.goToLoginList());
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
