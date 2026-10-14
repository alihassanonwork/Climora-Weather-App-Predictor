import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../models/city_location.dart';
import '../models/user_settings.dart';
import '../models/weather_data.dart';

/// Local storage service using SharedPreferences for settings, favorites, and cached weather.
class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  // --- User Settings ---
  UserSettings getUserSettings() {
    final jsonString = _prefs.getString(AppConstants.keyUserSettings);
    if (jsonString == null) return const UserSettings();
    try {
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserSettings.fromJson(map);
    } catch (_) {
      return const UserSettings();
    }
  }

  Future<bool> saveUserSettings(UserSettings settings) {
    return _prefs.setString(
      AppConstants.keyUserSettings,
      jsonEncode(settings.toJson()),
    );
  }

  // --- Favorite Cities ---
  List<CityLocation> getFavoriteCities() {
    final list = _prefs.getStringList(AppConstants.keyFavoriteCities);
    if (list == null || list.isEmpty) {
      return [AppConstants.defaultCity];
    }
    try {
      return list
          .map(
            (item) =>
                CityLocation.fromJson(jsonDecode(item) as Map<String, dynamic>),
          )
          .map((city) => city.copyWith(isFavorite: true))
          .toList();
    } catch (_) {
      return [AppConstants.defaultCity];
    }
  }

  Future<bool> saveFavoriteCities(List<CityLocation> cities) {
    final list =
        cities
            .map((c) => jsonEncode(c.copyWith(isFavorite: true).toJson()))
            .toList();
    return _prefs.setStringList(AppConstants.keyFavoriteCities, list);
  }

  Future<void> addFavoriteCity(CityLocation city) async {
    final current = getFavoriteCities();
    if (!current.any((c) => c.id == city.id && c.name == city.name)) {
      current.add(city.copyWith(isFavorite: true));
      await saveFavoriteCities(current);
    }
  }

  Future<void> removeFavoriteCity(CityLocation city) async {
    final current = getFavoriteCities();
    current.removeWhere((c) => c.id == city.id && c.name == city.name);
    await saveFavoriteCities(current);
  }

  bool isFavorite(CityLocation city) {
    final favorites = getFavoriteCities();
    return favorites.any((c) => c.id == city.id && c.name == city.name);
  }

  // --- Recent Searched Cities ---
  List<CityLocation> getRecentCities() {
    final list = _prefs.getStringList(AppConstants.keyRecentCities);
    if (list == null) return [];
    try {
      return list
          .map(
            (item) =>
                CityLocation.fromJson(jsonDecode(item) as Map<String, dynamic>),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> addRecentCity(CityLocation city) async {
    final current = getRecentCities();
    current.removeWhere((c) => c.id == city.id && c.name == city.name);
    current.insert(0, city);
    final trimmed = current.take(10).toList();
    final list = trimmed.map((c) => jsonEncode(c.toJson())).toList();
    await _prefs.setStringList(AppConstants.keyRecentCities, list);
  }

  Future<void> clearRecentCities() async {
    await _prefs.remove(AppConstants.keyRecentCities);
  }

  // --- Last Selected City ---
  CityLocation getLastSelectedCity() {
    final jsonString = _prefs.getString(AppConstants.keyLastSelectedCity);
    if (jsonString == null) return AppConstants.defaultCity;
    try {
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      return CityLocation.fromJson(map);
    } catch (_) {
      return AppConstants.defaultCity;
    }
  }

  Future<bool> saveLastSelectedCity(CityLocation city) {
    return _prefs.setString(
      AppConstants.keyLastSelectedCity,
      jsonEncode(city.toJson()),
    );
  }

  // --- Weather Data Cache ---
  String _cacheKey(CityLocation city) => '_';

  WeatherData? getCachedWeather(CityLocation city) {
    final key = _cacheKey(city);
    final jsonString = _prefs.getString(key);
    if (jsonString == null) return null;
    try {
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      return WeatherData.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<bool> cacheWeather(WeatherData data) {
    final key = _cacheKey(data.city);
    return _prefs.setString(key, jsonEncode(data.toJson()));
  }
}
