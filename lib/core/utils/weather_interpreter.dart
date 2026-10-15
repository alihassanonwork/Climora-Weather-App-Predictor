import 'package:flutter/material.dart';
import '../theme/climora_colors.dart';
import '../../data/models/weather_condition.dart';

/// Interprets WMO Weather Interpretation Codes and UV Index values.
class WeatherInterpreter {
  WeatherInterpreter._();

  /// Maps a WMO code to human-readable condition, category, icons, and accent colors.
  static WeatherConditionInfo interpret(int? code, {bool isDay = true}) {
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
          description: 'Code $code',
          category: WeatherCategory.unknown,
          dayIcon: Icons.cloud_outlined,
          nightIcon: Icons.cloud_outlined,
          accentColor: ClimoraColors.skyLight,
        );
    }
  }

  /// Categorizes UV index with health guidance and warning level.
  static ({String label, String guidance, Color color}) interpretUvIndex(
    double? uv,
  ) {
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

  static String getUvCategory(double uv) {
    return interpretUvIndex(uv).label;
  }

  static String getUvAdvice(double uv) {
    return interpretUvIndex(uv).guidance;
  }

  /// Calculates atmospheric pressure trend (rising, falling, steady) based on current & 3h past pressure.
  static ({String label, IconData icon, Color color}) getPressureTrend(
    double currentPressure,
    double? pastPressure,
  ) {
    if (pastPressure == null) {
      return (
        label: 'Steady',
        icon: Icons.trending_flat_rounded,
        color: ClimoraColors.oceanBlue,
      );
    }
    final diff = currentPressure - pastPressure;
    if (diff > 1.0) {
      return (
        label: 'Rising',
        icon: Icons.trending_up_rounded,
        color: ClimoraColors.tealAccent,
      );
    } else if (diff < -1.0) {
      return (
        label: 'Falling',
        icon: Icons.trending_down_rounded,
        color: ClimoraColors.accentCoral,
      );
    } else {
      return (
        label: 'Steady',
        icon: Icons.trending_flat_rounded,
        color: ClimoraColors.skyBlue,
      );
    }
  }

  /// Categorizes wind speed using the international Beaufort Wind Force Scale.
  static ({String name, String effect, int force}) getBeaufortScale(
    double speedKmh,
  ) {
    if (speedKmh < 1.0) {
      return (name: 'Calm', effect: 'Smoke rises vertically', force: 0);
    } else if (speedKmh <= 5.0) {
      return (
        name: 'Light air',
        effect: 'Smoke drift indicates direction',
        force: 1,
      );
    } else if (speedKmh <= 11.0) {
      return (
        name: 'Light breeze',
        effect: 'Leaves rustle, wind felt on face',
        force: 2,
      );
    } else if (speedKmh <= 19.0) {
      return (
        name: 'Gentle breeze',
        effect: 'Leaves & twigs in constant motion',
        force: 3,
      );
    } else if (speedKmh <= 28.0) {
      return (
        name: 'Moderate breeze',
        effect: 'Small branches move, dust raised',
        force: 4,
      );
    } else if (speedKmh <= 38.0) {
      return (name: 'Fresh breeze', effect: 'Small trees sway', force: 5);
    } else if (speedKmh <= 49.0) {
      return (
        name: 'Strong breeze',
        effect: 'Large branches in motion',
        force: 6,
      );
    } else if (speedKmh <= 61.0) {
      return (name: 'Near gale', effect: 'Whole trees sway', force: 7);
    } else if (speedKmh <= 74.0) {
      return (name: 'Gale', effect: 'Twigs break off trees', force: 8);
    } else if (speedKmh <= 88.0) {
      return (
        name: 'Severe gale',
        effect: 'Slight structural damage',
        force: 9,
      );
    } else {
      return (
        name: 'Storm',
        effect: 'Trees uprooted, widespread damage',
        force: 10,
      );
    }
  }

  /// Evaluates relative humidity and comfort level.
  static ({String label, String summary, Color color}) getHumidityCategory(
    int humidity,
  ) {
    if (humidity < 30) {
      return (
        label: 'Dry air',
        summary: 'Low moisture level. Drink water.',
        color: ClimoraColors.accentGold,
      );
    } else if (humidity <= 60) {
      return (
        label: 'Comfortable',
        summary: 'Ideal relative humidity.',
        color: ClimoraColors.tealAccent,
      );
    } else if (humidity <= 75) {
      return (
        label: 'Moderate',
        summary: 'Noticeable moisture in air.',
        color: ClimoraColors.skyBlue,
      );
    } else {
      return (
        label: 'High humidity',
        summary: 'Air feels muggy and sticky.',
        color: ClimoraColors.oceanBlue,
      );
    }
  }
}
