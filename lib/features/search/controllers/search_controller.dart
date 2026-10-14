import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/app_config.dart';
import '../../../data/models/city_location.dart';
import '../../home/controllers/home_controller.dart';

class RecentSearchesNotifier extends Notifier<List<CityLocation>> {
  @override
  List<CityLocation> build() {
    final repository = ref.watch(weatherRepositoryProvider);
    return repository.getRecentCities();
  }

  Future<void> addCity(CityLocation city) async {
    final repository = ref.read(weatherRepositoryProvider);
    await repository.addRecentCity(city);
    state = repository.getRecentCities();
  }

  Future<void> clearAll() async {
    final repository = ref.read(weatherRepositoryProvider);
    await repository.clearRecentCities();
    state = [];
  }
}

final recentSearchesProvider =
    NotifierProvider<RecentSearchesNotifier, List<CityLocation>>(
      RecentSearchesNotifier.new,
    );

class SearchState {
  final String query;
  final List<CityLocation> results;
  final bool isLoading;
  final String? errorMessage;

  const SearchState({
    this.query = '',
    this.results = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  SearchState copyWith({
    String? query,
    List<CityLocation>? results,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class CitySearchController extends Notifier<SearchState> {
  Timer? _debounceTimer;

  @override
  SearchState build() {
    ref.onDispose(() {
      _debounceTimer?.cancel();
    });
    return const SearchState();
  }

  void onQueryChanged(String query) {
    _debounceTimer?.cancel();

    if (query.trim().isEmpty) {
      state = const SearchState();
      return;
    }

    state = state.copyWith(query: query, isLoading: true, errorMessage: null);

    _debounceTimer = Timer(AppConfig.searchDebounceDuration, () async {
      await _executeSearch(query);
    });
  }

  Future<void> _executeSearch(String query) async {
    try {
      final repository = ref.read(weatherRepositoryProvider);
      final results = await repository.searchCities(query);
      state = state.copyWith(
        results: results,
        isLoading: false,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        results: [],
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void clearQuery() {
    _debounceTimer?.cancel();
    state = const SearchState();
  }
}

final citySearchControllerProvider =
    NotifierProvider<CitySearchController, SearchState>(
      CitySearchController.new,
    );
