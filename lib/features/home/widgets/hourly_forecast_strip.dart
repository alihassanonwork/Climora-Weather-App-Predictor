import 'package:flutter/material.dart';

import '../../../core/theme/climora_colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/unit_converter.dart';
import '../../../data/models/hourly_forecast.dart';
import '../../../data/models/user_settings.dart';
import '../../../shared/widgets/climora_card.dart';
import '../../../shared/widgets/weather_icon_widget.dart';

/// Horizontally scrollable strip displaying hourly predictions with precipitation probabilities.
class HourlyForecastStrip extends StatelessWidget {
  final List<HourlyForecastItem> hourlyList;
  final UserSettings settings;

  const HourlyForecastStrip({
    super.key,
    required this.hourlyList,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    if (hourlyList.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Filter to show next 24 hours starting from current time
    final now = DateTime.now();
    final futureHours =
        hourlyList
            .where((h) {
              return h.dateTime.isAfter(
                now.subtract(const Duration(minutes: 59)),
              );
            })
            .take(24)
            .toList();

    final displayHours =
        futureHours.isNotEmpty ? futureHours : hourlyList.take(24).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClimoraCard(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 18,
                        color: ClimoraColors.skyBlue,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Hourly Forecast',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? Colors.white : ClimoraColors.navyPrimary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '24 Hours',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 126,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: displayHours.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final item = displayHours[index];
                  final isCurrentHour = index == 0;

                  return Container(
                    width: 66,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isCurrentHour
                              ? ClimoraColors.skyBlue.withValues(
                                alpha: isDark ? 0.25 : 0.15,
                              )
                              : isDark
                              ? ClimoraColors.navySurface.withValues(alpha: 0.5)
                              : ClimoraColors.skyBlue.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            isCurrentHour
                                ? ClimoraColors.skyBlue
                                : isDark
                                ? Colors.white12
                                : Colors.black.withValues(alpha: 0.06),
                        width: isCurrentHour ? 1.5 : 1.0,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isCurrentHour
                              ? 'Now'
                              : DateFormatter.formatHour(item.dateTime),
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight:
                                isCurrentHour
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                            color:
                                isCurrentHour
                                    ? ClimoraColors.skyBlue
                                    : isDark
                                    ? Colors.white70
                                    : Colors.black54,
                          ),
                        ),
                        WeatherIconWidget(
                          iconPath: item.condition.iconPath,
                          size: 28,
                        ),
                        Text(
                          UnitConverter.formatTemperature(
                            item.temperature,
                            settings.temperatureUnit,
                          ),
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color:
                                isDark
                                    ? Colors.white
                                    : ClimoraColors.navyPrimary,
                          ),
                        ),
                        if (item.precipitationProbability > 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.water_drop,
                                size: 10,
                                color: ClimoraColors.skyBlue,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${item.precipitationProbability}%',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontSize: 10,
                                  color: ClimoraColors.skyBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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
        ),
      ),
    );
  }
}
