import 'package:climora/core/utils/weather_summary_helper.dart';
import 'package:climora/data/models/current_weather.dart';
import 'package:climora/data/models/daily_forecast.dart';
import 'package:climora/data/models/user_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WeatherSummaryHelper', () {
    test('generates expected summary under normal conditions', () {
      const current = CurrentWeather(
        time: '2026-10-14T14:00',
        temperature: 24.0,
        apparentTemperature: 24.0,
        relativeHumidity: 45,
        isDay: true,
        precipitation: 0.0,
        rain: 0.0,
        showers: 0.0,
        snowfall: 0.0,
        weatherCode: 0,
        surfacePressure: 1018.0,
        windSpeed: 12.0,
        windDirection: 90.0,
        uvIndex: 4.0,
      );

      const today = DailyForecastDay(
        date: '2026-10-14',
        weatherCode: 0,
        maxTemp: 26.0,
        minTemp: 18.0,
        precipitationSum: 0.0,
        precipitationProbabilityMax: 0,
        maxWindSpeed: 15.0,
      );

      final summary = WeatherSummaryHelper.generateSummary(
        current: current,
        todayForecast: today,
        settings: const UserSettings(),
      );

      expect(summary, contains('Clear sky'));
      expect(summary, contains('24\u00B0C'));
      expect(summary, contains("Today's high is forecast at 26\u00B0C"));
    });

    test('detects advisories for high winds, extreme UV, and heavy rain', () {
      const severeCurrent = CurrentWeather(
        time: '2026-10-14T14:00',
        temperature: 32.0,
        apparentTemperature: 34.0,
        relativeHumidity: 80,
        isDay: true,
        precipitation: 15.0,
        rain: 15.0,
        showers: 0.0,
        snowfall: 0.0,
        weatherCode: 95,
        surfacePressure: 1005.0,
        windSpeed: 65.0,
        windDirection: 220.0,
        uvIndex: 9.0,
      );

      const severeToday = DailyForecastDay(
        date: '2026-10-14',
        weatherCode: 95,
        maxTemp: 32.0,
        minTemp: 22.0,
        precipitationSum: 30.0,
        precipitationProbabilityMax: 95,
        maxWindSpeed: 65.0,
      );

      final notices = WeatherSummaryHelper.detectNotices(
        current: severeCurrent,
        todayForecast: severeToday,
      );

      expect(notices.any((n) => n.title.contains('High Wind')), isTrue);
      expect(notices.any((n) => n.title.contains('Elevated UV')), isTrue);
      expect(notices.any((n) => n.title.contains('Heavy Rainfall')), isTrue);
    });
  });
}
