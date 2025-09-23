import 'package:base_ui/base_ui.dart';
import 'package:flutter/material.dart';

import '../../pages/home/tournament_list_page.dart';

/// トーナメントカードウィジェット
class TournamentCard extends StatelessWidget {
  /// トーナメントカードのコンストラクタ
  const TournamentCard({required this.tournament, super.key, this.onTap});

  /// トーナメントデータ
  final TournamentData tournament;

  /// タップ時のコールバック
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // すべてのステータスで Base UI の TournamentTitleCard を使用する。
    final style = switch (tournament.status) {
      TournamentStatus.upcoming => TournamentCardStyle.admin,
      TournamentStatus.ongoing => TournamentCardStyle.primary,
      TournamentStatus.completed => TournamentCardStyle.secondary,
    };

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 145,
          padding: const EdgeInsets.all(8),
          child: TournamentTitleCard(
            title: tournament.title,
            subtitle: tournament.gameType,
            date: tournament.date,
            participantCount: tournament.participants,
            style: style,
          ),
        ),
      ),
    );
  }
}
