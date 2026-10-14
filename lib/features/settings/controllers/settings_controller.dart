import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/user_settings.dart';
import '../../../data/services/storage_service.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('StorageService must be overridden in ProviderScope');
});

class SettingsController extends Notifier<UserSettings> {
  @override
  UserSettings build() {
    final storage = ref.watch(storageServiceProvider);
    return storage.getUserSettings();
  }

  Future<void> updateTemperatureUnit(TemperatureUnit unit) async {
    state = state.copyWith(temperatureUnit: unit);
    await ref.read(storageServiceProvider).saveUserSettings(state);
  }

  Future<void> updateWindSpeedUnit(WindSpeedUnit unit) async {
    state = state.copyWith(windSpeedUnit: unit);
    await ref.read(storageServiceProvider).saveUserSettings(state);
  }

  Future<void> updatePressureUnit(PressureUnit unit) async {
    state = state.copyWith(pressureUnit: unit);
    await ref.read(storageServiceProvider).saveUserSettings(state);
  }

  Future<void> updatePrecipitationUnit(PrecipitationUnit unit) async {
    state = state.copyWith(precipitationUnit: unit);
    await ref.read(storageServiceProvider).saveUserSettings(state);
  }

  Future<void> updateThemePreference(ThemePreference theme) async {
    state = state.copyWith(themePreference: theme);
    await ref.read(storageServiceProvider).saveUserSettings(state);
  }
}

final settingsControllerProvider =
    NotifierProvider<SettingsController, UserSettings>(SettingsController.new);
