/// Base exception class for the Climora application.
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException(this.message, {this.code, this.details});

  @override
  String toString() => message;
}

/// Thrown when network connection is unavailable or timeout occurs.
class NetworkException extends AppException {
  const NetworkException([
    super.message = 'Unable to reach the weather service. Please check your internet connection.',
  ]) : super(code: null);
}

/// Thrown when the Open-Meteo API returns an error response.
class ApiException extends AppException {
  final int? statusCode;

  const ApiException(
    super.message, {
    this.statusCode,
    super.code,
    super.details,
  });
}

/// Thrown when device location services or permissions fail.
class LocationException extends AppException {
  final bool isPermissionDeniedForever;
  final bool isServiceDisabled;

  const LocationException(
    super.message, {
    this.isPermissionDeniedForever = false,
    this.isServiceDisabled = false,
    super.code,
  });
}

/// Thrown when local cache reading or writing fails.
class CacheException extends AppException {
  const CacheException([
    super.message = 'Failed to load cached weather data.',
  ]) : super(code: null);
}
