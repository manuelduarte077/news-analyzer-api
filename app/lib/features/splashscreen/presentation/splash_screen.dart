import 'dart:async';

import 'package:app/routing/app_router.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    goToLogin();
  }

  /// Go to home screen

  void goToLogin() {
    Future.delayed(const Duration(seconds: 2), () {
      appRouter.go('/sign-in');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.indigoAccent,
      body: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
