import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../features/auth/presentation/login_screen.dart';
import '../features/auth/provider/auth_provider.dart';
import '../features/home/home_page.dart';
import '../features/splash/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final router = GoRouter(
            initialLocation: '/',
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const SplashScreen(),
              ),
              GoRoute(
                path: '/login',
                builder: (context, state) => const LoginScreen(),
              ),
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomePage(),
              ),
            ],
            redirect: (context, state) {
              final isAuthenticated = authProvider.isAuthenticated;

              if (state.uri.path == '/' && isAuthenticated) {
                return '/home';
              } else if (state.uri.path == '/' && !isAuthenticated) {
                return '/login';
              }
              return null;
            },
          );

          return MaterialApp.router(
            routerConfig: router,
            title: 'DaktarLamara Dashboard',
          );
        },
      ),
    );
  }
}
