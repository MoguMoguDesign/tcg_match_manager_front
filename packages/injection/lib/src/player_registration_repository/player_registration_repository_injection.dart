import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../http_client/http_client_injection.dart';

part 'player_registration_repository_injection.g.dart';

/// [PlayerRegistrationRepository] を提供する。
@riverpod
PlayerRegistrationRepository playerRegistrationRepository(Ref ref) {
  throw UnimplementedError('playerRegistrationRepositoryProvider は上書きされる必要があります。');
}

/// [PlayerRegistrationRepository] を取得する。
///
/// [FirebaseFirestore] の初期化を行なった上で
/// [PlayerRegistrationRepository] を生成する。
///
/// テスト時には [firestore] へモックの
/// [FirebaseFirestore] が渡される。
PlayerRegistrationRepository getPlayerRegistrationRepository(
  Ref ref, {
  @visibleForTesting FirebaseFirestore? firestore,
}) {
  return PlayerRegistrationRepository(
    httpClient: ref.watch(httpClientProvider),
    firestore: firestore ?? FirebaseFirestore.instance,
  );
}
