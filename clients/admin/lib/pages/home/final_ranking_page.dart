import 'package:flutter/material.dart';

import '../../widgets/layout/admin_scaffold.dart';

/// 最終順位画面を表示する。
///
/// トーナメントの最終順位を表示するための画面を提供する。現在はプレースホルダーとして
/// 簡易な表示のみを行い、今後 Base UI のランキングコンポーネントを用いた実装に置き換える。
class AdminFinalRankingPage extends StatelessWidget {
  /// [AdminFinalRankingPage] のコンストラクタ。
  const AdminFinalRankingPage({super.key, required this.tournamentId});

  /// トーナメント ID。
  final String tournamentId;

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: '最終順位',
      actions: const [],
      body: const Center(
        child: Text('最終順位（準備中）', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
