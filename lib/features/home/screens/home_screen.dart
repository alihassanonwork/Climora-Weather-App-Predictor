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
import '../widgets/hourly_interactive_chart.dart';
import '../widgets/metrics_grid.dart';
import '../widgets/weather_hero.dart';
import '../widgets/weather_insights_card.dart';

/// Main weather dashboard assembling living atmospheric visuals, real-time measurements,
/// interactive charts, 5-day forecasts, and responsive controls with Apple-like fluidity.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (mounted) {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weatherAsync = ref.watch(weatherControllerProvider);
    final settings = ref.watch(settingsControllerProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: weatherAsync.when(
            loading:
                () => const LoadingView(message: 'Gathering local forecast...'),
            error:
                (err, stack) => ErrorView(
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
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: const EdgeInsets.only(bottom: 40),
                  children: [
                    // 1. Header with city name, GPS button, search, refresh, and settings
                    _StaggeredEntrance(
                      delayMs: 0,
                      child: HomeHeader(
                        city: weather.city,
                        isRefreshing: weatherAsync.isRefreshing,
                        onSearchPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const SearchScreen(),
                            ),
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
                          ref
                              .read(weatherControllerProvider.notifier)
                              .refresh();
                        },
                        onSettingsPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const SettingsScreen(),
                            ),
                          );
                        },
                      ),
                    ),

                    // 2. Living Weather Hero Banner with Atmospheric Parallax
                    _StaggeredEntrance(
                      delayMs: 60,
                      child: WeatherHero(
                        current: weather.current,
                        todayForecast: todayForecast,
                        settings: settings,
                        lastUpdated: weather.lastUpdated,
                        scrollOffset: _scrollOffset,
                      ),
                    ),

                    // 3. Hourly Forecast Horizontal Strip
                    _StaggeredEntrance(
                      delayMs: 120,
                      child: HourlyForecastStrip(
                        hourlyList: weather.hourly.items,
                        settings: settings,
                      ),
                    ),

                    // 4. Interactive 24-Hour Trend Chart (Temp, Rain, Wind)
                    _StaggeredEntrance(
                      delayMs: 180,
                      child: HourlyInteractiveChart(
                        hourlyList: weather.hourly.items,
                        settings: settings,
                      ),
                    ),

                    // 5. Visual Meteorological Grid (Compass, Humidity, Barometer, UV, Precipitation, Sun Cycle)
                    _StaggeredEntrance(
                      delayMs: 240,
                      child: MetricsGrid(
                        current: weather.current,
                        today: todayForecast,
                        settings: settings,
                        hourly: weather.hourly.items,
                      ),
                    ),

                    // 6. 5-Day Forecast Card with Temperature Range Bars & Current Temp Dot
                    _StaggeredEntrance(
                      delayMs: 300,
                      child: DailyForecastCard(
                        dailyList: weather.daily.days,
                        allHourly: weather.hourly.items,
                        settings: settings,
                        currentTemperature: weather.current.temperature,
                      ),
                    ),

                    // 7. Rule-Based Insights & Weather Guidance
                    _StaggeredEntrance(
                      delayMs: 360,
                      child: WeatherInsightsCard(
                        current: weather.current,
                        today: todayForecast,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Staggered animated entrance wrapper offering subtle fade and slide-up transition.
class _StaggeredEntrance extends StatelessWidget {
  final int delayMs;
  final Widget child;

  const _StaggeredEntrance({required this.delayMs, required this.child});

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    if (reduceMotion) return child;

    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: delayMs)),
      builder: (context, snapshot) {
        final hasStarted = snapshot.connectionState == ConnectionState.done;

        return AnimatedOpacity(
          opacity: hasStarted ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
          child: AnimatedSlide(
            offset: hasStarted ? Offset.zero : const Offset(0.0, 0.08),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            child: child,
          ),
        );
      },
    );
  }
}
