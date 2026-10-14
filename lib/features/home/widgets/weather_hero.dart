import 'package:flutter/material.dart';

import '../../../core/theme/climora_colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/unit_converter.dart';
import '../../../data/models/current_weather.dart';
import '../../../data/models/daily_forecast.dart';
import '../../../data/models/user_settings.dart';
import '../../../shared/widgets/weather_icon_widget.dart';

/// Hero weather banner showing current temperature, feels like, min/max, condition, and timestamp.
class WeatherHero extends StatelessWidget {
  final CurrentWeather current;
  final DailyForecastDay? todayForecast;
  final UserSettings settings;
  final DateTime? lastUpdated;

  const WeatherHero({
    super.key,
    required this.current,
    required this.todayForecast,
    required this.settings,
    this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final gradientColors = ClimoraColors.getWeatherGradient(
      current.weatherCode,
      isDay: current.isDay,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date & Time + Last updated
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormatter.formatFullDate(current.dateTime),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
              if (lastUpdated != null)
                Text(
                  'Updated ${DateFormatter.formatTime(lastUpdated)}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 11,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Main Temperature and Icon Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Giant Temperature
                    Text(
                      UnitConverter.formatTemperature(
                        current.temperature,
                        settings.temperatureUnit,
                      ),
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontSize: 68,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -2.0,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Weather Condition Title
                    Text(
                      current.condition.description,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
              WeatherIconWidget(
                iconPath: current.condition.iconPath,
                size: 80,
                color: Colors.white,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Divider
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.18),
          ),

          const SizedBox(height: 16),

          // Bottom Stats: Feels Like & Today's Min/Max
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Feels like
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.thermostat_rounded,
                    size: 18,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Feels like ${UnitConverter.formatTemperature(current.apparentTemperature, settings.temperatureUnit)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              // Min / Max
              if (todayForecast != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.arrow_upward_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                    Text(
                      UnitConverter.formatTemperature(
                        todayForecast!.temperatureMax,
                        settings.temperatureUnit,
                      ),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_downward_rounded,
                      size: 16,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                    Text(
                      UnitConverter.formatTemperature(
                        todayForecast!.temperatureMin,
                        settings.temperatureUnit,
                      ),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

