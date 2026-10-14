import '../../core/config/app_config.dart';
import '../../core/errors/app_exceptions.dart';
import '../models/city_location.dart';
import '../models/weather_data.dart';
import '../services/geocoding_api_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';
import '../services/weather_api_service.dart';

/// Repository that orchestrates weather data fetching, local caching, and location services.
class WeatherRepository {
  final WeatherApiService _weatherApiService;
  final GeocodingApiService _geocodingApiService;
  final LocationService _locationService;
  final StorageService _storageService;

  WeatherRepository({
    required WeatherApiService weatherApiService,
    required GeocodingApiService geocodingApiService,
    required LocationService locationService,
    required StorageService storageService,
  })  : _weatherApiService = weatherApiService,
        _geocodingApiService = geocodingApiService,
        _locationService = locationService,
        _storageService = storageService;

  /// Retrieves weather for the given city, respecting cache freshness unless [forceRefresh] is true.
  Future<WeatherData> getWeather(
    CityLocation city, {
    bool forceRefresh = false,
  }) async {
    final cached = _storageService.getCachedWeather(city);

    if (!forceRefresh && cached != null) {
      final age = DateTime.now().difference(cached.lastUpdated);
      if (age < AppConfig.cacheValidityDuration) {
        return cached;
      }
    }

    try {
      final fresh = await _weatherApiService.fetchWeather(city);
      await _storageService.cacheWeather(fresh);
      return fresh;
    } catch (e) {
      if (cached != null) {
        return cached.copyWith(isCached: true);
      }
      if (e is AppException) rethrow;
      throw ApiException('Failed to retrieve weather data: ');
    }
  }

  Future<List<CityLocation>> searchCities(String query) {
    return _geocodingApiService.searchCities(query);
  }

  Future<CityLocation> getCurrentLocation() {
    return _locationService.getCurrentLocationCity();
  }

  List<CityLocation> getFavoriteCities() => _storageService.getFavoriteCities();

  Future<void> addFavoriteCity(CityLocation city) =>
      _storageService.addFavoriteCity(city);

  Future<void> removeFavoriteCity(CityLocation city) =>
      _storageService.removeFavoriteCity(city);

  bool isFavorite(CityLocation city) => _storageService.isFavorite(city);

  List<CityLocation> getRecentCities() => _storageService.getRecentCities();

  Future<void> addRecentCity(CityLocation city) =>
      _storageService.addRecentCity(city);

  Future<void> clearRecentCities() => _storageService.clearRecentCities();

  CityLocation getLastSelectedCity() => _storageService.getLastSelectedCity();

  Future<void> saveLastSelectedCity(CityLocation city) =>
      _storageService.saveLastSelectedCity(city);
}
