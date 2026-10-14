import '../../data/models/city_location.dart';

/// Application constant values, storage keys, and initial defaults.
class AppConstants {
  AppConstants._();

  // Storage Keys
  static const String keyUserSettings = 'climora_user_settings';
  static const String keyFavoriteCities = 'climora_favorite_cities';
  static const String keyRecentCities = 'climora_recent_cities';
  static const String keyLastSelectedCity = 'climora_last_selected_city';
  static const String keyCachedWeatherData = 'climora_cached_weather_';

  // Default Fallback City if location is denied and no city chosen
  static const CityLocation defaultCity = CityLocation(
    id: 5128581,
    name: 'New York',
    latitude: 40.7128,
    longitude: -74.0060,
    country: 'United States',
    admin1: 'New York',
    countryCode: 'US',
    timezone: 'America/New_York',
  );

  // Popular Quick-Access Cities for Search/Exploration
  static const List<CityLocation> popularCities = [
    CityLocation(
      id: 5128581,
      name: 'New York',
      latitude: 40.7128,
      longitude: -74.0060,
      country: 'United States',
      admin1: 'New York',
      countryCode: 'US',
      timezone: 'America/New_York',
    ),
    CityLocation(
      id: 2643743,
      name: 'London',
      latitude: 51.5085,
      longitude: -0.1257,
      country: 'United Kingdom',
      admin1: 'England',
      countryCode: 'GB',
      timezone: 'Europe/London',
    ),
    CityLocation(
      id: 1850147,
      name: 'Tokyo',
      latitude: 35.6895,
      longitude: 139.6917,
      country: 'Japan',
      admin1: 'Tokyo',
      countryCode: 'JP',
      timezone: 'Asia/Tokyo',
    ),
    CityLocation(
      id: 2988507,
      name: 'Paris',
      latitude: 48.8534,
      longitude: 2.3488,
      country: 'France',
      admin1: '?le-de-France',
      countryCode: 'FR',
      timezone: 'Europe/Paris',
    ),
    CityLocation(
      id: 2147714,
      name: 'Sydney',
      latitude: -33.8678,
      longitude: 151.2073,
      country: 'Australia',
      admin1: 'New South Wales',
      countryCode: 'AU',
      timezone: 'Australia/Sydney',
    ),
  ];
}
