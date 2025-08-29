import 'dart:async';

// クラス名が被っているもののみプレフィクスをつけてインポートする。
import 'package:logging/logging.dart' as logging show LogRecord, Logger;
import 'package:logging/logging.dart' hide LogRecord, Logger;

/// [LogRecord] 型のエイリアス。
typedef LogRecord = logging.LogRecord;

/// アプリケーション全体で使用する共通のロガー。
///
/// app またはテストの開始時に [setupLogging] を呼び出してログの出力先を設定する。
/// その後、[logDebug]、[logError] などのメソッドでログを出力する。
abstract final class Logger {
  /// [Logger] のインスタンス。
  static final _logger = logging.Logger('Global');

  /// デバッグレベルのログを出力する。
  ///
  /// [message] には、ログに出力するメッセージを指定する。
  /// [error] には、関連するエラーオブジェクトを指定する（オプション）。
  /// [stackTrace] には、スタックトレースを指定する（オプション）。
  static void logDebug(
    Object message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    _logger.fine(message, error, stackTrace);
  }

  /// エラーレベルのログを出力する。
  ///
  /// [message] には、ログに出力するメッセージを指定する。
  /// [error] には、関連するエラーオブジェクトを指定する（オプション）。
  /// [stackTrace] には、スタックトレースを指定する（オプション）。
  static void logError(
    Object message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    _logger.severe(message, error, stackTrace);
  }

  /// ログの出力先を設定する。
  ///
  /// [onRecord] には、ログレコードを処理するコールバック関数を指定する。
  /// [enableLogging] には、ログを有効にするかどうかを指定し（デフォルト: true ）、リリースモードの場合は false にする。
  ///
  /// 戻り値として [StreamSubscription] を返すため、必要に応じてキャンセルする。
  ///
  /// このメソッドは、[logDebug] や [logError] などのログ出力メソッドを使用する前に
  /// 必ず呼び出す必要がある。通常はアプリケーションの開始時やテストの setup で呼び出す。
  static StreamSubscription<LogRecord> setupLogging(
    void Function(LogRecord) onRecord, {
    bool enableLogging = true,
  }) {
    logging.Logger.root.level = enableLogging ? Level.ALL : Level.OFF;
    return logging.Logger.root.onRecord.listen(onRecord);
  }
}
