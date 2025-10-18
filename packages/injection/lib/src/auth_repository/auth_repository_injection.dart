import 'package:domain/domain.dart';
import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository_injection.g.dart';

/// AuthRepositoryの実装を提供するプロバイダー。
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return FirebaseAuthRepository();
}
