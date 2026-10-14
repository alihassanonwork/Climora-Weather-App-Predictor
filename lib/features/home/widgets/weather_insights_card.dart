import 'package:flutter/material.dart';

import '../../../core/theme/climora_colors.dart';
import '../../../core/utils/weather_interpreter.dart';
import '../../../core/utils/weather_summary_helper.dart';
import '../../../data/models/current_weather.dart';
import '../../../data/models/daily_forecast.dart';
import '../../../shared/widgets/climora_card.dart';

/// Card presenting intelligent, rule-based weather insights, UV advice, and meteorological notices.
class WeatherInsightsCard extends StatelessWidget {
  final CurrentWeather current;
  final DailyForecastDay? today;

  const WeatherInsightsCard({
    super.key,
    required this.current,
    required this.today,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final summary = WeatherSummaryHelper.generateSummary(
      current: current,
      todayForecast: today,
    );

    final uvVal = current.uvIndex ?? today?.uvIndexMax;
    final uvAdvice =
        uvVal != null ? WeatherInterpreter.getUvAdvice(uvVal) : null;
    final uvCategory =
        uvVal != null ? WeatherInterpreter.getUvCategory(uvVal) : null;

    final notice = WeatherSummaryHelper.getSevereNotice(
      current: current,
      todayForecast: today,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              'Insights & Guidance',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : ClimoraColors.navyPrimary,
              ),
            ),
          ),

          // Severe Notice if active
          if (notice != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ClimoraColors.accentCoral.withValues(
                  alpha: isDark ? 0.2 : 0.12,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: ClimoraColors.accentCoral.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: ClimoraColors.accentCoral,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weather Notice',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: ClimoraColors.accentCoral,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notice,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark ? Colors.white70 : Colors.black87,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Climora is not an official emergency dispatch service. Follow local authority advisories.',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 10,
                            fontStyle: FontStyle.italic,
                            color: isDark ? Colors.white54 : Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Daily Rule-Based Summary Card
          ClimoraCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ClimoraColors.skyBlue.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    size: 22,
                    color: ClimoraColors.skyBlue,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today\'s Outlook',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? Colors.white : ClimoraColors.navyPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        summary,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark ? Colors.white70 : Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // UV Guidance Card if available
          if (uvVal != null && uvAdvice != null) ...[
            const SizedBox(height: 12),
            ClimoraCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ClimoraColors.accentGold.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.wb_sunny_rounded,
                      size: 22,
                      color: ClimoraColors.accentGold,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'UV Index (${uvVal.toStringAsFixed(1)})',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color:
                                    isDark
                                        ? Colors.white
                                        : ClimoraColors.navyPrimary,
                              ),
                            ),
                            if (uvCategory != null) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: ClimoraColors.accentGold.withValues(
                                    alpha: 0.2,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  uvCategory,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: ClimoraColors.accentGold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          uvAdvice,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark ? Colors.white70 : Colors.black87,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

