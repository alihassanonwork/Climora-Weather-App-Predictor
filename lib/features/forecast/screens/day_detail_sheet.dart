import 'package:flutter/material.dart';

import '../../../core/theme/climora_colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/unit_converter.dart';
import '../../../data/models/daily_forecast.dart';
import '../../../data/models/hourly_forecast.dart';
import '../../../data/models/user_settings.dart';
import '../../../shared/widgets/climora_card.dart';
import '../../../shared/widgets/weather_icon_widget.dart';

/// Modal bottom sheet or screen showing deep daily details and hourly progression.
class DayDetailSheet extends StatelessWidget {
  final DailyForecastDay day;
  final List<HourlyForecastItem> dayHourly;
  final UserSettings settings;

  const DayDetailSheet({
    super.key,
    required this.day,
    required this.dayHourly,
    required this.settings,
  });

  static Future<void> show(
    BuildContext context, {
    required DailyForecastDay day,
    required List<HourlyForecastItem> allHourly,
    required UserSettings settings,
  }) {
    // Filter hours that belong to this calendar day
    final dayHours =
        allHourly.where((h) {
          return h.dateTime.year == day.dateTime.year &&
              h.dateTime.month == day.dateTime.month &&
              h.dateTime.day == day.dateTime.day;
        }).toList();

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => DayDetailSheet(
            day: day,
            dayHourly: dayHours,
            settings: settings,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.45,
      maxChildSize: 0.94,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? ClimoraColors.navyCard : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 24,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        WeatherIconWidget(
                          iconPath: day.condition.iconPath,
                          size: 56,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormatter.formatFullDate(day.dateTime),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isDark
                                          ? Colors.white
                                          : ClimoraColors.navyPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                day.condition.description,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: ClimoraColors.skyBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              UnitConverter.formatTemperature(
                                day.temperatureMax,
                                settings.temperatureUnit,
                              ),
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color:
                                    isDark
                                        ? Colors.white
                                        : ClimoraColors.navyPrimary,
                              ),
                            ),
                            Text(
                              UnitConverter.formatTemperature(
                                day.temperatureMin,
                                settings.temperatureUnit,
                              ),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isDark ? Colors.white60 : Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ClimoraCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatItem(
                                  context: context,
                                  icon: Icons.water_drop_rounded,
                                  label: 'Precipitation Prob.',
                                  value:
                                      day.precipitationProbabilityMax != null
                                          ? '${day.precipitationProbabilityMax}%'
                                          : 'N/A',
                                  color: ClimoraColors.skyBlue,
                                ),
                              ),
                              Expanded(
                                child: _buildStatItem(
                                  context: context,
                                  icon: Icons.grain_rounded,
                                  label: 'Rain Amount',
                                  value:
                                      UnitConverter.formatRain(
                                        day.precipitationSum,
                                        settings.precipitationUnit,
                                      ),
                                  color: ClimoraColors.oceanBlue,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatItem(
                                  context: context,
                                  icon: Icons.air_rounded,
                                  label: 'Max Wind',
                                  value:
                                      UnitConverter.formatWind(
                                        day.windSpeedMax,
                                        settings.windSpeedUnit,
                                      ),
                                  color: ClimoraColors.tealAccent,
                                ),
                              ),
                              Expanded(
                                child: _buildStatItem(
                                  context: context,
                                  icon: Icons.wb_sunny_rounded,
                                  label: 'Max UV Index',
                                  value:
                                      day.uvIndexMax != null
                                          ? day.uvIndexMax!.toStringAsFixed(1)
                                          : 'N/A',
                                  color: ClimoraColors.accentGold,
                                ),
                              ),
                            ],
                          ),
                          if (day.sunrise != null || day.sunset != null) ...[
                            const Divider(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatItem(
                                    context: context,
                                    icon: Icons.wb_twilight_rounded,
                                    label: 'Sunrise',
                                    value: DateFormatter.formatTime(
                                      day.sunriseDateTime,
                                    ),
                                    color: ClimoraColors.accentGold,
                                  ),
                                ),
                                Expanded(
                                  child: _buildStatItem(
                                    context: context,
                                    icon: Icons.nights_stay_rounded,
                                    label: 'Sunset',
                                    value: DateFormatter.formatTime(
                                      day.sunsetDateTime,
                                    ),
                                    color: ClimoraColors.skyBlue,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (dayHourly.isNotEmpty) ...[
                      Text(
                        'Hourly Forecast',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? Colors.white : ClimoraColors.navyPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 120,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: dayHourly.length,
                          separatorBuilder:
                              (_, __) => const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final h = dayHourly[index];
                            return Container(
                              width: 68,
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 6,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isDark
                                        ? ClimoraColors.navySurface.withValues(
                                          alpha: 0.6,
                                        )
                                        : ClimoraColors.skyBlue.withValues(
                                          alpha: 0.08,
                                        ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color:
                                      isDark
                                          ? Colors.white12
                                          : ClimoraColors.skyBlue.withValues(
                                            alpha: 0.2,
                                          ),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormatter.formatHour(h.dateTime),
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  WeatherIconWidget(
                                    iconPath: h.condition.iconPath,
                                    size: 26,
                                  ),
                                  Text(
                                    UnitConverter.formatTemperature(
                                      h.temperature,
                                      settings.temperatureUnit,
                                    ),
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  if (h.precipitationProbability > 0)
                                    Text(
                                      '${h.precipitationProbability}%',
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            color: ClimoraColors.skyBlue,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    )
                                  else
                                    const SizedBox(height: 12),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : ClimoraColors.navyPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

