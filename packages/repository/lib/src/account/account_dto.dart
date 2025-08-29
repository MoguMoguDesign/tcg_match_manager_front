import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:util/util.dart';

import '../flexible_bool_converter.dart';

part 'account_dto.freezed.dart';
part 'account_dto.g.dart';

/// アカウント用 DTO クラス。
///
/// 必要に応じて [JsonKey] を利用したフィールド名調整や Converter を利用した型変換を行う。
@freezed
abstract class AccountDto with _$AccountDto {
  /// [AccountDto] を生成する。
  const factory AccountDto({
    /// 失敗状態かどうか。
    ///
    /// 元々のフィールドでは int 型の値が返ってくるが、扱いやすくするために bool に変換している。
    @JsonKey(name: 'STATUS')
    @flexibleBoolConverter
    required bool isFailureStatus,

    /// 副次的な ステータス。
    ///
    /// 現状は初期値以外の値は返ってこない。
    @JsonKey(name: 'SUB') @Default(0) int sub,

    /// レスポンスメッセージ。
    @JsonKey(name: 'MESSAGE') @Default('') String message,

    /// ユーザー ID。
    @JsonKey(name: 'user_id') @Default('') String userId,

    /// ユーザー名。
    @JsonKey(name: 'username') @Default('') String username,

    /// 表示名。
    @JsonKey(name: 'display_name') @Default('') String displayName,

    /// メールアドレス。
    @JsonKey(name: 'email') @Default('') String email,

    /// API バージョン。
    @JsonKey(name: 'api_version') @Default(1) int apiVersion,

    /// アクセストークン。
    @JsonKey(name: 'access_token') @Default('') String accessToken,

    /// リフレッシュトークン。
    @JsonKey(name: 'refresh_token') @Default('') String refreshToken,

    /// トークンの有効期限（Unix timestamp）。
    @JsonKey(name: 'expires_at') @Default(0) int expiresAt,
  }) = _AccountDto;

  /// [JsonMap] から [AccountDto] インスタンスを生成する。
  factory AccountDto.fromJson(JsonMap json) => _$AccountDtoFromJson(json);
}
