import 'package:flutter/material.dart';

import '../../../core/theme/climora_colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/unit_converter.dart';
import '../../../data/models/daily_forecast.dart';
import '../../../data/models/hourly_forecast.dart';
import '../../../data/models/user_settings.dart';
import '../../../shared/widgets/climora_card.dart';
import '../../../shared/widgets/weather_icon_widget.dart';
import '../../forecast/screens/day_detail_sheet.dart';

/// 5-Day forecast card with temperature ranges, precipitation indicators, and tap-to-inspect modal.
class DailyForecastCard extends StatelessWidget {
  final List<DailyForecastDay> dailyList;
  final List<HourlyForecastItem> allHourly;
  final UserSettings settings;

  const DailyForecastCard({
    super.key,
    required this.dailyList,
    required this.allHourly,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    if (dailyList.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Take 5 days
    final displayDays = dailyList.take(5).toList();

    // Calculate global min and max for temperature range bar calculation
    double globalMin = double.infinity;
    double globalMax = -double.infinity;
    for (final day in displayDays) {
      if (day.temperatureMin < globalMin) globalMin = day.temperatureMin;
      if (day.temperatureMax > globalMax) globalMax = day.temperatureMax;
    }
    if (globalMax <= globalMin) {
      globalMax = globalMin + 1;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClimoraCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      size: 18,
                      color: ClimoraColors.skyBlue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '5-Day Forecast',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color:
                            isDark ? Colors.white : ClimoraColors.navyPrimary,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Tap for details',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: displayDays.length,
              separatorBuilder:
                  (_, __) => Divider(
                    height: 18,
                    color:
                        isDark
                            ? Colors.white10
                            : Colors.black.withValues(alpha: 0.05),
                  ),
              itemBuilder: (context, index) {
                final day = displayDays[index];
                final isToday = index == 0;

                return InkWell(
                  onTap: () {
                    DayDetailSheet.show(
                      context,
                      day: day,
                      allHourly: allHourly,
                      settings: settings,
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 4,
                    ),
                    child: Row(
                      children: [
                        // Weekday label
                        SizedBox(
                          width: 84,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isToday
                                    ? 'Today'
                                    : DateFormatter.formatWeekday(day.dateTime),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight:
                                      isToday
                                          ? FontWeight.bold
                                          : FontWeight.w600,
                                  color:
                                      isToday
                                          ? ClimoraColors.skyBlue
                                          : (isDark
                                              ? Colors.white
                                              : ClimoraColors.navyPrimary),
                                ),
                              ),
                              Text(
                                DateFormatter.formatShortDate(day.dateTime),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color:
                                      isDark ? Colors.white54 : Colors.black45,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Weather Icon
                        WeatherIconWidget(
                          iconPath: day.condition.iconPath,
                          size: 28,
                        ),
                        const SizedBox(width: 10),

                        // Precipitation probability if > 0
                        SizedBox(
                          width: 48,
                          child:
                              (day.precipitationProbabilityMax != null &&
                                      day.precipitationProbabilityMax! > 0)
                                  ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.water_drop,
                                        size: 11,
                                        color: ClimoraColors.skyBlue,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        '${day.precipitationProbabilityMax}%',
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                              color: ClimoraColors.skyBlue,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  )
                                  : const SizedBox.shrink(),
                        ),

                        const SizedBox(width: 8),

                        // Temperature Min
                        SizedBox(
                          width: 40,
                          child: Text(
                            UnitConverter.formatTemperature(
                              day.temperatureMin,
                              settings.temperatureUnit,
                            ),
                            textAlign: TextAlign.right,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark ? Colors.white60 : Colors.black54,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Visual Temperature Bar
                        Expanded(
                          child: _TemperatureRangeBar(
                            minTemp: day.temperatureMin,
                            maxTemp: day.temperatureMax,
                            globalMin: globalMin,
                            globalMax: globalMax,
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Temperature Max
                        SizedBox(
                          width: 40,
                          child: Text(
                            UnitConverter.formatTemperature(
                              day.temperatureMax,
                              settings.temperatureUnit,
                            ),
                            textAlign: TextAlign.left,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color:
                                  isDark
                                      ? Colors.white
                                      : ClimoraColors.navyPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TemperatureRangeBar extends StatelessWidget {
  final double minTemp;
  final double maxTemp;
  final double globalMin;
  final double globalMax;

  const _TemperatureRangeBar({
    required this.minTemp,
    required this.maxTemp,
    required this.globalMin,
    required this.globalMax,
  });

  @override
  Widget build(BuildContext context) {
    final range = globalMax - globalMin;
    final leftFraction = ((minTemp - globalMin) / range).clamp(0.0, 1.0);
    final widthFraction = ((maxTemp - minTemp) / range).clamp(0.08, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final barLeft = leftFraction * totalWidth;
        final barWidth = (widthFraction * totalWidth).clamp(
          16.0,
          totalWidth - barLeft,
        );

        return Container(
          height: 6,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Stack(
            children: [
              Positioned(
                left: barLeft,
                width: barWidth,
                top: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [ClimoraColors.skyBlue, ClimoraColors.accentGold],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
