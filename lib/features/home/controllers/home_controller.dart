import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/city_location.dart';
import '../../../data/models/weather_data.dart';
import '../../../data/repositories/weather_repository.dart';
import '../../../data/services/geocoding_api_service.dart';
import '../../../data/services/location_service.dart';
import '../../../data/services/weather_api_service.dart';
import '../../settings/controllers/settings_controller.dart';

final weatherApiServiceProvider = Provider<WeatherApiService>((ref) {
  final service = WeatherApiService();
  ref.onDispose(service.dispose);
  return service;
});

final geocodingApiServiceProvider = Provider<GeocodingApiService>((ref) {
  final service = GeocodingApiService();
  ref.onDispose(service.dispose);
  return service;
});

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepository(
    weatherApiService: ref.watch(weatherApiServiceProvider),
    geocodingApiService: ref.watch(geocodingApiServiceProvider),
    locationService: ref.watch(locationServiceProvider),
    storageService: ref.watch(storageServiceProvider),
  );
});

class FavoriteCitiesNotifier extends Notifier<List<CityLocation>> {
  @override
  List<CityLocation> build() {
    final repository = ref.watch(weatherRepositoryProvider);
    return repository.getFavoriteCities();
  }

  Future<void> toggleFavorite(CityLocation city) async {
    final repository = ref.read(weatherRepositoryProvider);
    final exists = state.any((c) => c.id == city.id && c.name == city.name);
    if (exists) {
      await repository.removeFavoriteCity(city);
    } else {
      await repository.addFavoriteCity(city);
    }
    state = repository.getFavoriteCities();
  }

  Future<void> removeFavorite(CityLocation city) async {
    final repository = ref.read(weatherRepositoryProvider);
    await repository.removeFavoriteCity(city);
    state = repository.getFavoriteCities();
  }
}

final favoriteCitiesProvider =
    NotifierProvider<FavoriteCitiesNotifier, List<CityLocation>>(
  FavoriteCitiesNotifier.new,
);

class SelectedCityNotifier extends Notifier<CityLocation> {
  @override
  CityLocation build() {
    final repository = ref.watch(weatherRepositoryProvider);
    return repository.getLastSelectedCity();
  }

  void selectCity(CityLocation city) {
    state = city;
    ref.read(weatherRepositoryProvider).saveLastSelectedCity(city);
  }
}

final selectedCityProvider =
    NotifierProvider<SelectedCityNotifier, CityLocation>(
  SelectedCityNotifier.new,
);

class WeatherController extends AsyncNotifier<WeatherData> {
  @override
  Future<WeatherData> build() async {
    final city = ref.watch(selectedCityProvider);
    final repository = ref.watch(weatherRepositoryProvider);
    return repository.getWeather(city, forceRefresh: false);
  }

  Future<void> refresh() async {
    final city = ref.read(selectedCityProvider);
    final repository = ref.read(weatherRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return repository.getWeather(city, forceRefresh: true);
    });
  }

  Future<void> useCurrentLocation() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(weatherRepositoryProvider);
      final locationCity = await repository.getCurrentLocation();
      ref.read(selectedCityProvider.notifier).selectCity(locationCity);
      return repository.getWeather(locationCity, forceRefresh: true);
    });
  }
}

final weatherControllerProvider =
    AsyncNotifierProvider<WeatherController, WeatherData>(
  WeatherController.new,
);
