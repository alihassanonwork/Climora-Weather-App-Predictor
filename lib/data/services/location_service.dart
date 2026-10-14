import 'package:geolocator/geolocator.dart';
import '../../core/errors/app_exceptions.dart';
import '../models/city_location.dart';

/// Service responsible for device geolocation permissions and position retrieval.
class LocationService {
  /// Checks permissions, requests them if required, and retrieves the device coordinates.
  Future<CityLocation> getCurrentLocationCity() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationException(
        'Location services are turned off on your device. Please enable GPS in device settings.',
        isServiceDisabled: true,
      );
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const LocationException(
          'Location permission was denied. You can still search for any city manually.',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationException(
        'Location permission is permanently denied. You can enable it in device app settings or search for any city manually.',
        isPermissionDeniedForever: true,
      );
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );

      return CityLocation(
        id: -1,
        name: 'Current Location',
        latitude: double.parse(position.latitude.toStringAsFixed(4)),
        longitude: double.parse(position.longitude.toStringAsFixed(4)),
        country: 'GPS Detected',
        admin1: null,
      );
    } catch (e) {
      final lastPosition = await Geolocator.getLastKnownPosition();
      if (lastPosition != null) {
        return CityLocation(
          id: -1,
          name: 'Current Location',
          latitude: double.parse(lastPosition.latitude.toStringAsFixed(4)),
          longitude: double.parse(lastPosition.longitude.toStringAsFixed(4)),
          country: 'GPS Detected (Cached)',
          admin1: null,
        );
      }
      throw LocationException('Failed to determine location: ');
    }
  }

  Future<bool> hasPermission() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }
}
