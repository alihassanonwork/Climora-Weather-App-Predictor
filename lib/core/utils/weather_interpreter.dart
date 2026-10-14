import 'package:flutter/material.dart';
import '../theme/climora_colors.dart';
import '../../data/models/weather_condition.dart';

/// Interprets WMO Weather Interpretation Codes and UV Index values.
class WeatherInterpreter {
  WeatherInterpreter._();

  /// Maps a WMO code to human-readable condition, category, icons, and accent colors.
  static WeatherConditionInfo interpret(int? code) {
    if (code == null) {
      return const WeatherConditionInfo(
        code: -1,
        description: 'Unknown',
        category: WeatherCategory.unknown,
        dayIcon: Icons.help_outline_rounded,
        nightIcon: Icons.help_outline_rounded,
        accentColor: ClimoraColors.skyLight,
      );
    }

    switch (code) {
      case 0:
        return const WeatherConditionInfo(
          code: 0,
          description: 'Clear sky',
          category: WeatherCategory.clear,
          dayIcon: Icons.wb_sunny_rounded,
          nightIcon: Icons.nightlight_round,
          accentColor: ClimoraColors.sunGold,
        );
      case 1:
        return const WeatherConditionInfo(
          code: 1,
          description: 'Mainly clear',
          category: WeatherCategory.clear,
          dayIcon: Icons.wb_sunny_outlined,
          nightIcon: Icons.nightlight_outlined,
          accentColor: ClimoraColors.sunAmber,
        );
      case 2:
        return const WeatherConditionInfo(
          code: 2,
          description: 'Partly cloudy',
          category: WeatherCategory.partlyCloudy,
          dayIcon: Icons.cloud_outlined,
          nightIcon: Icons.cloud_outlined,
          accentColor: ClimoraColors.skyLight,
        );
      case 3:
        return const WeatherConditionInfo(
          code: 3,
          description: 'Overcast',
          category: WeatherCategory.overcast,
          dayIcon: Icons.cloud_rounded,
          nightIcon: Icons.cloud_rounded,
          accentColor: ClimoraColors.textMutedDark,
        );
      case 45:
        return const WeatherConditionInfo(
          code: 45,
          description: 'Fog',
          category: WeatherCategory.fog,
          dayIcon: Icons.foggy,
          nightIcon: Icons.foggy,
          accentColor: ClimoraColors.textMutedLight,
        );
      case 48:
        return const WeatherConditionInfo(
          code: 48,
          description: 'Depositing rime fog',
          category: WeatherCategory.fog,
          dayIcon: Icons.foggy,
          nightIcon: Icons.foggy,
          accentColor: ClimoraColors.textMutedLight,
        );
      case 51:
        return const WeatherConditionInfo(
          code: 51,
          description: 'Light drizzle',
          category: WeatherCategory.drizzle,
          dayIcon: Icons.grain_rounded,
          nightIcon: Icons.grain_rounded,
          accentColor: ClimoraColors.skyAccent,
        );
      case 53:
        return const WeatherConditionInfo(
          code: 53,
          description: 'Moderate drizzle',
          category: WeatherCategory.drizzle,
          dayIcon: Icons.grain_rounded,
          nightIcon: Icons.grain_rounded,
          accentColor: ClimoraColors.skyAccent,
        );
      case 55:
        return const WeatherConditionInfo(
          code: 55,
          description: 'Dense drizzle',
          category: WeatherCategory.drizzle,
          dayIcon: Icons.grain_rounded,
          nightIcon: Icons.grain_rounded,
          accentColor: ClimoraColors.rainBlue,
        );
      case 56:
        return const WeatherConditionInfo(
          code: 56,
          description: 'Light freezing drizzle',
          category: WeatherCategory.freezingRain,
          dayIcon: Icons.ac_unit_rounded,
          nightIcon: Icons.ac_unit_rounded,
          accentColor: ClimoraColors.snowCyan,
        );
      case 57:
        return const WeatherConditionInfo(
          code: 57,
          description: 'Dense freezing drizzle',
          category: WeatherCategory.freezingRain,
          dayIcon: Icons.ac_unit_rounded,
          nightIcon: Icons.ac_unit_rounded,
          accentColor: ClimoraColors.snowCyan,
        );
      case 61:
        return const WeatherConditionInfo(
          code: 61,
          description: 'Slight rain',
          category: WeatherCategory.rain,
          dayIcon: Icons.water_drop_outlined,
          nightIcon: Icons.water_drop_outlined,
          accentColor: ClimoraColors.skyAccent,
        );
      case 63:
        return const WeatherConditionInfo(
          code: 63,
          description: 'Moderate rain',
          category: WeatherCategory.rain,
          dayIcon: Icons.water_drop_rounded,
          nightIcon: Icons.water_drop_rounded,
          accentColor: ClimoraColors.rainBlue,
        );
      case 65:
        return const WeatherConditionInfo(
          code: 65,
          description: 'Heavy rain',
          category: WeatherCategory.rain,
          dayIcon: Icons.water_drop_rounded,
          nightIcon: Icons.water_drop_rounded,
          accentColor: ClimoraColors.rainBlue,
        );
      case 66:
        return const WeatherConditionInfo(
          code: 66,
          description: 'Light freezing rain',
          category: WeatherCategory.freezingRain,
          dayIcon: Icons.ac_unit_rounded,
          nightIcon: Icons.ac_unit_rounded,
          accentColor: ClimoraColors.snowCyan,
        );
      case 67:
        return const WeatherConditionInfo(
          code: 67,
          description: 'Heavy freezing rain',
          category: WeatherCategory.freezingRain,
          dayIcon: Icons.ac_unit_rounded,
          nightIcon: Icons.ac_unit_rounded,
          accentColor: ClimoraColors.snowCyan,
        );
      case 71:
        return const WeatherConditionInfo(
          code: 71,
          description: 'Slight snowfall',
          category: WeatherCategory.snow,
          dayIcon: Icons.cloudy_snowing,
          nightIcon: Icons.cloudy_snowing,
          accentColor: ClimoraColors.snowCyan,
        );
      case 73:
        return const WeatherConditionInfo(
          code: 73,
          description: 'Moderate snowfall',
          category: WeatherCategory.snow,
          dayIcon: Icons.ac_unit_rounded,
          nightIcon: Icons.ac_unit_rounded,
          accentColor: ClimoraColors.snowCyan,
        );
      case 75:
        return const WeatherConditionInfo(
          code: 75,
          description: 'Heavy snowfall',
          category: WeatherCategory.snow,
          dayIcon: Icons.ac_unit_rounded,
          nightIcon: Icons.ac_unit_rounded,
          accentColor: ClimoraColors.snowCyan,
        );
      case 77:
        return const WeatherConditionInfo(
          code: 77,
          description: 'Snow grains',
          category: WeatherCategory.snow,
          dayIcon: Icons.grain_rounded,
          nightIcon: Icons.grain_rounded,
          accentColor: ClimoraColors.snowCyan,
        );
      case 80:
        return const WeatherConditionInfo(
          code: 80,
          description: 'Slight rain showers',
          category: WeatherCategory.rainShowers,
          dayIcon: Icons.shower_rounded,
          nightIcon: Icons.shower_rounded,
          accentColor: ClimoraColors.skyAccent,
        );
      case 81:
        return const WeatherConditionInfo(
          code: 81,
          description: 'Moderate rain showers',
          category: WeatherCategory.rainShowers,
          dayIcon: Icons.shower_rounded,
          nightIcon: Icons.shower_rounded,
          accentColor: ClimoraColors.rainBlue,
        );
      case 82:
        return const WeatherConditionInfo(
          code: 82,
          description: 'Violent rain showers',
          category: WeatherCategory.rainShowers,
          dayIcon: Icons.thunderstorm_rounded,
          nightIcon: Icons.thunderstorm_rounded,
          accentColor: ClimoraColors.stormPurple,
        );
      case 85:
        return const WeatherConditionInfo(
          code: 85,
          description: 'Slight snow showers',
          category: WeatherCategory.snowShowers,
          dayIcon: Icons.cloudy_snowing,
          nightIcon: Icons.cloudy_snowing,
          accentColor: ClimoraColors.snowCyan,
        );
      case 86:
        return const WeatherConditionInfo(
          code: 86,
          description: 'Heavy snow showers',
          category: WeatherCategory.snowShowers,
          dayIcon: Icons.cloudy_snowing,
          nightIcon: Icons.cloudy_snowing,
          accentColor: ClimoraColors.snowCyan,
        );
      case 95:
        return const WeatherConditionInfo(
          code: 95,
          description: 'Thunderstorm',
          category: WeatherCategory.thunderstorm,
          dayIcon: Icons.thunderstorm_rounded,
          nightIcon: Icons.thunderstorm_rounded,
          accentColor: ClimoraColors.stormPurple,
        );
      case 96:
        return const WeatherConditionInfo(
          code: 96,
          description: 'Thunderstorm with slight hail',
          category: WeatherCategory.thunderstorm,
          dayIcon: Icons.thunderstorm_rounded,
          nightIcon: Icons.thunderstorm_rounded,
          accentColor: ClimoraColors.stormPurple,
        );
      case 99:
        return const WeatherConditionInfo(
          code: 99,
          description: 'Thunderstorm with heavy hail',
          category: WeatherCategory.thunderstorm,
          dayIcon: Icons.thunderstorm_rounded,
          nightIcon: Icons.thunderstorm_rounded,
          accentColor: ClimoraColors.stormPurple,
        );
      default:
        return WeatherConditionInfo(
          code: code,
          description: 'Code ',
          category: WeatherCategory.unknown,
          dayIcon: Icons.cloud_outlined,
          nightIcon: Icons.cloud_outlined,
          accentColor: ClimoraColors.skyLight,
        );
    }
  }

