import 'package:flutter/material.dart';

import '../../pages/home/tournament_list_page.dart';

/// トーナメントカードウィジェット
class TournamentCard extends StatelessWidget {
  /// トーナメントカードのコンストラクタ
  const TournamentCard({
    required this.tournament,
    super.key,
    this.onTap,
  });

  /// トーナメントデータ
  final TournamentData tournament;

  /// タップ時のコールバック
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: tournament.status == TournamentStatus.ongoing
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1B4F72),
                      Color(0xFF3A44FB),
                    ],
                  )
                : null,
            color: tournament.status == TournamentStatus.ongoing
                ? null
                : const Color(0xFFF0F0F5),
          ),
          child: Stack(
            children: [
              // ステータスバッジ
              if (tournament.status == TournamentStatus.ongoing ||
                  tournament.round != null)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusBadgeColor(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tournament.status == TournamentStatus.ongoing
                          ? tournament.round ?? '開催中'
                          : _getStatusText(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _getStatusTextColor(),
                      ),
                    ),
                  ),
                ),
              
              // メインコンテンツ
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    
                    // タイトル
                    Text(
                      tournament.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: tournament.status == TournamentStatus.ongoing
                            ? Colors.white
                            : const Color(0xFF000336),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    
                    // 詳細情報
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 16,
                          color: tournament.status == TournamentStatus.ongoing
                              ? Colors.white.withValues(alpha: 0.8)
                              : const Color(0xFF7A7A83),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          tournament.date,
                          style: TextStyle(
                            fontSize: 14,
                            color: tournament.status == TournamentStatus.ongoing
                                ? Colors.white.withValues(alpha: 0.8)
                                : const Color(0xFF7A7A83),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.people,
                          size: 16,
                          color: tournament.status == TournamentStatus.ongoing
                              ? Colors.white.withValues(alpha: 0.8)
                              : const Color(0xFF7A7A83),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${tournament.participants}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: tournament.status == TournamentStatus.ongoing
                                ? Colors.white.withValues(alpha: 0.8)
                                : const Color(0xFF7A7A83),
                          ),
                        ),
                      ],
                    ),
                    
                    // アクションボタン（開催中のみ）
                    if (tournament.status == TournamentStatus.ongoing) ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        width: 140,
                        height: 32,
                        child: ElevatedButton(
                          onPressed: onTap,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3A44FB),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text(
                            '対戦表を見る',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusBadgeColor() {
    switch (tournament.status) {
      case TournamentStatus.ongoing:
        return const Color(0xFFD8FF62);
      case TournamentStatus.upcoming:
        return const Color(0xFF3A44FB);
      case TournamentStatus.completed:
        return const Color(0xFF7A7A83);
    }
  }

  Color _getStatusTextColor() {
    switch (tournament.status) {
      case TournamentStatus.ongoing:
        return const Color(0xFF000336);
      case TournamentStatus.upcoming:
        return Colors.white;
      case TournamentStatus.completed:
        return Colors.white;
    }
  }

  String _getStatusText() {
    switch (tournament.status) {
      case TournamentStatus.ongoing:
        return '開催中';
      case TournamentStatus.upcoming:
        return '開催前';
      case TournamentStatus.completed:
        return '開催済';
    }
  }
}
