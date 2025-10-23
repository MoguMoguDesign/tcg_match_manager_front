import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain.dart';

part 'restore_session_use_case.g.dart';

/// [RestoreSessionUseCase] を提供する。
@riverpod
RestoreSessionUseCase restoreSessionUseCase(Ref ref) {
  return RestoreSessionUseCase(
    validatePlayerUseCase: ref.watch(validatePlayerUseCaseProvider),
  );
}

/// セッション復旧用ユースケース。
class RestoreSessionUseCase {
  /// [RestoreSessionUseCase] を生成する。
  ///
  /// [validatePlayerUseCase] は、プレイヤー認証を行うためのユースケース。
  RestoreSessionUseCase({
    required ValidatePlayerUseCase validatePlayerUseCase,
  }) : _validatePlayerUseCase = validatePlayerUseCase;

  final ValidatePlayerUseCase _validatePlayerUseCase;

  /// セッション復旧処理を実行する。
  ///
  /// - [baseUrl] は、API のベース URL。
  /// - [currentSession] は、現在のセッション情報。
  ///
  /// セッション情報の有効期限をチェックし、有効な場合は [ValidatePlayerUseCase] を
  /// 呼び出して認証を行い、新しいセッション情報を返す。
  Future<PlayerSession> invoke({
    required String baseUrl,
    required PlayerSession currentSession,
  }) async {
    // セッション有効期限をチェックする。
    if (!_isSessionValid(currentSession)) {
      throw const GeneralFailureException(
        reason: GeneralFailureReason.sessionExpired,
        errorCode: 'sessionExpired',
      );
    }

    // ValidatePlayerUseCase を呼び出して認証を行う。
    final newSession = await _validatePlayerUseCase.invoke(
      baseUrl: baseUrl,
      tournamentId: currentSession.tournamentId,
      userId: currentSession.userId,
    );

    return newSession;
  }

  /// セッションが有効かどうか。
  ///
  /// セッション有効期限が現在時刻より後であれば true を返す。
  bool _isSessionValid(PlayerSession session) {
    // セッションが存在しない場合は無効。
    if (session.playerId == PlayerSession.playerIdDefault) {
      return false;
    }

    // セッション有効期限が現在時刻より後であれば有効。
    return session.expiresAt.isAfter(DateTime.now());
  }
}
