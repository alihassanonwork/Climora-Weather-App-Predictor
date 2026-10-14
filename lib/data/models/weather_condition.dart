import 'package:flutter/material.dart';
import '../../core/theme/climora_colors.dart';

/// Semantic weather categories mapped from WMO weather codes.
enum WeatherCategory {
  clear,
  partlyCloudy,
  overcast,
  fog,
  drizzle,
  rain,
  freezingRain,
  snow,
  rainShowers,
  snowShowers,
  thunderstorm,
  unknown;

  LinearGradient getGradient(bool isDay) {
    switch (this) {
      case WeatherCategory.clear:
        return isDay
            ? ClimoraColors.clearDayGradient
            : ClimoraColors.clearNightGradient;
      case WeatherCategory.partlyCloudy:
        return isDay
            ? ClimoraColors.clearDayGradient
            : ClimoraColors.clearNightGradient;
      case WeatherCategory.overcast:
      case WeatherCategory.fog:
        return ClimoraColors.cloudyGradient;
      case WeatherCategory.drizzle:
      case WeatherCategory.rain:
      case WeatherCategory.rainShowers:
      case WeatherCategory.freezingRain:
        return ClimoraColors.rainGradient;
      case WeatherCategory.snow:
      case WeatherCategory.snowShowers:
        return ClimoraColors.snowGradient;
      case WeatherCategory.thunderstorm:
        return ClimoraColors.thunderstormGradient;
      case WeatherCategory.unknown:
        return isDay
            ? ClimoraColors.clearDayGradient
            : ClimoraColors.clearNightGradient;
    }
  }
}

/// Strongly-typed information regarding a WMO weather code.
class WeatherConditionInfo {
  final int code;
  final String description;
  final WeatherCategory category;
  final IconData dayIcon;
  final IconData nightIcon;
  final Color accentColor;

  const WeatherConditionInfo({
    required this.code,
    required this.description,
    required this.category,
    required this.dayIcon,
    required this.nightIcon,
    required this.accentColor,
  });

  IconData getIcon(bool isDay) => isDay ? dayIcon : nightIcon;
}
