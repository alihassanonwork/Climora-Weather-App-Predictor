/// Global configuration constants for the Climora application.
class AppConfig {
  AppConfig._();

  static const String appName = 'Climora';
  static const String appTagline = 'Weather, beautifully understood.';
  static const String appVersion = '1.0.0';

  // Open-Meteo API Endpoints
  // Open-Meteo is free for non-commercial use with no API key required.
  // Terms: https://open-meteo.com/en/terms
  static const String weatherBaseUrl = 'https://api.open-meteo.com/v1/forecast';
  static const String geocodingBaseUrl =
      'https://geocoding-api.open-meteo.com/v1/search';

  // Network & Cache Settings
  static const Duration apiTimeout = Duration(seconds: 12);
  static const Duration cacheValidityDuration = Duration(minutes: 20);
  static const Duration searchDebounceDuration = Duration(milliseconds: 350);

  // Attribution
  static const String weatherProviderAttribution =
      'Weather data provided by Open-Meteo (open-meteo.com)';
  static const String openMeteoAttribution = weatherProviderAttribution;
  static const String weatherProviderUrl = 'https://open-meteo.com/';
}

