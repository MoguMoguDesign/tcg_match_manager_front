import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_api_client_injection.g.dart';

/// Admin API のベースURLを提供する。
///
/// デフォルトではダミーURLだが、main.dartでオーバーライドされる。
@riverpod
String adminApiBaseUrl(Ref ref) {
  // このデフォルト値はテスト用。実際のアプリではmain.dartでオーバーライドされる。
  return 'https://api.example.com/api/v1';
}

/// [AdminApiClient] を提供する。
@riverpod
AdminApiClient adminApiClient(Ref ref) {
  final baseUrl = ref.watch(adminApiBaseUrlProvider);
  return getAdminApiClient(baseUrl: baseUrl);
}

/// [AdminApiClient] を取得する。
///
/// [baseUrl] 管理者APIのベースURL
AdminApiClient getAdminApiClient({required String baseUrl}) {
  // coverage:ignore-start
  return AdminApiClient(
    baseUrl: baseUrl,
    httpClient: http.Client(),
    firebaseAuth: FirebaseAuth.instance,
  );
  // coverage:ignore-end
}
