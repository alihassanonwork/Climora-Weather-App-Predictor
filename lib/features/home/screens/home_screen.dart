import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/climora_colors.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../search/screens/search_screen.dart';
import '../../settings/controllers/settings_controller.dart';
import '../../settings/screens/settings_screen.dart';
import '../controllers/home_controller.dart';
import '../widgets/daily_forecast_card.dart';
import '../widgets/home_header.dart';
import '../widgets/hourly_forecast_strip.dart';
import '../widgets/metrics_grid.dart';
import '../widgets/weather_hero.dart';
import '../widgets/weather_insights_card.dart';

/// Main weather dashboard assembling real-time measurements, forecasts, and interactive controls.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherControllerProvider);
    final settings = ref.watch(settingsControllerProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: weatherAsync.when(
          loading: () => const LoadingView(
            message: 'Gathering local forecast...',
          ),
          error: (err, stack) => ErrorView(
            error: err,
            onRetry: () {
              ref.read(weatherControllerProvider.notifier).refresh();
            },
          ),
          data: (weather) {
            final todayForecast = weather.todayForecast;

            return RefreshIndicator(
              color: ClimoraColors.skyBlue,
              onRefresh: () async {
                await ref.read(weatherControllerProvider.notifier).refresh();
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.only(bottom: 40),
                children: [
                  // 1. Header with city name, GPS button, search, refresh, and settings
                  HomeHeader(
                    city: weather.city,
                    isRefreshing: weatherAsync.isRefreshing,
                    onSearchPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SearchScreen()),
                      );
                    },
                    onLocationPressed: () async {
                      try {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Detecting your location...'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                        await ref
                            .read(weatherControllerProvider.notifier)
                            .useCurrentLocation();
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                              backgroundColor: ClimoraColors.accentCoral,
                            ),
                          );
                        }
                      }
                    },
                    onRefreshPressed: () {
                      ref.read(weatherControllerProvider.notifier).refresh();
                    },
                    onSettingsPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SettingsScreen()),
                      );
                    },
                  ),

                  // 2. Weather Hero Banner
                  WeatherHero(
                    current: weather.current,
                    todayForecast: todayForecast,
                    settings: settings,
                    lastUpdated: weather.lastUpdated,
                  ),

                  // 3. Hourly Forecast Horizontal Strip
                  HourlyForecastStrip(
                    hourlyList: weather.hourly.items,
                    settings: settings,
                  ),

                  // 4. Detailed Meteorological Metrics Grid
                  MetricsGrid(
                    current: weather.current,
                    today: todayForecast,
                    settings: settings,
                  ),

                  // 5. 5-Day Forecast Card with Visual Temperature Bars
                  DailyForecastCard(
                    dailyList: weather.daily.days,
                    allHourly: weather.hourly.items,
                    settings: settings,
                  ),

                  // 6. Insights, Rule-Based Outlook & UV Guidance
                  WeatherInsightsCard(
                    current: weather.current,
                    today: todayForecast,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

