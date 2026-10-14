/// Single calendar day forecast model.
class DailyForecastDay {
  final String date;
  final int weatherCode;
  final double maxTemp;
  final double minTemp;
  final String? sunrise;
  final String? sunset;
  final double precipitationSum;
  final int? precipitationProbabilityMax;
  final double maxWindSpeed;

  const DailyForecastDay({
    required this.date,
    required this.weatherCode,
    required this.maxTemp,
    required this.minTemp,
    this.sunrise,
    this.sunset,
    required this.precipitationSum,
    this.precipitationProbabilityMax,
    required this.maxWindSpeed,
  });

  factory DailyForecastDay.fromJson(Map<String, dynamic> json) {
    return DailyForecastDay(
      date: json['date'] as String? ?? '',
      weatherCode: (json['weatherCode'] as num?)?.toInt() ?? 0,
      maxTemp: (json['maxTemp'] as num?)?.toDouble() ?? 0.0,
      minTemp: (json['minTemp'] as num?)?.toDouble() ?? 0.0,
      sunrise: json['sunrise'] as String?,
      sunset: json['sunset'] as String?,
      precipitationSum:
          (json['precipitationSum'] as num?)?.toDouble() ?? 0.0,
      precipitationProbabilityMax:
          (json['precipitationProbabilityMax'] as num?)?.toInt(),
      maxWindSpeed: (json['maxWindSpeed'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'weatherCode': weatherCode,
      'maxTemp': maxTemp,
      'minTemp': minTemp,
      'sunrise': sunrise,
      'sunset': sunset,
      'precipitationSum': precipitationSum,
      'precipitationProbabilityMax': precipitationProbabilityMax,
      'maxWindSpeed': maxWindSpeed,
    };
  }
}

/// Collection of 5+ day daily forecasts.
class DailyForecast {
  final List<DailyForecastDay> days;

  const DailyForecast({required this.days});

  factory DailyForecast.fromOpenMeteoJson(Map<String, dynamic> json) {
    final times = (json['time'] as List?)?.cast<String>() ?? [];
    final weatherCodes = json['weather_code'] as List? ?? [];
    final maxTemps = json['temperature_2m_max'] as List? ?? [];
    final minTemps = json['temperature_2m_min'] as List? ?? [];
    final sunrises = (json['sunrise'] as List?)?.cast<String>() ?? [];
    final sunsets = (json['sunset'] as List?)?.cast<String>() ?? [];
    final precipSums = json['precipitation_sum'] as List? ?? [];
    final precipProbs =
        json['precipitation_probability_max'] as List? ?? [];
    final maxWindSpeeds = json['wind_speed_10m_max'] as List? ?? [];

    final list = <DailyForecastDay>[];
    for (int i = 0; i < times.length; i++) {
      list.add(
        DailyForecastDay(
          date: times[i],
          weatherCode: i < weatherCodes.length
              ? (weatherCodes[i] as num).toInt()
              : 0,
          maxTemp: i < maxTemps.length
              ? (maxTemps[i] as num).toDouble()
              : 0.0,
          minTemp: i < minTemps.length
              ? (minTemps[i] as num).toDouble()
              : 0.0,
          sunrise: i < sunrises.length ? sunrises[i] : null,
          sunset: i < sunsets.length ? sunsets[i] : null,
          precipitationSum: i < precipSums.length
              ? (precipSums[i] as num).toDouble()
              : 0.0,
          precipitationProbabilityMax: i < precipProbs.length
              ? (precipProbs[i] as num?)?.toInt()
              : null,
          maxWindSpeed: i < maxWindSpeeds.length
              ? (maxWindSpeeds[i] as num).toDouble()
              : 0.0,
        ),
      );
    }

    return DailyForecast(days: list);
  }

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    final rawDays = json['days'] as List? ?? [];
    return DailyForecast(
      days: rawDays
          .map((e) => DailyForecastDay.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'days': days.map((e) => e.toJson()).toList(),
    };
  }

  /// Returns 5 calendar days of forecast starting from today.
  List<DailyForecastDay> getFiveDayForecast() {
    return days.take(5).toList();
  }
}
