import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_session.freezed.dart';

/// プレイヤーセッション情報を保持するエンティティクラス。
///
/// プレイヤーが大会に登録した際に生成され、24時間有効なセッション情報を管理する。
@freezed
abstract class PlayerSession with _$PlayerSession {
  /// [PlayerSession] を生成する。
  const factory PlayerSession({
    /// プレイヤー ID.
    required String playerId,

    /// プレイヤー番号。
    required int playerNumber,

    /// ユーザー ID（認証用）。
    required String userId,

    /// 大会 ID.
    required String tournamentId,

    /// プレイヤー名。
    required String playerName,

    /// セッション作成時刻。
    required DateTime createdAt,

    /// セッション有効期限（24時間後）。
    required DateTime expiresAt,
  }) = _PlayerSession;

  const PlayerSession._();

  /// JSON から [PlayerSession] を生成する。
  factory PlayerSession.fromJson(Map<String, dynamic> json) {
    return PlayerSession(
      playerId: json['playerId'] as String,
      playerNumber: json['playerNumber'] as int,
      userId: json['userId'] as String,
      tournamentId: json['tournamentId'] as String,
      playerName: json['playerName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }

  /// [playerId] の初期値。
  static const playerIdDefault = '';

  /// [playerNumber] の初期値。
  static const playerNumberDefault = 0;

  /// [userId] の初期値。
  static const userIdDefault = '';

  /// [tournamentId] の初期値。
  static const tournamentIdDefault = '';

  /// [playerName] の初期値。
  static const playerNameDefault = '';

  /// [PlayerSession] を JSON に変換する。
  Map<String, dynamic> toJson() {
    return {
      'playerId': playerId,
      'playerNumber': playerNumber,
      'userId': userId,
      'tournamentId': tournamentId,
      'playerName': playerName,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
    };
  }
}
