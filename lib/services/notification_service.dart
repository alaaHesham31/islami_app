import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart' show DateFormat;

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;

import 'location_helper.dart';
import '../home/time/prayer_times/prayer_repository.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String channelId = 'prayer_channel';
  static const String channelName = 'Prayer Times';
  static const String channelDescription = 'Prayer time notifications';

  // -------------------- INIT --------------------
  static Future<void> init() async {
    tzdata.initializeTimeZones();

    var set = false;
    try {
      final name = DateTime.now().timeZoneName;
      tz.setLocalLocation(tz.getLocation(name));
      set = true;
    } catch (_) {
      if (kDebugMode) debugPrint('⚠️ tz.getLocation failed for timeZoneName');
    }

    if (!set) {
      final offsetHours = DateTime.now().timeZoneOffset.inHours;
      final etcName =
          'Etc/GMT${offsetHours >= 0 ? '-' : '+'}${offsetHours.abs()}';
      try {
        tz.setLocalLocation(tz.getLocation(etcName));
        set = true;
      } catch (_) {
        if (kDebugMode) debugPrint('⚠️ tz.getLocation failed for $etcName');
      }
    }

    if (!set) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    final settings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (resp) {
        if (kDebugMode) debugPrint('Tapped: ${resp.payload}');
      },
    );

    // Android channel
    final androidPlugin =
        _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    if (androidPlugin != null) {
      final channel = AndroidNotificationChannel(
        channelId,
        channelName,
        description: channelDescription,
        importance: Importance.max,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('notification'),
      );
      await androidPlugin.createNotificationChannel(channel);
    }
  }

  // -------------------- PERMISSIONS --------------------
  static Future<void> requestPermission() async {
    final androidPlugin =
        _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    await androidPlugin?.requestNotificationsPermission();

    final iosPlugin =
        _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();
    await iosPlugin?.requestPermissions(alert: true, badge: true, sound: true);
  }

  // -------------------- CORE --------------------
  static Future<void> cancelAll() => _plugin.cancelAll();

  static Future<void> scheduleZoned({
    required int id,
    required String title,
    required String body,
    required DateTime localDateTime,
    bool dailyRepeat = false,
    String? payload,
  }) async {
    try {
      final scheduled = tz.TZDateTime.from(localDateTime, tz.local);
      final androidDetails = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      );
      final platform = NotificationDetails(android: androidDetails);

      await _plugin.zonedSchedule(
        id,
        title,
        body,
        scheduled,
        platform,
        androidAllowWhileIdle: true,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: dailyRepeat ? DateTimeComponents.time : null,
        payload: payload,
      );
    } on PlatformException catch (err) {
      debugPrint('⚠️ PlatformException scheduling: $err');
    } catch (e) {
      debugPrint('❌ Error scheduling: $e');
    }
  }

  // -------------------- PRAYER SCHEDULING --------------------
  static Future<void> schedulePrayerNotifications() async {
    try {
      final loc = await LocationService.getCurrentLocation();
      final repo = PrayerRepository();
      final times = await repo.getPrayerTimes(
        loc.latitude,
        loc.longitude,
        forceRefresh: false,
      );

      await cancelAll(); // clear old

      final now = DateTime.now();
      for (final e in times.entries) {
        var scheduled = e.value.subtract(const Duration(minutes: 10));
        if (!scheduled.isAfter(now)) {
          scheduled = scheduled.add(const Duration(days: 1));
        }

        await scheduleZoned(
          id: e.key.hashCode,
          title: '${e.key} Prayer',
          body: 'Prayer time for ${e.key} is coming in 10 minutes',
          localDateTime: scheduled,
          dailyRepeat: true,
        );

        // 🔹 Debug log in 12h format
        final formatted = DateFormat('hh:mm a').format(scheduled);
        debugPrint(
          '📅 Scheduled ${e.key} at $formatted (id=${e.key.hashCode})',
        );
      }
    } catch (e) {
      debugPrint('❌ Failed scheduling prayers: $e');
    }
  }
}
