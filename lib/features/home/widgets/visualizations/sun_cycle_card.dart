import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../core/theme/climora_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/climora_card.dart';

/// Celestial curved sun-path visualization illustrating the sun's trajectory
/// across the horizon based on real sunrise and sunset data.
class SunCycleCard extends StatelessWidget {
  final DateTime? sunrise;
  final DateTime? sunset;
  final bool isDay;

  const SunCycleCard({
    super.key,
    required this.sunrise,
    required this.sunset,
    required this.isDay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final sunriseStr =
        sunrise != null ? DateFormatter.formatTime(sunrise!) : '--:--';
    final sunsetStr =
        sunset != null ? DateFormatter.formatTime(sunset!) : '--:--';

    // Calculate progress between sunrise and sunset
    double progress = 0.5;
    String statusNote = 'Solar Cycle';

    if (sunrise != null && sunset != null) {
      final now = DateTime.now();
      final totalDaylight = sunset!.difference(sunrise!).inMinutes;

      if (now.isBefore(sunrise!)) {
        progress = 0.0;
        final untilRise = sunrise!.difference(now);
        final hours = untilRise.inHours;
        final mins = untilRise.inMinutes % 60;
        statusNote = 'Sunrise in ${hours}h ${mins}m';
      } else if (now.isAfter(sunset!)) {
        progress = 1.0;
        final sinceSet = now.difference(sunset!);
        final hours = sinceSet.inHours;
        statusNote = 'Sunset was ${hours}h ago';
      } else {
        final elapsed = now.difference(sunrise!).inMinutes;
        progress =
            totalDaylight > 0 ? (elapsed / totalDaylight).clamp(0.0, 1.0) : 0.5;

        final remaining = sunset!.difference(now);
        final hours = remaining.inHours;
        final mins = remaining.inMinutes % 60;
        statusNote = '$hours hrs $mins mins of daylight left';
      }
    }

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
                      color: ClimoraColors.accentCoral.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.wb_twilight_rounded,
                      size: 16,
                      color: ClimoraColors.accentCoral,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Sun Cycle',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  statusNote,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isDark ? Colors.white54 : Colors.black45,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Celestial Parabolic Arc
          SizedBox(
            height: 72,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: progress),
              duration: const Duration(milliseconds: 1400),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return CustomPaint(
                  size: const Size(double.infinity, 72),
                  painter: _SunPathPainter(
                    progress: value,
                    isDay: isDay,
                    isDark: isDark,
                  ),
                );
              },
            ),
          ),

          // Sunrise and Sunset Time Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.wb_sunny_outlined,
                        size: 12,
                        color: ClimoraColors.sunGold,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Sunrise',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontSize: 10,
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sunriseStr,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : ClimoraColors.navyPrimary,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.nightlight_outlined,
                        size: 12,
                        color: ClimoraColors.accentCoral,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Sunset',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontSize: 10,
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sunsetStr,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : ClimoraColors.navyPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SunPathPainter extends CustomPainter {
  final double progress;
  final bool isDay;
  final bool isDark;

  _SunPathPainter({
    required this.progress,
    required this.isDay,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final horizonY = height - 12;

    // Horizon line
    final horizonPaint =
        Paint()
          ..color =
              isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.08)
          ..strokeWidth = 1.0;
    canvas.drawLine(Offset(0, horizonY), Offset(width, horizonY), horizonPaint);

    // Parabolic arc path
    final arcPath = Path();
    arcPath.moveTo(14, horizonY);
    arcPath.quadraticBezierTo(width / 2, -10, width - 14, horizonY);

    // Track arc stroke
    final arcPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0
          ..color =
              isDark ? Colors.white24 : Colors.black.withValues(alpha: 0.12);
    canvas.drawPath(arcPath, arcPaint);

    // Calculate position of sun along the quadratic curve
    final t = progress.clamp(0.0, 1.0);
    // B(t) = (1-t)^2 P0 + 2(1-t)t P1 + t^2 P2
    final p0 = Offset(14, horizonY);
    final p1 = Offset(width / 2, -10);
    final p2 = Offset(width - 14, horizonY);

    final sunX =
        math.pow(1 - t, 2) * p0.dx +
        2 * (1 - t) * t * p1.dx +
        math.pow(t, 2) * p2.dx;
    final sunY =
        math.pow(1 - t, 2) * p0.dy +
        2 * (1 - t) * t * p1.dy +
        math.pow(t, 2) * p2.dy;
    final sunPos = Offset(sunX, sunY);

    // Sun glowing halo
    final haloPaint =
        Paint()
          ..shader = RadialGradient(
            colors: [
              ClimoraColors.sunGold.withValues(alpha: 0.45),
              ClimoraColors.sunGold.withValues(alpha: 0.0),
            ],
          ).createShader(Rect.fromCircle(center: sunPos, radius: 20));
    canvas.drawCircle(sunPos, 20, haloPaint);

    // Sun core
    final corePaint =
        Paint()
          ..color = isDay ? ClimoraColors.sunGold : const Color(0xFFC7D2FE)
          ..style = PaintingStyle.fill;
    canvas.drawCircle(sunPos, 6.5, corePaint);

    final innerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(sunPos, 3.5, innerPaint);
  }

  @override
  bool shouldRepaint(covariant _SunPathPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isDay != isDay;
  }
}
