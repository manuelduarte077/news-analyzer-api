import 'package:dashboard/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../features/auth/presentation/login_screen.dart';
import '../features/auth/provider/auth_provider.dart';
import '../features/home/home_page.dart';
import '../features/splash/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      child: ChangeNotifierProvider(
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

            return ToastificationWrapper(
              config: const ToastificationConfig(
                alignment: Alignment.topRight,
              ),
              child: MaterialApp.router(
                routerConfig: router,
                theme: AppTheme.light,
                title: 'DaktarLamara Dashboard',
              ),
            );
          },
        ),
      ),
    );
  }
}
