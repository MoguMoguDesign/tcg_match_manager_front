import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../admin_api_client/admin_api_client_injection.dart';

part 'player_repository_injection.g.dart';

/// [PlayerRepository] を提供する。
@riverpod
PlayerRepository playerRepository(Ref ref) {
  final adminApiClient = ref.watch(adminApiClientProvider);

  return PlayerApiRepository(apiClient: adminApiClient); // coverage:ignore-line
}
