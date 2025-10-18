import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:repository/repository.dart';

part 'player.freezed.dart';

/// プレイヤー情報を表すドメインエンティティ。
@freezed
abstract class Player with _$Player {
  /// [Player] のコンストラクタ。
  const factory Player({
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
  }) = _Player;

  const Player._();

  /// [PlayerModel] からドメインエンティティに変換する。
  factory Player.fromModel(PlayerModel model) {
    return Player(
      playerId: model.playerId,
      name: model.name,
      playerNumber: model.playerNumber,
      status: model.status,
      userId: model.userId,
    );
  }
}
