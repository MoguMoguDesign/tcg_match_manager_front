import 'package:flutter/material.dart';

import 'router.dart';

/// Entry point of the application.
void main() {
  runApp(const MyApp());
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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3A44FB)),
        useMaterial3: true,
      ),
      routerConfig: adminRouter,
    );
  }
}
