import 'package:climora/core/theme/climora_theme.dart';
import 'package:climora/data/models/city_location.dart';
import 'package:climora/data/models/current_weather.dart';
import 'package:climora/data/models/daily_forecast.dart';
import 'package:climora/data/models/hourly_forecast.dart';
import 'package:climora/data/models/weather_data.dart';
import 'package:climora/features/home/widgets/metrics_grid.dart';
import 'package:climora/features/home/widgets/weather_hero.dart';
import 'package:climora/shared/widgets/empty_view.dart';
import 'package:climora/shared/widgets/error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final testCity = const CityLocation(
    id: 1,
    name: 'San Francisco',
    latitude: 37.7749,
    longitude: -122.4194,
    country: 'United States',
  );

  final testCurrent = const CurrentWeather(
    time: '2026-10-14T15:00',
    temperature: 18.5,
    apparentTemperature: 18.0,
    relativeHumidity: 65,
    isDay: true,
    precipitation: 0.0,
    rain: 0.0,
    showers: 0.0,
    snowfall: 0.0,
    weatherCode: 1, // Mainly clear
    surfacePressure: 1016.0,
    windSpeed: 14.0,
    windDirection: 280.0,
    uvIndex: 3.0,
  );

  final testDaily = const DailyForecast(
    days: [
      DailyForecastDay(
        date: '2026-10-14',
        weatherCode: 1,
        maxTemp: 20.0,
        minTemp: 13.0,
        sunrise: '2026-10-14T07:15',
        sunset: '2026-10-14T18:30',
        precipitationSum: 0.0,
        precipitationProbabilityMax: 5,
        maxWindSpeed: 18.0,
      ),
    ],
  );

  final testWeatherData = WeatherData(
    city: testCity,
    current: testCurrent,
    hourly: const HourlyForecast(items: []),
    daily: testDaily,
    timezone: 'America/Los_Angeles',
    lastUpdated: DateTime(2026, 10, 14, 15, 0),
  );

  group('Climora Widget Tests', () {
    testWidgets('ClimoraErrorView renders message and responds to retry tap', (
      tester,
    ) async {
      bool retried = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: ClimoraTheme.lightTheme,
          home: Scaffold(
            body: ClimoraErrorView(
              message: 'Failed to connect to network',
              onRetry: () {
                retried = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Failed to connect to network'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);

      await tester.tap(find.text('Try Again'));
      await tester.pump();

      expect(retried, isTrue);
    });

    testWidgets('ClimoraEmptyView displays title and triggers callback', (
      tester,
    ) async {
      bool actionTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: ClimoraTheme.lightTheme,
          home: Scaffold(
            body: ClimoraEmptyView(
              icon: Icons.search,
              title: 'No Cities Found',
              description: 'Try another search term',
              actionLabel: 'Reset',
              onAction: () {
                actionTriggered = true;
              },
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
    });

    testWidgets('WeatherHero displays temperature and city name', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: ClimoraTheme.lightTheme,
            home: Scaffold(body: WeatherHero(weatherData: testWeatherData)),
          ),
        ),
      );

      expect(find.text('San Francisco'), findsOneWidget);
      expect(find.text('Mainly clear'), findsOneWidget);
      expect(find.text('19'), findsOneWidget); // Rounded from 18.5
      expect(find.text('°C'), findsOneWidget);
    });

    testWidgets('MetricsGrid displays wind, humidity, and pressure cards', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: ClimoraTheme.lightTheme,
            home: Scaffold(
              body: SingleChildScrollView(
                child: MetricsGrid(weatherData: testWeatherData),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Weather Conditions'), findsOneWidget);
      expect(find.text('WIND'), findsOneWidget);
      expect(find.text('HUMIDITY'), findsOneWidget);
      expect(find.text('PRESSURE'), findsOneWidget);
      expect(find.text('UV INDEX'), findsOneWidget);
      expect(find.text('65%'), findsOneWidget);
    });
  });
}
