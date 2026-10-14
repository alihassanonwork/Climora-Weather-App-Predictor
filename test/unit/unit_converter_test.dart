import 'package:climora/core/utils/unit_converter.dart';
import 'package:climora/data/models/user_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UnitConverter', () {
    test('converts and formats temperature correctly', () {
      expect(
        UnitConverter.convertTemperature(0.0, TemperatureUnit.fahrenheit),
        32.0,
      );
      expect(
        UnitConverter.convertTemperature(100.0, TemperatureUnit.fahrenheit),
        212.0,
      );
      expect(
        UnitConverter.convertTemperature(25.0, TemperatureUnit.celsius),
        25.0,
      );

      expect(
        UnitConverter.formatTemperature(22.4, TemperatureUnit.celsius),
        '22°C',
      );
      expect(
        UnitConverter.formatTemperature(22.4, TemperatureUnit.fahrenheit),
        '72°F',
      );
      expect(
        UnitConverter.formatTemperature(null, TemperatureUnit.celsius),
        '--',
      );
    });

    test('converts and formats wind speed correctly', () {
      // 36 km/h = 10 m/s
      expect(
        UnitConverter.convertWindSpeed(36.0, WindSpeedUnit.ms),
        10.0,
      );
      // 100 km/h = ~62.14 mph
      expect(
        UnitConverter.convertWindSpeed(100.0, WindSpeedUnit.mph),
        closeTo(62.137, 0.01),
      );

      expect(
        UnitConverter.formatWindSpeed(15.5, WindSpeedUnit.kmh),
        '15.5 km/h',
      );
      expect(
        UnitConverter.formatWindSpeed(null, WindSpeedUnit.kmh),
        '--',
      );
    });

    test('converts and formats pressure correctly', () {
      expect(
        UnitConverter.convertPressure(1013.25, PressureUnit.hPa),
        1013.25,
      );
      expect(
        UnitConverter.convertPressure(1000.0, PressureUnit.mmHg),
        closeTo(750.06, 0.1),
      );
      expect(
        UnitConverter.formatPressure(1015.0, PressureUnit.hPa),
        '1015 hPa',
      );
      expect(
        UnitConverter.formatPressure(null, PressureUnit.hPa),
        '--',
      );
    });

    test('converts and formats precipitation correctly', () {
      expect(
        UnitConverter.convertPrecipitation(25.4, PrecipitationUnit.inch),
        closeTo(1.0, 0.01),
      );
      expect(
        UnitConverter.formatPrecipitation(5.2, PrecipitationUnit.mm),
        '5.2 mm',
      );
      expect(
        UnitConverter.formatPrecipitation(null, PrecipitationUnit.mm),
        '--',
      );
    });

    test('formats wind direction degrees to compass points', () {
      expect(UnitConverter.formatWindDirection(0), 'N');
      expect(UnitConverter.formatWindDirection(90), 'E');
      expect(UnitConverter.formatWindDirection(180), 'S');
      expect(UnitConverter.formatWindDirection(270), 'W');
      expect(UnitConverter.formatWindDirection(206), 'SSW');
      expect(UnitConverter.formatWindDirection(null), '--');
    });
  });
}
