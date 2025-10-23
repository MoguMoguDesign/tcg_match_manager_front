import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_auth_response.freezed.dart';
part 'player_auth_response.g.dart';

/// プレイヤー認証レスポンス。
@freezed
abstract class PlayerAuthResponse with _$PlayerAuthResponse {
  /// [PlayerAuthResponse] のコンストラクタ。
  const factory PlayerAuthResponse({
    /// 有効かどうか。
    required bool valid,

    /// プレイヤー ID。
    required String playerId,

    /// プレイヤー名。
    required String playerName,
  }) = _PlayerAuthResponse;

  /// JSON から [PlayerAuthResponse] を生成する。
  factory PlayerAuthResponse.fromJson(Map<String, dynamic> json) =>
      _$PlayerAuthResponseFromJson(json);
}
