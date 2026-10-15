import '../../data/models/user_settings.dart';

/// Accurate mathematical conversion utilities for weather units across Climora.
class UnitConverter {
  UnitConverter._();

  // --- Temperature Conversion (Base: Celsius) ---
  static double convertTemperature(double celsius, TemperatureUnit targetUnit) {
    switch (targetUnit) {
      case TemperatureUnit.celsius:
        return celsius;
      case TemperatureUnit.fahrenheit:
        return (celsius * 9 / 5) + 32;
    }
  }

  static String formatTemperature(
    double? celsius,
    TemperatureUnit targetUnit, {
    bool includeUnit = true,
    int fractionDigits = 0,
  }) {
    if (celsius == null) return '--';
    final converted = convertTemperature(celsius, targetUnit);
    final formatted = converted.toStringAsFixed(fractionDigits);
    return includeUnit ? '$formatted${targetUnit.symbol}' : formatted;
  }

  // --- Wind Speed Conversion (Base: km/h) ---
  static double convertWindSpeed(double kmh, WindSpeedUnit targetUnit) {
    switch (targetUnit) {
      case WindSpeedUnit.kmh:
        return kmh;
      case WindSpeedUnit.ms:
        return kmh / 3.6;
      case WindSpeedUnit.mph:
        return kmh * 0.621371;
    }
  }

  static String formatWindSpeed(
    double? kmh,
    WindSpeedUnit targetUnit, {
    bool includeUnit = true,
  }) {
    if (kmh == null) return '--';
    final converted = convertWindSpeed(kmh, targetUnit);
    final formatted = converted.toStringAsFixed(1);
    return includeUnit ? '$formatted ${targetUnit.symbol}' : formatted;
  }

  static String formatWind(
    double? kmh,
    WindSpeedUnit targetUnit, {
    bool includeUnit = true,
  }) => formatWindSpeed(kmh, targetUnit, includeUnit: includeUnit);

  // --- Pressure Conversion (Base: hPa) ---
  static double convertPressure(double hPa, PressureUnit targetUnit) {
    switch (targetUnit) {
      case PressureUnit.hPa:
        return hPa;
      case PressureUnit.mmHg:
        return hPa * 0.750062;
      case PressureUnit.inHg:
        return hPa * 0.02953;
    }
  }

  static String formatPressure(
    double? hPa,
    PressureUnit targetUnit, {
    bool includeUnit = true,
  }) {
    if (hPa == null) return '--';
    final converted = convertPressure(hPa, targetUnit);
    final fractionDigits = targetUnit == PressureUnit.inHg ? 2 : 0;
    final formatted = converted.toStringAsFixed(fractionDigits);
    return includeUnit ? '$formatted ${targetUnit.symbol}' : formatted;
  }

  // --- Precipitation Conversion (Base: mm) ---
  static double convertPrecipitation(double mm, PrecipitationUnit targetUnit) {
    switch (targetUnit) {
      case PrecipitationUnit.mm:
        return mm;
      case PrecipitationUnit.inch:
        return mm * 0.0393701;
    }
  }

  static String formatPrecipitation(
    double? mm,
    PrecipitationUnit targetUnit, {
    bool includeUnit = true,
  }) {
    if (mm == null) return '--';
    final converted = convertPrecipitation(mm, targetUnit);
    final fractionDigits = targetUnit == PrecipitationUnit.inch ? 2 : 1;
    final formatted = converted.toStringAsFixed(fractionDigits);
    return includeUnit ? '$formatted ${targetUnit.symbol}' : formatted;
  }

  static String formatRain(
    double? mm,
    PrecipitationUnit targetUnit, {
    bool includeUnit = true,
  }) => formatPrecipitation(mm, targetUnit, includeUnit: includeUnit);

  // --- Wind Direction to Compass Rose (0-360) ---
  static String formatWindDirection(double? degrees) {
    if (degrees == null) return '--';
    const directions = [
      'N',
      'NNE',
      'NE',
      'ENE',
      'E',
      'ESE',
      'SE',
      'SSE',
      'S',
      'SSW',
      'SW',
      'WSW',
      'W',
      'WNW',
      'NW',
      'NNW',
    ];
    final index = ((degrees + 11.25) % 360 / 22.5).floor();
    return directions[index % 16];
  }
}
