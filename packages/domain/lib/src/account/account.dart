import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:repository/repository.dart';

part 'account.freezed.dart';

/// アカウント情報用エンティティクラス。
@freezed
abstract class Account with _$Account {
  /// [Account] を生成する。
  const factory Account({
    /// ユーザー ID。
    @Default('') String userId,

    /// ユーザー名。
    @Default('') String username,

    /// 表示名。
    @Default('') String displayName,

    /// メールアドレス。
    @Default('') String email,

    /// アクセストークン。
    @Default('') String accessToken,

    /// リフレッシュトークン。
    @Default('') String refreshToken,

    /// トークンの有効期限（Unix timestamp）。
    @Default(0) int expiresAt,
  }) = _Account;

  /// [AccountDto] から [Account] インスタンスを生成する。
  factory Account.fromDto(AccountDto accountDto) => Account(
    userId: accountDto.userId,
    username: accountDto.username,
    displayName: accountDto.displayName,
    email: accountDto.email,
    accessToken: accountDto.accessToken,
    refreshToken: accountDto.refreshToken,
    expiresAt: accountDto.expiresAt,
  );
}
