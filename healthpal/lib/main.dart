import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthpal/utils/app_strings/app_strings.dart';
import 'package:healthpal/views/splash/splash_view.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      home: SplashView(),
    );
  }
}
