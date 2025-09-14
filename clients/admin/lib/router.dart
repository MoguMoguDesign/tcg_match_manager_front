import 'package:go_router/go_router.dart';

import 'pages/auth/login_page.dart';
import 'pages/auth/password_reset_page.dart';
import 'pages/auth/signup_page.dart';
import 'pages/home/tournament_detail_page.dart';
import 'pages/home/tournament_list_page.dart';

/// 管理者アプリケーションのルーター設定
final adminRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    // 認証関連ルート
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const AdminLoginPage(),
    ),
    GoRoute(
      path: '/signup',
      name: 'signup',
      builder: (context, state) => const AdminSignupPage(),
    ),
    GoRoute(
      path: '/password-reset',
      name: 'password-reset',
      builder: (context, state) => const AdminPasswordResetPage(),
    ),
    
    // メイン管理画面ルート
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const TournamentListPage(),
    ),
    GoRoute(
      path: '/tournament/:id',
      name: 'tournament-detail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return TournamentDetailPage(tournamentId: id);
      },
    ),
  ],
);
