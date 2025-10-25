import 'package:base_ui/base_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';

import '../router.dart';

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

  // 旧ボトムシート UI は DropdownSelectField に置換済みのため削除。

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SvgBackground(
        assetPath: 'packages/base_ui/assets/images/login_background.svg',
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
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
                      const SizedBox(height: 32),
                      // 選択フォーム（共通コンポーネントへ置換）
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
                          DropdownSelectField<String>(
                            hintText: selectedPlayer ?? 'リストから選択',
                            items: MockData.players.map((p) => p.name).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedPlayer = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          CommonConfirmButton(
                            text: 'トーナメントに復帰する',
                            onPressed: () {
                              context.goToMatchingTable();
                            },
                            isEnabled: selectedPlayer != null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 80),
                      // 登録に戻る
                      CommonSmallButton(
                        text: '参加登録に戻る',
                        onPressed: () {
                          context.goToRegistration();
                        },
                        style: SmallButtonStyle.secondary,
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
