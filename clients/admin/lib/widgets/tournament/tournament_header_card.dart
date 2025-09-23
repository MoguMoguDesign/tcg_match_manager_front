import 'package:base_ui/base_ui.dart';
import 'package:flutter/material.dart';

import '../../models/tournament_display_data.dart';

/// トーナメント情報を表示するヘッダーカード
class TournamentHeaderCard extends StatelessWidget {
  /// ヘッダーカードのコンストラクタ
  const TournamentHeaderCard({
    required this.tournament,
    this.height = 101,
    this.showStatusLabel = true,
    super.key,
  });

  /// トーナメントデータ
  final TournamentDisplayData tournament;

  /// カードの高さ
  final double height;

  /// ステータスラベルを表示するかどうか
  final bool showStatusLabel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // メインカード
        Container(
          height: height,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment(-0.8, -1),
              end: Alignment(1, 0.6),
              colors: [
                AppColors.gradientDarkBlue,
                AppColors.gradientBlack,
                AppColors.userPrimary,
              ],
              stops: [0.0, 0.8, 1.0],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(58, 68, 251, 0.1),
                blurRadius: 20,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // タイトル
                Text(
                  tournament.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 6),
                // メタ情報行（日時 / 参加者 / 種別）
                Row(
                  children: [
                    // 日時情報
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              tournament.date,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // 参加者情報
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.person, size: 18, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          tournament.maxParticipants.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    // ゲーム種別
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.category_outlined,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          tournament.gameType,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // 右上のステータスラベル
        if (showStatusLabel)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              height: 30,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 5.5,
              ),
              decoration: const BoxDecoration(
                color: AppColors.userPrimary,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: Text(
                _getStatusText(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textBlack,
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _getStatusText() {
    switch (tournament.status) {
      case TournamentStatus.upcoming:
        return tournament.status.displayName;
      case TournamentStatus.ongoing:
        return tournament.currentRound != null
            ? 'ラウンド${tournament.currentRound}'
            : tournament.status.displayName;
      case TournamentStatus.completed:
        return tournament.status.displayName;
    }
  }
}
