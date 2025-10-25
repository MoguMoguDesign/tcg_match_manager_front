import 'dart:io';

import 'package:dotenv/dotenv.dart';

/// テストデータ投入の設定を管理する。
class SeedConfig {
  SeedConfig._({
    required this.projectId,
    required this.serviceAccountPath,
    required this.useEmulator,
    required this.emulatorHost,
    required this.datasets,
  });

  /// Firebase プロジェクト ID。
  final String projectId;

  /// サービスアカウントキーのパス。
  final String serviceAccountPath;

  /// エミュレータを使用するかどうか。
  final bool useEmulator;

  /// エミュレータのホスト。
  final String? emulatorHost;

  /// 投入するデータセット。
  final List<String> datasets;

  /// 設定を読み込む。
  ///
  /// [useEmulator] エミュレータを使用するかどうか（CLI オプションで上書き）。
  /// [datasets] 投入するデータセット（CLI オプションで上書き）。
  static Future<SeedConfig> load({
    required bool useEmulator,
    required List<String> datasets,
  }) async {
    // プロジェクトルートのパスを取得
    // pubspec.yaml が存在するディレクトリを探す
    final projectRoot = await _findProjectRoot();

    // .env.seed ファイルを読み込み
    final envPath = '${projectRoot.path}/.env.seed';
    final envFile = File(envPath);

    if (!await envFile.exists()) {
      throw Exception(
        '.env.seed ファイルが見つかりません: $envPath\n'
        '\n'
        '以下の手順でセットアップしてください：\n'
        '1. .env.seed.example をコピー\n'
        '   cp .env.seed.example .env.seed\n'
        '2. FIREBASE_PROJECT_ID を設定',
      );
    }

    final env = DotEnv()..load([envPath]);

    // 環境変数を取得
    final projectId = env['FIREBASE_PROJECT_ID'];
    if (projectId == null || projectId.isEmpty) {
      throw Exception('FIREBASE_PROJECT_ID が設定されていません。\n'
          '.env.seed ファイルを確認してください。');
    }

    var serviceAccountPath =
        env['SERVICE_ACCOUNT_KEY_PATH'] ?? './serviceAccountKey.json';

    // 相対パスの場合はプロジェクトルートからの絶対パスに変換
    if (!serviceAccountPath.startsWith('/')) {
      serviceAccountPath = '${projectRoot.path}/$serviceAccountPath';
    }

    // サービスアカウントキーの存在確認
    final keyFile = File(serviceAccountPath);
    if (!await keyFile.exists()) {
      throw Exception(
        'サービスアカウントキーが見つかりません: $serviceAccountPath\n'
        '\n'
        '以下の手順で取得してください：\n'
        '1. Firebase Console を開く\n'
        '2. プロジェクト設定 > サービスアカウント\n'
        '3. 新しい秘密鍵を生成\n'
        '4. ダウンロードした JSON をプロジェクトルートに配置',
      );
    }

    final emulatorHost = env['EMULATOR_HOST'];

    return SeedConfig._(
      projectId: projectId,
      serviceAccountPath: serviceAccountPath,
      useEmulator: useEmulator,
      emulatorHost: emulatorHost,
      datasets: datasets,
    );
  }

  /// プロジェクトルートディレクトリを検索する。
  ///
  /// 現在のディレクトリから親ディレクトリを遡って、
  /// pubspec.yaml が存在するディレクトリを返す。
  static Future<Directory> _findProjectRoot() async {
    var current = Directory.current;

    // 最大 10 階層まで遡る
    for (var i = 0; i < 10; i++) {
      final pubspec = File('${current.path}/pubspec.yaml');
      if (await pubspec.exists()) {
        return current;
      }

      final parent = current.parent;
      if (parent.path == current.path) {
        // ルートディレクトリに到達
        break;
      }
      current = parent;
    }

    throw Exception(
      'プロジェクトルート(pubspec.yaml が存在するディレクトリ)が見つかりません',
    );
  }
}
