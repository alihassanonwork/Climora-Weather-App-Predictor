import '../../data/models/current_weather.dart';
import '../../data/models/daily_forecast.dart';
import '../../data/models/user_settings.dart';
import 'unit_converter.dart';
import 'weather_interpreter.dart';

/// Severe weather advisory model (rule-based, derived from actual forecast metrics).
class WeatherAlertNotice {
  final String title;
  final String description;
  final String severity; // 'Warning', 'Watch', 'Advisory'

  const WeatherAlertNotice({
    required this.title,
    required this.description,
    required this.severity,
  });
}

/// Generates rule-based natural language summaries and objective safety advisories.
class WeatherSummaryHelper {
  WeatherSummaryHelper._();

  /// Generates a natural language narrative summary based strictly on real API data.
  static String generateSummary({
    required CurrentWeather current,
    required DailyForecastDay? todayForecast,
    required UserSettings settings,
  }) {
    final condition = WeatherInterpreter.interpret(current.weatherCode);
    final tempStr = UnitConverter.formatTemperature(
      current.temperature,
      settings.temperatureUnit,
    );
    final feelsLikeStr = UnitConverter.formatTemperature(
      current.apparentTemperature,
      settings.temperatureUnit,
    );

    final buffer = StringBuffer();

    // 1. Current condition and thermal sensation
    buffer.write('\ with a current temperature of ');
    if ((current.temperature - current.apparentTemperature).abs() >= 2.0) {
      buffer.write(' (feels like \)');
    }
    buffer.write('. ');

    // 2. Highs and lows if available
    if (todayForecast != null) {
      final highStr = UnitConverter.formatTemperature(
        todayForecast.maxTemp,
        settings.temperatureUnit,
      );
      final lowStr = UnitConverter.formatTemperature(
        todayForecast.minTemp,
        settings.temperatureUnit,
      );
      buffer.write("Today's high is forecast at \ with an overnight low of \. ");
    }

    // 3. Rain / Precipitation insights
    if (current.precipitation > 0.0) {
      final precipStr = UnitConverter.formatPrecipitation(
        current.precipitation,
        settings.precipitationUnit,
      );
      buffer.write('Precipitation of \ is currently being recorded. ');
    } else if (todayForecast != null &&
        (todayForecast.precipitationProbabilityMax ?? 0) >= 40) {
      buffer.write(
        'There is a \% chance of rain today. An umbrella is recommended. ',
      );
    } else {
      buffer.write('No significant precipitation is expected in the immediate forecast. ');
    }

    // 4. Wind insights
    if (current.windSpeed >= 35.0) {
      final windStr = UnitConverter.formatWindSpeed(
        current.windSpeed,
        settings.windSpeedUnit,
      );
      buffer.write('Brisk winds blowing up to \. ');
    }

    // 5. UV insight
    if (current.uvIndex != null && current.uvIndex! >= 6.0) {
      buffer.write('High UV radiation levels detected; consider sun protection.');
    }

    return buffer.toString().trim();
  }

  /// Detects rule-based weather advisories directly from real meteorological thresholds.
  static List<WeatherAlertNotice> detectNotices({
    required CurrentWeather current,
    required DailyForecastDay? todayForecast,
  }) {
    final notices = <WeatherAlertNotice>[];

    // High Wind Warning
    final maxWind = todayForecast?.maxWindSpeed ?? current.windSpeed;
    if (maxWind >= 60.0) {
      notices.add(
        const WeatherAlertNotice(
          title: 'High Wind Advisory',
          description:
              'Wind gusts may reach or exceed 60 km/h. Secure loose outdoor objects and exercise caution while driving.',
          severity: 'Advisory',
        ),
      );
    }

    // Extreme UV Alert
    if ((current.uvIndex ?? 0) >= 8.0) {
      notices.add(
        const WeatherAlertNotice(
          title: 'Elevated UV Index Alert',
          description:
              'Very high UV index recorded. Minimize sun exposure between 10 AM and 4 PM, wear protective clothing and use SPF 50+ sunscreen.',
          severity: 'Advisory',
        ),
      );
    }

    // Heavy Precipitation
    final precipSum = todayForecast?.precipitationSum ?? current.precipitation;
    if (precipSum >= 25.0) {
      notices.add(
        const WeatherAlertNotice(
          title: 'Heavy Rainfall Advisory',
          description:
              'Accumulated precipitation is forecast to exceed 25 mm. Be cautious of localized water ponding and reduced visibility.',
          severity: 'Advisory',
        ),
      );
    }

    // Freezing Temperature / Frost Warning
    if (current.temperature <= 0.0 ||
        (todayForecast != null && todayForecast.minTemp <= 0.0)) {
      notices.add(
        const WeatherAlertNotice(
          title: 'Freezing Conditions Advisory',
          description:
              'Sub-zero temperatures detected. Watch for icy patches on roads and protect sensitive plants or exposed plumbing.',
          severity: 'Advisory',
        ),
      );
    }

    return notices;
  }
}
