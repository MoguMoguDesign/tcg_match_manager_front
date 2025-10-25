import '../models/tournament_data.dart';
import 'bye_tournament_generator.dart';
import 'completed_tournament_generator.dart';
import 'preparing_tournament_generator.dart';
import 'small_tournament_generator.dart';
import 'tournament_generator.dart';

/// データセットファクトリー。
///
/// データセット ID から適切な [TournamentGenerator] を生成する。
class DatasetFactory {
  /// データセット ID からトーナメントデータを生成する。
  ///
  /// [datasetId] データセット ID（small, bye, completed, preparing）。
  TournamentData generate(String datasetId) {
    final generator = _createGenerator(datasetId);
    return generator.generate();
  }

  /// データセット ID から Generator を作成する。
  TournamentGenerator _createGenerator(String datasetId) {
    switch (datasetId) {
      case 'small':
        return SmallTournamentGenerator();
      case 'bye':
        return ByeTournamentGenerator();
      case 'completed':
        return CompletedTournamentGenerator();
      case 'preparing':
        return PreparingTournamentGenerator();
      default:
        throw ArgumentError('不明なデータセット: $datasetId');
    }
  }
}
