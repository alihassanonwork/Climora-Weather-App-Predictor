import 'package:intl/intl.dart';

/// Date and time formatting helpers for Climora.
class DateFormatter {
  DateFormatter._();

  static final DateFormat _dayOfWeekFormat = DateFormat('EEE');
  static final DateFormat _shortDateFormat = DateFormat('MMM d');
  static final DateFormat _fullDateFormat = DateFormat('EEEE, MMMM d');
  static final DateFormat _hourFormat = DateFormat('h a');
  static final DateFormat _timeFormat = DateFormat('h:mm a');
  static final DateFormat _lastUpdatedFormat = DateFormat('MMM d, h:mm a');

  /// Formats an ISO string (e.g. 2026-10-14T20:15) or DateTime into a friendly time string (e.g. 8:15 PM).
  static String formatTimeString(String? isoString) {
    if (isoString == null) return '--:--';
    try {
      final dt = DateTime.parse(isoString);
      return _timeFormat.format(dt);
    } catch (_) {
      return isoString;
    }
  }

  /// Formats a DateTime for the hero subtitle (e.g. Wednesday, October 14).
  static String formatFullDate(DateTime dateTime) {
    return _fullDateFormat.format(dateTime);
  }

  /// Formats a DateTime or ISO string for time (e.g. "7:22 AM").
  static String formatTime(DateTime? dateTime) {
    if (dateTime == null) return '--:--';
    return _timeFormat.format(dateTime);
  }

  /// Formats an hour from DateTime (e.g. "3 PM").
  static String formatHour(DateTime dateTime) {
    return _hourFormat.format(dateTime);
  }

  /// Formats weekday name (e.g. "Wed").
  static String formatWeekday(DateTime dateTime) {
    return _dayOfWeekFormat.format(dateTime);
  }

  /// Formats for daily forecast lists (e.g. "Today", "Tomorrow", "Thu, Oct 16").
  static String formatDayLabel(String isoDateString, {bool isToday = false}) {
    if (isToday) return 'Today';
    try {
      final dt = DateTime.parse(isoDateString);
      final now = DateTime.now();
      final diff =
          DateTime(
            dt.year,
            dt.month,
            dt.day,
          ).difference(DateTime(now.year, now.month, now.day)).inDays;

      if (diff == 0) return 'Today';
      if (diff == 1) return 'Tomorrow';

      return _dayOfWeekFormat.format(dt);
    } catch (_) {
      return isoDateString;
    }
  }

  /// Formats short date (e.g. "Oct 16").
  static String formatShortDate(dynamic date) {
    if (date is DateTime) return _shortDateFormat.format(date);
    if (date is String) {
      try {
        final dt = DateTime.parse(date);
        return _shortDateFormat.format(dt);
      } catch (_) {
        return date;
      }
    }
    return '--';
  }

  /// Formats hourly timeline item (e.g. "Now", "3 PM", "11 AM").
  static String formatHourlyTime(String isoString, {bool isNow = false}) {
    if (isNow) return 'Now';
    try {
      final dt = DateTime.parse(isoString);
      return _hourFormat.format(dt);
    } catch (_) {
      return isoString;
    }
  }

  /// Formats last updated indicator (e.g. "Updated Oct 14, 8:15 PM").
  static String formatLastUpdated(DateTime dateTime) {
    return _lastUpdatedFormat.format(dateTime);
  }

  /// Formats sunrise or sunset ISO string (e.g. "2026-10-14T07:22") to readable time ("7:22 AM").
  static String formatSunTime(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '--:--';
    try {
      final dt = DateTime.parse(isoString);
      return _timeFormat.format(dt);
    } catch (_) {
      return '--:--';
    }
  }
}

