import 'package:flutter/material.dart';

import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/unit_converter.dart';
import '../../../data/models/current_weather.dart';
import '../../../data/models/daily_forecast.dart';
import '../../../data/models/user_settings.dart';
import '../../../shared/animation/weather_scene.dart';
import '../../../shared/widgets/weather_icon_widget.dart';

/// Living atmospheric hero banner combining real-time procedural animations,
/// smooth temperature counting, and feels-like/min-max metrics.
class WeatherHero extends StatelessWidget {
  final CurrentWeather current;
  final DailyForecastDay? todayForecast;
  final UserSettings settings;
  final DateTime? lastUpdated;
  final double scrollOffset;

  const WeatherHero({
    super.key,
    required this.current,
    required this.todayForecast,
    required this.settings,
    this.lastUpdated,
    this.scrollOffset = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: WeatherScene(
        weatherCode: current.weatherCode,
        isDay: current.isDay,
        precipitation: current.precipitation,
        windSpeed: current.windSpeed,
        windDirection: current.windDirection,
        scrollOffset: scrollOffset,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date & Time + Last updated
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormatter.formatFullDate(current.dateTime),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                  if (lastUpdated != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Updated ${DateFormatter.formatTime(lastUpdated)}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 18),

              // Main Temperature and Animated Icon Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Giant Smooth-Counting Temperature
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                            begin: current.temperature,
                            end: current.temperature,
                          ),
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.easeOutCubic,
                          builder: (context, animatedTemp, _) {
                            return Text(
                              UnitConverter.formatTemperature(
                                animatedTemp,
                                settings.temperatureUnit,
                              ),
                              style: theme.textTheme.displayLarge?.copyWith(
                                fontSize: 72,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: -2.5,
                                height: 1.0,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 10),

                        // Weather Condition Title
                        Text(
                          current.condition.description,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Floating / Pulsing Animated Weather Icon
                  _FloatingWeatherIcon(iconPath: current.condition.iconPath),
                ],
              ),

              const SizedBox(height: 22),

              // Frosted Divider
              Container(height: 1, color: Colors.white.withValues(alpha: 0.2)),

              const SizedBox(height: 16),

              // Bottom Stats: Feels Like & Today's Min/Max
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Feels like
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.thermostat_rounded,
                        size: 18,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Feels like ${UnitConverter.formatTemperature(current.apparentTemperature, settings.temperatureUnit)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.95),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  // Min / Max
                  if (todayForecast != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.arrow_upward_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                        Text(
                          UnitConverter.formatTemperature(
                            todayForecast!.temperatureMax,
                            settings.temperatureUnit,
                          ),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_downward_rounded,
                          size: 16,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                        Text(
                          UnitConverter.formatTemperature(
                            todayForecast!.temperatureMin,
                            settings.temperatureUnit,
                          ),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FloatingWeatherIcon extends StatefulWidget {
  final String iconPath;

  const _FloatingWeatherIcon({required this.iconPath});

  @override
  State<_FloatingWeatherIcon> createState() => _FloatingWeatherIconState();
}

class _FloatingWeatherIconState extends State<_FloatingWeatherIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: -4.0,
      end: 4.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, reduceMotion ? 0.0 : _animation.value),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: WeatherIconWidget(
              iconPath: widget.iconPath,
              size: 86,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
