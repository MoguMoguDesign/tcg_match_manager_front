import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/layout/admin_scaffold.dart';

/// トーナメント詳細画面
///
/// Figmaデザイン: https://www.figma.com/design/A4NEf0vCuJNuPfBMTEa4OO/%E3%83%9E%E3%83%81%E3%82%B5%E3%83%9D?node-id=96-1200&t=whDUBuHITxOChCST-4
class TournamentDetailPage extends StatelessWidget {
  /// トーナメント詳細画面のコンストラクタ
  const TournamentDetailPage({required this.tournamentId, super.key});

  /// トーナメントID
  final String tournamentId;

  @override
  Widget build(BuildContext context) {
    // ダミーデータ
    final tournament = _getTournamentData(tournamentId);

    return AdminScaffold(
      title: '',
      actions: [
        // 戻るボタン
        IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
          color: const Color(0xFF000336),
        ),
        const Spacer(),

        // 編集ボタン
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.edit),
          label: const Text('編集'),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF000336), width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        const SizedBox(width: 16),
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // メインカード
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1B4F72), Color(0xFF3A44FB)],
                ),
              ),
              child: Stack(
                children: [
                  // ステータスバッジ
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD8FF62),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '開催前',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000336),
                        ),
                      ),
                    ),
                  ),

                  // メインコンテンツ
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),

                        // タイトル
                        Text(
                          tournament.title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 説明文
                        Container(
                          constraints: const BoxConstraints(maxWidth: 800),
                          child: Text(
                            tournament.description,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withValues(alpha: 0.9),
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // アクションボタン
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => _showQRDialog(context),
                              icon: const Icon(Icons.qr_code),
                              label: const Text('QRコードを確認'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3A44FB),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.people),
                              label: const Text('受付開始'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3A44FB),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 詳細情報カード
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 左側：基本情報
                Expanded(
                  flex: 2,
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '基本情報',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF000336),
                            ),
                          ),
                          const SizedBox(height: 20),

                          _buildInfoRow('開催日', tournament.date),
                          _buildInfoRow('時間', tournament.time),
                          _buildInfoRow(
                            '参加者上限',
                            '${tournament.maxParticipants}人',
                          ),
                          _buildInfoRow('最大ラウンド', tournament.maxRounds),
                          _buildInfoRow('引き分け処理', tournament.drawHandling),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 24),

                // 右側：参加者情報
                Expanded(
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '参加者情報',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF000336),
                            ),
                          ),
                          const SizedBox(height: 20),

                          _buildInfoRow(
                            '現在の参加者数',
                            '${tournament.currentParticipants}人',
                          ),
                          Builder(
                            builder: (context) {
                              final percentage =
                                  (tournament.currentParticipants /
                                          tournament.maxParticipants *
                                          100)
                                      .round();
                              return _buildInfoRow('参加率', '$percentage%');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 備考
            if (tournament.notes.isNotEmpty) ...[
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '備考',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000336),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        tournament.notes,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF7A7A83),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000336),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Color(0xFF7A7A83)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showQRDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('QRコード'),
        content: const SizedBox(width: 200, height: 200, child: Placeholder()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }

  TournamentDetailData _getTournamentData(String id) {
    return const TournamentDetailData(
      id: '1',
      title: 'トーナメントタイトル',
      description:
          '200文字の大会概要200文字の大会概要200文字の大会概要200文字の大会概要'
          '200文字の大会概要200文字の大会概要200文字の大会概要200文字の大会概要'
          '200文字の大会概要200文字の大会概要200文字の大会概要200文字の大会概要'
          '200文字の大会概要200文字の大会概要',
      date: '2025/08/31',
      time: '19:00-21:00',
      maxParticipants: 32,
      currentParticipants: 32,
      maxRounds: '勝者が1人になるまで',
      drawHandling: '両者敗北',
      notes:
          'テキストテキストテキストテキストテキストテキストテキストテキスト'
          'テキストテキストテキストテキストテキストテキストテキストテキスト'
          'テキストテキストテキストテキストテキストテキスト',
    );
  }
}

/// トーナメント詳細データクラス
class TournamentDetailData {
  /// トーナメント詳細データのコンストラクタ
  const TournamentDetailData({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.maxRounds,
    required this.drawHandling,
    required this.notes,
  });

  /// ID
  final String id;

  /// タイトル
  final String title;

  /// 説明
  final String description;

  /// 日付
  final String date;

  /// 時間
  final String time;

  /// 最大参加者数
  final int maxParticipants;

  /// 現在の参加者数
  final int currentParticipants;

  /// 最大ラウンド
  final String maxRounds;

  /// 引き分け処理
  final String drawHandling;

  /// 備考
  final String notes;
}
