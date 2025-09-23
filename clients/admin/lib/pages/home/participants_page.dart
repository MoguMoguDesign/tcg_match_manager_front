import 'package:base_ui/base_ui.dart' as base_ui;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/layout/admin_scaffold.dart';

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
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
          color: const Color(0xFF000336),
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
                      Expanded(
                        child: Text(
                          '参加者一覧',
                          style: base_ui.AppTextStyles.headlineLarge.copyWith(
                            color: base_ui.AppColors.textBlack,
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 192,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: _showQRCode,
                          icon: const Icon(
                            Icons.qr_code,
                            size: 20,
                            color: Color(0xFF000336),
                          ),
                          label: const Text(
                            'QRコード表示',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF000336),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 0,
                            side: const BorderSide(
                              color: Color(0xFF000336),
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
          style: TextStyle(fontSize: 16, color: Color(0xFF7A7A83)),
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
              color: Color(0xFFF5F5F5),
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
                      color: Color(0xFF000336),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '参加者名',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000336),
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
                      color: Color(0xFF000336),
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
                      color: Color(0xFF000336),
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
                        color: const Color(0xFFE0E0E0),
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
                            color: Color(0xFF7A7A83),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          participant.name,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF000336),
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
                            color: Color(0xFF7A7A83),
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
                                color: Color(0xFFE53E3E),
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
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('参加者削除確認'),
        content: Text('${participant.name}を削除しますか？\nこの操作は取り消せません。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteParticipant(participant);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53E3E),
              foregroundColor: Colors.white,
            ),
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }

  void _deleteParticipant(ParticipantData participant) {
    // TODO(admin): 実際の削除処理を実装
    setState(() {
      _participants.removeWhere((p) => p.id == participant.id);
      _participantStatus.remove(participant.id);
      _nameControllers[participant.id]?.dispose();
      _nameControllers.remove(participant.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${participant.name}を削除しました'),
        backgroundColor: const Color(0xFF38A169),
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
                style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
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

  void _createRound() {
    // TODO(admin): 実際のラウンド作成処理を実装
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('ラウンドを作成しました'),
        backgroundColor: Color(0xFF38A169),
      ),
    );
  }

  void _showQRCode() {
    // TODO(admin): 実際のQRコード表示処理を実装
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('QRコードを表示します'),
        backgroundColor: Color(0xFF38A169),
      ),
    );
  }

  void _applyChanges() {
    // TODO(admin): 実際の変更反映処理を実装
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
        backgroundColor: Color(0xFF38A169),
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
        registeredAt: DateTime.now().subtract(Duration(days: index)),
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
                    Expanded(
                      child: Text(
                        '参加者一覧',
                        style: base_ui.AppTextStyles.headlineLarge.copyWith(
                          color: base_ui.AppColors.textBlack,
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 192,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _showQRCode,
                        icon: const Icon(
                          Icons.qr_code,
                          size: 20,
                          color: Color(0xFF000336),
                        ),
                        label: const Text(
                          'QRコード表示',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF000336),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          side: const BorderSide(
                            color: Color(0xFF000336),
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
    );
  }

  Widget _buildParticipantsList() {
    if (_participants.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: const Center(
          child: Text(
            '参加者がいません',
            style: TextStyle(fontSize: 16, color: Color(0xFF7A7A83)),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          // ヘッダー
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
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
                      color: Color(0xFF000336),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '参加者名',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000336),
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: Text(
                    'ステータス',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000336),
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
                      color: Color(0xFF000336),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 参加者リスト
          for (int index = 0; index < _participants.length; index++) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xFFE2E8F0),
                    width: index == _participants.length - 1 ? 0 : 1,
                  ),
                ),
              ),
              child: _buildParticipantRow(_participants[index], index + 1),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildParticipantRow(ParticipantData participant, int number) {
    final isParticipating = _participantStatus[participant.id] ?? true;
    final nameController = _nameControllers[participant.id]!;

    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '$number',
            style: const TextStyle(fontSize: 16, color: Color(0xFF7A7A83)),
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: nameController,
            style: const TextStyle(fontSize: 16, color: Color(0xFF000336)),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 参加中ラジオボタン
              GestureDetector(
                onTap: () {
                  setState(() {
                    _participantStatus[participant.id] = true;
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isParticipating
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: isParticipating
                          ? const Color(0xFF22C55E)
                          : const Color(0xFF9CA3AF),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '参加中',
                      style: TextStyle(
                        fontSize: 14,
                        color: isParticipating
                            ? const Color(0xFF22C55E)
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // ドロップラジオボタン
              GestureDetector(
                onTap: () {
                  setState(() {
                    _participantStatus[participant.id] = false;
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      !isParticipating
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: !isParticipating
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF9CA3AF),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'ドロップ',
                      style: TextStyle(
                        fontSize: 14,
                        color: !isParticipating
                            ? const Color(0xFFEF4444)
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 100,
          height: 40,
          child: base_ui.CommonConfirmButton(
            text: '削除',
            style: base_ui.ConfirmButtonStyle.alertOutlined,
            onPressed: () => _showDeleteDialog(participant),
          ),
        ),
      ],
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
                style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
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

  Future<void> _showDeleteDialog(ParticipantData participant) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('参加者削除確認'),
        content: Text('${participant.name}を削除しますか？\nこの操作は取り消せません。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteParticipant(participant);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53E3E),
              foregroundColor: Colors.white,
            ),
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }

  void _deleteParticipant(ParticipantData participant) {
    // TODO(admin): 実際の削除処理を実装
    setState(() {
      _participants.removeWhere((p) => p.id == participant.id);
      _participantStatus.remove(participant.id);
      _nameControllers[participant.id]?.dispose();
      _nameControllers.remove(participant.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${participant.name}を削除しました'),
        backgroundColor: const Color(0xFF38A169),
      ),
    );
  }

  void _createRound() {
    // TODO(admin): 実際のラウンド作成処理を実装
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('ラウンドを作成しました'),
        backgroundColor: Color(0xFF38A169),
      ),
    );
  }

  void _showQRCode() {
    // TODO(admin): 実際のQRコード表示処理を実装
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('QRコードを表示します'),
        backgroundColor: Color(0xFF38A169),
      ),
    );
  }

  void _applyChanges() {
    // TODO(admin): 実際の変更反映処理を実装
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
        backgroundColor: Color(0xFF38A169),
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
        registeredAt: DateTime.now().subtract(Duration(days: index)),
      );
    });
  }
}

/// 参加者データクラス
class ParticipantData {
  /// 参加者データのコンストラクタ
  const ParticipantData({
    required this.id,
    required this.name,
    required this.tournamentId,
    this.registeredAt,
  });

  /// 参加者ID
  final String id;

  /// 参加者名
  final String name;

  /// トーナメントID
  final String tournamentId;

  /// 登録日時
  final DateTime? registeredAt;
}
