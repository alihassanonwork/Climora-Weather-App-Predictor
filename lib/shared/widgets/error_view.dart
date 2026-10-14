import 'package:flutter/material.dart';

import '../../core/errors/app_exceptions.dart';
import '../../core/theme/climora_colors.dart';

/// A friendly, user-focused error screen with a clear retry action.
class ErrorView extends StatelessWidget {
  final Object? error;
  final VoidCallback onRetry;
  final String? customTitle;
  final String? customMessage;

  const ErrorView({
    super.key,
    required this.error,
    required this.onRetry,
    this.customTitle,
    this.customMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final String title;
    final String message;
    final IconData icon;

    if (error is NetworkException) {
      title = 'No Internet Connection';
      message =
          'Please check your network and try again. Cached weather may be available.';
      icon = Icons.wifi_off_rounded;
    } else if (error is LocationException) {
      title = 'Location Access Needed';
      message = (error as LocationException).message;
      icon = Icons.location_off_rounded;
    } else if (error is ApiException) {
      title = 'Weather Service Unavailable';
      message = (error as ApiException).message;
      icon = Icons.cloud_off_rounded;
    } else if (error is AppException) {
      title = 'Something Went Wrong';
      message = (error as AppException).message;
      icon = Icons.error_outline_rounded;
    } else {
      title = customTitle ?? 'Unable to Load Weather';
      message =
          customMessage ??
          (error != null
              ? error.toString()
              : 'An unexpected error occurred. Please try again.');
      icon = Icons.cloud_off_rounded;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color:
                    isDark
                        ? ClimoraColors.navySurface.withValues(alpha: 0.8)
                        : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 48,
                color:
                    isDark ? ClimoraColors.skyBlue : ClimoraColors.navyPrimary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : ClimoraColors.navyPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white70 : Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ClimoraColors.skyBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

