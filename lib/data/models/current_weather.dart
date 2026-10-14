import '../../core/utils/weather_interpreter.dart';
import 'weather_condition.dart';

/// Represents current meteorological conditions parsed from the Open-Meteo API.
class CurrentWeather {
  final String time;
  final double temperature;
  final double apparentTemperature;
  final int relativeHumidity;
  final bool isDay;
  final double precipitation;
  final double rain;
  final double showers;
  final double snowfall;
  final int weatherCode;
  final double surfacePressure;
  final double windSpeed;
  final double windDirection;
  final double? uvIndex;

  const CurrentWeather({
    required this.time,
    required this.temperature,
    required this.apparentTemperature,
    required this.relativeHumidity,
    required this.isDay,
    required this.precipitation,
    required this.rain,
    required this.showers,
    required this.snowfall,
    required this.weatherCode,
    required this.surfacePressure,
    required this.windSpeed,
    required this.windDirection,
    this.uvIndex,
  });

  WeatherCondition get condition =>
      WeatherInterpreter.interpret(weatherCode, isDay: isDay);

  DateTime get dateTime => DateTime.tryParse(time) ?? DateTime.now();

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      time: json['time'] as String? ?? '',
      temperature: (json['temperature_2m'] as num?)?.toDouble() ?? 0.0,
      apparentTemperature:
          (json['apparent_temperature'] as num?)?.toDouble() ?? 0.0,
      relativeHumidity: (json['relative_humidity_2m'] as num?)?.toInt() ?? 0,
      isDay: (json['is_day'] as num?)?.toInt() == 1,
      precipitation: (json['precipitation'] as num?)?.toDouble() ?? 0.0,
      rain: (json['rain'] as num?)?.toDouble() ?? 0.0,
      showers: (json['showers'] as num?)?.toDouble() ?? 0.0,
      snowfall: (json['snowfall'] as num?)?.toDouble() ?? 0.0,
      weatherCode: (json['weather_code'] as num?)?.toInt() ?? 0,
      surfacePressure:
          (json['surface_pressure'] as num?)?.toDouble() ?? 1013.25,
      windSpeed: (json['wind_speed_10m'] as num?)?.toDouble() ?? 0.0,
      windDirection: (json['wind_direction_10m'] as num?)?.toDouble() ?? 0.0,
      uvIndex: (json['uv_index'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'temperature_2m': temperature,
      'apparent_temperature': apparentTemperature,
      'relative_humidity_2m': relativeHumidity,
      'is_day': isDay ? 1 : 0,
      'precipitation': precipitation,
      'rain': rain,
      'showers': showers,
      'snowfall': snowfall,
      'weather_code': weatherCode,
      'surface_pressure': surfacePressure,
      'wind_speed_10m': windSpeed,
      'wind_direction_10m': windDirection,
      'uv_index': uvIndex,
    };
  }
}

