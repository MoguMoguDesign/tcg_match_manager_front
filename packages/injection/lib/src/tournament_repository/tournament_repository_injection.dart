import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tournament_repository_injection.g.dart';

/// [TournamentRepository] を提供する。
@riverpod
TournamentRepository tournamentRepository(Ref ref) {
  return TournamentFirestoreRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ); // coverage:ignore-line
}
