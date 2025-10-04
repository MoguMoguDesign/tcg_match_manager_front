import 'package:freezed_annotation/freezed_annotation.dart';

part 'tournament_info_response.freezed.dart';
part 'tournament_info_response.g.dart';

/// 大会情報レスポンス。
@freezed
abstract class TournamentInfoResponse with _$TournamentInfoResponse {
  /// [TournamentInfoResponse] のコンストラクタ。
  const factory TournamentInfoResponse({
    /// 大会 ID。
    required String id,

    /// 大会名。
    required String name,

    /// 大会ステータス。
    required String status,

    /// スケジュール設定。
    required ScheduleInfo schedule,

    /// 現在のラウンド番号。
    required int currentRound,
  }) = _TournamentInfoResponse;

  /// JSON から [TournamentInfoResponse] を生成する。
  factory TournamentInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$TournamentInfoResponseFromJson(json);
}

/// スケジュール情報。
@freezed
abstract class ScheduleInfo with _$ScheduleInfo {
  /// [ScheduleInfo] のコンストラクタ。
  const factory ScheduleInfo({
    /// スケジュールモード（FIXED または UNTIL_CHAMPION）。
    required String mode,

    /// 総ラウンド数（FIXED モードの場合）。
    int? totalRounds,

    /// 最大ラウンド数（UNTIL_CHAMPION モードの場合）。
    int? maxRounds,
  }) = _ScheduleInfo;

  /// JSON から [ScheduleInfo] を生成する。
  factory ScheduleInfo.fromJson(Map<String, dynamic> json) =>
      _$ScheduleInfoFromJson(json);
}
