// lib/services/pray_times/prayer_notifier.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;

/// PrayerNotifier: wrapper around flutter_local_notifications + timezone.
/// - Provides clearAll() and scheduleNotification(...) so it matches your main.dart usage.
/// - Converts plain DateTime -> tz.TZDateTime with a safe fallback.
class PrayerNotifier {
  final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  /// Initialize the notifications plugin and timezone DB.
  /// Call this early (before scheduling). This does NOT try to obtain IANA timezone name.
  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();

    final settings = InitializationSettings(android: android, iOS: ios);
    await _notifications.initialize(settings);

    // initialize timezone database (local mapping must be set by app if possible)
    // This only loads the tz database; it doesn't set tz.local.
    // You should call tz.setLocalLocation(...) in main if you have an IANA tz name.
    try {
      tzdata.initializeTimeZones();
    } catch (e) {
      // ignore - initialization should be safe on mobile
    }
  }

  /// Cancel all scheduled notifications
  Future<void> cancelAll() => _notifications.cancelAll();

  /// Alias used in your main.dart
  Future<void> clearAll() => cancelAll();

  /// Schedules a notification when you already have a tz.TZDateTime
  Future<void> schedulePrayerNotification({
    required int id,
    required String title,
    required tz.TZDateTime tzDate,
    String? body,
    bool dailyRepeat = false,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'prayer_channel',
      'Prayer Times',
      channelDescription: 'Prayer time alerts',
      importance: Importance.max,
      priority: Priority.high,
    );

    final platform = NotificationDetails(android: androidDetails);


    if (tzDate.isAfter(tz.TZDateTime.now(tz.local))) {
       await _notifications.zonedSchedule(
        id,
        'Prayer Time',
        body ?? "It's time for $title",
        tzDate,
        platform,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents:
        dailyRepeat ? DateTimeComponents.time : null,
      );
    } else {
      debugPrint("⏭ Skipping ${title}, already passed today");
    }

  }

  /// Convenience wrapper that accepts a plain DateTime (what your main currently calls).
  /// It converts to tz.TZDateTime.from(..., tz.local) when possible, else falls back to UTC.
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required DateTime scheduledTime,
    String? body,
    bool dailyRepeat = false,
  }) async {
    tz.TZDateTime tzDate;

    // Try to use tz.local — if it's not set properly, fallback to UTC
    try {
      tzDate = tz.TZDateTime.from(scheduledTime, tz.local);

      debugPrint("📌 Converting $scheduledTime → tzDate: $tzDate for $title");

    } catch (e) {
      // If tz.local isn't configured, convert to UTC and use tz.UTC
      tzDate = tz.TZDateTime.from(scheduledTime.toUtc(), tz.UTC);
      debugPrint("📌 Converting $scheduledTime → tzDate: $tzDate for $title");

    }

    return schedulePrayerNotification(
      id: id,
      title: title,
      tzDate: tzDate,
      body: body,
      dailyRepeat: dailyRepeat,
    );
  }
}
