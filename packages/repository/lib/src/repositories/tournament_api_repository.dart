import '../api_clients/admin_api_client.dart';
import '../models/create_tournament_request.dart';
import '../models/tournament_model.dart';
import '../models/update_tournament_request.dart';
import 'tournament_repository.dart';

/// AdminApiClient を使用したトーナメントリポジトリの実装。
///
/// 管理者API経由でトーナメント関連の操作を実行する。
/// Firebase Authentication による認証を行い、HTTPリクエストでAPIと通信する。
class TournamentApiRepository implements TournamentRepository {
  /// [TournamentApiRepository]のコンストラクタ。
  const TournamentApiRepository({required AdminApiClient apiClient})
    : _apiClient = apiClient;

  final AdminApiClient _apiClient;

  @override
  Future<TournamentModel> createTournament(
    CreateTournamentRequest request,
  ) async {
    final response = await _apiClient.post(
      '/admin/tournaments',
      body: request.toJson(),
    );

    return _parseTournamentResponse(response);
  }

  /// トーナメント作成のAPIレスポンスを解析してModelに変換する。
  ///
  /// [response]: API レスポンスのJSON データ
  ///
  /// Returns: 作成された [TournamentModel]
  /// Throws: [AdminApiException] レスポンス形式が不正な場合
  TournamentModel _parseTournamentResponse(Map<String, dynamic> response) {
    try {
      return TournamentModel.fromJson(response);
    } catch (e) {
      throw AdminApiException(
        code: 'PARSE_ERROR',
        message: 'トーナメントデータの変換中にエラーが発生しました: $e',
      );
    }
  }

  @override
  Future<List<TournamentModel>> getTournaments() async {
    final response = await _apiClient.get('/admin/tournaments');

    return _parseTournamentsResponse(response);
  }

  @override
  Future<TournamentModel> getTournament(String id) async {
    // 入力検証
    if (id.isEmpty) {
      throw const AdminApiException(
        code: 'INVALID_ARGUMENT',
        message: 'トーナメントIDは必須です',
      );
    }

    final response = await _apiClient.get('/admin/tournaments/$id');

    return _parseTournamentResponse(response);
  }

  @override
  Future<TournamentModel> updateTournament(
    String id,
    UpdateTournamentRequest request,
  ) async {
    // 入力検証
    if (id.isEmpty) {
      throw const AdminApiException(
        code: 'INVALID_ARGUMENT',
        message: 'トーナメントIDは必須です',
      );
    }

    if (!request.hasUpdates) {
      throw const AdminApiException(
        code: 'INVALID_ARGUMENT',
        message: '更新するフィールドが指定されていません',
      );
    }

    final response = await _apiClient.patch(
      '/admin/tournaments/$id',
      body: request.toJson(),
    );

    return _parseTournamentResponse(response);
  }

  @override
  Future<void> deleteTournament(String id) async {
    // 入力検証
    if (id.isEmpty) {
      throw const AdminApiException(
        code: 'INVALID_ARGUMENT',
        message: 'トーナメントIDは必須です',
      );
    }

    await _apiClient.delete('/admin/tournaments/$id');

    // DELETE操作は正常完了時にレスポンスボディを必要としない
    // HTTPステータス 200 (OK) または 204 (No Content) で成功を判断
    // エラーの場合は AdminApiClient 内で AdminApiException がスローされる
  }

  /// トーナメント一覧のAPIレスポンスを解析してModelのリストに変換する。
  ///
  /// [response]: API レスポンスのJSON データ
  ///
  /// Returns: [TournamentModel] のリスト
  /// Throws: [AdminApiException] レスポンス形式が不正な場合
  List<TournamentModel> _parseTournamentsResponse(
    Map<String, dynamic> response,
  ) {
    // dataフィールドの存在確認
    if (!response.containsKey('data')) {
      throw const AdminApiException(
        code: 'INVALID_RESPONSE',
        message: 'APIレスポンスに"data"フィールドが含まれていません',
      );
    }

    final data = response['data'];

    // dataがListかどうか確認
    if (data is! List) {
      throw AdminApiException(
        code: 'INVALID_RESPONSE',
        message:
            'APIレスポンスの"data"フィールドがList型ではありません'
            '（実際の型: ${data.runtimeType}）',
      );
    }

    // 各要素をTournamentModelに変換
    try {
      return data.map((item) {
        if (item is! Map<String, dynamic>) {
          throw AdminApiException(
            code: 'INVALID_RESPONSE',
            message:
                'トーナメントデータの形式が不正です'
                '（期待: Map<String, dynamic>、実際: ${item.runtimeType}）',
          );
        }
        return TournamentModel.fromJson(item);
      }).toList();
    } catch (e) {
      if (e is AdminApiException) {
        rethrow;
      }

      throw AdminApiException(
        code: 'PARSE_ERROR',
        message: 'トーナメントデータの変換中にエラーが発生しました: $e',
      );
    }
  }
}
