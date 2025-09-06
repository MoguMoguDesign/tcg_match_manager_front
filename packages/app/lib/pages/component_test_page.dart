import 'package:base_ui/base_ui.dart';
import 'package:flutter/material.dart';

/// コンポーネントテスト用のページを表示する。
///
/// 各種 UI コンポーネントの表示確認とテストを行う。
class ComponentTestPage extends StatelessWidget {
  /// [ComponentTestPage] のコンストラクタ。
  const ComponentTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('コンポーネントテスト'),
        backgroundColor: AppColors.adminPrimary,
        foregroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              const Text(
                'UI コンポーネントテストページ',
                style: AppTextStyles.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              const Text(
                'ここに各種コンポーネントを追加してテストできます。',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Figma CommonConfirmButton (node-id: 86-7960)
              const Text(
                'CommonConfirmButton (Figma 86-7960)',
                style: AppTextStyles.labelLarge,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 12),
              // Default: userFilled
              CommonConfirmButton(
                text: '参加に進む',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('userFilled: 参加に進む')),
                  );
                },
              ),
              const SizedBox(height: 16),
              // userOutlined
              CommonConfirmButton(
                text: '参加に進む',
                style: ConfirmButtonStyle.userOutlined,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('userOutlined: 参加に進む')),
                  );
                },
              ),
              const SizedBox(height: 16),
              // adminFilled
              CommonConfirmButton(
                text: 'ログイン',
                style: ConfirmButtonStyle.adminFilled,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('adminFilled: ログイン')),
                  );
                },
              ),
              const SizedBox(height: 16),
              // adminOutlined
              CommonConfirmButton(
                text: 'ログイン',
                style: ConfirmButtonStyle.adminOutlined,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('adminOutlined: ログイン')),
                  );
                },
              ),
              const SizedBox(height: 32),
              
              // CommonSmallButton のテスト
              const Text(
                'CommonSmallButton (Figma 95-183)',
                style: AppTextStyles.labelLarge,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  CommonSmallButton(
                    text: 'プライマリ',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('CommonSmallButton: プライマリ'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  CommonSmallButton(
                    text: 'セカンダリ',
                    style: SmallButtonStyle.secondary,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('CommonSmallButton: セカンダリ'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  CommonSmallButton(
                    text: '管理者',
                    style: SmallButtonStyle.admin,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('CommonSmallButton: 管理者')),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // ConfirmDialog のテスト
              const Text(
                'ConfirmDialog (Figma 86-7764)',
                style: AppTextStyles.labelLarge,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 12),
              CommonConfirmButton(
                text: 'ダイアログ表示',
                style: ConfirmButtonStyle.adminFilled,
                onPressed: () async {
                  await ConfirmDialog.show(
                    context,
                    title: '確認',
                    message: 'この操作を実行しますか？',
                    onConfirm: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('確認されました')),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              
              // TextField のテスト
              const Text(
                'TextField (Figma 86-7923)',
                style: AppTextStyles.labelLarge,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 12),
              const FigmaTextField(
                hintText: 'テキストを入力してください',
              ),
              const SizedBox(height: 12),
              const PasswordTextField(
                hintText: 'パスワードを入力してください',
              ),
              const SizedBox(height: 12),
              const SearchTextField(
                hintText: '検索キーワード',
              ),
              const SizedBox(height: 32),
              
              // TournamentTitleCard のテスト
              const Text(
                'TournamentTitleCard (Figma 244-5226)',
                style: AppTextStyles.labelLarge,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 12),
              const TournamentTitleCard(
                title: '春季トーナメント',
                subtitle: '2024年4月開催',
              ),
              const SizedBox(height: 16),
              const TournamentTitleCard(
                title: 'プレミアリーグ',
                style: TournamentCardStyle.admin,
              ),
              const SizedBox(height: 24),
              
              // MatchStatusContainer のテスト
              const Text(
                'MatchStatusContainer (Figma 244-5549)',
                style: AppTextStyles.labelLarge,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 12),
              const Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  MatchStatusContainer(status: MatchStatus.waiting),
                  MatchStatusContainer(status: MatchStatus.playing),
                  MatchStatusContainer(status: MatchStatus.finished),
                  MatchStatusContainer(status: MatchStatus.cancelled),
                  MatchStatusContainer(status: MatchStatus.paused),
                ],
              ),
              const SizedBox(height: 24),
              
              // PlayerContainer のテスト
              const Text(
                'PlayerContainer (Figma 244-5574)',
                style: AppTextStyles.labelLarge,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 12),
              const PlayerContainer(
                playerName: '田中太郎',
                playerNumber: 1,
              ),
              const SizedBox(height: 8),
              const PlayerContainer(
                playerName: '佐藤花子',
                playerNumber: 2,
                isWinner: true,
              ),
              const SizedBox(height: 24),
              
              // VSContainer のテスト
              const Text(
                'VSContainer (Figma 244-5640)',
                style: AppTextStyles.labelLarge,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 12),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  VSContainer(size: VSContainerSize.small),
                  VSContainer(),
                  VSContainer(size: VSContainerSize.large),
                ],
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  VSContainer(),
                  VSContainer(style: VSContainerStyle.secondary),
                  VSContainer(style: VSContainerStyle.admin),
                ],
              ),
              const SizedBox(height: 24),
              
              // TableNumberColumn のテスト
              const Text(
                'TableNumberColumn (Figma 244-5517)',
                style: AppTextStyles.labelLarge,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 12),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TableNumberColumn(tableNumber: 1),
                  TableNumberColumn(
                    tableNumber: 2,
                    style: TableNumberStyle.secondary,
                  ),
                  TableNumberColumn(
                    tableNumber: 3,
                    style: TableNumberStyle.admin,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // PlayersContainer のテスト
              const Text(
                'PlayersContainer (Figma 253-5745)',
                style: AppTextStyles.labelLarge,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 12),
              const PlayersContainer(
                player1Name: '田中太郎',
                player2Name: '佐藤花子',
                player1Number: 1,
                player2Number: 2,
                player2IsWinner: true,
              ),
              const SizedBox(height: 16),
              const PlayersContainer(
                player1Name: '山田次郎',
                player2Name: '鈴木一郎',
                playerStyle: PlayerContainerStyle.secondary,
                vsStyle: VSContainerStyle.secondary,
              ),
              const SizedBox(height: 24),
              
              // ResultContainer のテスト
              const Text(
                'ResultContainer (Figma 255-2469)',
                style: AppTextStyles.labelLarge,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 12),
              const Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  ResultContainer(
                    result: ResultData(
                      title: 'SCORE',
                      value: '15',
                      subtitle: 'pts',
                    ),
                  ),
                  ResultContainer(
                    result: ResultData(
                      title: 'RANK',
                      value: '1st',
                      isHighlight: true,
                    ),
                    style: ResultContainerStyle.winner,
                  ),
                  ResultContainer(
                    result: ResultData(
                      value: '2-1',
                    ),
                    style: ResultContainerStyle.secondary,
                    size: ResultContainerSize.large,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // MatchList のテスト
              const Text(
                'MatchList (Figma 253-6796)',
                style: AppTextStyles.labelLarge,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 12),
              MatchList(
                matches: const [
                  MatchData(
                    tableNumber: 1,
                    player1Name: '田中太郎',
                    player2Name: '佐藤花子',
                    status: MatchStatus.playing,
                    player1Number: 1,
                    player2Number: 2,
                  ),
                  MatchData(
                    tableNumber: 2,
                    player1Name: '山田次郎',
                    player2Name: '鈴木一郎',
                    status: MatchStatus.finished,
                    player2IsWinner: true,
                  ),
                  MatchData(
                    tableNumber: 3,
                    player1Name: '高橋三郎',
                    player2Name: '渡辺四郎',
                    status: MatchStatus.waiting,
                  ),
                ],
                onMatchTap: (match) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('テーブル ${match.tableNumber} をタップ'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              
              // TODO(component): 他のコンポーネントのテスト要素をここに追加
              ],
            ),
          ),
        ),
      ),
    );
  }
}
