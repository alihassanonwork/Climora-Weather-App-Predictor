import '../../core/utils/weather_interpreter.dart';
import 'weather_condition.dart';

/// Single hour forecast item.
class HourlyForecastItem {
  final String time;
  final double temperature;
  final int relativeHumidity;
  final int precipitationProbability;
  final int weatherCode;
  final double windSpeed;
  final double? uvIndex;

  const HourlyForecastItem({
    required this.time,
    required this.temperature,
    required this.relativeHumidity,
    required this.precipitationProbability,
    required this.weatherCode,
    required this.windSpeed,
    this.uvIndex,
  });

  DateTime get dateTime => DateTime.tryParse(time) ?? DateTime.now();
  WeatherCondition get condition =>
      WeatherInterpreter.interpret(weatherCode, isDay: true);

  factory HourlyForecastItem.fromJson(Map<String, dynamic> json) {
    return HourlyForecastItem(
      time: json['time'] as String? ?? '',
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.0,
      relativeHumidity: (json['relativeHumidity'] as num?)?.toInt() ?? 0,
      precipitationProbability:
          (json['precipitationProbability'] as num?)?.toInt() ?? 0,
      weatherCode: (json['weatherCode'] as num?)?.toInt() ?? 0,
      windSpeed: (json['windSpeed'] as num?)?.toDouble() ?? 0.0,
      uvIndex: (json['uvIndex'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'temperature': temperature,
      'relativeHumidity': relativeHumidity,
      'precipitationProbability': precipitationProbability,
      'weatherCode': weatherCode,
      'windSpeed': windSpeed,
      'uvIndex': uvIndex,
    };
  }
}

/// Collection of hourly forecasts parsed from Open-Meteo arrays.
class HourlyForecast {
  final List<HourlyForecastItem> items;

  const HourlyForecast({required this.items});

  factory HourlyForecast.fromOpenMeteoJson(Map<String, dynamic> json) {
    final times = (json['time'] as List?)?.cast<String>() ?? [];
    final temps = json['temperature_2m'] as List? ?? [];
    final humidities = json['relative_humidity_2m'] as List? ?? [];
    final precipProbs = json['precipitation_probability'] as List? ?? [];
    final weatherCodes = json['weather_code'] as List? ?? [];
    final windSpeeds = json['wind_speed_10m'] as List? ?? [];
    final uvIndices = json['uv_index'] as List? ?? [];

    final list = <HourlyForecastItem>[];
    for (int i = 0; i < times.length; i++) {
      list.add(
        HourlyForecastItem(
          time: times[i],
          temperature: i < temps.length ? (temps[i] as num).toDouble() : 0.0,
          relativeHumidity:
              i < humidities.length ? (humidities[i] as num).toInt() : 0,
          precipitationProbability:
              i < precipProbs.length
                  ? (precipProbs[i] as num?)?.toInt() ?? 0
                  : 0,
          weatherCode:
              i < weatherCodes.length ? (weatherCodes[i] as num).toInt() : 0,
          windSpeed:
              i < windSpeeds.length ? (windSpeeds[i] as num).toDouble() : 0.0,
          uvIndex:
              i < uvIndices.length ? (uvIndices[i] as num?)?.toDouble() : null,
        ),
      );
    }

    return HourlyForecast(items: list);
  }

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List? ?? [];
    return HourlyForecast(
      items:
          rawItems
              .map(
                (e) => HourlyForecastItem.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'items': items.map((e) => e.toJson()).toList()};
  }

  /// Returns hourly items within a window starting from the current time.
  List<HourlyForecastItem> getUpcomingHours({int count = 24}) {
    if (items.isEmpty) return [];

    final now = DateTime.now();
    int startIndex = 0;
    for (int i = 0; i < items.length; i++) {
      try {
        final itemDt = DateTime.parse(items[i].time);
        if (itemDt.isAfter(now.subtract(const Duration(minutes: 50)))) {
          startIndex = i;
          break;
        }
      } catch (_) {}
    }

    return items.skip(startIndex).take(count).toList();
  }
}
