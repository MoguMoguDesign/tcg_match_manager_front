import 'package:base_ui/base_ui.dart';
import 'package:domain/domain.dart' show authRepositoryProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injection/injection.dart' as injection;

import 'firebase_options.dart';
import 'router.dart';

/// Entry point of the application.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 環境変数を読み込む
  await dotenv.load();

  // Firebase を初期化する
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ProviderScope(
      overrides: [
        // AuthRepositoryのプロバイダーをオーバーライド
        authRepositoryProvider.overrideWith(injection.authRepository),
      ],
      child: const MyApp(),
    ),
  );
}

/// The main application widget.
class MyApp extends StatelessWidget {
  /// Creates a [MyApp].
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TCG Match Manager Admin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.adminPrimary),
        useMaterial3: true,
      ),
      routerConfig: adminRouter,
    );
  }
}
