import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'pages/component_test_page.dart';
import 'pages/final_ranking_page.dart';
import 'pages/login_list_page.dart';
import 'pages/login_page.dart';
// import 'pages/match_result_input_page.dart';
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
      name: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/registration',
      name: AppRoutes.registration,
      builder: (context, state) => const RegistrationPage(),
    ),
    GoRoute(
      path: '/login-list',
      name: AppRoutes.loginList,
      builder: (context, state) => const LoginListPage(),
    ),
    GoRoute(
      path: '/pre-tournament',
      name: AppRoutes.preTournament,
      builder: (context, state) => const PreTournamentPage(),
    ),
    GoRoute(
      path: '/matching-table',
      name: AppRoutes.matchingTable,
      builder: (context, state) => const MatchingTablePage(),
    ),
    GoRoute(
      path: '/result-entry',
      name: AppRoutes.resultEntry,
      builder: (context, state) => const ResultEntryPage(),
    ),
    // GoRoute(
    //   path: '/match-result-input/:tournamentId',
    //   name: AppRoutes.matchResultInput,
    //   builder: (context, state) {
    //     final tournamentId = state.pathParameters['tournamentId']!;
    //     final roundNumber = state.uri.queryParameters['roundNumber'];
    //     return MatchResultInputPage(
    //       tournamentId: tournamentId,
    //       roundNumber:
    //           roundNumber != null ? int.tryParse(roundNumber) : null,
    //     );
    //   },
    // ),
    // GoRoute(
    //   path: '/match-generation',
    //   name: AppRoutes.matchGeneration,
    //   builder: (context, state) => const MatchGenerationPage(),
    // ),
    // GoRoute(
    //   path: '/match-publish',
    //   name: AppRoutes.matchPublish,
    //   builder: (context, state) => const MatchPublishPage(),
    // ),
    GoRoute(
      path: '/final-ranking',
      name: AppRoutes.finalRanking,
      builder: (context, state) => const FinalRankingPage(),
    ),
    GoRoute(
      path: '/component-test',
      name: AppRoutes.componentTest,
      builder: (context, state) => const ComponentTestPage(),
    ),
  ],
);

/// ルート名の定数クラス。
/// タイプセーフなナビゲーションのために使用する。
class AppRoutes {
  AppRoutes._();

  /// ログインページ。
  static const String login = 'login';

  /// 登録ページ。
  static const String registration = 'registration';

  /// ログインリストページ。
  static const String loginList = 'login-list';

  /// トーナメント前ページ。
  static const String preTournament = 'pre-tournament';

  /// マッチングテーブルページ。
  static const String matchingTable = 'matching-table';

  /// マッチ生成ページ。
  static const String matchGeneration = 'match-generation';

  /// マッチ公開ページ。
  static const String matchPublish = 'match-publish';

  /// 結果入力ページ。
  static const String resultEntry = 'result-entry';

  /// マッチ結果入力ページ。
  static const String matchResultInput = 'match-result-input';

  /// 最終ランキングページ。
  static const String finalRanking = 'final-ranking';

  /// コンポーネントテストページ。
  static const String componentTest = 'component-test';
}

/// タイプセーフなナビゲーションのための拡張メソッド。
extension AppNavigator on BuildContext {
  /// ログインページに遷移する。
  void goToLogin() => goNamed(AppRoutes.login);

  /// 登録ページに遷移する。
  void goToRegistration() => goNamed(AppRoutes.registration);

  /// ログインリストページに遷移する。
  void goToLoginList() => goNamed(AppRoutes.loginList);

  /// トーナメント前ページに遷移する。
  void goToPreTournament() => goNamed(AppRoutes.preTournament);

  /// マッチングテーブルページに遷移する。
  void goToMatchingTable() => goNamed(AppRoutes.matchingTable);

  /// マッチ生成ページに遷移する。
  void goToMatchGeneration() => goNamed(AppRoutes.matchGeneration);

  /// マッチ公開ページに遷移する。
  void goToMatchPublish() => goNamed(AppRoutes.matchPublish);

  /// 結果入力ページに遷移する。
  void goToResultEntry() => goNamed(AppRoutes.resultEntry);

  /// マッチ結果入力ページに遷移する。
  void goToMatchResultInput({required String tournamentId, int? roundNumber}) {
    final queryParams = <String, String>{};
    if (roundNumber != null) {
      queryParams['roundNumber'] = roundNumber.toString();
    }

    if (queryParams.isNotEmpty) {
      goNamed(
        AppRoutes.matchResultInput,
        pathParameters: {'tournamentId': tournamentId},
        queryParameters: queryParams,
      );
    } else {
      goNamed(
        AppRoutes.matchResultInput,
        pathParameters: {'tournamentId': tournamentId},
      );
    }
  }

  /// 最終ランキングページに遷移する。
  void goToFinalRanking() => goNamed(AppRoutes.finalRanking);

  /// コンポーネントテストページに遷移する。
  void goToComponentTest() => goNamed(AppRoutes.componentTest);
}
