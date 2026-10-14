import 'package:flutter/material.dart';

import '../../../core/theme/climora_colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/unit_converter.dart';
import '../../../core/utils/weather_interpreter.dart';
import '../../../data/models/current_weather.dart';
import '../../../data/models/daily_forecast.dart';
import '../../../data/models/user_settings.dart';
import '../../../shared/widgets/climora_card.dart';

/// Clean 2-column grid displaying key meteorological measurements.
class MetricsGrid extends StatelessWidget {
  final CurrentWeather current;
  final DailyForecastDay? today;
  final UserSettings settings;

  const MetricsGrid({
    super.key,
    required this.current,
    required this.today,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final windDirection =
        UnitConverter.formatWindDirection(current.windDirection);

    final uvCategory =
        current.uvIndex != null
            ? WeatherInterpreter.getUvCategory(current.uvIndex!)
            : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              'Weather Details',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : ClimoraColors.navyPrimary,
              ),
            ),
          ),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.45,
            children: [
              // 1. Wind
              _MetricCard(
                icon: Icons.air_rounded,
                iconColor: ClimoraColors.tealAccent,
                label: 'Wind',
                value: UnitConverter.formatWind(
                  current.windSpeed,
                  settings.windSpeedUnit,
                ),
                subValue: '$windDirection (${current.windDirection.toStringAsFixed(0)}°)',
              ),

              // 2. Humidity
              _MetricCard(
                icon: Icons.water_drop_rounded,
                iconColor: ClimoraColors.skyBlue,
                label: 'Humidity',
                value: '${current.relativeHumidity}%',
                subValue:
                    current.relativeHumidity > 70
                        ? 'High humidity'
                        : current.relativeHumidity < 30
                        ? 'Dry air'
                        : 'Comfortable',
              ),

              // 3. Pressure
              _MetricCard(
                icon: Icons.compress_rounded,
                iconColor: ClimoraColors.oceanBlue,
                label: 'Pressure',
                value: UnitConverter.formatPressure(
                  current.surfacePressure,
                  settings.pressureUnit,
                ),
                subValue: 'Atmospheric',
              ),

              // 4. UV Index
              _MetricCard(
                icon: Icons.wb_sunny_rounded,
                iconColor: ClimoraColors.accentGold,
                label: 'UV Index',
                value:
                    current.uvIndex != null
                        ? current.uvIndex!.toStringAsFixed(1)
                        : (today?.uvIndexMax != null
                            ? today!.uvIndexMax!.toStringAsFixed(1)
                            : 'N/A'),
                subValue: uvCategory,
              ),

              // 5. Precipitation / Rain
              _MetricCard(
                icon: Icons.umbrella_rounded,
                iconColor: ClimoraColors.skyBlue,
                label: 'Precipitation',
                value: UnitConverter.formatRain(
                  current.precipitation,
                  settings.precipitationUnit,
                ),
                subValue:
                    today?.precipitationProbabilityMax != null
                        ? '${today!.precipitationProbabilityMax}% chance today'
                        : 'Accumulated',
              ),

              // 6. Sunrise / Sunset
              _MetricCard(
                icon: Icons.wb_twilight_rounded,
                iconColor: ClimoraColors.accentCoral,
                label: 'Sun Cycle',
                value:
                    today?.sunriseDateTime != null
                        ? DateFormatter.formatTime(today!.sunriseDateTime)
                        : 'N/A',
                subValue:
                    today?.sunsetDateTime != null
                        ? 'Sunset ${DateFormatter.formatTime(today!.sunsetDateTime)}'
                        : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String? subValue;

  const _MetricCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.subValue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ClimoraCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? Colors.white60 : Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : ClimoraColors.navyPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (subValue != null)
            Text(
              subValue!,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isDark ? Colors.white54 : Colors.black45,
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          else
            const SizedBox(height: 14),
        ],
      ),
    );
  }
}

