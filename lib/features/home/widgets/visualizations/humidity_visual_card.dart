import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../core/theme/climora_colors.dart';
import '../../../../core/utils/weather_interpreter.dart';
import '../../../../data/models/hourly_forecast.dart';
import '../../../../shared/widgets/climora_card.dart';

/// Visually rich humidity card with an animated progress ring, moisture indicators,
/// comfort level classification, and an hourly humidity trend sparkline.
class HumidityVisualCard extends StatelessWidget {
  final int relativeHumidity;
  final List<HourlyForecastItem> hourly;

  const HumidityVisualCard({
    super.key,
    required this.relativeHumidity,
    this.hourly = const [],
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final info = WeatherInterpreter.getHumidityCategory(relativeHumidity);
    final fraction = (relativeHumidity / 100.0).clamp(0.0, 1.0);

    final recentHourly =
        hourly.take(12).map((h) => h.relativeHumidity.toDouble()).toList();

    return ClimoraCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: ClimoraColors.skyBlue.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.water_drop_rounded,
                  size: 16,
                  color: ClimoraColors.skyBlue,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Humidity',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Main Visual: Circular Progress Ring & Value
          Row(
            children: [
              // Radial Gauge
              SizedBox(
                width: 68,
                height: 68,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: fraction),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) {
                    return CustomPaint(
                      painter: _HumidityRingPainter(
                        progress: value,
                        isDark: isDark,
                        activeColor: info.color,
                      ),
                      child: Center(
                        child: Text(
                          '$relativeHumidity%',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color:
                                isDark
                                    ? Colors.white
                                    : ClimoraColors.navyPrimary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 14),

              // Status and Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: info.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        info.label,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: info.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      info.summary,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark ? Colors.white70 : Colors.black87,
                        fontSize: 12,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Mini Hourly Trend Sparkline
          if (recentHourly.length >= 4) ...[
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '12h Trend',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isDark ? Colors.white38 : Colors.black38,
                    fontSize: 10,
                  ),
                ),
                Text(
                  '${recentHourly.first.toInt()}% → ${recentHourly.last.toInt()}%',
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
              height: 24,
              child: CustomPaint(
                size: const Size(double.infinity, 24),
                painter: _SparklinePainter(
                  values: recentHourly,
                  lineColor: info.color,
                  minVal: 0,
                  maxVal: 100,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HumidityRingPainter extends CustomPainter {
  final double progress;
  final bool isDark;
  final Color activeColor;

  _HumidityRingPainter({
    required this.progress,
    required this.isDark,
    required this.activeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 10) / 2;

    // Track Paint
    final trackPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 7.0
          ..strokeCap = StrokeCap.round
          ..color =
              isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.08);

    canvas.drawCircle(center, radius, trackPaint);

    // Active Arc
    final sweepAngle = 2 * math.pi * progress;
    final activePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 7.0
          ..strokeCap = StrokeCap.round
          ..shader = SweepGradient(
            startAngle: -math.pi / 2,
            endAngle: 3 * math.pi / 2,
            colors: [ClimoraColors.skyLight, activeColor],
          ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _HumidityRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.activeColor != activeColor;
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> values;
  final Color lineColor;
  final double minVal;
  final double maxVal;

  _SparklinePainter({
    required this.values,
    required this.lineColor,
    required this.minVal,
    required this.maxVal,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;

    final path = Path();
    final fillPath = Path();
    final stepX = size.width / (values.length - 1);

    for (int i = 0; i < values.length; i++) {
      final normY = (values[i] - minVal) / (maxVal - minVal);
      final x = i * stepX;
      final y = size.height - (normY * size.height).clamp(0.0, size.height);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    final fillPaint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              lineColor.withValues(alpha: 0.25),
              lineColor.withValues(alpha: 0.0),
            ],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fillPath, fillPaint);

    final linePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0
          ..strokeCap = StrokeCap.round
          ..color = lineColor;
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.lineColor != lineColor;
  }
}
