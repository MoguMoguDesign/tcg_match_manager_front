import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injection/injection.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:system/system.dart';

import '../models/player_model.dart';
import '../repository_result.dart';
import 'player_registration_request.dart';
import 'player_registration_response.dart';

part 'player_registration_repository.g.dart';

/// [PlayerRegistrationRepository] を提供する。
@riverpod
PlayerRegistrationRepository playerRegistrationRepository(Ref ref) {
  return PlayerRegistrationRepository(
    httpClient: ref.watch(httpClientProvider),
    firestore: ref.watch(firestoreProvider),
  );
}

/// プレイヤー登録に関する通信を行うためのリポジトリ。
class PlayerRegistrationRepository {
  /// [PlayerRegistrationRepository] を生成する。
  ///
  /// [httpClient] は、HTTP 通信を行うためのクライアント。
  /// [firestore] は、Firestore インスタンス。
  PlayerRegistrationRepository({
    required HttpClient httpClient,
    required FirebaseFirestore firestore,
  })  : _httpClient = httpClient,
        _firestore = firestore;

  final HttpClient _httpClient;
  final FirebaseFirestore _firestore;

  /// API バージョン。
  static const _apiVersion = 'v1';

  /// プレイヤーを登録する。
  ///
  /// - [baseUrl] は、API のベース URL。
  /// - [tournamentId] は、大会 ID。
  /// - [request] は、プレイヤー登録リクエスト。
  Future<RepositoryResult<PlayerRegistrationResponse>> registerPlayer({
    required String baseUrl,
    required String tournamentId,
    required PlayerRegistrationRequest request,
  }) async {
    // リクエストボディを作成する。
    final requestBody = request.toJson();

    // URL を生成する。
    final uri = Uri.parse(baseUrl).replace(
      path: '${Uri.parse(baseUrl).path}player/api/$_apiVersion/tournaments/$tournamentId/players',
    );

    final response = await _httpClient.postUri(uri, requestBody);

    switch (response) {
      case SuccessHttpResponse(jsonData: final jsonData):
        // JsonMap を Response に変換する。
        final playerRegistrationResponse =
            PlayerRegistrationResponse.fromJson(
          jsonData as Map<String, dynamic>,
        );

        return SuccessRepositoryResult(playerRegistrationResponse);
      case FailureHttpResponse(:final e, :final status, :final statusCode):
        final reason = FailureRepositoryResultReason.fromString(status.name);
        return RepositoryResult.failure(
          e,
          reason: reason,
          statusCode: statusCode,
        );
    }
  }

  /// Firestore からプレイヤーリストを取得する。
  ///
  /// - [tournamentId] は、大会 ID。
  ///
  /// Returns: プレイヤーのリスト
  Future<RepositoryResult<List<PlayerModel>>> getPlayersFromFirestore({
    required String tournamentId,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('tournaments')
          .doc(tournamentId)
          .collection('players')
          .get();

      final players = snapshot.docs.map((doc) {
        final data = doc.data();
        return PlayerModel(
          playerId: doc.id,
          name: data['name'] as String? ?? '',
          playerNumber: data['playerNumber'] as int? ?? 0,
          status: data['status'] as String? ?? 'ACTIVE',
          userId: data['userId'] as String? ?? '',
        );
      }).toList();

      return SuccessRepositoryResult(players);
    } catch (e) {
      return RepositoryResult.failure(
        e,
        reason: FailureRepositoryResultReason.other,
      );
    }
  }
}
