import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../core/theme/climora_colors.dart';
import '../../core/utils/weather_interpreter.dart';
import '../../data/models/weather_condition.dart';

/// Interactive and living atmospheric weather scene that renders real-time
/// animations (sun rays, cloud layers, rain, snow, wind trails, mist, or stars)
/// responding directly to actual API conditions.
class WeatherScene extends StatefulWidget {
  final int weatherCode;
  final bool isDay;
  final double precipitation;
  final double windSpeed;
  final double windDirection;
  final Widget? child;
  final double height;
  final double scrollOffset;

  const WeatherScene({
    super.key,
    required this.weatherCode,
    this.isDay = true,
    this.precipitation = 0.0,
    this.windSpeed = 10.0,
    this.windDirection = 0.0,
    this.child,
    this.height = 360,
    this.scrollOffset = 0.0,
  });

  @override
  State<WeatherScene> createState() => _WeatherSceneState();
}

class _WeatherSceneState extends State<WeatherScene>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final condition = WeatherInterpreter.interpret(
      widget.weatherCode,
      isDay: widget.isDay,
    );
    final category = condition.category;
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    final baseGradient = ClimoraColors.getWeatherGradient(
      widget.weatherCode,
      isDay: widget.isDay,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          // 1. Dynamic Atmospheric Gradient Background
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: baseGradient,
                ),
              ),
            ),
          ),

          // 2. Weather Animation Canvas (Custom Painter)
          Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _WeatherScenePainter(
                  category: category,
                  isDay: widget.isDay,
                  progress: reduceMotion ? 0.5 : _controller.value,
                  precipitation: widget.precipitation,
                  windSpeed: widget.windSpeed,
                  windDirection: widget.windDirection,
                  scrollOffset: widget.scrollOffset,
                  repaint: reduceMotion ? null : _controller,
                ),
              ),
            ),
          ),

          // 3. Subtle Frosted Ambient Overlay for Text Legibility
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.04),
                    Colors.black.withValues(alpha: 0.16),
                  ],
                ),
              ),
            ),
          ),

          // 4. Foreground Content (Hero Stats & Details)
          if (widget.child != null) widget.child!,
        ],
      ),
    );
  }
}

/// Unified CustomPainter rendering condition-specific atmospheric graphics.
class _WeatherScenePainter extends CustomPainter {
  final WeatherCategory category;
  final bool isDay;
  final double progress;
  final double precipitation;
  final double windSpeed;
  final double windDirection;
  final double scrollOffset;

  // Cached paint objects to avoid runtime allocations
  final Paint _sunPaint = Paint()..isAntiAlias = true;
  final Paint _rayPaint = Paint()..isAntiAlias = true;
  final Paint _cloudPaint = Paint()..isAntiAlias = true;
  final Paint _particlePaint = Paint()..isAntiAlias = true;
  final Paint _windPaint = Paint()..isAntiAlias = true;

