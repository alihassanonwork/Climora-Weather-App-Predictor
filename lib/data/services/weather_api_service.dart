import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../core/config/app_config.dart';
import '../../core/errors/app_exceptions.dart';
import '../models/city_location.dart';
import '../models/weather_data.dart';

/// Data service responsible for querying the Open-Meteo Weather Forecast API.
class WeatherApiService {
  final http.Client _client;

  WeatherApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches current, hourly, and 7-day daily weather for the specified coordinates.
  Future<WeatherData> fetchWeather(CityLocation city) async {
    final queryParameters = {
      'latitude': city.latitude.toString(),
      'longitude': city.longitude.toString(),
      'current': [
        'temperature_2m',
        'relative_humidity_2m',
        'apparent_temperature',
        'is_day',
        'precipitation',
        'rain',
        'showers',
        'snowfall',
        'weather_code',
        'surface_pressure',
        'wind_speed_10m',
        'wind_direction_10m',
        'uv_index',
      ].join(','),
      'hourly': [
        'temperature_2m',
        'relative_humidity_2m',
        'precipitation_probability',
        'weather_code',
        'wind_speed_10m',
        'uv_index',
      ].join(','),
      'daily': [
        'weather_code',
        'temperature_2m_max',
        'temperature_2m_min',
        'sunrise',
        'sunset',
        'precipitation_sum',
        'precipitation_probability_max',
        'wind_speed_10m_max',
        'uv_index_max',
      ].join(','),
      'timezone': 'auto',
    };

    final uri = Uri.parse(
      AppConfig.weatherBaseUrl,
    ).replace(queryParameters: queryParameters);

    try {
      final response = await _client.get(uri).timeout(AppConfig.apiTimeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json =
            jsonDecode(response.body) as Map<String, dynamic>;
        return WeatherData.fromOpenMeteoJson(city: city, json: json);
      } else {
        throw ApiException(
          'Failed to retrieve weather data from Open-Meteo.',
          statusCode: response.statusCode,
          details: response.body,
        );
      }
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const NetworkException(
        'Weather request timed out. Please check your connection and try again.',
      );
    } on FormatException catch (e) {
      throw ApiException('Malformed response received: $e');
    } catch (e) {
      if (e is AppException) rethrow;
      throw ApiException('An unexpected network error occurred: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}

