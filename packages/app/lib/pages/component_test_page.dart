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
                Text(
                  'UI コンポーネントテストページ',
                  style: AppTextStyles.headlineLarge.copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Text(
                  'ここに各種コンポーネントを追加してテストできます。',
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // ✅ 実装済み: CommonConfirmButton(APP) - Figma node-id: 86-7960
                Text(
                  '✅ CommonConfirmButton(APP) - Figma 86-7960',
                  style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
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

                // ✅ 実装済み: CommonSmallButton - Figma node-id: 95-183
                Text(
                  '✅ CommonSmallButton - Figma 95-183',
                  style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
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
                          const SnackBar(
                            content: Text('CommonSmallButton: 管理者'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // 前のラウンド / 次のラウンド（アイコン付き）
                Row(
                  children: [
                    CommonSmallButton.leadingIcon(
                      text: '前のラウンド',
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('CommonSmallButton: 前のラウンド'),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    CommonSmallButton.trailingIcon(
                      text: '次のラウンド',
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('CommonSmallButton: 次のラウンド'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ✅ 実装済み: CommonConfirmButton(PC) - Figma node-id: 244-1212
                Text(
                  '✅ AdminConfirmButton (CommonConfirmButton(PC))\n'
                  'Figma 244-1212',
                  style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 12),
                AdminConfirmButton(
                  text: '管理者ボタン',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('AdminConfirmButton: アイコンなし'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                AdminConfirmButton.leadingIcon(
                  text: '管理者ボタン',
                  icon: const Icon(Icons.admin_panel_settings),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('AdminConfirmButton: 左アイコンあり'),
                      ),
                    );
                  },
                ),

                // ✅ 実装済み: ConfirmDialog - Figma node-id: 86-7764
                Text(
                  '✅ ConfirmDialog - Figma 86-7764',
                  style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
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

                // ✅ 実装済み: TextField - Figma node-id: 86-7923
                Text(
                  '✅ TextField - Figma 86-7923',
                  style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 12),
                const FigmaTextField(hintText: 'テキストを入力してください'),
                const SizedBox(height: 12),
                const PasswordTextField(hintText: 'パスワードを入力してください'),
                const SizedBox(height: 12),
                const SearchTextField(hintText: '検索キーワード'),
                const SizedBox(height: 12),
                DropdownSelectField<String>(
                  hintText: 'リストから選択',
                  items: const ['オプション1', 'オプション2', 'オプション3'],
                  onChanged: (value) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('選択: $value')));
                  },
                ),
                const SizedBox(height: 32),

                // ✅ 実装済み: TournamentTitleCard - Figma node-id: 244-5226
                Text(
                  '✅ TournamentTitleCard - Figma 244-5226',
                  style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 12),
                const TournamentTitleCard(
                  title: 'トーナメントタイトル',
                  date: '2025/08/31',
                  participantCount: 32,
                ),
                const SizedBox(height: 16),
                const TournamentTitleCard(
                  title: '春季トーナメント',
                  subtitle: '2024年4月開催',
                ),
                const SizedBox(height: 16),
                const TournamentTitleCard(
                  title: 'プレミアリーグ',
                  style: TournamentCardStyle.admin,
                  date: '2025/09/15',
                  participantCount: 16,
                ),
                const SizedBox(height: 24),

                // ✅ 実装済み: MatchStatusContainer - Figma node-id: 244-5549
                Text(
                  '✅ MatchStatusContainer - Figma 244-5549',
                  style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 12),
                const Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    MatchStatusContainer(status: MatchStatus.playing),
                    MatchStatusContainer(status: MatchStatus.finished),
                  ],
                ),
                const SizedBox(height: 24),

                // ✅ 実装済み: PlayerContainer - Figma 244-5574 (6種類)
                Text(
                  '✅ PlayerContainer - 6種類のデザインパターン',
                  style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 12),

                // 通常ユーザーパターン
                const Text(
                  '通常ユーザー:',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const PlayerContainer(
                  playerName: 'プレイヤー名',
                  state: PlayerState.progress,
                ),
                const SizedBox(height: 8),
                const PlayerContainer(
                  playerName: 'プレイヤー名',
                  state: PlayerState.win,
                ),
                const SizedBox(height: 8),
                const PlayerContainer(
                  playerName: 'プレイヤー名',
                  state: PlayerState.lose,
                ),
                const SizedBox(height: 16),

                // 現在ユーザーパターン
                const Text(
                  'カレントユーザー:',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const PlayerContainer(
                  playerName: 'プレイヤー名',
                  state: PlayerState.progress,
                  isCurrentUser: true,
                ),
                const SizedBox(height: 8),
                const PlayerContainer(
                  playerName: 'プレイヤー名',
                  state: PlayerState.win,
                  isCurrentUser: true,
                ),
                const SizedBox(height: 8),
                const PlayerContainer(
                  playerName: 'プレイヤー名',
                  state: PlayerState.lose,
                  isCurrentUser: true,
                ),
                const SizedBox(height: 24),

                // ✅ 実装済み: VSContainer - 9パターンデザイン
                Text(
                  '✅ VSContainer - 9パターンデザイン',
                  style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 12),
                // Progress状態のパターン
                Text(
                  'Progress States',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        VSContainer(
                          state: VSContainerState.progress,
                          currentUserPosition: VSContainerUserPosition.none,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Progress',
                          style: TextStyle(color: Colors.white70, fontSize: 10),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        VSContainer(
                          state: VSContainerState.progress,
                          currentUserPosition: VSContainerUserPosition.left,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'User Left',
                          style: TextStyle(color: Colors.white70, fontSize: 10),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        VSContainer(
                          state: VSContainerState.progress,
                          currentUserPosition: VSContainerUserPosition.right,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'User Right',
                          style: TextStyle(color: Colors.white70, fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Left Player Win状態のパターン
                Text(
                  'Left Player Win States',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        VSContainer(
                          state: VSContainerState.leftPlayerWin,
                          currentUserPosition: VSContainerUserPosition.none,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Left Win',
                          style: TextStyle(color: Colors.white70, fontSize: 10),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        VSContainer(
                          state: VSContainerState.leftPlayerWin,
                          currentUserPosition: VSContainerUserPosition.left,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Win User Left',
                          style: TextStyle(color: Colors.white70, fontSize: 10),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        VSContainer(
                          state: VSContainerState.leftPlayerWin,
                          currentUserPosition: VSContainerUserPosition.right,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Win User Right',
                          style: TextStyle(color: Colors.white70, fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Left Player Lose状態のパターン
                Text(
                  'Left Player Lose States',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        VSContainer(
                          state: VSContainerState.leftPlayerLose,
                          currentUserPosition: VSContainerUserPosition.none,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Left Lose',
                          style: TextStyle(color: Colors.white70, fontSize: 10),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        VSContainer(
                          state: VSContainerState.leftPlayerLose,
                          currentUserPosition: VSContainerUserPosition.left,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Lose User Left',
                          style: TextStyle(color: Colors.white70, fontSize: 10),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        VSContainer(
                          state: VSContainerState.leftPlayerLose,
                          currentUserPosition: VSContainerUserPosition.right,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Lose User Right',
                          style: TextStyle(color: Colors.white70, fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ✅ 実装済み: TableNumberColumn - Figma node-id: 244-5517
                Text(
                  '✅ TableNumberColumn - Figma 244-5517',
                  style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 12),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TableNumberColumn(
                      tableNumber: 1,
                      status: MatchStatus.playing,
                    ),
                    TableNumberColumn(
                      tableNumber: 2,
                      status: MatchStatus.playing,
                    ),
                    TableNumberColumn(
                      tableNumber: 3,
                      status: MatchStatus.finished,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ✅ 実装済み: PlayersContainer - Figma node-id: 253-5745
                Text(
                  '✅ PlayersContainer - Figma 253-5745',
                  style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 12),
                // 1. Progress vs Progress (通常)
                const PlayersContainer(player1Name: '左通常', player2Name: '右通常'),
                const SizedBox(height: 8),
                // 2. Progress vs Progress (左自分)
                const PlayersContainer(
                  player1Name: '左自分',
                  player2Name: '右通常',
                  player1IsCurrentUser: true,
                ),
                const SizedBox(height: 8),
                // 3. Progress vs Progress (右自分)
                const PlayersContainer(
                  player1Name: '左通常',
                  player2Name: '右自分',
                  player2IsCurrentUser: true,
                ),
                const SizedBox(height: 8),
                // 4. Win vs Lose (左勝ち)
                const PlayersContainer(
                  player1Name: '左勝ち',
                  player2Name: '右負け',
                  player1State: PlayerState.win,
                  player2State: PlayerState.lose,
                ),
                const SizedBox(height: 8),
                // 5. Win vs Lose (左自分勝ち)
                const PlayersContainer(
                  player1Name: '左自分勝ち',
                  player2Name: '右負け',
                  player1State: PlayerState.win,
                  player2State: PlayerState.lose,
                  player1IsCurrentUser: true,
                ),
                const SizedBox(height: 8),
                // 6. Win vs Lose (右自分負け)
                const PlayersContainer(
                  player1Name: '左勝ち',
                  player2Name: '右自分負け',
                  player1State: PlayerState.win,
                  player2State: PlayerState.lose,
                  player2IsCurrentUser: true,
                ),
                const SizedBox(height: 8),
                // 7. Lose vs Win (左負け)
                const PlayersContainer(
                  player1Name: '左負け',
                  player2Name: '右勝ち',
                  player1State: PlayerState.lose,
                  player2State: PlayerState.win,
                ),
                const SizedBox(height: 8),
                // 8. Lose vs Win (左自分負け)
                const PlayersContainer(
                  player1Name: '左自分負け',
                  player2Name: '右勝ち',
                  player1State: PlayerState.lose,
                  player2State: PlayerState.win,
                  player1IsCurrentUser: true,
                ),
                const SizedBox(height: 8),
                // 9. Lose vs Win (右自分勝ち)
                const PlayersContainer(
                  player1Name: '左負け',
                  player2Name: '右自分勝ち',
                  player1State: PlayerState.lose,
                  player2State: PlayerState.win,
                  player2IsCurrentUser: true,
                ),
                const SizedBox(height: 24),

                // ✅ 実装済み: ResultContainer - Figma node-id: 255-2469
                Text(
                  '✅ ResultContainer - Figma 255-2469',
                  style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
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
                      result: ResultData(value: '2-1'),
                      style: ResultContainerStyle.secondary,
                      size: ResultContainerSize.large,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ✅ 実装済み: MatchList - Figma node-id: 253-6796
                Text(
                  '✅ MatchList - Figma 253-6796',
                  style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
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
                      player1State: PlayerState.progress,
                      player2State: PlayerState.progress,
                    ),
                    MatchData(
                      tableNumber: 2,
                      player1Name: '山田次郎',
                      player2Name: '鈴木一郎',
                      status: MatchStatus.finished,
                      player2State: PlayerState.win,
                    ),
                    MatchData(
                      tableNumber: 3,
                      player1Name: '高橋三郎',
                      player2Name: '渡辺四郎',
                      status: MatchStatus.playing,
                    ),
                  ],
                  onMatchTap: (match) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('テーブル ${match.tableNumber} をタップ')),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // === 未実装コンポーネント ===
                Text(
                  '❌ 未実装コンポーネント',
                  style: AppTextStyles.headlineLarge.copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // ✅ 実装済み: DialogButtons - Figma node-id: 86-7843
                Text(
                  '✅ DialogButtons - Figma 86-7843',
                  style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 12),
                // Default（2ボタン）
                DialogButtons(
                  primaryText: '決定',
                  onPrimaryPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('DialogButtons: 決定')),
                    );
                  },
                  secondaryText: 'キャンセル',
                  onSecondaryPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('DialogButtons: キャンセル')),
                    );
                  },
                ),
                const SizedBox(height: 12),
                // OnlyClose（1ボタン）
                DialogButtons(
                  primaryText: '決定',
                  onPrimaryPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('DialogButtons: 決定のみ')),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // ❌ 未実装: MatchRow - Figma node-id: 253-6227
                Text(
                  '❌ MatchRow - Figma 253-6227',
                  style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 12),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      '未実装: MatchRow',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ❌ 未実装: MatchListHeader - Figma node-id: 253-6083
                Text(
                  '❌ MatchListHeader - Figma 253-6083',
                  style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 12),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      '未実装: MatchListHeader',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ❌ 注意: TournamentTitleCard重複 - Figma node-id: 254-2411
                Text(
                  '❌ TournamentTitleCard (重複？) - Figma 254-2411',
                  style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 12),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      '重複？要確認: TournamentTitleCard',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
