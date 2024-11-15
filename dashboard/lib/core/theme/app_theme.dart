import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      centerTitle: false,
      elevation: 0,
    ),

    // Define the default font family
    fontFamily: GoogleFonts.poppins().fontFamily,
  );
}
