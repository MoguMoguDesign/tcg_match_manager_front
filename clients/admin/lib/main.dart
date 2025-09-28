import 'package:base_ui/base_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';

/// Entry point of the application.
void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
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
