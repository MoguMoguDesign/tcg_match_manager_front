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
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 環境変数からAdmin API URLを取得
  final adminApiUrl = dotenv.env['ADMIN_API_URL'];
  if (adminApiUrl == null || adminApiUrl.isEmpty) {
    throw Exception('ADMIN_API_URL is not configured in .env file');
  }

  runApp(
    ProviderScope(
      overrides: [
        // AuthRepositoryのプロバイダーをオーバーライド
        authRepositoryProvider.overrideWith(injection.authRepository),
        // Admin API BaseURLのプロバイダーをオーバーライド
        injection.adminApiBaseUrlProvider.overrideWith((ref) => adminApiUrl),
        // TournamentRepositoryのプロバイダーをオーバーライド
        injection.tournamentRepositoryProvider.overrideWith(
          (ref) => injection.getTournamentRepository(),
        ),
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
