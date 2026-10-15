/// Represents a geographical city location parsed from Open-Meteo Geocoding.
class CityLocation {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String? country;
  final String? admin1;
  final String? countryCode;
  final String? timezone;
  final bool isFavorite;
  final bool isCurrentLocation;

  const CityLocation({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.country,
    this.admin1,
    this.countryCode,
    this.timezone,
    this.isFavorite = false,
    this.isCurrentLocation = false,
  });

  /// Readable display label e.g. "Tokyo, Japan" or "Springfield, Illinois, United States"
  String get displaySubtitle {
    final parts = <String>[];
    if (admin1 != null && admin1!.isNotEmpty && admin1 != name) {
      parts.add(admin1!);
    }
    if (country != null && country!.isNotEmpty) {
      parts.add(country!);
    }
    return parts.join(', ');
  }

  String get subTitle => displaySubtitle;

  CityLocation copyWith({
    int? id,
    String? name,
    double? latitude,
    double? longitude,
    String? country,
    String? admin1,
    String? countryCode,
    String? timezone,
    bool? isFavorite,
    bool? isCurrentLocation,
  }) {
    return CityLocation(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      country: country ?? this.country,
      admin1: admin1 ?? this.admin1,
      countryCode: countryCode ?? this.countryCode,
      timezone: timezone ?? this.timezone,
      isFavorite: isFavorite ?? this.isFavorite,
      isCurrentLocation: isCurrentLocation ?? this.isCurrentLocation,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
      'admin1': admin1,
      'country_code': countryCode,
      'timezone': timezone,
      'isFavorite': isFavorite,
      'isCurrentLocation': isCurrentLocation,
    };
  }

  factory CityLocation.fromJson(Map<String, dynamic> json) {
    return CityLocation(
      id:
          json['id'] is int
              ? json['id'] as int
              : (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? 'Unknown Location',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      country: json['country'] as String?,
      admin1: json['admin1'] as String?,
      countryCode: (json['country_code'] ?? json['countryCode']) as String?,
      timezone: json['timezone'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
      isCurrentLocation: json['isCurrentLocation'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CityLocation &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => id.hashCode ^ latitude.hashCode ^ longitude.hashCode;
}
