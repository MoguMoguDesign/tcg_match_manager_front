import 'package:go_router/go_router.dart';

import 'pages/component_test_page.dart';
import 'pages/final_ranking_page.dart';
import 'pages/login_list_page.dart';
import 'pages/login_page.dart';
import 'pages/matching_table_page.dart';
import 'pages/pre_tournament_page.dart';
import 'pages/registration_page.dart';
import 'pages/result_entry_page.dart';

/// アプリケーション全体のルーティング設定を提供する。
final GoRouter appRouter = GoRouter(
  initialLocation: '/registration',
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/registration',
      name: 'registration',
      builder: (context, state) => const RegistrationPage(),
    ),
    GoRoute(
      path: '/login-list',
      name: 'login-list',
      builder: (context, state) => const LoginListPage(),
    ),
    GoRoute(
      path: '/pre-tournament',
      name: 'pre-tournament',
      builder: (context, state) => const PreTournamentPage(),
    ),
    GoRoute(
      path: '/matching-table',
      name: 'matching-table',
      builder: (context, state) => const MatchingTablePage(),
    ),
    GoRoute(
      path: '/result-entry',
      name: 'result-entry',
      builder: (context, state) => const ResultEntryPage(),
    ),
    GoRoute(
      path: '/final-ranking',
      name: 'final-ranking',
      builder: (context, state) => const FinalRankingPage(),
    ),
    GoRoute(
      path: '/component-test',
      name: 'component-test',
      builder: (context, state) => const ComponentTestPage(),
    ),
  ],
);
