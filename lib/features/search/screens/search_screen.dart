import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/climora_colors.dart';
import '../../../data/models/city_location.dart';
import '../../../shared/widgets/empty_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/search_controller.dart';
import '../widgets/city_search_tile.dart';

/// Full-featured city search screen with debounce, geocoding results, recents, and favorites.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onCitySelected(CityLocation city) {
    ref.read(recentSearchesProvider.notifier).addCity(city);
    ref.read(selectedCityProvider.notifier).selectCity(city);
    Navigator.of(context).pop();
  }

  Future<void> _onCurrentLocationPressed() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (_) => const Center(
              child: LoadingView(
                message: 'Locating your device...',
                isFullScreen: false,
              ),
            ),
      );

      await ref.read(weatherControllerProvider.notifier).useCurrentLocation();
      if (mounted) {
        Navigator.of(context).pop(); // dismiss dialog
        Navigator.of(context).pop(); // dismiss search screen
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // dismiss dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: ClimoraColors.accentCoral,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final searchState = ref.watch(citySearchControllerProvider);
    final favorites = ref.watch(favoriteCitiesProvider);
    final recents = ref.watch(recentSearchesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Search Locations'), centerTitle: false),
      body: SafeArea(
        child: Column(
          children: [
            // Search Input Field
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: TextField(
                controller: _textController,
                autofocus: true,
                textInputAction: TextInputAction.search,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isDark ? Colors.white : ClimoraColors.navyPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Search city or region...',
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: ClimoraColors.skyBlue,
                  ),
                  suffixIcon:
                      _textController.text.isNotEmpty
                          ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              _textController.clear();
                              ref
                                  .read(citySearchControllerProvider.notifier)
                                  .clearQuery();
                              setState(() {});
                            },
                          )
                          : null,
                ),
                onChanged: (val) {
                  setState(() {});
                  ref
                      .read(citySearchControllerProvider.notifier)
                      .onQueryChanged(val);
                },
              ),
            ),

            // Content Area
            Expanded(
              child: _buildBody(
                searchState: searchState,
                favorites: favorites,
                recents: recents,
                theme: theme,
                isDark: isDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody({
    required SearchState searchState,
    required List<CityLocation> favorites,
    required List<CityLocation> recents,
    required ThemeData theme,
    required bool isDark,
  }) {
    // If user is searching
    if (searchState.query.trim().isNotEmpty) {
      if (searchState.isLoading) {
        return const LoadingView(
          message: 'Searching locations...',
          isFullScreen: false,
        );
      }

      if (searchState.errorMessage != null) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              searchState.errorMessage!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: ClimoraColors.accentCoral,
              ),
            ),
          ),
        );
      }

      if (searchState.results.isEmpty) {
        return const EmptyView(
          title: 'No Locations Found',
          message:
              'Check your spelling or try searching for a major nearby city or country.',
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: searchState.results.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final city = searchState.results[index];
          final isFav = favorites.any(
            (f) => f.id == city.id && f.name == city.name,
          );

          return CitySearchTile(
            city: city,
            isFavorite: isFav,
            onTap: () => _onCitySelected(city),
            onToggleFavorite: () {
              ref.read(favoriteCitiesProvider.notifier).toggleFavorite(city);
            },
          );
        },
      );
    }

    // Default View: Current Location, Favorites, Recents, and Popular Cities
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        // Current Location Banner
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color:
                  isDark
                      ? Colors.white12
                      : Colors.black.withValues(alpha: 0.06),
            ),
          ),
          tileColor:
              isDark
                  ? ClimoraColors.navyCard
                  : ClimoraColors.skyBlue.withValues(alpha: 0.08),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: ClimoraColors.skyBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.my_location_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          title: Text(
            'Use Current Location',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : ClimoraColors.navyPrimary,
            ),
          ),
          subtitle: Text(
            'Get instant weather for where you are',
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark ? Colors.white60 : Colors.black54,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
          onTap: _onCurrentLocationPressed,
        ),

        const SizedBox(height: 20),

        // Favorites Section
        if (favorites.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Saved Cities',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : ClimoraColors.navyPrimary,
                ),
              ),
              Text(
                '${favorites.length} saved',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...favorites.map((city) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: CitySearchTile(
                city: city,
                isFavorite: true,
                onTap: () => _onCitySelected(city),
                onToggleFavorite: () {
                  ref
                      .read(favoriteCitiesProvider.notifier)
                      .removeFavorite(city);
                },
              ),
            );
          }),
          const SizedBox(height: 16),
        ],

        // Recent Searches Section
        if (recents.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Searches',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : ClimoraColors.navyPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  ref.read(recentSearchesProvider.notifier).clearAll();
                },
                child: const Text('Clear All', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                recents.map((city) {
                  return ActionChip(
                    avatar: const Icon(Icons.history_rounded, size: 16),
                    label: Text(city.name),
                    onPressed: () => _onCitySelected(city),
                    backgroundColor:
                        isDark
                            ? ClimoraColors.navySurface
                            : ClimoraColors.skyBlue.withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                }).toList(),
          ),
          const SizedBox(height: 20),
        ],

        // Popular Global Cities Section
        Text(
          'Popular Destinations',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : ClimoraColors.navyPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              AppConstants.popularCities.map((city) {
                return ActionChip(
                  avatar: const Icon(Icons.location_city_rounded, size: 16),
                  label: Text('${city.name}, ${city.country}'),
                  onPressed: () => _onCitySelected(city),
                  backgroundColor:
                      isDark ? ClimoraColors.navyCard : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color:
                          isDark
                              ? Colors.white12
                              : Colors.black.withValues(alpha: 0.06),
                    ),
                  ),
                );
              }).toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
