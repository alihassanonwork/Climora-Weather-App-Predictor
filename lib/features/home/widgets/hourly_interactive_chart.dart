import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../core/theme/climora_colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/unit_converter.dart';
import '../../../data/models/hourly_forecast.dart';
import '../../../data/models/user_settings.dart';
import '../../../shared/widgets/climora_card.dart';
import '../../../shared/widgets/weather_icon_widget.dart';

enum HourlyChartMode { temperature, precipitation, wind }

/// Interactive spline chart allowing users to touch-scrub through hourly forecasts,
/// visualizing temperature gradients, precipitation probabilities, or wind speeds.
class HourlyInteractiveChart extends StatefulWidget {
  final List<HourlyForecastItem> hourlyList;
  final UserSettings settings;

  const HourlyInteractiveChart({
    super.key,
    required this.hourlyList,
    required this.settings,
  });

  @override
  State<HourlyInteractiveChart> createState() => _HourlyInteractiveChartState();
}

class _HourlyInteractiveChartState extends State<HourlyInteractiveChart> {
  HourlyChartMode _mode = HourlyChartMode.temperature;
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.hourlyList.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final now = DateTime.now();
    final futureHours =
        widget.hourlyList
            .where(
              (h) =>
                  h.dateTime.isAfter(now.subtract(const Duration(minutes: 59))),
            )
            .take(24)
            .toList();
    final displayHours =
        futureHours.isNotEmpty
            ? futureHours
            : widget.hourlyList.take(24).toList();

