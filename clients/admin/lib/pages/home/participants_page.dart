import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/layout/admin_scaffold.dart';
import 'tournament_list_page.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ヘッダー情報
            Row(
              children: [
                const Text(
                  '参加者管理',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000336),
                  ),
                ),
                const Spacer(),
                Text(
                  '参加者数: ${_getParticipants().length}人',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF7A7A83),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 参加者リスト
            Expanded(child: _buildParticipantsList()),
          ],
        ),
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${participant.name}を削除しました'),
        backgroundColor: const Color(0xFF38A169),
      ),
    );
    setState(() {});
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ヘッダー情報
          Row(
            children: [
              const Text(
                '参加者管理',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000336),
                ),
              ),
              const Spacer(),
              Text(
                '参加者数: ${_getParticipants().length}人',
                style: const TextStyle(fontSize: 16, color: Color(0xFF7A7A83)),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 参加者リスト
          Expanded(child: _buildParticipantsList()),
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${participant.name}を削除しました'),
        backgroundColor: const Color(0xFF38A169),
      ),
    );
    setState(() {});
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
