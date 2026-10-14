import 'package:flutter/material.dart';
import 'climora_colors.dart';

/// Material 3 theme configurations for Climora (Light & Dark modes).
class ClimoraTheme {
  ClimoraTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: ClimoraColors.navyPrimary,
      scaffoldBackgroundColor: ClimoraColors.backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: ClimoraColors.navyPrimary,
        secondary: ClimoraColors.skyPrimary,
        surface: ClimoraColors.surfaceLight,
        error: Colors.redAccent,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: ClimoraColors.textPrimaryLight,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: ClimoraColors.navyDarkest),
        titleTextStyle: TextStyle(
          color: ClimoraColors.navyDarkest,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardTheme(
        color: ClimoraColors.cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: ClimoraColors.borderLight, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(
        color: ClimoraColors.dividerLight,
        thickness: 1,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 68,
          fontWeight: FontWeight.w200,
          color: ClimoraColors.textPrimaryLight,
          letterSpacing: -2.0,
          height: 1.0,
        ),
        displayMedium: TextStyle(
          fontSize: 44,
          fontWeight: FontWeight.w300,
          color: ClimoraColors.textPrimaryLight,
          letterSpacing: -1.0,
        ),
        headlineLarge: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: ClimoraColors.textPrimaryLight,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: ClimoraColors.textPrimaryLight,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: ClimoraColors.textPrimaryLight,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: ClimoraColors.textPrimaryLight,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: ClimoraColors.textPrimaryLight,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: ClimoraColors.textSecondaryLight,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: ClimoraColors.textMutedLight,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ClimoraColors.skyPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      iconTheme: const IconThemeData(
        color: ClimoraColors.textPrimaryLight,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: ClimoraColors.skyPrimary,
      scaffoldBackgroundColor: ClimoraColors.backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: ClimoraColors.skyLight,
        secondary: ClimoraColors.skyPrimary,
        surface: ClimoraColors.surfaceDark,
        error: Colors.redAccent,
        onPrimary: ClimoraColors.navyDarkest,
        onSecondary: Colors.white,
        onSurface: ClimoraColors.textPrimaryDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: ClimoraColors.textPrimaryDark),
        titleTextStyle: TextStyle(
          color: ClimoraColors.textPrimaryDark,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardTheme(
        color: ClimoraColors.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: ClimoraColors.borderDark, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(
        color: ClimoraColors.dividerDark,
        thickness: 1,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 68,
          fontWeight: FontWeight.w200,
          color: ClimoraColors.textPrimaryDark,
          letterSpacing: -2.0,
          height: 1.0,
        ),
        displayMedium: TextStyle(
          fontSize: 44,
          fontWeight: FontWeight.w300,
          color: ClimoraColors.textPrimaryDark,
          letterSpacing: -1.0,
        ),
        headlineLarge: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: ClimoraColors.textPrimaryDark,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: ClimoraColors.textPrimaryDark,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: ClimoraColors.textPrimaryDark,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: ClimoraColors.textPrimaryDark,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: ClimoraColors.textPrimaryDark,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: ClimoraColors.textSecondaryDark,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: ClimoraColors.textMutedDark,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ClimoraColors.skyPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      iconTheme: const IconThemeData(
        color: ClimoraColors.textPrimaryDark,
      ),
    );
  }
}
