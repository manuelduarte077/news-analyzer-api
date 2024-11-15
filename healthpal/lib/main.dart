import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthpal/firebase_options.dart';
import 'package:healthpal/core/utils/app_strings/app_strings.dart';
import 'package:healthpal/features/splash/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// Firebase Crashlytics
  const fatalError = true;

  // Non-async exceptions
  FlutterError.onError = (errorDetails) {
    if (fatalError) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      // ignore: dead_code
    } else {
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    }
  };

  // Async exceptions
  PlatformDispatcher.instance.onError = (error, stack) {
    if (fatalError) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      // ignore: dead_code
    } else {
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
    return true;
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return MaterialApp(
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      home: SplashView(),
    );
  }
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      // Define the default font family.
      fontFamily: GoogleFonts.poppins().fontFamily,

      // Define the default brightness and colors.
      scaffoldBackgroundColor: Colors.white,
    );
  }
}
