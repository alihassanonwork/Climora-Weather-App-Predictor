import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../core/theme/climora_colors.dart';
import '../../../../core/utils/unit_converter.dart';
import '../../../../core/utils/weather_interpreter.dart';
import '../../../../data/models/hourly_forecast.dart';
import '../../../../data/models/user_settings.dart';
import '../../../../shared/widgets/climora_card.dart';

/// Visually compelling wind card with an animated rotating compass dial,
/// dynamic wind streamlines, Beaufort scale rating, and hourly wind trend.
class WindCompassCard extends StatefulWidget {
  final double windSpeed;
  final double windDirection;
  final WindSpeedUnit unit;
  final List<HourlyForecastItem> hourly;

  const WindCompassCard({
    super.key,
    required this.windSpeed,
    required this.windDirection,
    required this.unit,
    this.hourly = const [],
  });

  @override
  State<WindCompassCard> createState() => _WindCompassCardState();
}

class _WindCompassCardState extends State<WindCompassCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _windStreamController;

  @override
  void initState() {
    super.initState();
    // Animation period inversely proportional to wind speed (faster wind = faster streamlines)
    final clampedSpeed = widget.windSpeed.clamp(5.0, 80.0);
    final durationSec = (30.0 / clampedSpeed).clamp(1.0, 6.0).toInt();

    _windStreamController = AnimationController(
      vsync: this,
      duration: Duration(seconds: durationSec),
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant WindCompassCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.windSpeed != widget.windSpeed) {
      final clampedSpeed = widget.windSpeed.clamp(5.0, 80.0);
      final durationSec = (30.0 / clampedSpeed).clamp(1.0, 6.0).toInt();
      _windStreamController.duration = Duration(seconds: durationSec);
    }
  }

  @override
  void dispose() {
    _windStreamController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final directionLabel = UnitConverter.formatWindDirection(
      widget.windDirection,
    );
    final formattedSpeed = UnitConverter.formatWind(
      widget.windSpeed,
      widget.unit,
    );
    final beaufort = WeatherInterpreter.getBeaufortScale(widget.windSpeed);

    final recentWind = widget.hourly.take(12).map((h) => h.windSpeed).toList();
    final reduceMotion = MediaQuery.of(context).disableAnimations;

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
                      color: ClimoraColors.tealAccent.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.air_rounded,
                      size: 16,
                      color: ClimoraColors.tealAccent,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Wind',
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
                  color: ClimoraColors.tealAccent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  beaufort.name,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: ClimoraColors.tealAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Compass Dial & Wind Speed Row
          Row(
            children: [
              // Compass Dial
              SizedBox(
                width: 80,
                height: 80,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: widget.windDirection),
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.easeOutBack,
                  builder: (context, angle, _) {
                    return CustomPaint(
                      painter: _CompassDialPainter(
                        degrees: angle,
                        isDark: isDark,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 14),

              // Wind Stats & Beaufort effect
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formattedSpeed,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color:
                            isDark ? Colors.white : ClimoraColors.navyPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$directionLabel • ${widget.windDirection.toStringAsFixed(0)}°',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: isDark ? Colors.white70 : Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      beaufort.effect,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isDark ? Colors.white54 : Colors.black54,
                        fontSize: 11,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Animated Wind Streamlines
          const SizedBox(height: 10),
          SizedBox(
            height: 18,
            child: AnimatedBuilder(
              animation: _windStreamController,
              builder: (context, _) {
                return CustomPaint(
                  size: const Size(double.infinity, 18),
                  painter: _StreamlinePainter(
                    progress: reduceMotion ? 0.5 : _windStreamController.value,
                    color: ClimoraColors.tealAccent,
                  ),
                );
              },
            ),
          ),

          // Mini 12h Wind Speed Trend
          if (recentWind.length >= 4) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '12h Wind Trend',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isDark ? Colors.white38 : Colors.black38,
                    fontSize: 10,
                  ),
                ),
                Text(
                  'Peak: ${recentWind.reduce(math.max).toStringAsFixed(0)} ${widget.unit.symbol}',
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
                painter: _WindTrendPainter(
                  values: recentWind,
                  lineColor: ClimoraColors.tealAccent,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CompassDialPainter extends CustomPainter {
  final double degrees;
  final bool isDark;

  _CompassDialPainter({required this.degrees, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 8) / 2;

    // Dial background circle
    final bgPaint =
        Paint()
          ..color =
              isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)
          ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    // Outer border
    final borderPaint =
        Paint()
          ..color =
              isDark ? Colors.white24 : Colors.black.withValues(alpha: 0.12)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2;
    canvas.drawCircle(center, radius, borderPaint);

    // Cardinal tick marks
    final tickPaint =
        Paint()
          ..color = isDark ? Colors.white38 : Colors.black38
          ..strokeWidth = 1.0;

    for (int i = 0; i < 8; i++) {
      final tickAngle = i * (math.pi / 4);
      final isMajor = i % 2 == 0;
      final tickLen = isMajor ? 5.0 : 3.0;

      final p1 = Offset(
        center.dx + math.cos(tickAngle) * (radius - 2),
        center.dy + math.sin(tickAngle) * (radius - 2),
      );
      final p2 = Offset(
        center.dx + math.cos(tickAngle) * (radius - 2 - tickLen),
        center.dy + math.sin(tickAngle) * (radius - 2 - tickLen),
      );
      canvas.drawLine(p1, p2, tickPaint);
    }

    // North marker 'N'
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'N',
        style: TextStyle(
          color: ClimoraColors.accentCoral,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - radius + 5),
    );

    // Rotating Wind Direction Needle
    final rad = (degrees - 90) * (math.pi / 180);
    final needleLen = radius - 10;

    final arrowHead = Offset(
      center.dx + math.cos(rad) * needleLen,
      center.dy + math.sin(rad) * needleLen,
    );
    final arrowTail = Offset(
      center.dx - math.cos(rad) * (needleLen * 0.4),
      center.dy - math.sin(rad) * (needleLen * 0.4),
    );

    // Arrow Line
    final arrowPaint =
        Paint()
          ..color = ClimoraColors.tealAccent
          ..strokeWidth = 2.4
          ..strokeCap = StrokeCap.round;
    canvas.drawLine(arrowTail, arrowHead, arrowPaint);

    // Arrow Head Cone
    final headAngle1 = rad + math.pi - 0.4;
    final headAngle2 = rad + math.pi + 0.4;
    final headP1 = Offset(
      arrowHead.dx + math.cos(headAngle1) * 9,
      arrowHead.dy + math.sin(headAngle1) * 9,
    );
    final headP2 = Offset(
      arrowHead.dx + math.cos(headAngle2) * 9,
      arrowHead.dy + math.sin(headAngle2) * 9,
    );

    final headPath =
        Path()
          ..moveTo(arrowHead.dx, arrowHead.dy)
          ..lineTo(headP1.dx, headP1.dy)
          ..lineTo(headP2.dx, headP2.dy)
          ..close();

    final headFill = Paint()..color = ClimoraColors.tealAccent;
    canvas.drawPath(headPath, headFill);

    // Center pivot
    final pivotPaint =
        Paint()..color = isDark ? Colors.white : ClimoraColors.navyPrimary;
    canvas.drawCircle(center, 3.5, pivotPaint);
  }

  @override
  bool shouldRepaint(covariant _CompassDialPainter oldDelegate) {
    return oldDelegate.degrees != degrees || oldDelegate.isDark != isDark;
  }
}

class _StreamlinePainter extends CustomPainter {
  final double progress;
  final Color color;

  _StreamlinePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 1.5;

    for (int i = 0; i < 3; i++) {
      final y = 4.0 + i * 5.0;
      final speedFactor = 1.0 + i * 0.3;
      final startNorm = (progress * speedFactor + i * 0.33) % 1.0;
      final startX = startNorm * size.width;
      final length = size.width * 0.35;

      final path = Path();
      path.moveTo(startX, y);
      path.quadraticBezierTo(
        startX + length * 0.5,
        y - 2.0,
        startX + length,
        y + 1.0,
      );

      final alpha = (math.sin(startNorm * math.pi) * 0.4).clamp(0.0, 0.4);
      linePaint.color = color.withValues(alpha: alpha);
      canvas.drawPath(path, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _StreamlinePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _WindTrendPainter extends CustomPainter {
  final List<double> values;
  final Color lineColor;

  _WindTrendPainter({required this.values, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;

    final maxVal = values.reduce(math.max);
    final minVal = values.reduce(math.min);
    final span = (maxVal - minVal).abs() < 0.1 ? 1.0 : (maxVal - minVal);

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
  bool shouldRepaint(covariant _WindTrendPainter oldDelegate) => true;
}
