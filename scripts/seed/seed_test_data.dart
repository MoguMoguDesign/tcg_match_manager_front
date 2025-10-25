import 'dart:io';

import 'package:args/args.dart';
import 'package:logger/logger.dart';

import 'config/datasets.dart';
import 'config/seed_config.dart';
import 'generators/dataset_factory.dart';
import 'utils/firebase_initializer.dart';
import 'writer/firestore_writer.dart';

/// テストデータ投入スクリプトのエントリーポイント。
///
/// 使用例:
/// ```bash
/// # 全データセット投入
/// dart run seed_test_data.dart
///
/// # 特定データセットのみ
/// dart run seed_test_data.dart --dataset small
///
/// # エミュレータ使用
/// dart run seed_test_data.dart --emulator
/// ```
Future<void> main(List<String> args) async {
  // 1. コマンドライン引数のパース
  final parser = _buildArgParser();
  late final ArgResults results;

  try {
    results = parser.parse(args);
  } on FormatException catch (e) {
    print('❌ 引数エラー: ${e.message}');
    print('');
    print(parser.usage);
    exit(1);
  }

  // ヘルプ表示
  if (results['help'] as bool) {
    print('テストデータ投入スクリプト');
    print('');
    print(parser.usage);
    exit(0);
  }

  // 2. ロガー初期化
  final logger = Logger(
    level: results['verbose'] as bool ? Level.debug : Level.info,
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
    ),
  );

  try {
    // 3. 設定読み込み
    print('DEBUG: 設定読み込み開始...');
    final isDryRun = results['dry-run'] as bool;
    final config = await SeedConfig.load(
      useEmulator: results['emulator'] as bool,
      datasets: _parseDatasets(results['dataset'] as String),
      skipValidation: isDryRun, // dry-run時はサービスアカウントキー検証をスキップ
    );

    print('DEBUG: 設定読み込み完了');
    logger.i('🔧 設定読み込み完了');
    logger.d('プロジェクト ID: ${config.projectId}');
    logger.d('データセット: ${config.datasets}');
    logger.d('エミュレータ使用: ${config.useEmulator}');

    // 4. 本番環境への投入確認
    if (!config.useEmulator && !await _confirmProduction(config.projectId)) {
      logger.w('⚠️  投入がキャンセルされました');
      exit(0);
    }

    // 5. データセットファクトリー初期化
    final factory = DatasetFactory();

    // 6. ドライランチェック
    if (isDryRun) {
      print('DEBUG: ドライランモード開始');
      logger.i('🔍 ドライランモード: 実際の書き込みは行いません');
      logger.i('');

      for (final datasetId in config.datasets) {
        try {
          print('DEBUG: データセット処理開始: $datasetId');
          final dataset = TestDataset.fromId(datasetId);
          print('DEBUG: データセット名: ${dataset.displayName}');
          logger.i('📦 データセット: ${dataset.displayName}');

          // データ生成（検証のため）
          print('DEBUG: データ生成開始');
          final data = factory.generate(datasetId);
          print('DEBUG: データ生成完了');

          // データ検証
          print('DEBUG: データ検証開始');
          final validation = data.validate();
          print('DEBUG: 検証結果: ${validation.isValid}');
          if (validation.isValid) {
            print('  ✅ 検証成功');
            print('  - プレイヤー数: ${data.players.length}');
            print('  - ラウンド数: ${data.rounds.length}');
            logger.i('  ✅ 検証成功');
            logger.i('  - プレイヤー数: ${data.players.length}');
            logger.i('  - ラウンド数: ${data.rounds.length}');
          } else {
            print('  ❌ 検証失敗: ${validation.errors}');
            logger.e('  ❌ 検証失敗: ${validation.errors}');
          }
          logger.i('');
        } catch (e) {
          print('DEBUG: エラー発生: $e');
          logger.e('❌ エラー: $datasetId - $e');
          logger.i('');
        }
      }

      logger.i('✅ ドライラン完了');
      exit(0);
    }

    // 7. Firebase 初期化
    print('DEBUG: Firebase 初期化開始');
    logger.i('🔥 Firebase 初期化中...');

    final firestore = await FirebaseInitializer.initialize(
      projectId: config.projectId,
      serviceAccountPath: config.serviceAccountPath,
      useEmulator: config.useEmulator,
      emulatorHost: config.emulatorHost,
    );

    logger.i('✅ Firebase 初期化完了');

    // 8. データ投入
    logger.i('');
    logger.i('📝 データ投入開始...');
    logger.i('');

    final writer = FirestoreWriter(
      firestore: firestore,
      logger: logger,
      forceOverwrite: results['force'] as bool,
    );

    var successCount = 0;
    var failureCount = 0;

    for (final datasetId in config.datasets) {
      try {
        final dataset = TestDataset.fromId(datasetId);
        logger.i('📦 データセット: ${dataset.displayName}');

        // データ生成
        final data = factory.generate(datasetId);

        // データ書き込み
        final result = await writer.writeTournament(data);

        if (result.success) {
          successCount++;
        } else {
          failureCount++;
          if (result.error != null) {
            logger.w('  ${result.error}');
          }
        }

        logger.i('');
      } catch (e) {
        failureCount++;
        logger.e('❌ エラー: $datasetId - $e');
        logger.i('');
      }
    }

    // 9. 結果サマリー
    logger.i('');
    logger.i('📊 投入結果');
    logger.i('  成功: $successCount');
    logger.i('  失敗: $failureCount');
    logger.i('');

    if (failureCount == 0) {
      logger.i('✅ すべてのデータセットの投入に成功しました');
    } else {
      logger.w('⚠️  一部のデータセットの投入に失敗しました');
    }

    exit(failureCount == 0 ? 0 : 1);
  } catch (e, stackTrace) {
    print('DEBUG: エラー発生');
    print('ERROR: $e');
    print('STACK: $stackTrace');
    logger.e('❌ エラーが発生しました', error: e, stackTrace: stackTrace);
    exit(1);
  }
}

/// コマンドライン引数パーサーを構築する。
ArgParser _buildArgParser() {
  return ArgParser()
    ..addOption(
      'dataset',
      abbr: 'd',
      defaultsTo: 'all',
      help: '投入するデータセット（small, bye, completed, preparing, all）',
    )
    ..addFlag(
      'emulator',
      abbr: 'e',
      defaultsTo: false,
      help: 'エミュレータを使用する',
    )
    ..addFlag(
      'force',
      abbr: 'f',
      defaultsTo: false,
      help: '既存データを強制上書き',
    )
    ..addFlag(
      'verbose',
      abbr: 'v',
      defaultsTo: false,
      help: '詳細ログを出力',
    )
    ..addFlag(
      'dry-run',
      defaultsTo: false,
      help: '実際の書き込みを行わず、処理内容のみ表示',
    )
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'ヘルプを表示',
    );
}

/// データセット指定をパースする。
List<String> _parseDatasets(String input) {
  if (input == 'all') {
    return TestDataset.allIds;
  }
  return input.split(',').map((e) => e.trim()).toList();
}

/// 本番環境への投入を確認する。
Future<bool> _confirmProduction(String projectId) async {
  if (projectId.contains('prod') || projectId.contains('production')) {
    print('⚠️  本番環境への投入を検出しました: $projectId');
    print('本当に実行しますか？ (yes/no): ');

    final input = stdin.readLineSync();
    return input?.toLowerCase() == 'yes';
  }
  return true;
}
