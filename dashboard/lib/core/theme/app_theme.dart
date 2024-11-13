import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
    ),

    // Define the default font family
    fontFamily: GoogleFonts.poppins().fontFamily,
  );
}
