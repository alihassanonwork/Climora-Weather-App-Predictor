import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/theme/climora_colors.dart';
import '../../../data/models/user_settings.dart';
import '../../../shared/widgets/climora_card.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/settings_controller.dart';

/// Comprehensive settings screen allowing customization of units, themes, favorites, and attributions.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final settings = ref.watch(settingsControllerProvider);
    final favorites = ref.watch(favoriteCitiesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: false),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          children: [
            // Section 1: Appearance & Theme
            _buildSectionHeader(context, 'Appearance', Icons.palette_outlined),
            ClimoraCard(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  RadioListTile<ThemePreference>(
                    title: const Text('System Default'),
                    subtitle: const Text('Matches device light or dark mode'),
                    value: ThemePreference.system,
                    groupValue: settings.themePreference,
                    activeColor: ClimoraColors.skyBlue,
                    onChanged: (val) {
                      if (val != null) {
                        ref
                            .read(settingsControllerProvider.notifier)
                            .updateThemePreference(val);
                      }
                    },
                  ),
                  const Divider(height: 1),
                  RadioListTile<ThemePreference>(
                    title: const Text('Light Theme'),
                    subtitle: const Text(
                      'Crisp sky-blue and soft cloud backgrounds',
                    ),
                    value: ThemePreference.light,
                    groupValue: settings.themePreference,
                    activeColor: ClimoraColors.skyBlue,
                    onChanged: (val) {
                      if (val != null) {
                        ref
                            .read(settingsControllerProvider.notifier)
                            .updateThemePreference(val);
                      }
                    },
                  ),
                  const Divider(height: 1),
                  RadioListTile<ThemePreference>(
                    title: const Text('Dark Theme'),
                    subtitle: const Text('Deep navy-blue nocturnal aesthetic'),
                    value: ThemePreference.dark,
                    groupValue: settings.themePreference,
                    activeColor: ClimoraColors.skyBlue,
                    onChanged: (val) {
                      if (val != null) {
                        ref
                            .read(settingsControllerProvider.notifier)
                            .updateThemePreference(val);
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section 2: Units of Measurement
            _buildSectionHeader(
              context,
              'Measurement Units',
              Icons.straighten_rounded,
            ),
            ClimoraCard(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  // Temperature Unit
                  ListTile(
                    title: const Text('Temperature'),
                    trailing: SegmentedButton<TemperatureUnit>(
                      segments: const [
                        ButtonSegment(
                          value: TemperatureUnit.celsius,
                          label: Text('°C'),
                        ),
                        ButtonSegment(
                          value: TemperatureUnit.fahrenheit,
                          label: Text('°F'),
                        ),
                      ],
                      selected: {settings.temperatureUnit},
                      onSelectionChanged: (selected) {
                        ref
                            .read(settingsControllerProvider.notifier)
                            .updateTemperatureUnit(selected.first);
                      },
                    ),
                  ),
                  const Divider(height: 1),

                  // Wind Speed Unit
                  ListTile(
                    title: const Text('Wind Speed'),
                    trailing: DropdownButton<WindSpeedUnit>(
                      value: settings.windSpeedUnit,
                      underline: const SizedBox.shrink(),
                      borderRadius: BorderRadius.circular(12),
                      items: const [
                        DropdownMenuItem(
                          value: WindSpeedUnit.kmh,
                          child: Text('km/h'),
                        ),
                        DropdownMenuItem(
                          value: WindSpeedUnit.ms,
                          child: Text('m/s'),
                        ),
                        DropdownMenuItem(
                          value: WindSpeedUnit.mph,
                          child: Text('mph'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          ref
                              .read(settingsControllerProvider.notifier)
                              .updateWindSpeedUnit(val);
                        }
                      },
                    ),
                  ),
                  const Divider(height: 1),

                  // Pressure Unit
                  ListTile(
                    title: const Text('Atmospheric Pressure'),
                    trailing: DropdownButton<PressureUnit>(
                      value: settings.pressureUnit,
                      underline: const SizedBox.shrink(),
                      borderRadius: BorderRadius.circular(12),
                      items: const [
                        DropdownMenuItem(
                          value: PressureUnit.hPa,
                          child: Text('hPa'),
                        ),
                        DropdownMenuItem(
                          value: PressureUnit.mmHg,
                          child: Text('mmHg'),
                        ),
                        DropdownMenuItem(
                          value: PressureUnit.inHg,
                          child: Text('inHg'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          ref
                              .read(settingsControllerProvider.notifier)
                              .updatePressureUnit(val);
                        }
                      },
                    ),
                  ),
                  const Divider(height: 1),

                  // Rain / Precipitation Unit
                  ListTile(
                    title: const Text('Rainfall / Precipitation'),
                    trailing: SegmentedButton<PrecipitationUnit>(
                      segments: const [
                        ButtonSegment(
                          value: PrecipitationUnit.mm,
                          label: Text('mm'),
                        ),
                        ButtonSegment(
                          value: PrecipitationUnit.inch,
                          label: Text('inch'),
                        ),
                      ],
                      selected: {settings.precipitationUnit},
                      onSelectionChanged: (selected) {
                        ref
                            .read(settingsControllerProvider.notifier)
                            .updatePrecipitationUnit(selected.first);
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section 3: Manage Saved Locations
            _buildSectionHeader(
              context,
              'Saved Cities (${favorites.length})',
              Icons.bookmark_border_rounded,
            ),
            if (favorites.isEmpty)
              ClimoraCard(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    'No saved cities yet. Tap the star icon when searching to bookmark locations here.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ),
              )
            else
              ClimoraCard(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children:
                      favorites.map((city) {
                        return ListTile(
                          title: Text(city.name),
                          subtitle: Text(city.subTitle),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: ClimoraColors.accentCoral,
                            ),
                            tooltip: 'Remove',
                            onPressed: () {
                              ref
                                  .read(favoriteCitiesProvider.notifier)
                                  .removeFavorite(city);
                            },
                          ),
                          onTap: () {
                            ref
                                .read(selectedCityProvider.notifier)
                                .selectCity(city);
                            Navigator.of(context).pop();
                          },
                        );
                      }).toList(),
                ),
              ),

            const SizedBox(height: 24),

            // Section 4: About & Attribution
            _buildSectionHeader(
              context,
              'About Climora',
              Icons.info_outline_rounded,
            ),
            ClimoraCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: ClimoraColors.skyBlue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.cloud_queue_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppConfig.appName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color:
                                  isDark
                                      ? Colors.white
                                      : ClimoraColors.navyPrimary,
                            ),
                          ),
                          Text(
                            AppConfig.appTagline,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: ClimoraColors.skyBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Version ${AppConfig.appVersion}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Text(
                    'Weather Data Attribution:',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : ClimoraColors.navyPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppConfig.openMeteoAttribution,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? Colors.white70 : Colors.black87,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Geocoding and meteorological data provided under the Creative Commons Attribution 4.0 International (CC BY 4.0) license by Open-Meteo.com.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? Colors.white54 : Colors.black54,
                      fontSize: 11,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: ClimoraColors.skyBlue),
          const SizedBox(width: 6),
          Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : ClimoraColors.navyPrimary,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
