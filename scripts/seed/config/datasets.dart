/// 利用可能なテストデータセットを定義する。
enum TestDataset {
  /// 小規模トーナメント（8 人、開催中）。
  small('small', 'テスト大会（小規模・開催中）'),

  /// BYE マッチを含むトーナメント（9 人）。
  bye('bye', 'テスト大会（BYE あり）'),

  /// 完了済みトーナメント（8 人、3 ラウンド完了）。
  completed('completed', 'テスト大会（完了済み）'),

  /// 開催前トーナメント（プレイヤー登録受付中）。
  preparing('preparing', 'テスト大会（開催前）');

  const TestDataset(this.id, this.displayName);

  /// データセット ID。
  final String id;

  /// 表示名。
  final String displayName;

  /// ID から TestDataset を取得する。
  static TestDataset fromId(String id) {
    return TestDataset.values.firstWhere(
      (dataset) => dataset.id == id,
      orElse: () => throw ArgumentError('不明なデータセット: $id'),
    );
  }

  /// すべてのデータセット ID を取得する。
  static List<String> get allIds {
    return TestDataset.values.map((d) => d.id).toList();
  }
}