  /// Categorizes UV index with health guidance and warning level.
  static ({String label, String guidance, Color color}) interpretUvIndex(
      double? uv) {
    if (uv == null) {
      return (
        label: 'Unknown',
        guidance: 'UV data is currently unavailable.',
        color: ClimoraColors.textMutedLight,
      );
    }
    if (uv < 3) {
      return (
        label: 'Low',
        guidance: 'No protection needed. You can safely stay outside.',
        color: ClimoraColors.uvLow,
      );
    } else if (uv < 6) {
      return (
        label: 'Moderate',
        guidance: 'Wear sunglasses and apply SPF 30+ sunscreen if outdoors.',
        color: ClimoraColors.uvModerate,
      );
    } else if (uv < 8) {
      return (
        label: 'High',
        guidance: 'Seek shade during midday. Wear a wide-brim hat and SPF 50.',
        color: ClimoraColors.uvHigh,
      );
    } else if (uv < 11) {
      return (
        label: 'Very High',
        guidance: 'Extra protection essential. Avoid midday sun exposure.',
        color: ClimoraColors.uvHigh,
      );
    } else {
      return (
        label: 'Extreme',
        guidance: 'Take all precautions. Unprotected skin can burn in minutes.',
        color: ClimoraColors.uvExtreme,
      );
    }
  }
}
