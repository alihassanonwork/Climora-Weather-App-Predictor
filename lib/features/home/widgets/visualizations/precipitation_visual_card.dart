import 'package:flutter/material.dart';

import '../../../../core/theme/climora_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/unit_converter.dart';
import '../../../../data/models/hourly_forecast.dart';
import '../../../../data/models/user_settings.dart';
import '../../../../shared/widgets/climora_card.dart';

/// Precipitation card clearly distinguishing rainfall volume (mm/in)
/// from probability of precipitation (%), with an animated raindrop reservoir
/// and an hourly precipitation chance bar chart.
class PrecipitationVisualCard extends StatelessWidget {
  final double precipitation;
  final int? precipitationProbabilityMax;
  final PrecipitationUnit unit;
  final List<HourlyForecastItem> hourly;

  const PrecipitationVisualCard({
    super.key,
    required this.precipitation,
    required this.precipitationProbabilityMax,
    required this.unit,
    this.hourly = const [],
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final formattedRain = UnitConverter.formatRain(precipitation, unit);
    final chance = precipitationProbabilityMax ?? 0;

    final next12Hours = hourly.take(12).toList();

    return ClimoraCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: ClimoraColors.rainBlue.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.umbrella_rounded,
                      size: 16,
                      color: ClimoraColors.rainBlue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Precipitation',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: ClimoraColors.rainBlue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$chance% Chance',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: ClimoraColors.rainBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Main Visual: Raindrop Icon with Water Level & Amount
          Row(
            children: [
              // Raindrop Reservoir Graphic
              SizedBox(
                width: 60,
                height: 60,
                child: CustomPaint(
                  painter: _RaindropReservoirPainter(
                    precipitation: precipitation,
                    isDark: isDark,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // Volume & Summary
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formattedRain,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color:
                            isDark ? Colors.white : ClimoraColors.navyPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      precipitation > 5.0
                          ? 'Heavy accumulation today'
                          : precipitation > 0.0
                          ? 'Light to moderate rainfall'
                          : 'No rainfall accumulated',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Hourly Precipitation Probability Bar Chart
          if (next12Hours.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              'Hourly Rain Probability (Next 12h)',
              style: theme.textTheme.labelSmall?.copyWith(
                color: isDark ? Colors.white38 : Colors.black38,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 48,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children:
                    next12Hours.map((item) {
                      final prob = item.precipitationProbability;
                      final barHeight = (prob / 100.0 * 36.0).clamp(2.0, 36.0);

                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1.5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: barHeight,
                                decoration: BoxDecoration(
                                  color:
                                      prob > 0
                                          ? (prob > 50
                                              ? ClimoraColors.rainBlue
                                              : ClimoraColors.skyLight)
                                          : (isDark
                                              ? Colors.white10
                                              : Colors.black.withValues(
                                                alpha: 0.06,
                                              )),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormatter.formatHour(
                                  item.dateTime,
                                ).replaceAll(' ', ''),
                                style: TextStyle(
                                  fontSize: 7.5,
                                  color:
                                      isDark ? Colors.white38 : Colors.black38,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RaindropReservoirPainter extends CustomPainter {
  final double precipitation;
  final bool isDark;

  _RaindropReservoirPainter({
    required this.precipitation,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final width = size.width;
    final height = size.height;

    // Draw stylized water drop outline
    final path = Path();
    path.moveTo(center.dx, 6);
    path.cubicTo(
      width * 0.9,
      height * 0.45,
      width * 0.88,
      height * 0.9,
      center.dx,
      height - 4,
    );
    path.cubicTo(
      width * 0.12,
      height * 0.9,
      width * 0.1,
      height * 0.45,
      center.dx,
      6,
    );
    path.close();

    // Background drop fill
    final bgPaint =
        Paint()
          ..color =
              isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)
          ..style = PaintingStyle.fill;
    canvas.drawPath(path, bgPaint);

    // Liquid fill clipped to droplet
    canvas.save();
    canvas.clipPath(path);

    // Fill level: 0mm -> 15%, 10mm -> 90%
    final fillFraction = (0.15 + (precipitation / 10.0) * 0.75).clamp(
      0.15,
      0.95,
    );
    final liquidTop = height * (1.0 - fillFraction);

    final liquidPaint =
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ClimoraColors.skyLight, ClimoraColors.rainBlue],
          ).createShader(
            Rect.fromLTWH(0, liquidTop, width, height - liquidTop),
          );

    canvas.drawRect(
      Rect.fromLTWH(0, liquidTop, width, height - liquidTop),
      liquidPaint,
    );
    canvas.restore();

    // Border
    final borderPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color =
              isDark ? Colors.white24 : Colors.black.withValues(alpha: 0.12);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _RaindropReservoirPainter oldDelegate) {
    return oldDelegate.precipitation != precipitation ||
        oldDelegate.isDark != isDay;
  }

  bool get isDay => true;
}