  _WeatherScenePainter({
    required this.category,
    required this.isDay,
    required this.progress,
    required this.precipitation,
    required this.windSpeed,
    required this.windDirection,
    required this.scrollOffset,
    super.repaint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    if (!isDay) {
      _paintNightSky(canvas, size);
    } else {
      switch (category) {
        case WeatherCategory.clear:
          _paintSunny(canvas, size);
          break;
        case WeatherCategory.partlyCloudy:
          _paintPartlyCloudy(canvas, size);
          break;
        case WeatherCategory.overcast:
          _paintOvercast(canvas, size);
          break;
        case WeatherCategory.rain:
        case WeatherCategory.drizzle:
        case WeatherCategory.rainShowers:
          _paintRain(
            canvas,
            size,
            isHeavy: category == WeatherCategory.rain && precipitation > 2.0,
          );
          break;
        case WeatherCategory.thunderstorm:
          _paintThunderstorm(canvas, size);
          break;
        case WeatherCategory.snow:
        case WeatherCategory.snowShowers:
        case WeatherCategory.freezingRain:
          _paintSnow(canvas, size);
          break;
        case WeatherCategory.fog:
          _paintFog(canvas, size);
          break;
        case WeatherCategory.unknown:
          _paintSunny(canvas, size);
          break;
      }
    }

    // Optional dynamic wind trails if wind speed is prominent (> 15 km/h)
    if (windSpeed > 15.0 && category != WeatherCategory.fog) {
      _paintWindTrails(canvas, size);
    }
  }

  // ==========================================
  // SUNNY / CLEAR DAY
  // ==========================================
  void _paintSunny(Canvas canvas, Size size) {
    final sunCenter = Offset(size.width * 0.82, size.height * 0.28);
    final pulse = 0.94 + 0.06 * math.sin(progress * 2 * math.pi);

    // 1. Soft atmospheric sun bloom
    _sunPaint.shader = RadialGradient(
      colors: [
        const Color(0xFFFFE082).withValues(alpha: 0.45 * pulse),
        const Color(0xFFFFB300).withValues(alpha: 0.18 * pulse),
        Colors.transparent,
      ],
      stops: const [0.0, 0.55, 1.0],
    ).createShader(Rect.fromCircle(center: sunCenter, radius: 140 * pulse));
    canvas.drawCircle(sunCenter, 140 * pulse, _sunPaint);

    // 2. Rotating/breathing sun rays
    final rayCount = 12;
    final rayAngleStep = (2 * math.pi) / rayCount;
    final rayRotation = progress * 2 * math.pi * 0.2;

    _rayPaint.style = PaintingStyle.stroke;
    _rayPaint.strokeCap = StrokeCap.round;
    _rayPaint.strokeWidth = 2.5;

    for (int i = 0; i < rayCount; i++) {
      final angle = i * rayAngleStep + rayRotation;
      final rayStart = Offset(
        sunCenter.dx + math.cos(angle) * 36,
        sunCenter.dy + math.sin(angle) * 36,
      );
      final rayLen = 14 + 6 * math.sin(progress * 4 * math.pi + i);
      final rayEnd = Offset(
        sunCenter.dx + math.cos(angle) * (36 + rayLen),
        sunCenter.dy + math.sin(angle) * (36 + rayLen),
      );

      _rayPaint.color = const Color(
        0xFFFFF9C4,
      ).withValues(alpha: 0.35 + 0.15 * math.cos(progress * 2 * math.pi + i));
      canvas.drawLine(rayStart, rayEnd, _rayPaint);
    }

    // 3. Central glowing sun core
    _sunPaint.shader = const RadialGradient(
      colors: [Color(0xFFFFFDE7), Color(0xFFFFEE58), Color(0xFFF57F17)],
      stops: [0.0, 0.6, 1.0],
    ).createShader(Rect.fromCircle(center: sunCenter, radius: 30));
    canvas.drawCircle(sunCenter, 30, _sunPaint);

    // 4. Subtle drifting wispy cloud at bottom
    _paintDriftingWisps(canvas, size, baseSpeed: 0.05, opacity: 0.25);
  }

  // ==========================================
  // PARTLY CLOUDY
  // ==========================================
  void _paintPartlyCloudy(Canvas canvas, Size size) {
    // Soft sun peeking from top-right
    final sunCenter = Offset(size.width * 0.78, size.height * 0.25);
    _sunPaint.shader = RadialGradient(
      colors: [
        const Color(0xFFFFE082).withValues(alpha: 0.4),
        Colors.transparent,
      ],
    ).createShader(Rect.fromCircle(center: sunCenter, radius: 90));
    canvas.drawCircle(sunCenter, 90, _sunPaint);

    _sunPaint.shader = null;
    _sunPaint.color = const Color(0xFFFFD54F).withValues(alpha: 0.85);
    canvas.drawCircle(sunCenter, 26, _sunPaint);

    // Cloud layers at different depths
    _paintCloudLayer(
      canvas,
      size,
      yPos: size.height * 0.22,
      scale: 1.1,
      speed: 0.08,
      color: Colors.white.withValues(alpha: 0.35),
    );
    _paintCloudLayer(
      canvas,
      size,
      yPos: size.height * 0.45,
      scale: 1.4,
      speed: 0.14,
      color: Colors.white.withValues(alpha: 0.45),
    );
  }

  // ==========================================
  // OVERCAST / CLOUDY
  // ==========================================
  void _paintOvercast(Canvas canvas, Size size) {
    // 3 drifting cloud shelves creating atmospheric depth
    _paintCloudLayer(
      canvas,
      size,
      yPos: size.height * 0.15,
      scale: 1.0,
      speed: 0.04,
      color: const Color(0xFFCFD8DC).withValues(alpha: 0.25),
    );
    _paintCloudLayer(
      canvas,
      size,
      yPos: size.height * 0.32,
      scale: 1.3,
      speed: 0.07,
      color: const Color(0xFFB0BEC5).withValues(alpha: 0.35),
    );
    _paintCloudLayer(
      canvas,
      size,
      yPos: size.height * 0.55,
      scale: 1.6,
      speed: 0.11,
      color: const Color(0xFF90A4AE).withValues(alpha: 0.3),
    );
  }

  // ==========================================
  // RAIN / DRIZZLE
  // ==========================================
  void _paintRain(Canvas canvas, Size size, {bool isHeavy = false}) {
    // Background cloud cover
    _paintCloudLayer(
      canvas,
      size,
      yPos: size.height * 0.18,
      scale: 1.2,
      speed: 0.06,
      color: const Color(0xFF78909C).withValues(alpha: 0.3),
    );

    final dropCount = isHeavy ? 45 : 26;
    final angleRad = (windDirection - 180) * (math.pi / 180) * 0.15;
    final dxAngle = math.sin(angleRad) * 4;

    _particlePaint.style = PaintingStyle.stroke;
    _particlePaint.strokeCap = StrokeCap.round;

    for (int i = 0; i < dropCount; i++) {
      final randX = ((i * 37.0 + 13.0) % 100.0) / 100.0;
      final speedFactor = 1.0 + (i % 5) * 0.25;
      final dropY =
          ((progress * speedFactor * 1.5 + (i / dropCount)) % 1.0) *
          size.height;
      final dropX =
          (randX * size.width + (dropY / size.height) * dxAngle * 40) %
          size.width;

      final dropLength = isHeavy ? 14.0 + (i % 6) * 2.0 : 8.0 + (i % 4) * 2.0;
      final dropAlpha = 0.25 + 0.35 * (i % 3 == 0 ? 1.0 : 0.6);

      _particlePaint.color = const Color(
        0xFFB3E5FC,
      ).withValues(alpha: dropAlpha);
      _particlePaint.strokeWidth = isHeavy ? 1.8 : 1.2;

      canvas.drawLine(
        Offset(dropX, dropY),
        Offset(dropX + dxAngle, dropY + dropLength),
        _particlePaint,
      );

      // Subtle water ripple near bottom of the banner
      if (dropY > size.height * 0.85 && (i % 4 == 0)) {
        final rippleProg = (dropY - size.height * 0.85) / (size.height * 0.15);
        final rippleRadius = rippleProg * 12.0;
        final ripplePaint =
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.0
              ..color = const Color(
                0xFF81D4FA,
              ).withValues(alpha: (1.0 - rippleProg) * 0.35);
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(dropX, size.height * 0.95),
            width: rippleRadius * 2,
            height: rippleRadius * 0.7,
          ),
          ripplePaint,
        );
      }
    }
  }

  // ==========================================
  // THUNDERSTORM
  // ==========================================
  void _paintThunderstorm(Canvas canvas, Size size) {
    // 1. Rain base
    _paintRain(canvas, size, isHeavy: true);

    // 2. Realistic lightning flash pulse (timed cycle)
    final cycle = (progress * 4) % 1.0;
    if (cycle > 0.88 && cycle < 0.96) {
      final flashIntensity = math.sin((cycle - 0.88) / 0.08 * math.pi);

      // Ambient screen illumination flash
      final flashPaint =
          Paint()
            ..color = const Color(
              0xFFE0E7FF,
            ).withValues(alpha: flashIntensity * 0.28);
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), flashPaint);

      // Branched electric lightning bolt
      final boltPaint =
          Paint()
            ..color = Colors.white.withValues(alpha: flashIntensity * 0.85)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.2
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.miter;

      final startX = size.width * 0.72;
      final boltPath = Path();
      boltPath.moveTo(startX, 10);
      boltPath.lineTo(startX - 12, size.height * 0.22);
      boltPath.lineTo(startX + 8, size.height * 0.35);
      boltPath.lineTo(startX - 18, size.height * 0.58);
      boltPath.lineTo(startX - 4, size.height * 0.75);

      canvas.drawPath(boltPath, boltPaint);
    }
  }

  // ==========================================
  // SNOW
  // ==========================================
  void _paintSnow(Canvas canvas, Size size) {
    final flakeCount = 35;
    _particlePaint.style = PaintingStyle.fill;

    for (int i = 0; i < flakeCount; i++) {
      final randX = ((i * 47.0 + 17.0) % 100.0) / 100.0;
      final fallSpeed = 0.4 + (i % 4) * 0.15;
      final flakeY =
          ((progress * fallSpeed + (i / flakeCount)) % 1.0) * size.height;

      // Sinusoidal flutter drift
      final sway = math.sin(progress * 4 * math.pi + i) * 12.0;
      final flakeX = (randX * size.width + sway) % size.width;

      final radius = 1.6 + (i % 4) * 0.8;
      final alpha = 0.35 + 0.55 * ((i % 5) / 5.0);

      _particlePaint.color = Colors.white.withValues(alpha: alpha);
      canvas.drawCircle(Offset(flakeX, flakeY), radius, _particlePaint);
    }
  }

  // ==========================================
  // FOG / MIST
  // ==========================================
  void _paintFog(Canvas canvas, Size size) {
    for (int i = 0; i < 3; i++) {
      final yBase = size.height * (0.35 + i * 0.2);
      final waveOffset = math.sin(progress * 2 * math.pi + i * 2) * 8.0;
      final fogSpeed = (0.05 + i * 0.03) * progress;

      final fogPath = Path();
      fogPath.moveTo(0, yBase + waveOffset);

      for (double x = 0; x <= size.width; x += 40) {
        final y =
            yBase +
            waveOffset +
            math.sin(
                  (x / size.width * 2 * math.pi) + (fogSpeed * 2 * math.pi),
                ) *
                14.0;
        fogPath.lineTo(x, y);
      }
      fogPath.lineTo(size.width, size.height);
      fogPath.lineTo(0, size.height);
      fogPath.close();

      final fogPaint =
          Paint()
            ..shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: 0.08 + i * 0.05),
                Colors.white.withValues(alpha: 0.18 + i * 0.06),
              ],
            ).createShader(
              Rect.fromLTWH(0, yBase, size.width, size.height - yBase),
            );

      canvas.drawPath(fogPath, fogPaint);
    }
  }

  // ==========================================
  // NIGHT SKY (STARS, MOON & NIGHT WISPS)
  // ==========================================
  void _paintNightSky(Canvas canvas, Size size) {
    // 1. Twinkling stars
    final starCount = 38;
    for (int i = 0; i < starCount; i++) {
      final sx = ((i * 59.0 + 23.0) % 100.0) / 100.0 * size.width;
      final sy = ((i * 41.0 + 7.0) % 100.0) / 100.0 * (size.height * 0.75);

      final twinkle =
          0.3 + 0.7 * (0.5 + 0.5 * math.sin(progress * 6 * math.pi + i * 1.7));
      final starSize = (i % 7 == 0) ? 2.0 : 1.2;

      _particlePaint.color = Colors.white.withValues(alpha: twinkle * 0.85);
      canvas.drawCircle(Offset(sx, sy), starSize, _particlePaint);
    }

    // 2. Glowing Moon
    final moonCenter = Offset(size.width * 0.82, size.height * 0.28);
    // Outer lunar halo
    _sunPaint.shader = RadialGradient(
      colors: [
        const Color(0xFFC7D2FE).withValues(alpha: 0.3),
        const Color(0xFF818CF8).withValues(alpha: 0.08),
        Colors.transparent,
      ],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(Rect.fromCircle(center: moonCenter, radius: 80));
    canvas.drawCircle(moonCenter, 80, _sunPaint);

    // Crescent moon shape
    _sunPaint.shader = null;
    _sunPaint.color = const Color(0xFFF1F5F9);
    canvas.drawCircle(moonCenter, 24, _sunPaint);

    // Clip shadow to make subtle waxing crescent/gibbous
    final shadowPaint = Paint()..color = const Color(0xFF1E293B);
    canvas.drawCircle(
      Offset(moonCenter.dx - 8, moonCenter.dy - 4),
      22,
      shadowPaint,
    );

    // 3. Night wisps
    _paintDriftingWisps(canvas, size, baseSpeed: 0.04, opacity: 0.12);
  }

  // ==========================================
  // SHARED PROCEDURAL HELPERS
  // ==========================================
  void _paintCloudLayer(
    Canvas canvas,
    Size size, {
    required double yPos,
    required double scale,
    required double speed,
    required Color color,
  }) {
    _cloudPaint.color = color;
    final cloudOffset =
        (progress * speed * size.width * 2) % (size.width + 200) - 100;

    for (int i = -1; i <= 2; i++) {
      final cx = cloudOffset + i * 220;
      final cy = yPos - scrollOffset * 0.1;

      final path = Path();
      path.addOval(
        Rect.fromCenter(
          center: Offset(cx, cy),
          width: 140 * scale,
          height: 60 * scale,
        ),
      );
      path.addOval(
        Rect.fromCenter(
          center: Offset(cx + 40 * scale, cy - 18 * scale),
          width: 90 * scale,
          height: 70 * scale,
        ),
      );
      path.addOval(
        Rect.fromCenter(
          center: Offset(cx - 35 * scale, cy - 10 * scale),
          width: 80 * scale,
          height: 50 * scale,
        ),
      );
      canvas.drawPath(path, _cloudPaint);
    }
  }

  void _paintDriftingWisps(
    Canvas canvas,
    Size size, {
    required double baseSpeed,
    required double opacity,
  }) {
    final wispPaint = Paint()..color = Colors.white.withValues(alpha: opacity);
    final wispX =
        (progress * baseSpeed * size.width * 2) % (size.width + 300) - 150;
    final path = Path();
    path.addOval(
      Rect.fromCenter(
        center: Offset(wispX, size.height * 0.8),
        width: 220,
        height: 45,
      ),
    );
    path.addOval(
      Rect.fromCenter(
        center: Offset(wispX + 160, size.height * 0.75),
        width: 180,
        height: 35,
      ),
    );
    canvas.drawPath(path, wispPaint);
  }

  void _paintWindTrails(Canvas canvas, Size size) {
    _windPaint.style = PaintingStyle.stroke;
    _windPaint.strokeCap = StrokeCap.round;

    final trailCount = 5;
    for (int i = 0; i < trailCount; i++) {
      final trailProg = (progress * (1.0 + i * 0.2) + (i / trailCount)) % 1.0;
      final startX = (trailProg * (size.width + 100)) - 50;
      final startY = size.height * (0.2 + (i * 0.15));

      final path = Path();
      path.moveTo(startX, startY);
      path.quadraticBezierTo(startX + 35, startY - 6, startX + 70, startY + 4);

      _windPaint.strokeWidth = 1.4;
      _windPaint.color = Colors.white.withValues(
        alpha: (1.0 - (trailProg - 0.5).abs() * 2).clamp(0.0, 1.0) * 0.25,
      );
      canvas.drawPath(path, _windPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _WeatherScenePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.category != category ||
        oldDelegate.isDay != isDay ||
        oldDelegate.precipitation != precipitation ||
        oldDelegate.windSpeed != windSpeed ||
        oldDelegate.scrollOffset != scrollOffset;
  }
}
