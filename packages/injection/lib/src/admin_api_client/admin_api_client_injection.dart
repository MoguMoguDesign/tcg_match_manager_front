import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_api_client_injection.g.dart';

/// [AdminApiClient] を提供する。
@riverpod
AdminApiClient adminApiClient(Ref ref) {
  return getAdminApiClient();
}

/// [AdminApiClient] を取得する。
AdminApiClient getAdminApiClient() {
  // 実際のAPIベースURLを設定
  const baseUrl = 'https://api.example.com';

  return AdminApiClient( // coverage:ignore-line
    baseUrl: baseUrl,
    httpClient: http.Client(),
    firebaseAuth: FirebaseAuth.instance,
  );
}
