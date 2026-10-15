import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../core/theme/climora_colors.dart';
import '../../../../core/utils/unit_converter.dart';
import '../../../../core/utils/weather_interpreter.dart';
import '../../../../data/models/hourly_forecast.dart';
import '../../../../data/models/user_settings.dart';
import '../../../../shared/widgets/climora_card.dart';

/// Barometric pressure card featuring a calibrated dial gauge,
/// verified 3-hour pressure trend, and hourly pressure series curve.
class PressureGaugeCard extends StatelessWidget {
  final double surfacePressure;
  final PressureUnit unit;
  final List<HourlyForecastItem> hourly;

  const PressureGaugeCard({
    super.key,
    required this.surfacePressure,
    required this.unit,
    this.hourly = const [],
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Standard atmospheric pressure: ~1013.25 hPa. Typical surface range: 970 to 1050 hPa.
    final clampedHpa = surfacePressure.clamp(970.0, 1050.0);
    final fraction = ((clampedHpa - 970.0) / (1050.0 - 970.0)).clamp(0.0, 1.0);

    // Compute genuine trend from hourly pressure series (comparing 3 hours ago vs current)
    double? pastPressure;
    if (hourly.length >= 4) {
      pastPressure = hourly[3].surfacePressure;
    }
    final trend = WeatherInterpreter.getPressureTrend(
      surfacePressure,
      pastPressure,
    );
    final formattedPressure = UnitConverter.formatPressure(
      surfacePressure,
      unit,
    );

    final recentPressures =
        hourly.take(12).map((h) => h.surfacePressure).toList();

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
                      color: ClimoraColors.oceanBlue.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.compress_rounded,
                      size: 16,
                      color: ClimoraColors.oceanBlue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Pressure',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(trend.icon, size: 14, color: trend.color),
                  const SizedBox(width: 4),
                  Text(
                    trend.label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: trend.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Main Visual: Gauge and Value
          Row(
            children: [
              // Semicircular Barometer Dial
              SizedBox(
                width: 76,
                height: 52,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.5, end: fraction),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) {
                    return CustomPaint(
                      painter: _PressureGaugePainter(
                        fraction: value,
                        isDark: isDark,
                        indicatorColor: trend.color,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 14),

              // Pressure Value & Explanation
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formattedPressure,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color:
                            isDark ? Colors.white : ClimoraColors.navyPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      surfacePressure > 1020
                          ? 'High pressure • Stable conditions'
                          : surfacePressure < 1005
                          ? 'Low pressure • Possible clouds/rain'
                          : 'Normal barometric pressure',
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

          // 12-Hour Pressure Trend Curve
          if (recentPressures.length >= 4) ...[
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '12h History',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isDark ? Colors.white38 : Colors.black38,
                    fontSize: 10,
                  ),
                ),
                Text(
                  '${recentPressures.first.toStringAsFixed(0)} → ${recentPressures.last.toStringAsFixed(0)} hPa',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isDark ? Colors.white54 : Colors.black45,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 22,
              child: CustomPaint(
                size: const Size(double.infinity, 22),
                painter: _PressureHistoryPainter(
                  values: recentPressures,
                  lineColor: trend.color,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PressureGaugePainter extends CustomPainter {
  final double fraction;
  final bool isDark;
  final Color indicatorColor;

  _PressureGaugePainter({
    required this.fraction,
    required this.isDark,
    required this.indicatorColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.95);
    final radius = size.width / 2 - 6;

    // Track Arc (Semicircle from -PI to 0)
    final trackPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6.0
          ..strokeCap = StrokeCap.round
          ..color =
              isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.08);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      trackPaint,
    );

    // Active Arc Gradient
    final activePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6.0
          ..strokeCap = StrokeCap.round
          ..shader = LinearGradient(
            colors: [
              ClimoraColors.skyBlue,
              ClimoraColors.tealAccent,
              ClimoraColors.accentGold,
            ],
          ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi * fraction,
      false,
      activePaint,
    );

    // Needle pointer
    final needleAngle = math.pi + (math.pi * fraction);
    final needleLen = radius - 2;
    final needleEnd = Offset(
      center.dx + math.cos(needleAngle) * needleLen,
      center.dy + math.sin(needleAngle) * needleLen,
    );

    final needlePaint =
        Paint()
          ..color = indicatorColor
          ..strokeWidth = 2.4
          ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, needleEnd, needlePaint);

    // Pivot
    final pivotPaint =
        Paint()..color = isDark ? Colors.white : ClimoraColors.navyPrimary;
    canvas.drawCircle(center, 3.5, pivotPaint);
  }

  @override
  bool shouldRepaint(covariant _PressureGaugePainter oldDelegate) {
    return oldDelegate.fraction != fraction ||
        oldDelegate.indicatorColor != indicatorColor;
  }
}

class _PressureHistoryPainter extends CustomPainter {
  final List<double> values;
  final Color lineColor;

  _PressureHistoryPainter({required this.values, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;

    final maxVal = values.reduce(math.max);
    final minVal = values.reduce(math.min);
    final span = (maxVal - minVal).abs() < 1.0 ? 5.0 : (maxVal - minVal);

    final path = Path();
    final stepX = size.width / (values.length - 1);

    for (int i = 0; i < values.length; i++) {
      final normY = (values[i] - minVal) / span;
      final x = i * stepX;
      final y = size.height - (normY * (size.height - 4)) - 2;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final linePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8
          ..strokeCap = StrokeCap.round
          ..color = lineColor;
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _PressureHistoryPainter oldDelegate) => true;
}
