import 'package:climora/core/theme/climora_theme.dart';
import 'package:climora/data/models/current_weather.dart';
import 'package:climora/data/models/daily_forecast.dart';
import 'package:climora/data/models/hourly_forecast.dart';
import 'package:climora/data/models/user_settings.dart';
import 'package:climora/features/home/widgets/daily_forecast_card.dart';
import 'package:climora/features/home/widgets/hourly_forecast_strip.dart';
import 'package:climora/features/home/widgets/metrics_grid.dart';
import 'package:climora/features/home/widgets/weather_hero.dart';
import 'package:climora/shared/widgets/empty_view.dart';
import 'package:climora/shared/widgets/error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final testCurrent = const CurrentWeather(
    time: '2026-10-15T14:00',
    temperature: 18.5,
    apparentTemperature: 18.0,
    relativeHumidity: 65,
    isDay: true,
    precipitation: 0.0,
    rain: 0.0,
    showers: 0.0,
    snowfall: 0.0,
    weatherCode: 1,
    surfacePressure: 1016.0,
    windSpeed: 14.0,
    windDirection: 280.0,
    uvIndex: 4.5,
  );

  final testToday = const DailyForecastDay(
    date: '2026-10-15',
    weatherCode: 1,
    maxTemp: 22.0,
    minTemp: 12.0,
    precipitationSum: 0.0,
    precipitationProbabilityMax: 10,
    maxWindSpeed: 16.0,
    sunrise: '2026-10-15T07:10',
    sunset: '2026-10-15T18:45',
    uvIndexMax: 5.0,
  );

  final testSettings = const UserSettings(
    temperatureUnit: TemperatureUnit.celsius,
    windSpeedUnit: WindSpeedUnit.kmh,
    pressureUnit: PressureUnit.hPa,
    precipitationUnit: PrecipitationUnit.mm,
    themePreference: ThemePreference.system,
  );

  group('Climora Core Widget Tests', () {
    testWidgets('ErrorView renders error message and triggers retry on tap', (
      tester,
    ) async {
      bool retried = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: ClimoraTheme.lightTheme,
          home: Scaffold(
            body: ErrorView(
              error: 'Failed to connect to network',
              onRetry: () {
                retried = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Unable to Load Weather'), findsOneWidget);
      expect(find.text('Failed to connect to network'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);

      await tester.tap(find.text('Try Again'));
      await tester.pump();

      expect(retried, isTrue);
    });

    testWidgets(
      'EmptyView displays title, message, and optional action widget',
      (tester) async {
        bool actionTriggered = false;

        await tester.pumpWidget(
          MaterialApp(
            theme: ClimoraTheme.lightTheme,
            home: Scaffold(
              body: EmptyView(
                icon: Icons.search_off_rounded,
                title: 'No Cities Found',
                message: 'Try another search term',
                action: ElevatedButton(
                  onPressed: () {
                    actionTriggered = true;
                  },
                  child: const Text('Reset'),
                ),
              ),
            ),
          ),
        );

        expect(find.text('No Cities Found'), findsOneWidget);
        expect(find.text('Try another search term'), findsOneWidget);
        expect(find.text('Reset'), findsOneWidget);

        await tester.tap(find.text('Reset'));
        await tester.pump();

        expect(actionTriggered, isTrue);
      },
    );

    testWidgets(
      'WeatherHero displays temperature, condition, and feels-like metrics',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ClimoraTheme.lightTheme,
            home: Scaffold(
              body: WeatherHero(
                current: testCurrent,
                todayForecast: testToday,
                settings: testSettings,
                lastUpdated: DateTime(2026, 10, 15, 14, 0),
              ),
            ),
          ),
        );

        expect(find.text('19°C'), findsOneWidget);
        expect(find.text('Mainly clear'), findsOneWidget);
        expect(find.text('Feels like 18°C'), findsOneWidget);
        expect(find.text('22°C'), findsOneWidget);
        expect(find.text('12°C'), findsOneWidget);
      },
    );

    testWidgets(
      'MetricsGrid displays Wind, Humidity, Pressure, and UV index values',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ClimoraTheme.lightTheme,
            home: Scaffold(
              body: SingleChildScrollView(
                child: MetricsGrid(
                  current: testCurrent,
                  today: testToday,
                  settings: testSettings,
                ),
              ),
            ),
          ),
        );

        expect(find.text('Weather Details'), findsOneWidget);
        expect(find.text('Wind'), findsOneWidget);
        expect(find.text('14.0 km/h'), findsOneWidget);
        expect(find.text('Humidity'), findsOneWidget);
        expect(find.text('65%'), findsOneWidget);
        expect(find.text('Pressure'), findsOneWidget);
        expect(find.text('1016 hPa'), findsOneWidget);
        expect(find.text('UV Index'), findsOneWidget);
        expect(find.text('4.5'), findsOneWidget);
      },
    );

    testWidgets('HourlyForecastStrip renders horizontal hourly list', (
      tester,
    ) async {
      final hours = [
        HourlyForecastItem(
          time: DateTime.now().add(const Duration(hours: 1)).toIso8601String(),
          temperature: 19.0,
          relativeHumidity: 60,
          precipitationProbability: 0,
          weatherCode: 0,
          windSpeed: 10.0,
        ),
        HourlyForecastItem(
          time: DateTime.now().add(const Duration(hours: 2)).toIso8601String(),
          temperature: 18.0,
          relativeHumidity: 62,
          precipitationProbability: 20,
          weatherCode: 1,
          windSpeed: 12.0,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          theme: ClimoraTheme.lightTheme,
          home: Scaffold(
            body: HourlyForecastStrip(
              hourlyList: hours,
              settings: testSettings,
            ),
          ),
        ),
      );

      expect(find.text('Hourly Forecast'), findsOneWidget);
      expect(find.text('24 Hours'), findsOneWidget);
      expect(find.text('19°C'), findsOneWidget);
    });

    testWidgets('DailyForecastCard renders 5-day list and weekdays', (
      tester,
    ) async {
      final days = [
        testToday,
        const DailyForecastDay(
          date: '2026-10-16',
          weatherCode: 3,
          maxTemp: 20.0,
          minTemp: 11.0,
          precipitationSum: 1.2,
          precipitationProbabilityMax: 45,
          maxWindSpeed: 15.0,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          theme: ClimoraTheme.lightTheme,
          home: Scaffold(
            body: SingleChildScrollView(
              child: DailyForecastCard(
                dailyList: days,
                allHourly: const [],
                settings: testSettings,
              ),
            ),
          ),
        ),
      );

      expect(find.text('5-Day Forecast'), findsOneWidget);
      expect(find.text('Today'), findsOneWidget);
      expect(find.text('22°C'), findsOneWidget);
      expect(find.text('20°C'), findsOneWidget);
    });
  });
}
