import 'package:base_ui/base_ui.dart' as base_ui;
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/participant_data.dart';
import '../../widgets/layout/admin_scaffold.dart';
import '../../widgets/tournament/participant_table.dart';
import '../../widgets/tournament/tournament_footer.dart';
import '../dialogs/qr_display_dialog.dart';
import '../dialogs/user_delete_dialog.dart';

/// 参加者一覧画面
///
/// Figmaデザイン: https://www.figma.com/design/A4NEf0vCuJNuPfBMTEa4OO/%E3%83%9E%E3%83%81%E3%82%B5%E3%83%9D?node-id=512-5245&t=whDUBuHITxOChCST-4
class ParticipantsPage extends StatefulWidget {
  /// 参加者一覧画面のコンストラクタ
  const ParticipantsPage({required this.tournamentId, super.key});

  /// トーナメントID
  final String tournamentId;

  @override
  State<ParticipantsPage> createState() => _ParticipantsPageState();
}

class _ParticipantsPageState extends State<ParticipantsPage> {
  final List<ParticipantData> _participants = [];
  final Map<String, bool> _participantStatus = {}; // true: 参加中, false: ドロップ
  final Map<String, TextEditingController> _nameControllers = {};

  @override
  void initState() {
    super.initState();
    _initializeParticipants();
  }

