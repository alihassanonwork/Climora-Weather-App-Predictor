import 'package:climora/core/utils/weather_interpreter.dart';
import 'package:climora/data/models/hourly_forecast.dart';
import 'package:climora/data/models/weather_condition.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WeatherInterpreter Visualization & Meteorological Logic Tests', () {
    test('Pressure trend computes rising, falling, and steady correctly', () {
      // 1. Rising: current is higher than 3h past by > 1.0 hPa
      final rising = WeatherInterpreter.getPressureTrend(1015.5, 1013.0);
      expect(rising.label, equals('Rising'));

      // 2. Falling: current is lower than 3h past by > 1.0 hPa
      final falling = WeatherInterpreter.getPressureTrend(1010.0, 1013.0);
      expect(falling.label, equals('Falling'));

      // 3. Steady: difference within [-1.0, 1.0]
      final steady = WeatherInterpreter.getPressureTrend(1013.4, 1013.0);
      expect(steady.label, equals('Steady'));

      // 4. Null past pressure defaults to steady
      final noPast = WeatherInterpreter.getPressureTrend(1013.25, null);
      expect(noPast.label, equals('Steady'));
    });

    test('Beaufort scale accurately categorizes wind speeds', () {
      expect(WeatherInterpreter.getBeaufortScale(0.5).name, equals('Calm'));
      expect(
        WeatherInterpreter.getBeaufortScale(3.0).name,
        equals('Light air'),
      );
      expect(
        WeatherInterpreter.getBeaufortScale(10.0).name,
        equals('Light breeze'),
      );
      expect(
        WeatherInterpreter.getBeaufortScale(15.0).name,
        equals('Gentle breeze'),
      );
      expect(
        WeatherInterpreter.getBeaufortScale(25.0).name,
        equals('Moderate breeze'),
      );
      expect(
        WeatherInterpreter.getBeaufortScale(35.0).name,
        equals('Fresh breeze'),
      );
      expect(
        WeatherInterpreter.getBeaufortScale(45.0).name,
        equals('Strong breeze'),
      );
      expect(
        WeatherInterpreter.getBeaufortScale(55.0).name,
        equals('Near gale'),
      );
      expect(WeatherInterpreter.getBeaufortScale(70.0).name, equals('Gale'));
      expect(
        WeatherInterpreter.getBeaufortScale(80.0).name,
        equals('Severe gale'),
      );
      expect(WeatherInterpreter.getBeaufortScale(95.0).name, equals('Storm'));
    });

    test('Relative humidity classification thresholds are sound', () {
      final dry = WeatherInterpreter.getHumidityCategory(20);
      expect(dry.label, equals('Dry air'));

      final comfortable = WeatherInterpreter.getHumidityCategory(45);
      expect(comfortable.label, equals('Comfortable'));

      final moderate = WeatherInterpreter.getHumidityCategory(68);
      expect(moderate.label, equals('Moderate'));

      final high = WeatherInterpreter.getHumidityCategory(85);
      expect(high.label, equals('High humidity'));
    });

    test('UV Index scale matches WHO standard guidance', () {
      expect(WeatherInterpreter.getUvCategory(1.5), equals('Low'));
      expect(WeatherInterpreter.getUvCategory(4.2), equals('Moderate'));
      expect(WeatherInterpreter.getUvCategory(6.8), equals('High'));
      expect(WeatherInterpreter.getUvCategory(9.0), equals('Very High'));
      expect(WeatherInterpreter.getUvCategory(12.0), equals('Extreme'));
    });

    test('Weather code mapping resolves expected weather categories', () {
      expect(
        WeatherInterpreter.interpret(0, isDay: true).category,
        equals(WeatherCategory.clear),
      );
      expect(
        WeatherInterpreter.interpret(2, isDay: true).category,
        equals(WeatherCategory.partlyCloudy),
      );
      expect(
        WeatherInterpreter.interpret(3, isDay: true).category,
        equals(WeatherCategory.overcast),
      );
      expect(
        WeatherInterpreter.interpret(63, isDay: true).category,
        equals(WeatherCategory.rain),
      );
      expect(
        WeatherInterpreter.interpret(73, isDay: true).category,
        equals(WeatherCategory.snow),
      );
      expect(
        WeatherInterpreter.interpret(95, isDay: true).category,
        equals(WeatherCategory.thunderstorm),
      );
      expect(
        WeatherInterpreter.interpret(45, isDay: true).category,
        equals(WeatherCategory.fog),
      );
    });

    test(
      'HourlyForecastItem correctly serializes surfacePressure and precipitation',
      () {
        final item = HourlyForecastItem(
          time: '2026-10-15T12:00',
          temperature: 22.5,
          relativeHumidity: 55,
          precipitationProbability: 30,
          weatherCode: 1,
          windSpeed: 14.2,
          uvIndex: 5.0,
          surfacePressure: 1016.4,
          precipitation: 1.2,
        );

        final json = item.toJson();
        expect(json['surfacePressure'], equals(1016.4));
        expect(json['precipitation'], equals(1.2));

        final restored = HourlyForecastItem.fromJson(json);
        expect(restored.surfacePressure, equals(1016.4));
        expect(restored.precipitation, equals(1.2));
        expect(restored.temperature, equals(22.5));
      },
    );
  });
}
