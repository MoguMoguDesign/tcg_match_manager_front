import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:system/system.dart';

part 'http_client_injection.g.dart';

/// [HttpClient] を提供する。
///
/// アプリやテストの起動時に環境に応じて適切な [HttpClient] を注入して使用される。
@riverpod
HttpClient httpClient(Ref ref) => throw UnimplementedError();

// MEMO(masaki): 実際は、ビルド環境によって異なるエンドポイントやアクセストークン関連の情報を Flavor 経由で app から渡す想定。
// 本アプリについてはサーバーがアカウントごとに複数存在するため、一般的な開発用・本番用のエンドポイントを Flavor で切り替える、
// というということにはならないはずだが、アクセストークンなどはここで管理する想定。
/// [HttpClient] を取得する。
HttpClient getHttpClient() => HttpClient(DioHttpClient());
