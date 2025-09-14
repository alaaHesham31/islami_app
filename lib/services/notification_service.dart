// lib/services/notification_service.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:flutter/services.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // load timezone db
    tzdata.initializeTimeZones();

    // Attempt to set tz.local from DateTime.timeZoneName or offset fallback
    var set = false;
    try {
      final name = DateTime.now().timeZoneName;
      tz.setLocalLocation(tz.getLocation(name));
      set = true;
      if (kDebugMode) debugPrint('🔁 tz set from name: $name');
    } catch (_) {
      if (kDebugMode) debugPrint('⚠️ tz.getLocation failed for timeZoneName');
    }

    if (!set) {
      final offsetHours = DateTime.now().timeZoneOffset.inHours;
      final etcName = 'Etc/GMT${offsetHours >= 0 ? '-' : '+'}${offsetHours.abs()}';
      try {
        tz.setLocalLocation(tz.getLocation(etcName));
        set = true;
        if (kDebugMode) debugPrint('🔁 tz set from offset: $etcName');
      } catch (_) {
        if (kDebugMode) debugPrint('⚠️ tz.getLocation failed for $etcName');
      }
    }

    if (!set) {
      tz.setLocalLocation(tz.getLocation('UTC'));
      if (kDebugMode) debugPrint('🔁 tz set fallback to UTC');
    }

    // init plugin
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: ios);
    await _plugin.initialize(settings, onDidReceiveNotificationResponse: (resp) {
      if (kDebugMode) debugPrint('notification tapped: ${resp.payload}');
    });

    if (kDebugMode) debugPrint('NotificationService initialized (tz=${tz.local.name})');
  }

  static Future<void> cancelAll() => _plugin.cancelAll();

  /// Schedule a zoned notification for a local DateTime.
  /// Uses inexact scheduling by default to avoid exact alarm permission issues.
  static Future<void> scheduleZoned({
    required int id,
    required String title,
    required String body,
    required DateTime localDateTime,
    String? payload,
    bool dailyRepeat = false,
  }) async {
    try {
      final scheduled = tz.TZDateTime.from(localDateTime, tz.local);

      final androidDetails = AndroidNotificationDetails(
        'prayer_channel',
        'Prayer Times',
        channelDescription: 'Prayer time notifications',
        importance: Importance.max,
        priority: Priority.high,
      );
      final platform = NotificationDetails(android: androidDetails);

      // Skip scheduling if in the past (caller should have checked but double-safe here)
      final now = tz.TZDateTime.now(tz.local);
      if (!scheduled.isAfter(now)) {
        if (kDebugMode) debugPrint('⏭ scheduleZoned: scheduled time is NOT after now ($scheduled <= $now), skipping');
        throw Exception('scheduled time is not after now');
      }

      // Try inexact scheduling first (this avoids requiring exact alarm permission)
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        scheduled,
        platform,
        androidAllowWhileIdle: true,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: dailyRepeat ? DateTimeComponents.time : null,
        payload: payload,
      );

      if (kDebugMode) debugPrint('⏰ Scheduled id=$id at $localDateTime (tz=${tz.local.name})');
      return;
    } on PlatformException catch (pErr) {
      // Exact alarms not permitted on some devices: fallback to scheduling without androidScheduleMode
      if (kDebugMode) debugPrint('⚠️ PlatformException scheduling: $pErr — falling back to simpler scheduling');

      try {
        final scheduled = tz.TZDateTime.from(localDateTime, tz.local);
        final androidDetails = AndroidNotificationDetails('prayer_channel', 'Prayer Times',
            channelDescription: 'Prayer time notifications');
        final platform = NotificationDetails(android: androidDetails);

        await _plugin.zonedSchedule(
          id,
          title,
          body,
          scheduled,
          platform,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: dailyRepeat ? DateTimeComponents.time : null,
          payload: payload,
        );

        if (kDebugMode) debugPrint('⏰ Fallback scheduled id=$id at $localDateTime');
        return;
      } catch (e) {
        debugPrint('❌ Fallback schedule failed: $e');
      }
    } catch (e) {
      debugPrint('❌ Unknown error scheduling notification: $e');
    }
  }

  static Future<void> debugPending() async {
    final pending = await _plugin.pendingNotificationRequests();
    if (kDebugMode) debugPrint('Pending notifications count=${pending.length}');
    for (final p in pending) debugPrint('PENDING: id=${p.id}, title=${p.title}, body=${p.body}');
  }
}
