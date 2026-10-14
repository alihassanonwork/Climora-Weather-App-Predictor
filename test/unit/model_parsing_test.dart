import 'package:climora/data/models/city_location.dart';
import 'package:climora/data/models/current_weather.dart';
import 'package:climora/data/models/daily_forecast.dart';
import 'package:climora/data/models/hourly_forecast.dart';
import 'package:climora/data/models/user_settings.dart';
import 'package:climora/data/models/weather_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Model Parsing & Serialization', () {
    test('CurrentWeather correctly parses Open-Meteo current JSON', () {
      final json = {
        'time': '2026-10-14T20:15',
        'temperature_2m': 16.6,
        'relative_humidity_2m': 75,
        'apparent_temperature': 15.2,
        'is_day': 1,
        'precipitation': 0.5,
        'rain': 0.5,
        'showers': 0.0,
        'snowfall': 0.0,
        'weather_code': 3,
        'surface_pressure': 1023.1,
        'wind_speed_10m': 14.4,
        'wind_direction_10m': 206.0,
        'uv_index': 3.5,
      };

      final current = CurrentWeather.fromJson(json);
      expect(current.time, '2026-10-14T20:15');
      expect(current.temperature, 16.6);
      expect(current.relativeHumidity, 75);
      expect(current.apparentTemperature, 15.2);
      expect(current.isDay, isTrue);
      expect(current.precipitation, 0.5);
      expect(current.weatherCode, 3);
      expect(current.surfacePressure, 1023.1);
      expect(current.windSpeed, 14.4);
      expect(current.windDirection, 206.0);
      expect(current.uvIndex, 3.5);
    });

    test('HourlyForecast correctly parses array structure', () {
      final json = {
        'time': ['2026-10-14T20:00', '2026-10-14T21:00'],
        'temperature_2m': [16.0, 15.5],
        'relative_humidity_2m': [70, 75],
        'precipitation_probability': [10, 20],
        'weather_code': [1, 2],
        'wind_speed_10m': [12.0, 11.5],
        'uv_index': [0.0, 0.0],
      };

      final hourly = HourlyForecast.fromOpenMeteoJson(json);
      expect(hourly.items.length, 2);
      expect(hourly.items[0].time, '2026-10-14T20:00');
      expect(hourly.items[0].temperature, 16.0);
      expect(hourly.items[0].precipitationProbability, 10);
      expect(hourly.items[1].temperature, 15.5);
      expect(hourly.items[1].weatherCode, 2);
    });

    test('DailyForecast correctly parses array structure and computes 5-day', () {
      final json = {
        'time': [
          '2026-10-14',
          '2026-10-15',
          '2026-10-16',
          '2026-10-17',
          '2026-10-18',
          '2026-10-19',
          '2026-10-20',
        ],
        'weather_code': [1, 2, 3, 61, 80, 0, 1],
        'temperature_2m_max': [20.0, 21.0, 19.5, 18.0, 17.5, 22.0, 23.0],
        'temperature_2m_min': [10.0, 11.0, 9.5, 8.0, 8.5, 11.0, 12.0],
        'sunrise': ['2026-10-14T07:00', '2026-10-15T07:01'],
        'sunset': ['2026-10-14T18:00', '2026-10-15T17:59'],
        'precipitation_sum': [0.0, 0.0, 2.5, 5.0, 1.2, 0.0, 0.0],
        'precipitation_probability_max': [0, 10, 60, 80, 40, 0, 0],
        'wind_speed_10m_max': [15.0, 18.0, 22.0, 25.0, 16.0, 12.0, 14.0],
      };

      final daily = DailyForecast.fromOpenMeteoJson(json);
      expect(daily.days.length, 7);
      expect(daily.getFiveDayForecast().length, 5);
      expect(daily.days[0].date, '2026-10-14');
      expect(daily.days[0].maxTemp, 20.0);
      expect(daily.days[0].minTemp, 10.0);
      expect(daily.days[3].weatherCode, 61);
      expect(daily.days[3].precipitationSum, 5.0);
    });

    test('CityLocation parses geocoding JSON properly', () {
      final json = {
        'id': 1850147,
        'name': 'Tokyo',
        'latitude': 35.6895,
        'longitude': 139.69171,
        'country': 'Japan',
        'admin1': 'Tokyo',
        'country_code': 'JP',
        'timezone': 'Asia/Tokyo',
      };

      final city = CityLocation.fromJson(json);
      expect(city.id, 1850147);
      expect(city.name, 'Tokyo');
      expect(city.country, 'Japan');
      expect(city.displaySubtitle, 'Japan');
    });

    test('UserSettings serializes and deserializes identically', () {
      const original = UserSettings(
        temperatureUnit: TemperatureUnit.fahrenheit,
        windSpeedUnit: WindSpeedUnit.mph,
        pressureUnit: PressureUnit.inHg,
        precipitationUnit: PrecipitationUnit.inch,
        themePreference: ThemePreference.dark,
      );

      final json = original.toJson();
      final restored = UserSettings.fromJson(json);
      expect(restored, original);
    });

    test('WeatherData serializes and deserializes for caching', () {
      final city = const CityLocation(
        id: 1,
        name: 'Test City',
        latitude: 10.0,
        longitude: 20.0,
      );
      final current = const CurrentWeather(
        time: '2026-10-14T12:00',
        temperature: 20.0,
        apparentTemperature: 19.0,
        relativeHumidity: 50,
        isDay: true,
        precipitation: 0.0,
        rain: 0.0,
        showers: 0.0,
        snowfall: 0.0,
        weatherCode: 0,
        surfacePressure: 1013.0,
        windSpeed: 10.0,
        windDirection: 180.0,
      );
      final weatherData = WeatherData(
        city: city,
        current: current,
        hourly: const HourlyForecast(items: []),
        daily: const DailyForecast(days: []),
        timezone: 'UTC',
        lastUpdated: DateTime(2026, 10, 14, 12, 0),
      );

      final json = weatherData.toJson();
      final restored = WeatherData.fromJson(json);

      expect(restored.city.name, 'Test City');
      expect(restored.current.temperature, 20.0);
      expect(restored.isCached, isTrue);
    });
  });
}
