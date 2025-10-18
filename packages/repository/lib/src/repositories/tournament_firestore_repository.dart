import 'package:clock/clock.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../api_clients/admin_api_client.dart';
import '../models/create_tournament_request.dart';
import '../models/tournament_model.dart';
import '../models/update_tournament_request.dart';
import 'tournament_repository.dart';

/// Firestoreを使用したトーナメントリポジトリの実装。
///
/// Firebase Authenticationで認証されたユーザーのトーナメントデータを
/// Firestoreから直接取得・管理する。
class TournamentFirestoreRepository implements TournamentRepository {
  /// [TournamentFirestoreRepository]のコンストラクタ。
  const TournamentFirestoreRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _firestore = firestore,
       _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  /// tournamentsコレクションの参照を取得する。
  CollectionReference<Map<String, dynamic>> get _tournamentsCollection =>
      _firestore.collection('tournaments');

  /// 現在ログイン中のユーザーのUIDを取得する。
  ///
  /// Returns: ユーザーUID
  /// Throws: [AdminApiException] 未ログインの場合
  String _getCurrentUserUid() {
    final user = _auth.currentUser;
    if (user == null) {
      throw const AdminApiException(
        code: 'UNAUTHENTICATED',
        message: 'ログインが必要です',
      );
    }
    return user.uid;
  }

  /// TimestampをISO 8601形式の文字列に変換する。
  ///
  /// [timestamp]: Firestoreのタイムスタンプ
  ///
  /// Returns: ISO 8601形式の文字列
  String _timestampToString(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate().toIso8601String();
    }
    if (timestamp is String) {
      return timestamp;
    }
    return clock.now().toIso8601String();
  }

  /// FirestoreドキュメントをTournamentModelに変換する。
  ///
  /// [doc]: Firestoreドキュメントスナップショット
  ///
  /// Returns: TournamentModel
  /// Throws: [AdminApiException] 変換に失敗した場合
  TournamentModel _documentToModel(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw const AdminApiException(
        code: 'NOT_FOUND',
        message: 'トーナメントが見つかりません',
      );
    }

    try {
      // Timestampフィールドを文字列に変換し、nullフィールドを除外
      final modelData = <String, dynamic>{};

      // IDを追加
      modelData['id'] = doc.id;

      // データをコピーし、nullではない値のみを追加
      data.forEach((key, value) {
        if (value != null) {
          modelData[key] = value;
        }
      });

      // createdAtの処理
      if (modelData.containsKey('createdAt')) {
        modelData['createdAt'] = _timestampToString(modelData['createdAt']);
      } else {
        modelData['createdAt'] = clock.now().toIso8601String();
      }

      // updatedAtの処理
      if (modelData.containsKey('updatedAt')) {
        modelData['updatedAt'] = _timestampToString(modelData['updatedAt']);
      } else {
        modelData['updatedAt'] = clock.now().toIso8601String();
      }

      return TournamentModel.fromJson(modelData);
    } catch (e) {
      throw AdminApiException(
        code: 'PARSE_ERROR',
        message: 'トーナメントデータの変換中にエラーが発生しました: $e',
      );
    }
  }

  @override
  Future<List<TournamentModel>> getTournaments() async {
    try {
      final uid = _getCurrentUserUid();

      final querySnapshot = await _tournamentsCollection
          .where('adminUid', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map(_documentToModel).toList();
    } on AdminApiException {
      rethrow;
    } catch (e) {
      throw AdminApiException(
        code: 'FIRESTORE_ERROR',
        message: 'トーナメント一覧の取得中にエラーが発生しました: $e',
      );
    }
  }

  @override
  Future<TournamentModel> getTournament(String id) async {
    if (id.isEmpty) {
      throw const AdminApiException(
        code: 'INVALID_ARGUMENT',
        message: 'トーナメントIDは必須です',
      );
    }

    try {
      final doc = await _tournamentsCollection.doc(id).get();

      if (!doc.exists) {
        throw const AdminApiException(
          code: 'NOT_FOUND',
          message: 'トーナメントが見つかりません',
        );
      }

      return _documentToModel(doc);
    } on AdminApiException {
      rethrow;
    } catch (e) {
      throw AdminApiException(
        code: 'FIRESTORE_ERROR',
        message: 'トーナメントの取得中にエラーが発生しました: $e',
      );
    }
  }

  @override
  Future<TournamentModel> createTournament(
    CreateTournamentRequest request,
  ) async {
    try {
      final uid = _getCurrentUserUid();
      final docRef = _tournamentsCollection.doc();

      final tournamentData = {
        ...request.toJson(),
        'adminUid': uid,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await docRef.set(tournamentData);

      // 作成直後のドキュメントを取得
      final doc = await docRef.get();
      return _documentToModel(doc);
    } on AdminApiException {
      rethrow;
    } catch (e) {
      throw AdminApiException(
        code: 'FIRESTORE_ERROR',
        message: 'トーナメントの作成中にエラーが発生しました: $e',
      );
    }
  }

  @override
  Future<TournamentModel> updateTournament(
    String id,
    UpdateTournamentRequest request,
  ) async {
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

    try {
      final docRef = _tournamentsCollection.doc(id);

      // ドキュメントの存在確認
      final doc = await docRef.get();
      if (!doc.exists) {
        throw const AdminApiException(
          code: 'NOT_FOUND',
          message: 'トーナメントが見つかりません',
        );
      }

      final updateData = {
        ...request.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await docRef.update(updateData);

      // 更新後のドキュメントを取得
      final updatedDoc = await docRef.get();
      return _documentToModel(updatedDoc);
    } on AdminApiException {
      rethrow;
    } catch (e) {
      throw AdminApiException(
        code: 'FIRESTORE_ERROR',
        message: 'トーナメントの更新中にエラーが発生しました: $e',
      );
    }
  }

  @override
  Future<void> deleteTournament(String id) async {
    if (id.isEmpty) {
      throw const AdminApiException(
        code: 'INVALID_ARGUMENT',
        message: 'トーナメントIDは必須です',
      );
    }

    try {
      final docRef = _tournamentsCollection.doc(id);

      // ドキュメントの存在確認
      final doc = await docRef.get();
      if (!doc.exists) {
        throw const AdminApiException(
          code: 'NOT_FOUND',
          message: 'トーナメントが見つかりません',
        );
      }

      await docRef.delete();
    } on AdminApiException {
      rethrow;
    } catch (e) {
      throw AdminApiException(
        code: 'FIRESTORE_ERROR',
        message: 'トーナメントの削除中にエラーが発生しました: $e',
      );
    }
  }
}