    final selectedHour =
        (_selectedIndex != null && _selectedIndex! < displayHours.length)
            ? displayHours[_selectedIndex!]
            : displayHours.first;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClimoraCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header & Mode Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.show_chart_rounded,
                      size: 18,
                      color: ClimoraColors.skyBlue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '24-Hour Trend',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color:
                            isDark ? Colors.white : ClimoraColors.navyPrimary,
                      ),
                    ),
                  ],
                ),
                // Toggle mode pills
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color:
                        isDark
                            ? Colors.white10
                            : Colors.black.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      _buildPill('Temp', HourlyChartMode.temperature, isDark),
                      _buildPill('Rain', HourlyChartMode.precipitation, isDark),
                      _buildPill('Wind', HourlyChartMode.wind, isDark),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Selected Hour Tooltip Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color:
                    isDark
                        ? ClimoraColors.navySurface
                        : ClimoraColors.skyBlue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      isDark
                          ? Colors.white12
                          : ClimoraColors.skyBlue.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      WeatherIconWidget(
                        iconPath: selectedHour.condition.iconPath,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormatter.formatHour(selectedHour.dateTime),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? Colors.white : ClimoraColors.navyPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        selectedHour.condition.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _mode == HourlyChartMode.temperature
                        ? UnitConverter.formatTemperature(
                          selectedHour.temperature,
                          widget.settings.temperatureUnit,
                        )
                        : _mode == HourlyChartMode.precipitation
                        ? '${selectedHour.precipitationProbability}% chance (${selectedHour.precipitation} mm)'
                        : UnitConverter.formatWind(
                          selectedHour.windSpeed,
                          widget.settings.windSpeedUnit,
                        ),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color:
                          _mode == HourlyChartMode.temperature
                              ? ClimoraColors.accentGold
                              : _mode == HourlyChartMode.precipitation
                              ? ClimoraColors.skyBlue
                              : ClimoraColors.tealAccent,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Interactive Touch-Scrubbing Chart
            SizedBox(
              height: 110,
              child: GestureDetector(
                onPanDown:
                    (details) =>
                        _handleTouch(details.localPosition.dx, context),
                onPanUpdate:
                    (details) =>
                        _handleTouch(details.localPosition.dx, context),
                child: CustomPaint(
                  size: const Size(double.infinity, 110),
                  painter: _HourlySplinePainter(
                    hours: displayHours,
                    mode: _mode,
                    selectedIndex: _selectedIndex ?? 0,
                    isDark: isDark,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Axis Time Ticks (0h, 6h, 12h, 18h, 24h)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Now', style: _tickStyle(isDark)),
                if (displayHours.length > 6)
                  Text(
                    DateFormatter.formatHour(displayHours[6].dateTime),
                    style: _tickStyle(isDark),
                  ),
                if (displayHours.length > 12)
                  Text(
                    DateFormatter.formatHour(displayHours[12].dateTime),
                    style: _tickStyle(isDark),
                  ),
                if (displayHours.length > 18)
                  Text(
                    DateFormatter.formatHour(displayHours[18].dateTime),
                    style: _tickStyle(isDark),
                  ),
                if (displayHours.isNotEmpty)
                  Text(
                    DateFormatter.formatHour(displayHours.last.dateTime),
                    style: _tickStyle(isDark),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _tickStyle(bool isDark) {
    return TextStyle(
      fontSize: 10,
      color: isDark ? Colors.white38 : Colors.black38,
      fontWeight: FontWeight.w500,
    );
  }

  void _handleTouch(double localX, BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final chartWidth = box.size.width - 32;
    if (chartWidth <= 0) return;

    final step = chartWidth / (widget.hourlyList.take(24).length - 1);
    final index = (localX / step).round().clamp(
      0,
      widget.hourlyList.take(24).length - 1,
    );
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Widget _buildPill(String title, HourlyChartMode mode, bool isDark) {
    final isSelected = _mode == mode;
    return GestureDetector(
      onTap: () {
        setState(() {
          _mode = mode;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? (isDark ? ClimoraColors.navyPrimary : Colors.white)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                    ),
                  ]
                  : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color:
                isSelected
                    ? (isDark ? Colors.white : ClimoraColors.navyPrimary)
                    : (isDark ? Colors.white60 : Colors.black54),
          ),
        ),
      ),
    );
  }
}

class _HourlySplinePainter extends CustomPainter {
  final List<HourlyForecastItem> hours;
  final HourlyChartMode mode;
  final int selectedIndex;
  final bool isDark;

  _HourlySplinePainter({
    required this.hours,
    required this.mode,
    required this.selectedIndex,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (hours.length < 2) return;

    final values = <double>[];
    for (final h in hours) {
      switch (mode) {
        case HourlyChartMode.temperature:
          values.add(h.temperature);
          break;
        case HourlyChartMode.precipitation:
          values.add(h.precipitationProbability.toDouble());
          break;
        case HourlyChartMode.wind:
          values.add(h.windSpeed);
          break;
      }
    }

    final minVal =
        mode == HourlyChartMode.precipitation ? 0.0 : values.reduce(math.min);
    final maxVal =
        mode == HourlyChartMode.precipitation ? 100.0 : values.reduce(math.max);
    final span = (maxVal - minVal).abs() < 0.1 ? 1.0 : (maxVal - minVal);

    final stepX = size.width / (values.length - 1);
    final points = <Offset>[];

    for (int i = 0; i < values.length; i++) {
      final normY = (values[i] - minVal) / span;
      final x = i * stepX;
      final y = (size.height - 14) - (normY * (size.height - 28));
      points.add(Offset(x, y));
    }

    final Color themeColor;
    switch (mode) {
      case HourlyChartMode.temperature:
        themeColor = ClimoraColors.sunGold;
        break;
      case HourlyChartMode.precipitation:
        themeColor = ClimoraColors.skyBlue;
        break;
      case HourlyChartMode.wind:
        themeColor = ClimoraColors.tealAccent;
        break;
    }

    // 1. Draw smooth cubic spline path
    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = i > 0 ? points[i - 1] : points[i];
      final p1 = points[i];
      final p2 = points[i + 1];
      final p3 = i < points.length - 2 ? points[i + 2] : p2;

      final cp1x = p1.dx + (p2.dx - p0.dx) / 6.0;
      final cp1y = p1.dy + (p2.dy - p0.dy) / 6.0;
      final cp2x = p2.dx - (p3.dx - p1.dx) / 6.0;
      final cp2y = p2.dy - (p3.dy - p1.dy) / 6.0;

      path.cubicTo(cp1x, cp1y, cp2x, cp2y, p2.dx, p2.dy);
    }

    // 2. Draw gradient area fill
    final fillPath =
        Path.from(path)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();

    final fillPaint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              themeColor.withValues(alpha: 0.35),
              themeColor.withValues(alpha: 0.0),
            ],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fillPath, fillPaint);

    // 3. Draw spline line
    final linePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.4
          ..strokeCap = StrokeCap.round
          ..color = themeColor;
    canvas.drawPath(path, linePaint);

    // 4. Scrubbing cursor & indicator circle
    if (selectedIndex >= 0 && selectedIndex < points.length) {
      final selectedPoint = points[selectedIndex];

      // Vertical guideline
      final guidePaint =
          Paint()
            ..color = isDark ? Colors.white30 : Colors.black26
            ..strokeWidth = 1.0
            ..style = PaintingStyle.stroke;
      canvas.drawLine(
        Offset(selectedPoint.dx, 0),
        Offset(selectedPoint.dx, size.height),
        guidePaint,
      );

      // Glowing outer ring
      final ringPaint =
          Paint()
            ..color = themeColor.withValues(alpha: 0.4)
            ..style = PaintingStyle.fill;
      canvas.drawCircle(selectedPoint, 8, ringPaint);

      // Inner dot
      final dotPaint =
          Paint()..color = isDark ? Colors.white : ClimoraColors.navyPrimary;
      canvas.drawCircle(selectedPoint, 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _HourlySplinePainter oldDelegate) {
    return oldDelegate.mode != mode ||
        oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.hours != hours;
  }
}
