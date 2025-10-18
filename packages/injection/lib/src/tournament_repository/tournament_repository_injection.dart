import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tournament_repository_injection.g.dart';

/// [TournamentRepository] を提供する。
@riverpod
TournamentRepository tournamentRepository(Ref ref) {
  throw UnimplementedError('tournamentRepositoryProvider は上書きされる必要があります。');
}

/// [TournamentRepository] を取得する。
///
/// [FirebaseFirestore] と [FirebaseAuth] の初期化を行なった上で
/// [TournamentFirestoreRepository] を生成する。
///
/// テスト時には [firestore] と [auth] へモックの
/// [FirebaseFirestore] と [FirebaseAuth] が渡される。
TournamentRepository getTournamentRepository({
  @visibleForTesting FirebaseFirestore? firestore,
  @visibleForTesting FirebaseAuth? auth,
}) {
  return TournamentFirestoreRepository(
    firestore: firestore ?? FirebaseFirestore.instance,
    auth: auth ?? FirebaseAuth.instance,
  );
}
