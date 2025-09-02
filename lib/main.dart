import 'package:flutter/material.dart';

import 'pages/final_ranking_page.dart';
import 'pages/login_list_page.dart';
import 'pages/matching_table_page.dart';
import 'pages/pre_tournament_page.dart';
import 'pages/registration_page.dart';
import 'pages/result_entry_page.dart';

/// アプリケーションのエントリーポイント。
void main() {
  runApp(const MyApp());
}

/// TCGマッチマネージャーアプリのルートウィジェット。
class MyApp extends StatelessWidget {
  /// [MyApp]のコンストラクタ。
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TCG Match Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'M PLUS 1p',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const RegistrationPage(),
        '/login-list': (context) => const LoginListPage(),
        '/pre-tournament': (context) => const PreTournamentPage(),
        '/matching-table': (context) => const MatchingTablePage(),
        '/result-entry': (context) => const ResultEntryPage(),
        '/final-ranking': (context) => const FinalRankingPage(),
      },
    );
  }
}
