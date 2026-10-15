import 'package:flutter/material.dart';

import '../../../core/theme/climora_colors.dart';
import '../../../data/models/city_location.dart';

/// Top bar displaying app branding, current city title, and quick action icons.
class HomeHeader extends StatelessWidget {
  final CityLocation city;
  final bool isRefreshing;
  final VoidCallback onSearchPressed;
  final VoidCallback onLocationPressed;
  final VoidCallback onRefreshPressed;
  final VoidCallback onSettingsPressed;

  const HomeHeader({
    super.key,
    required this.city,
    required this.isRefreshing,
    required this.onSearchPressed,
    required this.onLocationPressed,
    required this.onRefreshPressed,
    required this.onSettingsPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          // City info & App title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'CLIMORA',
                      style: theme.textTheme.labelSmall?.copyWith(
                        letterSpacing: 2.2,
                        fontWeight: FontWeight.w800,
                        color: ClimoraColors.skyBlue,
                      ),
                    ),
                    if (city.isCurrentLocation) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: ClimoraColors.skyBlue.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.my_location_rounded,
                              size: 10,
                              color: ClimoraColors.skyBlue,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              'Current',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: ClimoraColors.skyBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                InkWell(
                  onTap: onSearchPressed,
                  borderRadius: BorderRadius.circular(8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          city.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color:
                                isDark
                                    ? Colors.white
                                    : ClimoraColors.navyPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 22,
                        color:
                            isDark ? Colors.white70 : ClimoraColors.navyPrimary,
                      ),
                    ],
                  ),
                ),
                if (city.country != null && city.country!.isNotEmpty)
                  Text(
                    city.admin1 != null && city.admin1!.isNotEmpty
                        ? '${city.admin1}, ${city.country}'
                        : city.country!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),

          // Action buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIconButton(
                context: context,
                icon: Icons.my_location_rounded,
                tooltip: 'Current Location',
                onPressed: onLocationPressed,
              ),
              const SizedBox(width: 6),
              _buildIconButton(
                context: context,
                icon: Icons.search_rounded,
                tooltip: 'Search City',
                onPressed: onSearchPressed,
              ),
              const SizedBox(width: 6),
              _buildIconButton(
                context: context,
                icon:
                    isRefreshing
                        ? Icons.hourglass_top_rounded
                        : Icons.refresh_rounded,
                tooltip: 'Refresh Weather',
                onPressed: isRefreshing ? null : onRefreshPressed,
              ),
              const SizedBox(width: 6),
              _buildIconButton(
                context: context,
                icon: Icons.settings_outlined,
                tooltip: 'Settings',
                onPressed: onSettingsPressed,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required BuildContext context,
    required IconData icon,
    required String tooltip,
    required VoidCallback? onPressed,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color:
            isDark
                ? ClimoraColors.navyCard.withValues(alpha: 0.8)
                : Colors.white.withValues(alpha: 0.9),
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 20),
        color: isDark ? Colors.white : ClimoraColors.navyPrimary,
        tooltip: tooltip,
        onPressed: onPressed,
      ),
    );
  }
}
