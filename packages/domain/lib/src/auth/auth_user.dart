import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';

/// 認証済みユーザーエンティティ
///
/// Firebase Authenticationで認証されたユーザー情報を表すドメインモデル。
@freezed
abstract class AuthUser with _$AuthUser {
  /// [AuthUser]のコンストラクタ。
  const factory AuthUser({
    required String uid,
    String? email,
    String? displayName,
    required bool emailVerified,
  }) = _AuthUser;
}
