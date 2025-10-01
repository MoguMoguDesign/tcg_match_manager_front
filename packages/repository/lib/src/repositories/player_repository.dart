import '../models/add_player_request.dart';
import '../models/player_model.dart';

/// プレイヤーリポジトリインターフェース。
abstract class PlayerRepository {
  /// プレイヤーを登録する。
  ///
  /// [tournamentId] トーナメントID。
  /// [request] プレイヤー登録リクエスト。
  /// 成功時は [PlayerModel] を返す。
  Future<PlayerModel> addPlayer({
    required String tournamentId,
    required AddPlayerRequest request,
  });

  /// プレイヤー一覧を取得する。
  ///
  /// [tournamentId] トーナメントID。
  /// [status] プレイヤーステータス (オプション)。
  /// 成功時は [PlayerModel] のリストを返す。
  Future<List<PlayerModel>> getPlayers({
    required String tournamentId,
    String? status,
  });
}
