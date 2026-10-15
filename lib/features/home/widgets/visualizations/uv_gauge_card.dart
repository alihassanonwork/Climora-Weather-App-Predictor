import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../core/theme/climora_colors.dart';
import '../../../../core/utils/weather_interpreter.dart';
import '../../../../shared/widgets/climora_card.dart';

/// WHO-standard UV Index gauge card with segmented danger scale,
/// animated pointer, dynamic protection advisory, and nighttime handling.
class UvGaugeCard extends StatelessWidget {
  final double? uvIndex;
  final double? uvIndexMax;
  final bool isDay;

  const UvGaugeCard({
    super.key,
    required this.uvIndex,
    this.uvIndexMax,
    this.isDay = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Determine effective UV value
    final effectiveUv = !isDay ? 0.0 : (uvIndex ?? uvIndexMax ?? 0.0);
    final info =
        !isDay
            ? (
              label: 'Low (Night)',
              guidance: 'UV radiation is 0 at night.',
              color: ClimoraColors.uvLow,
            )
            : WeatherInterpreter.interpretUvIndex(effectiveUv);

    final fraction = (effectiveUv / 12.0).clamp(0.0, 1.0);

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
                      color: ClimoraColors.accentGold.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.wb_sunny_rounded,
                      size: 16,
                      color: ClimoraColors.accentGold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'UV Index',
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
            ],
          ),

          const SizedBox(height: 14),

          // Main Visual: Radial Gauge & Value
          Row(
            children: [
              // Radial UV Meter
              SizedBox(
                width: 76,
                height: 52,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: fraction),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) {
                    return CustomPaint(
                      painter: _UvRadialPainter(
                        fraction: value,
                        isDark: isDark,
                        indicatorColor: info.color,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 14),

              // UV Score & Guidance
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      effectiveUv.toStringAsFixed(1),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color:
                            isDark ? Colors.white : ClimoraColors.navyPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      info.guidance,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark ? Colors.white70 : Colors.black87,
                        fontSize: 11,
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Scale Legend (0-12)
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Row(
              children: [
                _buildSegment(ClimoraColors.uvLow, 2),
                _buildSegment(ClimoraColors.uvModerate, 3),
                _buildSegment(ClimoraColors.uvHigh, 2),
                _buildSegment(const Color(0xFFDC2626), 3),
                _buildSegment(ClimoraColors.stormPurple, 2),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0 Low',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 9,
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
              ),
              Text(
                '6 High',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 9,
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
              ),
              Text(
                '11+ Extreme',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 9,
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSegment(Color color, int flex) {
    return Expanded(flex: flex, child: Container(height: 4, color: color));
  }
}

class _UvRadialPainter extends CustomPainter {
  final double fraction;
  final bool isDark;
  final Color indicatorColor;

  _UvRadialPainter({
    required this.fraction,
    required this.isDark,
    required this.indicatorColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.95);
    final radius = size.width / 2 - 6;

    // Track Arc
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

    // Multi-color UV Spectrum Gradient
    final activePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6.0
          ..strokeCap = StrokeCap.round
          ..shader = const SweepGradient(
            startAngle: math.pi,
            endAngle: 2 * math.pi,
            colors: [
              ClimoraColors.uvLow,
              ClimoraColors.uvModerate,
              ClimoraColors.uvHigh,
              Color(0xFFDC2626),
              ClimoraColors.stormPurple,
            ],
          ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi * fraction,
      false,
      activePaint,
    );

    // Indicator needle
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
  bool shouldRepaint(covariant _UvRadialPainter oldDelegate) {
    return oldDelegate.fraction != fraction ||
        oldDelegate.indicatorColor != indicatorColor;
  }
}
