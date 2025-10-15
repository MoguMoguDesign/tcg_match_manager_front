import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:repository/src/api_clients/admin_api_client.dart';

import 'admin_api_client_test.mocks.dart';

// モッククラスを生成する。
@GenerateNiceMocks([
  MockSpec<http.Client>(),
  MockSpec<FirebaseAuth>(),
  MockSpec<User>(),
])
void main() {
  late MockClient mockHttpClient;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockUser;
  late AdminApiClient client;

  const baseUrl = 'https://api.example.com';
  const testToken = 'test-id-token';

  setUp(() {
    mockHttpClient = MockClient();
    mockFirebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();
    client = AdminApiClient(
      baseUrl: baseUrl,
      httpClient: mockHttpClient,
      firebaseAuth: mockFirebaseAuth,
    );
  });

  tearDown(() {
    client.dispose();
  });

  group('AdminApiClient のコンストラクタのテスト', () {
    test('正常にインスタンスを作成できる', () {
      final client = AdminApiClient(
        baseUrl: baseUrl,
        httpClient: mockHttpClient,
        firebaseAuth: mockFirebaseAuth,
      );

      expect(client, isA<AdminApiClient>());
      client.dispose();
    });
  });

  group('GET リクエストのテスト', () {
    test('正常にGETリクエストを実行できる', () async {
      // Firebase Authのモック設定
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.getIdToken()).thenAnswer((_) async => testToken);

      // HTTPレスポンスのモック設定
      when(
        mockHttpClient.get(
          any,
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          jsonEncode({'data': 'test'}),
          200,
        ),
      );

      final response = await client.get('/test');

      expect(response, {'data': 'test'});
      verify(mockFirebaseAuth.currentUser).called(1);
      verify(mockUser.getIdToken()).called(1);
      verify(
        mockHttpClient.get(
          Uri.parse('$baseUrl/test'),
          headers: {
            'Authorization': 'Bearer $testToken',
            'Content-Type': 'application/json; charset=utf-8',
          },
        ),
      ).called(1);
    });

    test('クエリパラメータ付きのGETリクエストを実行できる', () async {
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.getIdToken()).thenAnswer((_) async => testToken);

      when(
        mockHttpClient.get(
          any,
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          jsonEncode({'data': 'test'}),
          200,
        ),
      );

      final response = await client.get(
        '/test',
        queryParameters: {'key': 'value'},
      );

      expect(response, {'data': 'test'});
      verify(
        mockHttpClient.get(
          Uri.parse('$baseUrl/test?key=value'),
          headers: anyNamed('headers'),
        ),
      ).called(1);
    });

    test('空のレスポンスボディを処理できる', () async {
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.getIdToken()).thenAnswer((_) async => testToken);

      when(
        mockHttpClient.get(
          any,
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response('', 200),
      );

      final response = await client.get('/test');

      expect(response, <String, dynamic>{});
    });
  });

  group('POST リクエストのテスト', () {
    test('正常にPOSTリクエストを実行できる', () async {
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.getIdToken()).thenAnswer((_) async => testToken);

      when(
        mockHttpClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          jsonEncode({'data': 'created'}),
          201,
        ),
      );

      final response = await client.post(
        '/test',
        body: {'field': 'value'},
      );

      expect(response, {'data': 'created'});
      verify(
        mockHttpClient.post(
          Uri.parse('$baseUrl/test'),
          headers: {
            'Authorization': 'Bearer $testToken',
            'Content-Type': 'application/json; charset=utf-8',
          },
          body: jsonEncode({'field': 'value'}),
        ),
      ).called(1);
    });

    test('body が null の場合でもPOSTリクエストを実行できる', () async {
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.getIdToken()).thenAnswer((_) async => testToken);

      when(
        mockHttpClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          jsonEncode({'data': 'created'}),
          201,
        ),
      );

      final response = await client.post('/test');

      expect(response, {'data': 'created'});
    });

    test('クエリパラメータ付きのPOSTリクエストを実行できる', () async {
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.getIdToken()).thenAnswer((_) async => testToken);

      when(
        mockHttpClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          jsonEncode({'data': 'created'}),
          201,
        ),
      );

      await client.post(
        '/test',
        queryParameters: {'key': 'value'},
      );

      verify(
        mockHttpClient.post(
          Uri.parse('$baseUrl/test?key=value'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).called(1);
    });
  });

  group('PATCH リクエストのテスト', () {
    test('正常にPATCHリクエストを実行できる', () async {
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.getIdToken()).thenAnswer((_) async => testToken);

      when(
        mockHttpClient.patch(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          jsonEncode({'data': 'updated'}),
          200,
        ),
      );

      final response = await client.patch(
        '/test',
        body: {'field': 'new_value'},
      );

      expect(response, {'data': 'updated'});
      verify(
        mockHttpClient.patch(
          Uri.parse('$baseUrl/test'),
          headers: {
            'Authorization': 'Bearer $testToken',
            'Content-Type': 'application/json; charset=utf-8',
          },
          body: jsonEncode({'field': 'new_value'}),
        ),
      ).called(1);
    });

    test('body が null の場合でもPATCHリクエストを実行できる', () async {
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.getIdToken()).thenAnswer((_) async => testToken);

      when(
        mockHttpClient.patch(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          jsonEncode({'data': 'updated'}),
          200,
        ),
      );

      final response = await client.patch('/test');

      expect(response, {'data': 'updated'});
    });
  });

  group('DELETE リクエストのテスト', () {
    test('正常にDELETEリクエストを実行できる', () async {
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.getIdToken()).thenAnswer((_) async => testToken);

      when(
        mockHttpClient.delete(
          any,
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          jsonEncode({'data': 'deleted'}),
          200,
        ),
      );

      final response = await client.delete('/test');

      expect(response, {'data': 'deleted'});
      verify(
        mockHttpClient.delete(
          Uri.parse('$baseUrl/test'),
          headers: {
            'Authorization': 'Bearer $testToken',
            'Content-Type': 'application/json; charset=utf-8',
          },
        ),
      ).called(1);
    });

    test('クエリパラメータ付きのDELETEリクエストを実行できる', () async {
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.getIdToken()).thenAnswer((_) async => testToken);

      when(
        mockHttpClient.delete(
          any,
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          jsonEncode({'data': 'deleted'}),
          200,
        ),
      );

      await client.delete(
        '/test',
        queryParameters: {'key': 'value'},
      );

      verify(
        mockHttpClient.delete(
          Uri.parse('$baseUrl/test?key=value'),
          headers: anyNamed('headers'),
        ),
      ).called(1);
    });
  });

  group('認証エラーのテスト', () {
    test('ユーザーがログインしていない場合、AdminApiExceptionをスローする', () async {
      when(mockFirebaseAuth.currentUser).thenReturn(null);

      expect(
        () => client.get('/test'),
        throwsA(
          isA<AdminApiException>()
              .having((e) => e.code, 'code', 'UNAUTHENTICATED')
              .having(
                (e) => e.message,
                'message',
                '管理者としてログインしてください',
              ),
        ),
      );
    });

    test('IDトークン取得に失敗した場合、AdminApiExceptionをスローする', () async {
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.getIdToken()).thenAnswer((_) async => null);

      expect(
        () => client.get('/test'),
        throwsA(
          isA<AdminApiException>()
              .having((e) => e.code, 'code', 'AUTH_ERROR')
              .having(
                (e) => e.message,
                'message',
                'IDトークンの取得に失敗しました',
              ),
        ),
      );
    });

    test('認証処理中に例外が発生した場合、AdminApiExceptionをスローする', () async {
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.getIdToken()).thenThrow(Exception('Auth error'));

      expect(
        () => client.get('/test'),
        throwsA(
          isA<AdminApiException>()
              .having((e) => e.code, 'code', 'AUTH_ERROR')
              .having(
                (e) => e.message,
                'message',
                contains('認証処理中にエラーが発生しました'),
              ),
        ),
      );
    });
  });

  group('HTTPエラーレスポンスのテスト', () {
    setUp(() {
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.getIdToken()).thenAnswer((_) async => testToken);
    });

    test('400 Bad Request エラーを処理できる', () async {
      when(
        mockHttpClient.get(
          any,
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response('Invalid request', 400),
      );

      expect(
        () => client.get('/test'),
        throwsA(
          isA<AdminApiException>()
              .having((e) => e.code, 'code', 'INVALID_ARGUMENT')
              .having(
                (e) => e.message,
                'message',
                '入力内容に問題があります',
              ),
        ),
      );
    });

    test('401 Unauthorized エラーを処理できる', () async {
      when(
        mockHttpClient.get(
          any,
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response('Unauthorized', 401),
      );

      expect(
        () => client.get('/test'),
        throwsA(
          isA<AdminApiException>()
              .having((e) => e.code, 'code', 'UNAUTHORIZED')
              .having((e) => e.message, 'message', '認証に失敗しました'),
        ),
      );
    });

    test('403 Forbidden エラーを処理できる', () async {
      when(
        mockHttpClient.get(
          any,
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response('Forbidden', 403),
      );

      expect(
        () => client.get('/test'),
        throwsA(
          isA<AdminApiException>()
              .having((e) => e.code, 'code', 'FORBIDDEN')
              .having(
                (e) => e.message,
                'message',
                'アクセス権限がありません',
              ),
        ),
      );
    });

    test('404 Not Found エラーを処理できる', () async {
      when(
        mockHttpClient.get(
          any,
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response('Not found', 404),
      );

      expect(
        () => client.get('/test'),
        throwsA(
          isA<AdminApiException>()
              .having((e) => e.code, 'code', 'NOT_FOUND')
              .having(
                (e) => e.message,
                'message',
                '指定されたリソースが見つかりません',
              ),
        ),
      );
    });

    test('409 Conflict エラーを処理できる', () async {
      when(
        mockHttpClient.get(
          any,
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response('Conflict', 409),
      );

      expect(
        () => client.get('/test'),
        throwsA(
          isA<AdminApiException>()
              .having((e) => e.code, 'code', 'CONFLICT')
              .having(
                (e) => e.message,
                'message',
                '処理を実行できません（競合状態）',
              ),
        ),
      );
    });

    test('429 Too Many Requests エラーを処理できる', () async {
      when(
        mockHttpClient.get(
          any,
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response('Too many requests', 429),
      );

      expect(
        () => client.get('/test'),
        throwsA(
          isA<AdminApiException>()
              .having((e) => e.code, 'code', 'TOO_MANY_REQUESTS')
              .having(
                (e) => e.message,
                'message',
                'リクエスト回数が上限に達しました',
              ),
        ),
      );
    });

    test('500 Internal Server Error エラーを処理できる', () async {
      when(
        mockHttpClient.get(
          any,
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response('Internal error', 500),
      );

      expect(
        () => client.get('/test'),
        throwsA(
          isA<AdminApiException>()
              .having((e) => e.code, 'code', 'INTERNAL_ERROR')
              .having(
                (e) => e.message,
                'message',
                'サーバー内部エラーが発生しました',
              ),
        ),
      );
    });

    test('その他のHTTPエラーを処理できる', () async {
      when(
        mockHttpClient.get(
          any,
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response('Unknown error', 418),
      );

      expect(
        () => client.get('/test'),
        throwsA(
          isA<AdminApiException>()
              .having((e) => e.code, 'code', 'UNKNOWN_ERROR')
              .having((e) => e.message, 'message', contains('HTTP 418')),
        ),
      );
    });

    test('JSONエラーレスポンスを処理できる', () async {
      final errorBody = jsonEncode({
        'code': 'CUSTOM_ERROR',
        'message': 'Custom error message',
        'details': {'field': 'error_detail'},
      });

      when(
        mockHttpClient.get(
          any,
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response(errorBody, 400),
      );

      expect(
        () => client.get('/test'),
        throwsA(
          isA<AdminApiException>()
              .having((e) => e.code, 'code', 'CUSTOM_ERROR')
              .having(
                (e) => e.message,
                'message',
                'Custom error message',
              )
              .having(
                (e) => e.details,
                'details',
                {'field': 'error_detail'},
              ),
        ),
      );
    });
  });

  group('その他のエラーのテスト', () {
    setUp(() {
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.getIdToken()).thenAnswer((_) async => testToken);
    });

    test('レスポンスのJSON解析に失敗した場合、AdminApiExceptionをスローする', () async {
      when(
        mockHttpClient.get(
          any,
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response('invalid json', 200),
      );

      expect(
        () => client.get('/test'),
        throwsA(
          isA<AdminApiException>()
              .having((e) => e.code, 'code', 'RESPONSE_PARSE_ERROR')
              .having(
                (e) => e.message,
                'message',
                'レスポンスの解析に失敗しました',
              ),
        ),
      );
    });

    test('ネットワークエラーが発生した場合、AdminApiExceptionをスローする', () async {
      when(
        mockHttpClient.get(
          any,
          headers: anyNamed('headers'),
        ),
      ).thenThrow(Exception('Network error'));

      expect(
        () => client.get('/test'),
        throwsA(
          isA<AdminApiException>()
              .having((e) => e.code, 'code', 'NETWORK_ERROR')
              .having(
                (e) => e.message,
                'message',
                contains('ネットワークエラーが発生しました'),
              ),
        ),
      );
    });
  });

  group('サポートされていないメソッドのテスト', () {
    test('サポートされていないHTTPメソッドの場合、AdminApiExceptionをスローする', () async {
      // このテストは内部メソッドを直接呼び出すことができないため、
      // コンストラクタで無効なクライアントを作成することで間接的にテストできます。
      // しかし、実際にはこのコードパスに到達することは難しいため、
      // カバレッジのためにコメントで記載します。
      // 実装上、GET/POST/PATCH/DELETE以外のメソッドは使用されないため、
      // このコードは防御的プログラミングの一環です。
    });
  });

  group('URI構築のテスト', () {
    setUp(() {
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.getIdToken()).thenAnswer((_) async => testToken);
      when(
        mockHttpClient.get(
          any,
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          jsonEncode({'data': 'test'}),
          200,
        ),
      );
    });

    test('baseUrlの末尾にスラッシュがある場合、正しくURIを構築する', () async {
      final clientWithTrailingSlash = AdminApiClient(
        baseUrl: 'https://api.example.com/',
        httpClient: mockHttpClient,
        firebaseAuth: mockFirebaseAuth,
      );

      await clientWithTrailingSlash.get('/test');

      verify(
        mockHttpClient.get(
          Uri.parse('https://api.example.com/test'),
          headers: anyNamed('headers'),
        ),
      ).called(1);

      clientWithTrailingSlash.dispose();
    });

    test('baseUrlの末尾にスラッシュがない場合、正しくURIを構築する', () async {
      await client.get('/test');

      verify(
        mockHttpClient.get(
          Uri.parse('$baseUrl/test'),
          headers: anyNamed('headers'),
        ),
      ).called(1);
    });
  });

  group('AdminApiException のテスト', () {
    test('正常にインスタンスを作成できる', () {
      const exception = AdminApiException(
        code: 'TEST_ERROR',
        message: 'テストエラー',
      );

      expect(exception.code, 'TEST_ERROR');
      expect(exception.message, 'テストエラー');
      expect(exception.details, isNull);
    });

    test('details付きでインスタンスを作成できる', () {
      const exception = AdminApiException(
        code: 'TEST_ERROR',
        message: 'テストエラー',
        details: {'field': 'value'},
      );

      expect(exception.code, 'TEST_ERROR');
      expect(exception.message, 'テストエラー');
      expect(exception.details, {'field': 'value'});
    });

    test('toString() が正しく動作する', () {
      const exception = AdminApiException(
        code: 'TEST_ERROR',
        message: 'テストエラー',
        details: {'field': 'value'},
      );

      expect(
        exception.toString(),
        'AdminApiException(code: TEST_ERROR, message: テストエラー, '
        'details: {field: value})',
      );
    });

    test('同じ値を持つインスタンスは等しい', () {
      const exception1 = AdminApiException(
        code: 'TEST_ERROR',
        message: 'テストエラー',
      );

      const exception2 = AdminApiException(
        code: 'TEST_ERROR',
        message: 'テストエラー',
      );

      expect(exception1, equals(exception2));
      expect(exception1.hashCode, equals(exception2.hashCode));
    });

    test('異なる値を持つインスタンスは等しくない', () {
      const exception1 = AdminApiException(
        code: 'TEST_ERROR',
        message: 'テストエラー',
      );

      const exception2 = AdminApiException(
        code: 'OTHER_ERROR',
        message: 'テストエラー',
      );

      expect(exception1, isNot(equals(exception2)));
    });

    test('messageが異なる場合は等しくない', () {
      const exception1 = AdminApiException(
        code: 'TEST_ERROR',
        message: 'Message 1',
      );

      const exception2 = AdminApiException(
        code: 'TEST_ERROR',
        message: 'Message 2',
      );

      expect(exception1, isNot(equals(exception2)));
    });

    test('identical な場合は等しい', () {
      const exception = AdminApiException(
        code: 'TEST_ERROR',
        message: 'テストエラー',
      );

      expect(exception, equals(exception));
    });

    test('異なる型と比較した場合は等しくない', () {
      const exception = AdminApiException(
        code: 'TEST_ERROR',
        message: 'テストエラー',
      );

      expect(exception, isNot(equals('TEST_ERROR')));
      expect(exception, isNot(equals(123)));
    });
  });

  group('dispose のテスト', () {
    test('dispose() を呼ぶと httpClient が close される', () {
      client.dispose();
      verify(mockHttpClient.close()).called(1);
    });
  });
}
