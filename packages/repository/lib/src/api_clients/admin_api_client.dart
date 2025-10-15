import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

/// 管理者向けAPI通信を行うHTTPクライアント。
///
/// Firebase AuthenticationのIDトークンを使用して
/// 管理者権限でAPIにアクセスする。
class AdminApiClient {
  /// [AdminApiClient]のコンストラクタ。
  AdminApiClient({
    required String baseUrl,
    http.Client? httpClient,
    FirebaseAuth? firebaseAuth,
  }) : _baseUrl = baseUrl,
       // coverage:ignore-start
       _httpClient = httpClient ?? http.Client(),
       _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
       // coverage:ignore-end

  final String _baseUrl;
  final http.Client _httpClient;
  final FirebaseAuth _firebaseAuth;

  /// Firebase AuthenticationのIDトークンを取得する。
  ///
  /// 管理者認証が必要なAPIアクセス時に使用する。
  ///
  /// Returns: IDトークン文字列
  /// Throws: [AdminApiException] 認証失敗時
  Future<String> _getIdToken() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AdminApiException(
          code: 'UNAUTHENTICATED',
          message: '管理者としてログインしてください',
        );
      }

      final idToken = await user.getIdToken();
      if (idToken == null) {
        throw const AdminApiException(
          code: 'AUTH_ERROR',
          message: 'IDトークンの取得に失敗しました',
        );
      }
      return idToken;
    } catch (e) {
      if (e is AdminApiException) {
        rethrow;
      }

      throw AdminApiException(
        code: 'AUTH_ERROR',
        message: '認証処理中にエラーが発生しました: $e',
      );
    }
  }

  /// 管理者向けAPIにGETリクエストを送信する。
  ///
  /// [path]: APIエンドポイントのパス（例: '/tournaments'）
  /// [queryParameters]: クエリパラメータ
  ///
  /// Returns: レスポンスボディのJSON
  /// Throws: [AdminApiException] APIエラー時
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    return _makeRequest('GET', path, queryParameters: queryParameters);
  }

  /// 管理者向けAPIにPOSTリクエストを送信する。
  ///
  /// [path]: APIエンドポイントのパス
  /// [body]: リクエストボディ
  /// [queryParameters]: クエリパラメータ
  ///
  /// Returns: レスポンスボディのJSON
  /// Throws: [AdminApiException] APIエラー時
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
  }) async {
    return _makeRequest(
      'POST',
      path,
      body: body,
      queryParameters: queryParameters,
    );
  }

  /// 管理者向けAPIにPATCHリクエストを送信する。
  ///
  /// [path]: APIエンドポイントのパス
  /// [body]: リクエストボディ
  /// [queryParameters]: クエリパラメータ
  ///
  /// Returns: レスポンスボディのJSON
  /// Throws: [AdminApiException] APIエラー時
  Future<Map<String, dynamic>> patch(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
  }) async {
    return _makeRequest(
      'PATCH',
      path,
      body: body,
      queryParameters: queryParameters,
    );
  }

  /// 管理者向けAPIにDELETEリクエストを送信する。
  ///
  /// [path]: APIエンドポイントのパス
  /// [queryParameters]: クエリパラメータ
  ///
  /// Returns: レスポンスボディのJSON
  /// Throws: [AdminApiException] APIエラー時
  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    return _makeRequest('DELETE', path, queryParameters: queryParameters);
  }

  /// HTTPリクエストを実行する内部メソッド。
  Future<Map<String, dynamic>> _makeRequest(
    String method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
  }) async {
    try {
      // IDトークン取得
      final idToken = await _getIdToken();

      // URL構築
      final uri = _buildUri(path, queryParameters);

      // リクエストヘッダー構築
      final headers = {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json; charset=utf-8',
      };

      // HTTPリクエスト実行
      late http.Response response;
      switch (method.toUpperCase()) {
        case 'GET':
          response = await _httpClient.get(uri, headers: headers);
        case 'POST':
          final bodyJson = body != null ? jsonEncode(body) : null;
          response = await _httpClient.post(
            uri,
            headers: headers,
            body: bodyJson,
          );
        case 'PATCH':
          final bodyJson = body != null ? jsonEncode(body) : null;
          response = await _httpClient.patch(
            uri,
            headers: headers,
            body: bodyJson,
          );
        case 'DELETE':
          response = await _httpClient.delete(uri, headers: headers);
        // coverage:ignore-start
        default:
          throw AdminApiException(
            code: 'UNSUPPORTED_METHOD',
            message: 'サポートされていないHTTPメソッド: $method',
          );
        // coverage:ignore-end
      }

      // レスポンス解析
      return _parseResponse(response);
    } on AdminApiException {
      rethrow;
    } on Object catch (e) {
      throw AdminApiException(
        code: 'NETWORK_ERROR',
        message: 'ネットワークエラーが発生しました: $e',
      );
    }
  }

  /// URIを構築する。
  Uri _buildUri(String path, Map<String, String>? queryParameters) {
    final fullPath = _baseUrl.endsWith('/')
        ? _baseUrl + path.substring(1)
        : _baseUrl + path;

    return Uri.parse(fullPath).replace(queryParameters: queryParameters);
  }

  /// HTTPレスポンスを解析する。
  Map<String, dynamic> _parseResponse(http.Response response) {
    // ステータスコード確認
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // 成功レスポンス
      if (response.body.isEmpty) {
        return <String, dynamic>{};
      }

      try {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } on Object {
        throw const AdminApiException(
          code: 'RESPONSE_PARSE_ERROR',
          message: 'レスポンスの解析に失敗しました',
        );
      }
    } else {
      // エラーレスポンス
      _handleErrorResponse(response);
    }
  }

  /// エラーレスポンスを処理する。
  Never _handleErrorResponse(http.Response response) {
    var code = 'UNKNOWN_ERROR';
    var message = 'エラーが発生しました';
    Map<String, dynamic>? details;

    // レスポンスボディからエラー情報を取得
    try {
      final errorBody = jsonDecode(response.body) as Map<String, dynamic>;
      code = errorBody['code'] as String? ?? code;
      message = errorBody['message'] as String? ?? message;
      details = errorBody['details'] as Map<String, dynamic>?;
    } on Object {
      // JSONデコードに失敗した場合はHTTPステータスから推測
      switch (response.statusCode) {
        case 400:
          code = 'INVALID_ARGUMENT';
          message = '入力内容に問題があります';
        case 401:
          code = 'UNAUTHORIZED';
          message = '認証に失敗しました';
        case 403:
          code = 'FORBIDDEN';
          message = 'アクセス権限がありません';
        case 404:
          code = 'NOT_FOUND';
          message = '指定されたリソースが見つかりません';
        case 409:
          code = 'CONFLICT';
          message = '処理を実行できません（競合状態）';
        case 429:
          code = 'TOO_MANY_REQUESTS';
          message = 'リクエスト回数が上限に達しました';
        case 500:
          code = 'INTERNAL_ERROR';
          message = 'サーバー内部エラーが発生しました';
        default:
          message =
              'HTTP ${response.statusCode}: '
              '${response.reasonPhrase}';
      }
    }

    throw AdminApiException(code: code, message: message, details: details);
  }

  /// リソースを解放する。
  void dispose() {
    _httpClient.close();
  }
}

/// 管理者API通信で発生するエラー。
@immutable
class AdminApiException implements Exception {
  /// [AdminApiException]のコンストラクタ。
  const AdminApiException({
    required this.code,
    required this.message,
    this.details,
  });

  /// エラーコード（API設計書準拠）。
  final String code;

  /// 人間が読めるエラーメッセージ。
  final String message;

  /// 追加のエラー詳細情報。
  final Map<String, dynamic>? details;

  @override
  String toString() {
    return 'AdminApiException(code: $code, message: $message, '
        'details: $details)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is AdminApiException &&
        other.code == code &&
        other.message == message;
  }

  @override
  int get hashCode => code.hashCode ^ message.hashCode;
}