  void _initializeParticipants() {
    _participants.addAll(_getParticipants());
    for (final participant in _participants) {
      _participantStatus[participant.id] = true; // デフォルトで参加中
      _nameControllers[participant.id] = TextEditingController(
        text: participant.name,
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _nameControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: '参加者一覧',
      actions: [
        // 戻るボタン
        IconButton(
          onPressed: () => _handleBack(context),
          icon: const Icon(Icons.arrow_back),
          color: base_ui.AppColors.textBlack,
        ),
        const Spacer(),
      ],
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // ヘッダーとボタン
                  Row(
                    children: [
                      Text(
                        '参加者一覧',
                        style: base_ui.AppTextStyles.headlineLarge.copyWith(
                          color: base_ui.AppColors.textBlack,
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 192,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: _showQRCode,
                          icon: const Icon(
                            Icons.qr_code,
                            size: 20,
                            color: base_ui.AppColors.textBlack,
                          ),
                          label: const Text(
                            'QRコード表示',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: base_ui.AppColors.textBlack,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 0,
                            side: const BorderSide(
                              color: base_ui.AppColors.textBlack,
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 240,
                        height: 56,
                        child: base_ui.CommonConfirmButton(
                          text: 'ラウンド作成(大会開始)',
                          style: base_ui.ConfirmButtonStyle.adminFilled,
                          onPressed: _createRound,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          // 参加者リスト
          SliverToBoxAdapter(child: _buildParticipantsList()),
          // フッター
          SliverToBoxAdapter(child: _buildFooter()),
        ],
      ),
    );
  }

  Widget _buildParticipantsList() {
    final participants = _getParticipants();

    if (participants.isEmpty) {
      return const Center(
        child: Text(
          '参加者がいません',
          style: TextStyle(fontSize: 16, color: base_ui.AppColors.grayDark),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          // ヘッダー
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: base_ui.AppColors.backgroundField,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    'No.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: base_ui.AppColors.textBlack,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '参加者名',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: base_ui.AppColors.textBlack,
                    ),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: Text(
                    '登録日時',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: base_ui.AppColors.textBlack,
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    '操作',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: base_ui.AppColors.textBlack,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 参加者リスト
          Expanded(
            child: ListView.builder(
              itemCount: participants.length,
              itemBuilder: (context, index) {
                final participant = participants[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: base_ui.AppColors.borderLight,
                        width: index == participants.length - 1 ? 0 : 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: base_ui.AppColors.grayDark,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          participant.name,
                          style: const TextStyle(
                            fontSize: 16,
                            color: base_ui.AppColors.textBlack,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        child: Text(
                          participant.registeredAt != null
                              ? '${participant.registeredAt!.month}/${participant.registeredAt!.day} ${participant.registeredAt!.hour}:${participant.registeredAt!.minute.toString().padLeft(2, '0')}'
                              : '-',
                          style: const TextStyle(
                            fontSize: 14,
                            color: base_ui.AppColors.grayDark,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () => _showDeleteDialog(participant),
                              icon: const Icon(
                                Icons.delete,
                                color: base_ui.AppColors.alart,
                                size: 20,
                              ),
                              tooltip: '削除',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteDialog(ParticipantData participant) async {
    final confirmed = await showUserDeleteDialog(
      context,
      userName: participant.name,
    );

    if (confirmed ?? false) {
      _deleteParticipant(participant);
    }
  }

  void _deleteParticipant(ParticipantData participant) {
    // 実際の削除処理を実装する必要があります
    setState(() {
      _participants.removeWhere((p) => p.id == participant.id);
      _participantStatus.remove(participant.id);
      _nameControllers[participant.id]?.dispose();
      _nameControllers.remove(participant.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${participant.name}を削除しました'),
        backgroundColor: base_ui.AppColors.success,
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // 最大人数表示を右下に配置
          const Row(
            children: [
              Spacer(),
              Text(
                '最大人数: 32人',
                style: TextStyle(
                  fontSize: 14,
                  color: base_ui.AppColors.textGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 変更を反映ボタンを中央に配置
          Center(
            child: SizedBox(
              width: 192,
              height: 56,
              child: base_ui.CommonConfirmButton(
                text: '変更を反映',
                style: base_ui.ConfirmButtonStyle.adminFilled,
                onPressed: _applyChanges,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createRound() async {
    // 実際のラウンド作成処理を実装する必要があります
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('ラウンドを作成しました'),
        backgroundColor: base_ui.AppColors.success,
      ),
    );

    // 対戦表タブに切り替え（親のTabControllerを操作）
    // 親のTabControllerにアクセスして対戦表タブ（index: 2）に切り替える実装が必要
  }

  Future<void> _showQRCode() async {
    await showQRDisplayDialog(
      context,
      tournamentId: widget.tournamentId,
      tournamentTitle: 'トーナメントタイトル', // 実際のトーナメントタイトルを取得する必要があります
    );
  }

  void _applyChanges() {
    // 実際の変更反映処理を実装する必要があります
    // 名前の変更を適用
    for (final participant in _participants) {
      final newName = _nameControllers[participant.id]?.text ?? '';
      if (newName != participant.name) {
        // 名前を更新
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('変更を反映しました'),
        backgroundColor: base_ui.AppColors.success,
      ),
    );
  }

  /// 安全な戻る処理
  /// ナビゲーションスタックをチェックしてから適切に戻る
  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      // popできない場合はトーナメント一覧にリダイレクト
      context.go('/tournaments');
    }
  }

  // ダミーデータ生成メソッド
  List<ParticipantData> _getParticipants() {
    return List.generate(16, (index) {
      return ParticipantData(
        id: 'participant_$index',
        name: '参加者${index + 1}',
        tournamentId: widget.tournamentId,
        registeredAt: clock.now().subtract(Duration(days: index)),
      );
    });
  }
}

/// 参加者一覧コンテンツ。
///
/// AdminScaffold を含まない、タブ内などで再利用するためのコンテンツ部分を提供する。
class ParticipantsContent extends StatefulWidget {
  /// 参加者一覧コンテンツのコンストラクタ。
  const ParticipantsContent({required this.tournamentId, super.key});

  /// トーナメント ID。
  final String tournamentId;

  @override
  State<ParticipantsContent> createState() => _ParticipantsContentState();
}

class _ParticipantsContentState extends State<ParticipantsContent> {
  final List<ParticipantData> _participants = [];
  final Map<String, bool> _participantStatus = {}; // true: 参加中, false: ドロップ
  final Map<String, TextEditingController> _nameControllers = {};

  @override
  void initState() {
    super.initState();
    _initializeParticipants();
  }

  void _initializeParticipants() {
    _participants.addAll(_getParticipants());
    for (final participant in _participants) {
      _participantStatus[participant.id] = true; // デフォルトで参加中
      _nameControllers[participant.id] = TextEditingController(
        text: participant.name,
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _nameControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // ヘッダーとボタン
                Row(
                  children: [
                    // Expanded(
                    //   child: Text(
                    //     '参加者一覧',
                    //     style: base_ui.AppTextStyles.headlineLarge.copyWith(
                    //       color: base_ui.AppColors.textBlack,
                    //       fontSize: 24,
                    //       fontWeight: FontWeight.w600,
                    //     ),
                    //   ),
                    // ),
                    const Spacer(),
                    SizedBox(
                      width: 192,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _showQRCode,
                        icon: const Icon(
                          Icons.qr_code,
                          size: 20,
                          color: base_ui.AppColors.textBlack,
                        ),
                        label: const Text(
                          'QRコード表示',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: base_ui.AppColors.textBlack,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          side: const BorderSide(
                            color: base_ui.AppColors.textBlack,
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 240,
                      height: 56,
                      child: base_ui.CommonConfirmButton(
                        text: 'ラウンド作成(大会開始)',
                        style: base_ui.ConfirmButtonStyle.adminFilled,
                        onPressed: _createRound,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // 参加者リスト
        SliverToBoxAdapter(
          child: ParticipantTable(
            participants: _participants,
            participantStatus: _participantStatus,
            nameControllers: _nameControllers,
            onStatusChanged: (participantId, {required isParticipating}) {
              setState(() {
                _participantStatus[participantId] = isParticipating;
              });
            },
            onDelete: _showDeleteDialog,
          ),
        ),
        // フッター
        SliverToBoxAdapter(
          child: TournamentFooter(
            maxParticipants: 32,
            actionButtonText: '変更を反映',
            onActionPressed: _applyChanges,
          ),
        ),
      ],
    );
  }

  Future<void> _showDeleteDialog(ParticipantData participant) async {
    final confirmed = await showUserDeleteDialog(
      context,
      userName: participant.name,
    );

    if (confirmed ?? false) {
      _deleteParticipant(participant);
    }
  }

  void _deleteParticipant(ParticipantData participant) {
    // 実際の削除処理を実装する必要があります
    setState(() {
      _participants.removeWhere((p) => p.id == participant.id);
      _participantStatus.remove(participant.id);
      _nameControllers[participant.id]?.dispose();
      _nameControllers.remove(participant.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${participant.name}を削除しました'),
        backgroundColor: base_ui.AppColors.success,
      ),
    );
  }

  Future<void> _createRound() async {
    // 実際のラウンド作成処理を実装する必要があります
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('ラウンドを作成しました'),
        backgroundColor: base_ui.AppColors.success,
      ),
    );

    // 対戦表タブに切り替え（親のTabControllerを操作）
    // 親のTabControllerにアクセスして対戦表タブ（index: 2）に切り替える実装が必要
  }

  Future<void> _showQRCode() async {
    await showQRDisplayDialog(
      context,
      tournamentId: widget.tournamentId,
      tournamentTitle: 'トーナメントタイトル', // 実際のトーナメントタイトルを取得する必要があります
    );
  }

  void _applyChanges() {
    // 実際の変更反映処理を実装する必要があります
    // 名前の変更を適用
    for (final participant in _participants) {
      final newName = _nameControllers[participant.id]?.text ?? '';
      if (newName != participant.name) {
        // 名前を更新
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('変更を反映しました'),
        backgroundColor: base_ui.AppColors.success,
      ),
    );
  }

  // ダミーデータ生成メソッド
  List<ParticipantData> _getParticipants() {
    return List.generate(16, (index) {
      return ParticipantData(
        id: 'participant_$index',
        name: '参加者${index + 1}',
        tournamentId: widget.tournamentId,
        registeredAt: clock.now().subtract(Duration(days: index)),
      );
    });
  }
}
