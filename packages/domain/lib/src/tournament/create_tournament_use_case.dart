import 'dart:math' as math;

import 'package:injection/injection.dart';
import 'package:repository/repository.dart' as repository;
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain.dart';
import 'create_tournament_request.dart' as domain;

part 'create_tournament_use_case.g.dart';

/// [CreateTournamentUseCase] を提供する。
@riverpod
CreateTournamentUseCase createTournamentUseCase(Ref ref) {
  return CreateTournamentUseCase(
    tournamentRepository: ref.watch(tournamentRepositoryProvider),
  );
}

/// トーナメント作成に関する処理を行う UseCase。
class CreateTournamentUseCase {
  /// [CreateTournamentUseCase] を生成する。
  ///
  /// [tournamentRepository] は、トーナメントに関する通信を行うためのリポジトリ。
  const CreateTournamentUseCase({
    required repository.TournamentRepository tournamentRepository,
  }) : _tournamentRepository = tournamentRepository;

  final repository.TournamentRepository _tournamentRepository;

  /// トーナメントを作成する。
  ///
  /// [request]: 大会作成リクエスト
  ///
  /// Returns: 作成されたトーナメント情報
  /// Throws: [ArgumentError] リクエストの内容が不正な場合
  /// Throws: [FailureStatusException] API がエラーステータスを返した場合
  /// Throws: [GeneralFailureException] ネットワークエラーや予期しないエラーの場合
  Future<Tournament> call(domain.CreateTournamentRequest request) async {
    try {
      // バリデーション
      _validateRequest(request);

      // ラウンド数の決定（自動計算 or 手動指定）
      final maxRounds =
          request.maxRounds ??
          _calculateRecommendedRounds(request.expectedPlayers);

      // Repositoryレイヤー用のリクエストに変換
      final repositoryRequest = repository.CreateTournamentRequest(
        title: request.title,
        description: request.description,
        category: request.category,
        tournamentMode: request.tournamentMode,
        startDate: request.startDate,
        endDate: request.endDate,
        startTime: request.startTime,
        endTime: request.endTime,
        drawPoints: request.drawPoints,
        maxRounds: maxRounds,
        expectedPlayers: request.expectedPlayers,
      );

      final result = await _tournamentRepository.createTournament(
        repositoryRequest,
      );
      return Tournament.fromModel(result);
    } catch (e) {
      if (e is repository.AdminApiException) {
        switch (e.code) {
          case 'INVALID_ARGUMENT':
          case 'PARSE_ERROR':
            throw FailureStatusException(e.message);
          case 'UNAUTHENTICATED':
          case 'AUTH_ERROR':
            throw GeneralFailureException(
              reason: GeneralFailureReason.other,
              errorCode: e.code,
            );
          case 'NETWORK_ERROR':
            throw GeneralFailureException(
              reason: GeneralFailureReason.noConnectionError,
              errorCode: e.code,
            );
          default:
            throw GeneralFailureException(
              reason: GeneralFailureReason.other,
              errorCode: e.code,
            );
        }
      }
      rethrow;
    }
  }

  /// 推奨ラウンド数を取得する。
  ///
  /// [expectedPlayers]: 予定参加者数
  ///
  /// Returns: 推奨ラウンド数
  int getRecommendedRounds(int expectedPlayers) {
    return _calculateRecommendedRounds(expectedPlayers);
  }

  /// リクエストの内容をバリデーションする。
  void _validateRequest(domain.CreateTournamentRequest request) {
    // タイトルの検証
    if (request.title.trim().isEmpty) {
      throw ArgumentError('大会タイトルは必須です');
    }

    // 日時の検証
    try {
      final startDate = DateTime.parse(request.startDate);
      final endDate = DateTime.parse(request.endDate);

      if (endDate.isBefore(startDate)) {
        throw ArgumentError('終了日時は開始日時より後である必要があります');
      }
    } on FormatException {
      throw ArgumentError('日時の形式が正しくありません（ISO 8601形式が必要です）');
    }

    // 開催時刻の検証
    if (request.startTime.trim().isEmpty) {
      throw ArgumentError('開催開始時刻は必須です');
    }
    if (request.endTime.trim().isEmpty) {
      throw ArgumentError('開催終了時刻は必須です');
    }

    // 時刻のフォーマット検証（HH:mm形式）
    final timePattern = RegExp(r'^\d{2}:\d{2}$');
    if (!timePattern.hasMatch(request.startTime)) {
      throw ArgumentError('開催開始時刻の形式が正しくありません（HH:mm形式が必要です）');
    }
    if (!timePattern.hasMatch(request.endTime)) {
      throw ArgumentError('開催終了時刻の形式が正しくありません（HH:mm形式が必要です）');
    }

    // 開催時刻の論理検証（開始時刻 < 終了時刻）
    final startTimeParts = request.startTime.split(':');
    final endTimeParts = request.endTime.split(':');
    final startMinutes =
        int.parse(startTimeParts[0]) * 60 + int.parse(startTimeParts[1]);
    final endMinutes =
        int.parse(endTimeParts[0]) * 60 + int.parse(endTimeParts[1]);

    if (endMinutes <= startMinutes) {
      throw ArgumentError('終了時刻は開始時刻より後である必要があります');
    }

    // 引き分け得点の検証
    if (request.drawPoints < 0 || request.drawPoints > 1) {
      throw ArgumentError('引き分け得点は0点または1点である必要があります');
    }

    // ラウンド数の検証（手動指定時）
    if (request.maxRounds != null && request.maxRounds! < 1) {
      throw ArgumentError('ラウンド数は1以上である必要があります');
    }

    // 予定参加者数の検証
    if (request.expectedPlayers != null && request.expectedPlayers! < 2) {
      throw ArgumentError('予定参加者数は2名以上である必要があります');
    }

    // 自動計算時の必須チェック
    if (request.maxRounds == null &&
        (request.expectedPlayers == null || request.expectedPlayers! <= 0)) {
      throw ArgumentError('ラウンド数を自動計算する場合、予定参加者数の入力が必要です');
    }
  }

  /// 推奨ラウンド数を計算する。
  int _calculateRecommendedRounds(int? expectedPlayers) {
    if (expectedPlayers == null || expectedPlayers <= 0) {
      return 1;
    }

    // ceil(log2(players)) の計算
    final logValue = math.log(expectedPlayers) / math.log(2);
    return math.max(1, logValue.ceil());
  }
}
