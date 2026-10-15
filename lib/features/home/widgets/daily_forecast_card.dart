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

/// 5-Day forecast card with temperature ranges, current temperature indicator dot,
/// precipitation probability, maximum wind speed, and tap-to-inspect daily modal.
class DailyForecastCard extends StatelessWidget {
  final List<DailyForecastDay> dailyList;
  final List<HourlyForecastItem> allHourly;
  final UserSettings settings;
  final double? currentTemperature;

  const DailyForecastCard({
    super.key,
    required this.dailyList,
    required this.allHourly,
    required this.settings,
    this.currentTemperature,
  });

  @override
  Widget build(BuildContext context) {
    if (dailyList.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Take 5 days
    final displayDays = dailyList.take(5).toList();

    // Calculate global min and max for temperature range bar scale
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
                  'Tap for hourly details',
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
                        // Weekday & Date Label
                        SizedBox(
                          width: 80,
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

                        // Animated / Stylized Weather Icon
                        WeatherIconWidget(
                          iconPath: day.condition.iconPath,
                          size: 28,
                        ),
                        const SizedBox(width: 8),

                        // Precipitation Chance & Wind
                        SizedBox(
                          width: 48,
                          child:
                              (day.precipitationProbabilityMax != null &&
                                      day.precipitationProbabilityMax! > 0)
                                  ? FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Row(
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
                                    ),
                                  )
                                  : const SizedBox.shrink(),
                        ),

                        const SizedBox(width: 6),

                        // Min Temperature
                        SizedBox(
                          width: 38,
                          child: Text(
                            UnitConverter.formatTemperature(
                              day.temperatureMin,
                              settings.temperatureUnit,
                            ),
                            textAlign: TextAlign.right,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark ? Colors.white60 : Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Apple Weather-Style Range Bar with Current Temp Dot Indicator
                        Expanded(
                          child: _TemperatureRangeBar(
                            minTemp: day.temperatureMin,
                            maxTemp: day.temperatureMax,
                            globalMin: globalMin,
                            globalMax: globalMax,
                            currentTemp: isToday ? currentTemperature : null,
                            isDark: isDark,
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Max Temperature
                        SizedBox(
                          width: 38,
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
  final double? currentTemp;
  final bool isDark;

  const _TemperatureRangeBar({
    required this.minTemp,
    required this.maxTemp,
    required this.globalMin,
    required this.globalMax,
    this.currentTemp,
    required this.isDark,
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

        // Dot position for current temperature on Today's row
        double? dotLeft;
        if (currentTemp != null) {
          final tempFraction = ((currentTemp! - minTemp) / (maxTemp - minTemp))
              .clamp(0.0, 1.0);
          dotLeft = barLeft + (tempFraction * barWidth).clamp(0.0, barWidth);
        }

        return SizedBox(
          height: 12,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Track background
              Container(
                height: 5,
                decoration: BoxDecoration(
                  color:
                      isDark
                          ? Colors.white12
                          : Colors.black.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),

              // Active Range Gradient
              Positioned(
                left: barLeft,
                width: barWidth,
                child: Container(
                  height: 5,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        ClimoraColors.skyBlue,
                        ClimoraColors.tealAccent,
                        ClimoraColors.sunGold,
                        ClimoraColors.accentCoral,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),

              // Today's current temperature indicator dot
              if (dotLeft != null)
                Positioned(
                  left: (dotLeft - 4.5).clamp(0.0, totalWidth - 9.0),
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            isDark ? ClimoraColors.navyDarkest : Colors.black87,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 3,
                        ),
                      ],
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
