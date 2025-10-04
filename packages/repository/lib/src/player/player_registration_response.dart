import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_registration_response.freezed.dart';
part 'player_registration_response.g.dart';

/// プレイヤー登録レスポンス。
@freezed
abstract class PlayerRegistrationResponse with _$PlayerRegistrationResponse {
  /// [PlayerRegistrationResponse] のコンストラクタ。
  const factory PlayerRegistrationResponse({
    /// プレイヤー ID。
    required String playerId,

    /// プレイヤー番号。
    required int playerNumber,

    /// プレイヤーステータス（ACTIVE, DROPPED など）。
    required String status,

    /// ユーザー ID（UUID v4）。
    required String userId,
  }) = _PlayerRegistrationResponse;

  /// JSON から [PlayerRegistrationResponse] を生成する。
  factory PlayerRegistrationResponse.fromJson(Map<String, dynamic> json) =>
      _$PlayerRegistrationResponseFromJson(json);
}
