import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:repository/repository.dart' as repo;

part 'match.freezed.dart';

/// マッチ情報を保持するエンティティクラス。
///
/// プレイヤーが対戦表を確認する際に使用するマッチ情報を管理する。
@freezed
abstract class Match with _$Match {
  /// [Match] を生成する。
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
    MatchResultDetail? result,

    /// 自分のマッチかどうか。
    required bool isMine,

    /// 自分の側（player1 または player2、自分のマッチでない場合は null）。
    String? meSide,
  }) = _Match;

  const Match._();

  /// Repository層のMatchモデルから [Match] エンティティを生成する。
  factory Match.fromRepositoryModel(repo.Match repoMatch) {
    return Match(
      id: repoMatch.id,
      tableNumber: repoMatch.tableNumber,
      published: repoMatch.published,
      player1: MatchPlayer.fromRepositoryModel(repoMatch.player1),
      player2: MatchPlayer.fromRepositoryModel(repoMatch.player2),
      isByeMatch: repoMatch.isByeMatch,
      result: repoMatch.result != null
          ? MatchResultDetail.fromRepositoryModel(repoMatch.result!)
          : null,
      isMine: repoMatch.isMine,
      meSide: repoMatch.meSide,
    );
  }
}

/// マッチ内のプレイヤー情報を保持するエンティティクラス。
@freezed
abstract class MatchPlayer with _$MatchPlayer {
  /// [MatchPlayer] を生成する。
  const factory MatchPlayer({
    /// プレイヤー ID。
    required String id,

    /// プレイヤー名。
    required String name,

    /// マッチングポイント（累計勝点）。
    required int matchingPoints,
  }) = _MatchPlayer;

  const MatchPlayer._();

  /// Repository層のMatchPlayerモデルから [MatchPlayer] エンティティを生成する。
  factory MatchPlayer.fromRepositoryModel(repo.MatchPlayer repoPlayer) {
    return MatchPlayer(
      id: repoPlayer.id,
      name: repoPlayer.name,
      matchingPoints: repoPlayer.matchingPoints,
    );
  }
}

/// マッチ結果詳細を保持するエンティティクラス。
@freezed
abstract class MatchResultDetail with _$MatchResultDetail {
  /// [MatchResultDetail] を生成する。
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

  const MatchResultDetail._();

  /// Repository層のMatchResultDetailモデルから [MatchResultDetail] エンティティを生成する。
  factory MatchResultDetail.fromRepositoryModel(
    repo.MatchResultDetail repoResult,
  ) {
    return MatchResultDetail(
      type: repoResult.type,
      winnerId: repoResult.winnerId,
      submittedAt: repoResult.submittedAt,
      submittedBy: repoResult.submittedBy,
      submitterUserId: repoResult.submitterUserId,
    );
  }
}
