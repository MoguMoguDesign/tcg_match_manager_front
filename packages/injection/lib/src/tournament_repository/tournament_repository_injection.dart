import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../admin_api_client/admin_api_client_injection.dart';

part 'tournament_repository_injection.g.dart';

/// [TournamentRepository] を提供する。
@riverpod
TournamentRepository tournamentRepository(Ref ref) {
  final adminApiClient = ref.watch(adminApiClientProvider);

  return TournamentApiRepository(apiClient: adminApiClient);
}
