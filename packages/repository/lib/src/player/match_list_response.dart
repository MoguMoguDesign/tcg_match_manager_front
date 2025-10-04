import 'package:freezed_annotation/freezed_annotation.dart';

part 'match_list_response.freezed.dart';
part 'match_list_response.g.dart';

/// マッチリストレスポンス（配列）。
typedef MatchListResponse = List<Match>;

/// マッチ。
@freezed
abstract class Match with _$Match {
  /// [Match] のコンストラクタ。
  const factory Match({
    /// マッチ ID。
    required String id,

    /// 卓番号。
    required int tableNumber,

    /// 公開されているかどうか。
    required bool published,

    /// プレイヤー1。
    required MatchPlayer player1,

    /// プレイヤー2。
    required MatchPlayer player2,

    /// BYE マッチかどうか。
    required bool isByeMatch,

    /// 結果（未確定の場合は null）。
    required MatchResultDetail? result,

    /// 自分のマッチかどうか。
    required bool isMine,

    /// 自分の側（player1 または player2、自分のマッチでない場合は null）。
    String? meSide,
  }) = _Match;

  /// JSON から [Match] を生成する。
  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);
}

/// マッチ内のプレイヤー情報。
@freezed
abstract class MatchPlayer with _$MatchPlayer {
  /// [MatchPlayer] のコンストラクタ。
  const factory MatchPlayer({
    /// プレイヤー ID。
    required String id,

    /// プレイヤー名。
    required String name,

    /// マッチングポイント（累計勝点）。
    required int matchingPoints,
  }) = _MatchPlayer;

  /// JSON から [MatchPlayer] を生成する。
  factory MatchPlayer.fromJson(Map<String, dynamic> json) =>
      _$MatchPlayerFromJson(json);
}

/// マッチ結果詳細（GET レスポンス用）。
@freezed
abstract class MatchResultDetail with _$MatchResultDetail {
  /// [MatchResultDetail] のコンストラクタ。
  const factory MatchResultDetail({
    /// 結果タイプ。
    required String type,

    /// 勝者のプレイヤー ID。
    String? winnerId,

    /// 送信日時。
    String? submittedAt,

    /// 送信したプレイヤー ID。
    String? submittedBy,

    /// 送信者のユーザー ID。
    String? submitterUserId,
  }) = _MatchResultDetail;

  /// JSON から [MatchResultDetail] を生成する。
  factory MatchResultDetail.fromJson(Map<String, dynamic> json) =>
      _$MatchResultDetailFromJson(json);
}
