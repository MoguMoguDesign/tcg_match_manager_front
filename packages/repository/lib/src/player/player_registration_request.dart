import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_registration_request.freezed.dart';
part 'player_registration_request.g.dart';

/// プレイヤー登録リクエスト。
@freezed
abstract class PlayerRegistrationRequest with _$PlayerRegistrationRequest {
  /// [PlayerRegistrationRequest] のコンストラクタ。
  const factory PlayerRegistrationRequest({
    /// プレイヤー名。
    required String name,
  }) = _PlayerRegistrationRequest;

  /// JSON から [PlayerRegistrationRequest] を生成する。
  factory PlayerRegistrationRequest.fromJson(Map<String, dynamic> json) =>
      _$PlayerRegistrationRequestFromJson(json);
}
