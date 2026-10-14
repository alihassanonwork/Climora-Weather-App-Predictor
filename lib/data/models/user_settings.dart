enum TemperatureUnit {
  celsius('?C', 'Celsius'),
  fahrenheit('?F', 'Fahrenheit');

  final String symbol;
  final String label;
  const TemperatureUnit(this.symbol, this.label);
}

enum WindSpeedUnit {
  kmh('km/h', 'Kilometers per hour'),
  ms('m/s', 'Meters per second'),
  mph('mph', 'Miles per hour');

  final String symbol;
  final String label;
  const WindSpeedUnit(this.symbol, this.label);
}

enum PressureUnit {
  hPa('hPa', 'Hectopascals'),
  mmHg('mmHg', 'Millimeters of mercury'),
  inHg('inHg', 'Inches of mercury');

  final String symbol;
  final String label;
  const PressureUnit(this.symbol, this.label);
}

enum PrecipitationUnit {
  mm('mm', 'Millimeters'),
  inch('in', 'Inches');

  final String symbol;
  final String label;
  const PrecipitationUnit(this.symbol, this.label);
}

enum ThemePreference {
  system('System Default'),
  light('Light Theme'),
  dark('Dark Theme');

  final String label;
  const ThemePreference(this.label);
}

/// Immutable model storing all user preferences and measurement unit settings.
class UserSettings {
  final TemperatureUnit temperatureUnit;
  final WindSpeedUnit windSpeedUnit;
  final PressureUnit pressureUnit;
  final PrecipitationUnit precipitationUnit;
  final ThemePreference themePreference;

  const UserSettings({
    this.temperatureUnit = TemperatureUnit.celsius,
    this.windSpeedUnit = WindSpeedUnit.kmh,
    this.pressureUnit = PressureUnit.hPa,
    this.precipitationUnit = PrecipitationUnit.mm,
    this.themePreference = ThemePreference.system,
  });

  UserSettings copyWith({
    TemperatureUnit? temperatureUnit,
    WindSpeedUnit? windSpeedUnit,
    PressureUnit? pressureUnit,
    PrecipitationUnit? precipitationUnit,
    ThemePreference? themePreference,
  }) {
    return UserSettings(
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      windSpeedUnit: windSpeedUnit ?? this.windSpeedUnit,
      pressureUnit: pressureUnit ?? this.pressureUnit,
      precipitationUnit: precipitationUnit ?? this.precipitationUnit,
      themePreference: themePreference ?? this.themePreference,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperatureUnit': temperatureUnit.name,
      'windSpeedUnit': windSpeedUnit.name,
      'pressureUnit': pressureUnit.name,
      'precipitationUnit': precipitationUnit.name,
      'themePreference': themePreference.name,
    };
  }

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      temperatureUnit: TemperatureUnit.values.firstWhere(
        (e) => e.name == json['temperatureUnit'],
        orElse: () => TemperatureUnit.celsius,
      ),
      windSpeedUnit: WindSpeedUnit.values.firstWhere(
        (e) => e.name == json['windSpeedUnit'],
        orElse: () => WindSpeedUnit.kmh,
      ),
      pressureUnit: PressureUnit.values.firstWhere(
        (e) => e.name == json['pressureUnit'],
        orElse: () => PressureUnit.hPa,
      ),
      precipitationUnit: PrecipitationUnit.values.firstWhere(
        (e) => e.name == json['precipitationUnit'],
        orElse: () => PrecipitationUnit.mm,
      ),
      themePreference: ThemePreference.values.firstWhere(
        (e) => e.name == json['themePreference'],
        orElse: () => ThemePreference.system,
      ),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSettings &&
          runtimeType == other.runtimeType &&
          temperatureUnit == other.temperatureUnit &&
          windSpeedUnit == other.windSpeedUnit &&
          pressureUnit == other.pressureUnit &&
          precipitationUnit == other.precipitationUnit &&
          themePreference == other.themePreference;

  @override
  int get hashCode =>
      temperatureUnit.hashCode ^
      windSpeedUnit.hashCode ^
      pressureUnit.hashCode ^
      precipitationUnit.hashCode ^
      themePreference.hashCode;
}
