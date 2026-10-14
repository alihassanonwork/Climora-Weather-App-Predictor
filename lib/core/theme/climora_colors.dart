import 'package:flutter/material.dart';

/// Design tokens and semantic color definitions for Climora.
class ClimoraColors {
  ClimoraColors._();

  // Primary Palette - Navy & Sky Blues
  static const Color navyDarkest = Color(0xFF0A1128);
  static const Color navyDark = Color(0xFF101F42);
  static const Color navyPrimary = Color(0xFF1C315E);
  static const Color navySurface = Color(0xFF1E293B);
  static const Color navyCard = Color(0xFF1E2C48);

  static const Color skyPrimary = Color(0xFF0284C7);
  static const Color skyLight = Color(0xFF38BDF8);
  static const Color skyLighter = Color(0xFFBAE6FD);
  static const Color skyAccent = Color(0xFF00B4D8);
  static const Color skyBlue = Color(0xFF0284C7);

  // Backgrounds
  static const Color backgroundLight = Color(0xFFF1F5F9);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);

  static const Color backgroundDark = Color(0xFF0B132B);
  static const Color surfaceDark = Color(0xFF141F3C);
  static const Color cardDark = Color(0xFF1C2A4A);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF475569);
  static const Color textMutedLight = Color(0xFF94A3B8);

  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFFCBD5E1);
  static const Color textMutedDark = Color(0xFF64748B);

  // Weather Condition Accents
  static const Color sunAmber = Color(0xFFF59E0B);
  static const Color sunGold = Color(0xFFFBBF24);
  static const Color rainBlue = Color(0xFF3B82F6);
  static const Color stormPurple = Color(0xFF8B5CF6);
  static const Color snowCyan = Color(0xFF06B6D4);
  static const Color uvExtreme = Color(0xFFEF4444);
  static const Color uvHigh = Color(0xFFF97316);
  static const Color uvModerate = Color(0xFFFBBF24);
  static const Color uvLow = Color(0xFF10B981);

  static const Color accentCoral = Color(0xFFEF4444);
  static const Color accentGold = Color(0xFFFBBF24);
  static const Color tealAccent = Color(0xFF0D9488);
  static const Color oceanBlue = Color(0xFF1D4ED8);

  // Borders & Dividers
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderDark = Color(0xFF2D3C5E);
  static const Color dividerLight = Color(0xFFE2E8F0);
  static const Color dividerDark = Color(0xFF1E293B);

  // Weather Gradient Presets
  static const LinearGradient clearDayGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0284C7), Color(0xFF38BDF8), Color(0xFF7DD3FC)],
  );

  static const LinearGradient clearNightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF334155)],
  );

  static const LinearGradient cloudyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF334155), Color(0xFF475569), Color(0xFF64748B)],
  );

  static const LinearGradient rainGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E3A8A), Color(0xFF1D4ED8), Color(0xFF3B82F6)],
  );

  static const LinearGradient snowGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E293B), Color(0xFF3B82F6), Color(0xFF93C5FD)],
  );

  static const LinearGradient thunderstormGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF18181B), Color(0xFF27272A), Color(0xFF4C1D95)],
  );

  static List<Color> getWeatherGradient(int weatherCode, {bool isDay = true}) {
    if (!isDay) {
      return const [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF334155)];
    }
    if (weatherCode == 0 || weatherCode == 1) {
      return const [Color(0xFF0284C7), Color(0xFF38BDF8)];
    }
    if (weatherCode == 2 || weatherCode == 3) {
      return const [Color(0xFF1E293B), Color(0xFF475569)];
    }
    if (weatherCode >= 51 && weatherCode <= 67) {
      return const [Color(0xFF1E3A8A), Color(0xFF3B82F6)];
    }
    if (weatherCode >= 71 && weatherCode <= 86) {
      return const [Color(0xFF1E293B), Color(0xFF60A5FA)];
    }
    if (weatherCode >= 95) {
      return const [Color(0xFF18181B), Color(0xFF4C1D95)];
    }
    return const [Color(0xFF0284C7), Color(0xFF38BDF8)];
  }
}

