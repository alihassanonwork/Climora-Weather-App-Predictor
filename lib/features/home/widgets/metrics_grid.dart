import 'package:flutter/material.dart';

import '../../../core/theme/climora_colors.dart';
import '../../../data/models/current_weather.dart';
import '../../../data/models/daily_forecast.dart';
import '../../../data/models/hourly_forecast.dart';
import '../../../data/models/user_settings.dart';
import 'visualizations/humidity_visual_card.dart';
import 'visualizations/precipitation_visual_card.dart';
import 'visualizations/pressure_gauge_card.dart';
import 'visualizations/sun_cycle_card.dart';
import 'visualizations/uv_gauge_card.dart';
import 'visualizations/wind_compass_card.dart';

/// Comprehensive 2-column grid of animated meteorological visualizations
/// communicating weather physics through dials, gauges, compasses, and charts.
class MetricsGrid extends StatelessWidget {
  final CurrentWeather current;
  final DailyForecastDay? today;
  final UserSettings settings;
  final List<HourlyForecastItem> hourly;

  const MetricsGrid({
    super.key,
    required this.current,
    required this.today,
    required this.settings,
    this.hourly = const [],
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Row(
              children: [
                const Icon(
                  Icons.insights_rounded,
                  size: 18,
                  color: ClimoraColors.skyBlue,
                ),
                const SizedBox(width: 8),
                Text(
                  'Weather Details',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.2,
                    color: isDark ? Colors.white : ClimoraColors.navyPrimary,
                  ),
                ),
              ],
            ),
          ),

          // Row 1: Wind Compass & Relative Humidity
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: WindCompassCard(
                  windSpeed: current.windSpeed,
                  windDirection: current.windDirection,
                  unit: settings.windSpeedUnit,
                  hourly: hourly,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: HumidityVisualCard(
                  relativeHumidity: current.relativeHumidity,
                  hourly: hourly,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Row 2: Atmospheric Pressure & UV Index
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: PressureGaugeCard(
                  surfacePressure: current.surfacePressure,
                  unit: settings.pressureUnit,
                  hourly: hourly,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: UvGaugeCard(
                  uvIndex: current.uvIndex,
                  uvIndexMax: today?.uvIndexMax,
                  isDay: current.isDay,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Row 3: Precipitation & Sun Cycle
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: PrecipitationVisualCard(
                  precipitation: current.precipitation,
                  precipitationProbabilityMax:
                      today?.precipitationProbabilityMax,
                  unit: settings.precipitationUnit,
                  hourly: hourly,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SunCycleCard(
                  sunrise: today?.sunriseDateTime,
                  sunset: today?.sunsetDateTime,
                  isDay: current.isDay,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
