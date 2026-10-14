import 'package:climora/core/utils/weather_interpreter.dart';
import 'package:climora/data/models/weather_condition.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WeatherInterpreter', () {
    test('maps WMO codes accurately', () {
      final clear = WeatherInterpreter.interpret(0);
      expect(clear.code, 0);
      expect(clear.description, 'Clear sky');
      expect(clear.category, WeatherCategory.clear);

      final partlyCloudy = WeatherInterpreter.interpret(2);
      expect(partlyCloudy.description, 'Partly cloudy');
      expect(partlyCloudy.category, WeatherCategory.partlyCloudy);

      final rain = WeatherInterpreter.interpret(63);
      expect(rain.description, 'Moderate rain');
      expect(rain.category, WeatherCategory.rain);

      final storm = WeatherInterpreter.interpret(95);
      expect(storm.description, 'Thunderstorm');
      expect(storm.category, WeatherCategory.thunderstorm);

      final nullCondition = WeatherInterpreter.interpret(null);
      expect(nullCondition.description, 'Unknown');

      final unknownCode = WeatherInterpreter.interpret(999);
      expect(unknownCode.description, 'Code 999');
    });

    test('interprets UV index categories and health guidance', () {
      final low = WeatherInterpreter.interpretUvIndex(1.5);
      expect(low.label, 'Low');

      final moderate = WeatherInterpreter.interpretUvIndex(4.2);
      expect(moderate.label, 'Moderate');

      final high = WeatherInterpreter.interpretUvIndex(6.8);
      expect(high.label, 'High');

      final veryHigh = WeatherInterpreter.interpretUvIndex(9.5);
      expect(veryHigh.label, 'Very High');

      final extreme = WeatherInterpreter.interpretUvIndex(12.0);
      expect(extreme.label, 'Extreme');

      final nullUv = WeatherInterpreter.interpretUvIndex(null);
      expect(nullUv.label, 'Unknown');
    });
  });
}
