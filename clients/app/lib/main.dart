import 'package:base_ui/base_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injection/injection.dart';
import 'package:util/util.dart';

import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ログ出力を初期化する。
  if (kReleaseMode) {
    Logger.setupLogging(
      // リリースモードの場合はログを出力しない。
      enableLogging: false,
      (record) {
        // MEMO(masaki): 一定レベル以上のログをサーバーへ送信する。
      },
    );
  } else {
    Logger.setupLogging((_) {});
  }

  // MEMO(masaki): 意図しない例外が発生した場合のための対応を検討する。
  // クラッシュしないように try-catch してサーバーへログ送信 & アプリが開けないようにダイアログを表示する、等。
  // SharedPreferencesClient を非同期で初期化する。
  final sharedPreferencesClient = await getSharedPreferencesClient();

  final container = ProviderContainer(
    // 各プロバイダーを injection パッケージ経由で初期化する。
    overrides: [
      httpClientProvider.overrideWith((ref) => getHttpClient()),
      sharedPreferencesClientProvider.overrideWithValue(
        sharedPreferencesClient,
      ),
    ],
  );

  runApp(
    UncontrolledProviderScope(container: container, child: const MainApp()),
  );
}

/// [runApp] から直接呼び出される大元となるウィジェット。
class MainApp extends ConsumerWidget {
  /// [MainApp] を生成する。
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      // base_ui パッケージに定義した多言語対応の設定を適用する。
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      localeListResolutionCallback: localeListResolutionCallback,
      routerConfig: appRouter,
      theme: CommonThemeData.lightTheme,
      darkTheme: CommonThemeData.darkTheme,
    );
  }
}
