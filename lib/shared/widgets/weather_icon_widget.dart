import 'package:flutter/material.dart';
import '../../core/utils/weather_interpreter.dart';

/// Renders a responsive weather icon with subtle atmospheric glow based on WMO code and day/night.
class WeatherIconWidget extends StatelessWidget {
  final int? weatherCode;
  final String? iconPath;
  final bool isDay;
  final double size;
  final Color? color;
  final bool showGlow;

  const WeatherIconWidget({
    super.key,
    this.weatherCode,
    this.iconPath,
    this.isDay = true,
    this.size = 32.0,
    this.color,
    this.showGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    final condition = WeatherInterpreter.interpret(weatherCode ?? 0);
    final iconData = condition.getIcon(isDay);
    final iconColor = color ?? condition.accentColor;

    if (!showGlow) {
      return Icon(iconData, size: size, color: iconColor);
    }

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: iconColor.withAlpha(80),
            blurRadius: size * 0.7,
            spreadRadius: size * 0.1,
          ),
        ],
      ),
      child: Icon(iconData, size: size, color: iconColor),
    );
  }
}
