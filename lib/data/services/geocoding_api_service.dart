import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../core/config/app_config.dart';
import '../../core/errors/app_exceptions.dart';
import '../models/city_location.dart';

/// Data service responsible for city searching via Open-Meteo Geocoding API.
class GeocodingApiService {
  final http.Client _client;

  GeocodingApiService({http.Client? client})
    : _client = client ?? http.Client();

  /// Searches for matching global cities given a text query string.
  Future<List<CityLocation>> searchCities(
    String query, {
    int count = 10,
  }) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];

    final queryParameters = {
      'name': trimmed,
      'count': count.toString(),
      'language': 'en',
      'format': 'json',
    };

    final uri = Uri.parse(
      AppConfig.geocodingBaseUrl,
    ).replace(queryParameters: queryParameters);

    try {
      final response = await _client.get(uri).timeout(AppConfig.apiTimeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json =
            jsonDecode(response.body) as Map<String, dynamic>;
        final results = json['results'] as List?;
        if (results == null || results.isEmpty) {
          return [];
        }

        return results
            .map((item) => CityLocation.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw ApiException(
          'Failed to search cities.',
          statusCode: response.statusCode,
          details: response.body,
        );
      }
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const NetworkException('City search timed out.');
    } on FormatException catch (e) {
      throw ApiException('Malformed geocoding response: $e');
    } catch (e) {
      if (e is AppException) rethrow;
      throw ApiException('Failed to search locations: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
