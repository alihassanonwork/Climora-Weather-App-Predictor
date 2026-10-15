import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/app_config.dart';
import 'core/theme/climora_theme.dart';
import 'data/models/user_settings.dart';
import 'features/home/screens/home_screen.dart';
import 'features/settings/controllers/settings_controller.dart';

/// Root Application Widget configuring theme modes and top-level navigation.
class ClimoraApp extends ConsumerWidget {
  const ClimoraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);

    final themeMode = switch (settings.themePreference) {
      ThemePreference.system => ThemeMode.system,
      ThemePreference.light => ThemeMode.light,
      ThemePreference.dark => ThemeMode.dark,
    };

    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: ClimoraTheme.lightTheme,
      darkTheme: ClimoraTheme.darkTheme,
      themeMode: themeMode,
      home: const HomeScreen(),
    );
  }
}
