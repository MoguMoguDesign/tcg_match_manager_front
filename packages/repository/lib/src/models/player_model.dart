import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_model.freezed.dart';
part 'player_model.g.dart';

/// プレイヤー情報を表すモデルクラス。
///
/// API レスポンスからプレイヤーデータを表現する。
@freezed
abstract class PlayerModel with _$PlayerModel {
  /// [PlayerModel] のコンストラクタ。
  const factory PlayerModel({
    /// プレイヤー ID。
    required String playerId,

    /// プレイヤー名。
    required String name,

    /// プレイヤー番号。
    required int playerNumber,

    /// プレイヤーステータス（ACTIVE, DROPPED など）。
    required String status,

    /// ユーザー ID（UUID v4）。
    required String userId,
  }) = _PlayerModel;

  /// JSON から PlayerModel インスタンスを作成する。
  factory PlayerModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerModelFromJson(json);
}
