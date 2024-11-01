import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/animations/custom_transition_page.dart';
import '../features/auth/auth.dart';
import '../features/home/home_screen.dart';
import '../features/splashscreen/presentation/splash_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: navigatorKey,
  debugLogDiagnostics: true,
  initialLocation: '/',
  routerNeglect: true,
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        return buildCustomTransitionPage(
          key: state.pageKey,
          child: const SplashScreen(),
        );
      },
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) {
        return buildCustomTransitionPage(
          key: state.pageKey,
          child: const HomeScreen(),
        );
      },
    ),

    // Auth
    GoRoute(
      path: '/sign-in',
      pageBuilder: (context, state) {
        return buildCustomTransitionPage(
          key: state.pageKey,
          child: const SignInPage(),
        );
      },
    ),
    // Auth
    GoRoute(
      path: '/sign-up',
      pageBuilder: (context, state) {
        return buildCustomTransitionPage(
          key: state.pageKey,
          child: const SignupPage(),
        );
      },
    ),
  ],
);
