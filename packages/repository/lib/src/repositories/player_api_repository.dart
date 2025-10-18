import '../api_clients/admin_api_client.dart';
import '../models/add_player_request.dart';
import '../models/player_model.dart';
import 'player_repository.dart';

/// AdminApiClient を使用したプレイヤーリポジトリの実装。
///
/// 管理者API経由でプレイヤー関連の操作を実行する。
class PlayerApiRepository implements PlayerRepository {
  /// [PlayerApiRepository]のコンストラクタ。
  const PlayerApiRepository({required AdminApiClient apiClient})
    : _apiClient = apiClient;

  final AdminApiClient _apiClient;

  @override
  Future<PlayerModel> addPlayer({
    required String tournamentId,
    required AddPlayerRequest request,
  }) async {
    final response = await _apiClient.post(
      '/admin/tournaments/$tournamentId/players',
      body: request.toJson(),
    );
    return _parsePlayerResponse(response);
  }

  /// プレイヤー登録のAPIレスポンスを解析してModelに変換する。
  PlayerModel _parsePlayerResponse(Map<String, dynamic> response) {
    try {
      return PlayerModel.fromJson(response);
    } catch (e) {
      throw AdminApiException(
        code: 'PARSE_ERROR',
        message: 'プレイヤーデータの変換中にエラーが発生しました: $e',
      );
    }
  }

  @override
  Future<List<PlayerModel>> getPlayers({
    required String tournamentId,
    String? status,
  }) async {
    final queryParams = status != null ? {'status': status} : null;
    final response = await _apiClient.get(
      '/admin/tournaments/$tournamentId/players',
      queryParameters: queryParams,
    );
    return _parsePlayersListResponse(response);
  }

  /// プレイヤー一覧のAPIレスポンスを解析してModelのリストに変換する。
  List<PlayerModel> _parsePlayersListResponse(Map<String, dynamic> response) {
    try {
      final data = response['players'] as List<dynamic>;
      return data
          .map((json) => PlayerModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw AdminApiException(
        code: 'PARSE_ERROR',
        message: 'プレイヤー一覧データの変換中にエラーが発生しました: $e',
      );
    }
  }
}
