import 'package:flutter/material.dart';
import 'package:base_ui/base_ui.dart';

class LoginListPage extends StatefulWidget {
  /// [LoginListPage]のコンストラクタ。
  const LoginListPage({super.key});

  @override
  State<LoginListPage> createState() => _LoginListPageState();
}

class _LoginListPageState extends State<LoginListPage> {
  String? selectedPlayer;

  void _showPlayerList() {
    showModalBottomSheet<void>(
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
              Text('ニックネームを選択', style: AppTextStyles.labelMedium),
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
    );
  }

  @override
  Widget build(BuildContext context) {
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
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top,
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 135),
                    // ロゴコンテナ - Figma完全準拠
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
                    const SizedBox(height: 59),
                    // トーナメント情報カード
                    TournamentInfoCard(
                      title: MockData.tournament.title,
                      date: MockData.tournament.date,
                      participantCount: MockData.tournament.participantCount,
                    ),
                    const SizedBox(height: 32),
                    // 選択フォーム
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '参加者リストからあなたのニックネームを選んでください',
                          style: AppTextStyles.labelMedium.copyWith(
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'ニックネーム',
                          style: AppTextStyles.labelMedium.copyWith(
                            fontSize: 14,
                          ),
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
                            Navigator.pushNamed(context, '/matching-table');
                          },
                          isEnabled: selectedPlayer != null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    // 登録に戻る
                    SmallButton(
                      text: '参加登録に戻る',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom + 24,
                    ), // 下部Safe Area + 余白
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
