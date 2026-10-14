import 'city_location.dart';
import 'current_weather.dart';
import 'daily_forecast.dart';
import 'hourly_forecast.dart';

/// Aggregated, strongly-typed weather data bundle for a specific city location.
class WeatherData {
  final CityLocation city;
  final CurrentWeather current;
  final HourlyForecast hourly;
  final DailyForecast daily;
  final String timezone;
  final double? elevation;
  final DateTime lastUpdated;
  final bool isCached;

  const WeatherData({
    required this.city,
    required this.current,
    required this.hourly,
    required this.daily,
    required this.timezone,
    this.elevation,
    required this.lastUpdated,
    this.isCached = false,
  });

  /// The daily forecast corresponding to today.
  DailyForecastDay? get todayForecast {
    if (daily.days.isEmpty) return null;
    return daily.days.first;
  }

  WeatherData copyWith({
    CityLocation? city,
    CurrentWeather? current,
    HourlyForecast? hourly,
    DailyForecast? daily,
    String? timezone,
    double? elevation,
    DateTime? lastUpdated,
    bool? isCached,
  }) {
    return WeatherData(
      city: city ?? this.city,
      current: current ?? this.current,
      hourly: hourly ?? this.hourly,
      daily: daily ?? this.daily,
      timezone: timezone ?? this.timezone,
      elevation: elevation ?? this.elevation,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isCached: isCached ?? this.isCached,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city.toJson(),
      'current': current.toJson(),
      'hourly': hourly.toJson(),
      'daily': daily.toJson(),
      'timezone': timezone,
      'elevation': elevation,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      city: CityLocation.fromJson(json['city'] as Map<String, dynamic>),
      current:
          CurrentWeather.fromJson(json['current'] as Map<String, dynamic>),
      hourly: HourlyForecast.fromJson(json['hourly'] as Map<String, dynamic>),
      daily: DailyForecast.fromJson(json['daily'] as Map<String, dynamic>),
      timezone: json['timezone'] as String? ?? 'UTC',
      elevation: (json['elevation'] as num?)?.toDouble(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      isCached: true,
    );
  }

  factory WeatherData.fromOpenMeteoJson({
    required CityLocation city,
    required Map<String, dynamic> json,
  }) {
    return WeatherData(
      city: city,
      current: CurrentWeather.fromJson(
        json['current'] as Map<String, dynamic>? ?? {},
      ),
      hourly: HourlyForecast.fromOpenMeteoJson(
        json['hourly'] as Map<String, dynamic>? ?? {},
      ),
      daily: DailyForecast.fromOpenMeteoJson(
        json['daily'] as Map<String, dynamic>? ?? {},
      ),
      timezone: json['timezone'] as String? ?? 'UTC',
      elevation: (json['elevation'] as num?)?.toDouble(),
      lastUpdated: DateTime.now(),
      isCached: false,
    );
  }
}
