import 'dart:async';

import 'package:logging/logging.dart' hide LogRecord, Logger;
import 'package:test/test.dart';
import 'package:util/src/logger.dart';

void main() {
  group('Logger のテスト。', () {
    late List<LogRecord> logRecords;
    late StreamSubscription<LogRecord> subscription;

    setUp(() {
      logRecords = <LogRecord>[];
    });

    tearDown(() async {
      await subscription.cancel();
    });

    group('setupLogging メソッドのテスト。', () {
      test('enableLogging が true の場合、ログが記録される。', () async {
        subscription = Logger.setupLogging(logRecords.add);

        Logger.logDebug('Test debug message');
        Logger.logError('Test error message');

        // ログレコードが記録されることを確認する。
        expect(logRecords, hasLength(2));
      });

      test('enableLogging が false の場合、ログが記録されない。', () async {
        subscription = Logger.setupLogging(
          logRecords.add,
          enableLogging: false,
        );

        Logger.logDebug('Test debug message');
        Logger.logError('Test error message');

        // ログレコードが記録されないことを確認する。
        expect(logRecords, isEmpty);
      });

      test('StreamSubscription が返される。', () {
        subscription = Logger.setupLogging(logRecords.add);

        expect(subscription, isA<StreamSubscription<LogRecord>>());
      });
    });

    group('logDebug メソッドのテスト。', () {
      setUp(() {
        subscription = Logger.setupLogging(logRecords.add);
      });

      test('メッセージのみを指定した場合、デバッグログが出力される。', () {
        Logger.logDebug('Debug message');

        expect(logRecords, hasLength(1));
        expect(logRecords[0].message, equals('Debug message'));
        expect(logRecords[0].level, equals(Level.FINE));
        expect(logRecords[0].error, isNull);
        expect(logRecords[0].stackTrace, isNull);
      });

      test('エラーオブジェクトも指定した場合、エラー情報が含まれる。', () {
        final testError = Exception('Test error');

        Logger.logDebug('Debug message with error', testError);

        expect(logRecords, hasLength(1));
        expect(logRecords[0].message, equals('Debug message with error'));
        expect(logRecords[0].level, equals(Level.FINE));
        expect(logRecords[0].error, equals(testError));
        expect(logRecords[0].stackTrace, isNull);
      });

      test('スタックトレースも指定した場合、スタックトレース情報が含まれる。', () {
        final testError = Exception('Test error');
        final testStackTrace = StackTrace.current;

        Logger.logDebug(
          'Debug message with stackTrace',
          testError,
          testStackTrace,
        );

        expect(logRecords, hasLength(1));
        expect(logRecords[0].message, equals('Debug message with stackTrace'));
        expect(logRecords[0].level, equals(Level.FINE));
        expect(logRecords[0].error, equals(testError));
        expect(logRecords[0].stackTrace, equals(testStackTrace));
      });
    });

    group('logError メソッドのテスト。', () {
      setUp(() {
        subscription = Logger.setupLogging(logRecords.add);
      });

      test('メッセージのみを指定した場合、エラーログが出力される。', () {
        Logger.logError('Error message');

        expect(logRecords, hasLength(1));
        expect(logRecords[0].message, equals('Error message'));
        expect(logRecords[0].level, equals(Level.SEVERE));
        expect(logRecords[0].error, isNull);
        expect(logRecords[0].stackTrace, isNull);
      });

      test('エラーオブジェクトも指定した場合、エラー情報が含まれる。', () {
        final testError = Exception('Test error');

        Logger.logError('Error message with error', testError);

        expect(logRecords, hasLength(1));
        expect(logRecords[0].message, equals('Error message with error'));
        expect(logRecords[0].level, equals(Level.SEVERE));
        expect(logRecords[0].error, equals(testError));
        expect(logRecords[0].stackTrace, isNull);
      });

      test('スタックトレースも指定した場合、スタックトレース情報が含まれる。', () {
        final testError = Exception('Test error');
        final testStackTrace = StackTrace.current;

        Logger.logError(
          'Error message with stackTrace',
          testError,
          testStackTrace,
        );

        expect(logRecords, hasLength(1));
        expect(logRecords[0].message, equals('Error message with stackTrace'));
        expect(logRecords[0].level, equals(Level.SEVERE));
        expect(logRecords[0].error, equals(testError));
        expect(logRecords[0].stackTrace, equals(testStackTrace));
      });
    });
  });
}
