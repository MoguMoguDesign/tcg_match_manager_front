import '../models/create_tournament_request.dart';
import '../models/tournament_model.dart';
import '../models/update_tournament_request.dart';

/// トーナメント関連の操作を定義するリポジトリインターフェース。
///
/// データソース（API、ローカルDB等）の実装詳細を隠蔽し、
/// アプリケーション層に対して統一されたインターフェースを提供する。
abstract interface class TournamentRepository {
  /// 新しいトーナメントを作成する。
  ///
  /// [request]: トーナメント作成リクエスト
  ///
  /// Returns: 作成されたトーナメント情報
  /// Throws: トーナメント作成に失敗した場合
  Future<TournamentModel> createTournament(CreateTournamentRequest request);

  /// 全てのトーナメント一覧を取得する。
  ///
  /// Returns: トーナメント一覧
  /// Throws: 取得に失敗した場合
  Future<List<TournamentModel>> getTournaments();

  /// 指定されたIDのトーナメント詳細を取得する。
  ///
  /// [id]: 取得するトーナメントのID
  ///
  /// Returns: 指定されたトーナメントの詳細情報
  /// Throws: トーナメントが見つからない場合や取得に失敗した場合
  Future<TournamentModel> getTournament(String id);

  /// 指定されたIDのトーナメント情報を更新する。
  ///
  /// [id]: 更新するトーナメントのID
  /// [request]: トーナメント更新リクエスト
  ///
  /// Returns: 更新されたトーナメント情報
  /// Throws: トーナメントが見つからない場合や更新に失敗した場合
  Future<TournamentModel> updateTournament(
      String id, UpdateTournamentRequest request);

  /// 指定されたIDのトーナメントを削除する。
  ///
  /// [id]: 削除するトーナメントのID
  ///
  /// Throws: トーナメントが見つからない場合や削除に失敗した場合
  Future<void> deleteTournament(String id);
}
