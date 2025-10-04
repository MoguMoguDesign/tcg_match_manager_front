import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_auth_request.freezed.dart';
part 'player_auth_request.g.dart';

/// プレイヤー認証リクエスト。
@freezed
abstract class PlayerAuthRequest with _$PlayerAuthRequest {
  /// [PlayerAuthRequest] のコンストラクタ。
  const factory PlayerAuthRequest({
    /// 大会 ID。
    required String tournamentId,

    /// ユーザー ID（UUID v4）。
    required String userId,
  }) = _PlayerAuthRequest;

  /// JSON から [PlayerAuthRequest] を生成する。
  factory PlayerAuthRequest.fromJson(Map<String, dynamic> json) =>
      _$PlayerAuthRequestFromJson(json);
}
