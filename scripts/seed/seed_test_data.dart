import 'dart:io';

import 'package:args/args.dart';
import 'package:logger/logger.dart';

import 'config/datasets.dart';
import 'config/seed_config.dart';

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
    final config = await SeedConfig.load(
      useEmulator: results['emulator'] as bool,
      datasets: _parseDatasets(results['dataset'] as String),
    );

    logger.i('🔧 設定読み込み完了');
    logger.d('プロジェクト ID: ${config.projectId}');
    logger.d('データセット: ${config.datasets}');
    logger.d('エミュレータ使用: ${config.useEmulator}');

    // 4. 本番環境への投入確認
    if (!config.useEmulator && !await _confirmProduction(config.projectId)) {
      logger.w('⚠️  投入がキャンセルされました');
      exit(0);
    }

    // 5. ドライランチェック
    if (results['dry-run'] as bool) {
      logger.i('🔍 ドライランモード: 実際の書き込みは行いません');
      for (final datasetId in config.datasets) {
        try {
          final dataset = TestDataset.fromId(datasetId);
          logger.i('  - ${dataset.displayName}');
        } catch (e) {
          logger.e('❌ 不明なデータセット: $datasetId');
        }
      }
      logger.i('✅ ドライラン完了');
      exit(0);
    }

    // TODO: 6. Firebase 初期化
    // TODO: 7. データ生成と投入

    logger.i('');
    logger.i('📊 投入結果');
    logger.i('  成功: 0 (未実装)');
    logger.i('  失敗: 0 (未実装)');
    logger.i('');
    logger.w('⚠️  データ生成と投入機能は Phase 2 以降で実装されます');

    exit(0);
  } catch (e, stackTrace) {
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
