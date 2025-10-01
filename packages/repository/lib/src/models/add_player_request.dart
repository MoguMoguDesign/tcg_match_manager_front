import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_player_request.freezed.dart';
part 'add_player_request.g.dart';

/// プレイヤー登録リクエスト。
@freezed
abstract class AddPlayerRequest with _$AddPlayerRequest {
  /// プレイヤー登録リクエストを作成する。
  const factory AddPlayerRequest({
    required String name,
    required int playerNumber,
    required String userId,
  }) = _AddPlayerRequest;

  /// JSON から AddPlayerRequest を生成する。
  factory AddPlayerRequest.fromJson(Map<String, dynamic> json) =>
      _$AddPlayerRequestFromJson(json);
}
