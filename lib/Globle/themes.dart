import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tnt/Globle/colors.dart';


class Themes {
  // Light theme
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: blueColor,
      primary: blueColor,
      surface: whiteColor,
    ),
    useMaterial3: true,
    // AppBar theme
    appBarTheme: AppBarTheme(
      backgroundColor: whiteColor,
      titleTextStyle: GoogleFonts.poppins(
        color: blackColor,
        fontSize: appbarTextSize, // 14
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(color: blackColor),
    ),
    // Button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(12),
        backgroundColor: blueColor,
        textStyle: GoogleFonts.poppins(
          fontSize: buttonTextSize, // 14
          color: blackColor, // Black text on buttons
          fontWeight: FontWeight.w600,
        ),
        foregroundColor: blackColor, // For splash/ripple effect
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    // Text theme
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.poppins(
        fontSize: bodyLargeFontSize, // 16
        color: blackColor,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: bodyMediumFontSize, // 14
        color: blackColor,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: bodySmallFontSize, // 12
        color: blackColor,
      ),

      labelSmall: GoogleFonts.poppins(
        fontSize: hintFontSize, // 10 for hints
        color: lightBlackColor, // Light black for hints
      ),
    ),
    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: GoogleFonts.poppins(
        fontSize: bodySmallFontSize, // 12
        color: blackColor,
      ),
      hintStyle: GoogleFonts.poppins(
        fontSize: hintFontSize, // 10
        color: lightBlackColor, // Light black for hints
      ),
      prefixIconColor: blackColor,
      suffixIconColor: blackColor,
      fillColor: whiteColor,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 1, color: greyBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 2, color: blueColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 1, color: greyBorderColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 1, color: Colors.red),
      ),
    ),
  );

  // Dark theme
  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: blueColor,
      primary: blueColor,
      secondary: blueColor,
      surface: const Color(0xFF1E1E1E),
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    // AppBar theme
    appBarTheme: AppBarTheme(
      backgroundColor: blackColor,
      titleTextStyle: GoogleFonts.poppins(
        color: whiteColor, // White text for contrast in dark theme
        fontSize: appbarTextSize, // 14
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(color: whiteColor),
    ),
    // Button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(12),
        backgroundColor: blueColor,
        textStyle: GoogleFonts.poppins(
          fontSize: buttonTextSize, // 14
          color: blackColor, // Black text on buttons
          fontWeight: FontWeight.w600,
        ),
        foregroundColor: blackColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    // Text theme
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.poppins(
        fontSize: bodyLargeFontSize, // 16
        color: whiteColor, // White for dark theme
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: bodyMediumFontSize, // 14
        color: whiteColor,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: bodySmallFontSize, // 12
        color: whiteColor,
      ),
      labelSmall: GoogleFonts.poppins(
        fontSize: hintFontSize, // 10 for hints
        color: lightBlackColor, // Light black for hints
      ),
    ),
    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: GoogleFonts.poppins(
        fontSize: bodySmallFontSize, // 12
        color: whiteColor,
      ),
      hintStyle: GoogleFonts.poppins(
        fontSize: hintFontSize, // 10
        color: lightBlackColor, // Light black for hints
      ),
      prefixIconColor: whiteColor,
      suffixIconColor: whiteColor,
      fillColor: const Color(0xFF1E1E1E), // Dark input background
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 1, color: greyBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 2, color: blueColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 1, color: greyBorderColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 1, color: Colors.red),
      ),
    ),
  );
}
