import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:flutter_timezone/flutter_timezone.dart' as ftz;
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../features/time/prayer_times/data/repositories/prayer_repository_impl.dart';
import 'location_helper.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService I = NotificationService._();

  static final FlutterLocalNotificationsPlugin _fln = FlutterLocalNotificationsPlugin();

  static const String _channelId = 'prayer_channel';
  static const String _channelName = 'Prayer Times';
  static const String _channelDesc = 'Prayer time reminders';

  /// Call once at app startup (before scheduling)
  static Future<void> init() async {
    tzdata.initializeTimeZones();

    // robust tz setup: try flutter_timezone -> DateTime.name -> Etc/GMT -> UTC
    bool tzOk = false;
    try {
      final name = await ftz.FlutterTimezone.getLocalTimezone();
      if (kDebugMode) debugPrint('🕓 flutter_timezone returned: $name');
      try {
        tz.setLocalLocation(tz.getLocation(name));
        tzOk = true;
        if (kDebugMode) debugPrint('✅ tz set from flutter_timezone: $name');
      } catch (e) {
        debugPrint('⚠️ tz.setLocalLocation failed for $name: $e');
      }
    } catch (e) {
      debugPrint('⚠️ flutter_timezone failed: $e');
    }

    if (!tzOk) {
      try {
        final name = DateTime.now().timeZoneName;
        tz.setLocalLocation(tz.getLocation(name));
        tzOk = true;
        if (kDebugMode) debugPrint('✅ tz set from DateTime.timeZoneName: $name');
      } catch (_) {
        debugPrint('⚠️ tz.getLocation failed for DateTime.timeZoneName');
      }
    }
    if (!tzOk) {
      try {
        final offsetHours = DateTime.now().timeZoneOffset.inHours;
        final etc = 'Etc/GMT${offsetHours >= 0 ? '-' : '+'}${offsetHours.abs()}';
        tz.setLocalLocation(tz.getLocation(etc));
        tzOk = true;
        if (kDebugMode) debugPrint('✅ tz set from $etc');
      } catch (_) {
        debugPrint('⚠️ tz.getLocation failed for Etc/GMT fallback');
      }
    }
    if (!tzOk) {
      tz.setLocalLocation(tz.getLocation('UTC'));
      debugPrint('⚠️ tz fallback to UTC');
    }

    // initialize plugin
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iosInit = DarwinInitializationSettings(requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: true);
    final settings = InitializationSettings(android: androidInit, iOS: iosInit);
    await _fln.initialize(settings, onDidReceiveNotificationResponse: (resp) {
      debugPrint('🔔 Notification tapped payload=${resp.payload}');
    });

    // create channel for Android
    final androidImpl =
    _fln.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidImpl != null) {
      final ch = AndroidNotificationChannel(_channelId, _channelName, description: _channelDesc, importance: Importance.max);
      await androidImpl.createNotificationChannel(ch);
    }

    if (kDebugMode) debugPrint('✅ NotificationService.init complete (tz=${tz.local.name})');
  }

  /// Request runtime notification permission (Android 13+ / iOS)
  static Future<void> requestPermissionsAndLog() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      debugPrint('🔒 Notification permission status before request: $status');
      if (!status.isGranted) {
        final result = await Permission.notification.request();
        debugPrint('🔒 Notification permission request result: $result');
        if (!result.isGranted) {
          debugPrint('⚠️ Notification permission NOT granted. Please open app settings to enable notifications.');
        }
      }
    } else if (Platform.isIOS) {
      final ios = _fln.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      await ios?.requestPermissions(alert: true, badge: true, sound: true);
      debugPrint('🔒 iOS permission requested');
    }
  }

  // deterministic id: (daysSinceEpoch % 1000000) * 10 + prayerIndex
  static int _idFor(DateTime date, int prayerIndex) {
    final days = date.toUtc().millisecondsSinceEpoch ~/ 86400000;
    final id = (days % 1000000) * 10 + (prayerIndex % 10);
    return id;
  }

  /// Schedule ALL cached prayer times from Hive for the next `daysAhead` days.
  /// - reads `prayer_cache` box key 'final_times_by_date' (expected shape: { 'YYYY-MM-DD': { 'Fajr': msUtc, ... } })
  /// - schedules each prayer at (finalTimeLocal - minutesBefore)
  static Future<void> scheduleMonthFromHive({int minutesBefore = 10, int daysAhead = 31}) async {
    try {
      final box = await Hive.openBox('prayer_cache');
      final raw = box.get('final_times_by_date') as Map<dynamic, dynamic>?; // null if not cached
      final nowLocal = tz.TZDateTime.now(tz.local);

      if (raw == null || raw.isEmpty) {
        debugPrint('⚠️ No cached month found in Hive (final_times_by_date). Falling back to scheduling next day only.');
        await scheduleNextDay(minutesBefore: minutesBefore);
        return;
      }

      // Gather date keys sorted ascending
      final keys = raw.keys.map((k) => k.toString()).toList()..sort();
      int scheduledCount = 0;

      // Mapping English keys → Arabic display
      const Map<String, String> prayerArabicNames = {
        "Fajr": "الفجر",
        "Dhuhr": "الظهر",
        "Asr": "العصر",
        "Maghrib": "المغرب",
        "Isha": "العشاء",
      };

      final prayerOrder = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

      for (final dateKey in keys) {
        DateTime date;
        try {
          date = DateTime.parse(dateKey); // expect YYYY-MM-DD
        } catch (_) {
          debugPrint('⚠️ Skipping invalid dateKey=$dateKey in cache');
          continue;
        }
        final diffDays = date.difference(DateTime(nowLocal.year, nowLocal.month, nowLocal.day)).inDays;
        if (diffDays < 0) continue; // past day
        if (diffDays >= daysAhead) continue; // beyond requested window

        final inner = Map<String, dynamic>.from(raw[dateKey] as Map);

        for (var i = 0; i < prayerOrder.length; i++) {
          final engKey = prayerOrder[i];
          if (!inner.containsKey(engKey)) continue;

          final msUtc = inner[engKey] as int;
          final dtLocal = DateTime.fromMillisecondsSinceEpoch(msUtc, isUtc: true).toLocal();
          final scheduledLocal = dtLocal.subtract(Duration(minutes: minutesBefore));
          final scheduledTz = tz.TZDateTime.from(scheduledLocal, tz.local);

          if (scheduledTz.isBefore(nowLocal)) {
            debugPrint('⚠️ Not scheduling $engKey for $dateKey because scheduled time $scheduledTz is in the past');
            continue;
          }

          final arabicName = prayerArabicNames[engKey]!;
          final id = _idFor(date, i);

          final androidDetails = AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDesc,
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
          );
          final details = NotificationDetails(android: androidDetails, iOS: DarwinNotificationDetails());

          await _fln.zonedSchedule(
            id,
            'أذان $arabicName',
            'ستبدأ صلاة $arabicName بعد $minutesBefore دقيقة',
            scheduledTz,
            details,
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
            payload: 'prayer|$engKey|$dateKey',
          );

          debugPrint('📅 Scheduled $engKey ($arabicName) (id=$id) at $scheduledTz (${scheduledLocal.toIso8601String()})');
          scheduledCount++;
        }
      }

      // After scheduling, print pending list for verification
      final pending = await _fln.pendingNotificationRequests();
      debugPrint('🔎 Pending notifications count after scheduling: ${pending.length}');
      for (final p in pending) {
        debugPrint('  • pending id=${p.id} title="${p.title}" payload=${p.payload}');
      }

      debugPrint('✅ scheduleMonthFromHive completed — scheduledCount=$scheduledCount');
    } catch (e, st) {
      debugPrint('❌ scheduleMonthFromHive error: $e\n$st');
    }
  }

  /// Schedule next day (fallback). Uses PrayerRepository if cache missing.
  static Future<void> scheduleNextDay({int minutesBefore = 10}) async {
    try {
      final saved = await LocationService.getSavedLocation();
      double lat, lng;
      if (saved != null) {
        lat = saved.latitude;
        lng = saved.longitude;
        debugPrint('📍 scheduleNextDay using saved location $lat,$lng');
      } else {
        final pos = await LocationService.getCurrentLocation();
        lat = pos.latitude;
        lng = pos.longitude;
        debugPrint('📍 scheduleNextDay fetched current location $lat,$lng');
      }

      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final dayKey = '${tomorrow.year}-${tomorrow.month.toString().padLeft(2,'0')}-${tomorrow.day.toString().padLeft(2,'0')}';

      final repo = PrayerRepositoryImpl();
      final times = await repo.getPrayerTimes(lat, lng, date: DateTime(tomorrow.year, tomorrow.month, tomorrow.day), forceRefresh: false);

      // write into cache (so next run can schedule month)
      final box = await Hive.openBox('prayer_cache');
      final raw = box.get('final_times_by_date') as Map<dynamic, dynamic>? ?? {};
      final entry = <String,int>{};
      for (final e in times.entries) {
        entry[e.key] = e.value.toUtc().millisecondsSinceEpoch;
      }
      raw[dayKey] = entry;
      await box.put('final_times_by_date', raw);

      // schedule this single day via scheduleMonthFromHive with daysAhead=1
      await scheduleMonthFromHive(minutesBefore: minutesBefore, daysAhead: 1);
    } catch (e, st) {
      debugPrint('❌ scheduleNextDay error: $e\n$st');
    }
  }

  /// Debug helper: schedule an immediate test notification (seconds from now)
  static Future<void> testImmediateNotification({int seconds = 5}) async {
    final when = tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds));
    final androidDetails = AndroidNotificationDetails(_channelId, _channelName, channelDescription: _channelDesc, importance: Importance.max);
    final details = NotificationDetails(android: androidDetails, iOS: DarwinNotificationDetails());
    await _fln.zonedSchedule(9999999, 'Test notification', 'This is a test', when, details, androidAllowWhileIdle: true, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
    debugPrint('🧪 Scheduled test notification at $when');
  }

  /// Debug helper: print pending notifications + simple cache summary
  static Future<void> printPendingAndCacheSummary() async {
    final pending = await _fln.pendingNotificationRequests();
    debugPrint('🔎 Pending notifications (${pending.length}):');
    for (final p in pending) {
      debugPrint('  • id=${p.id} title="${p.title}" payload=${p.payload}');
    }

    try {
      final box = await Hive.openBox('prayer_cache');
      final raw = box.get('final_times_by_date') as Map<dynamic, dynamic>?;
      if (raw == null) {
        debugPrint('⚠️ Cache empty (final_times_by_date missing)');
        return;
      }
      // show up to next 7 days from now
      final keys = raw.keys.map((k) => k.toString()).toList()..sort();
      final now = DateTime.now();
      debugPrint('💾 Cached dates (next 7):');
      var printed = 0;
      for (final k in keys) {
        final d = DateTime.tryParse(k);
        if (d == null) continue;
        if (d.isBefore(now)) continue;
        debugPrint('  • $k');
        printed++;
        if (printed >= 7) break;
      }
    } catch (e) {
      debugPrint('⚠️ Could not read cache summary: $e');
    }
  }

  /// Returns true if cache has at least 7 future days available
  static Future<bool> cacheIsStillValid({int daysAhead = 7}) async {
    final box = await Hive.openBox('prayer_cache');
    final raw = box.get('final_times_by_date') as Map<dynamic, dynamic>?;
    if (raw == null || raw.isEmpty) return false;

    final keys = raw.keys.map((k) => k.toString()).toList()..sort();
    final now = DateTime.now();
    for (final k in keys) {
      final d = DateTime.tryParse(k);
      if (d != null && d.isAfter(now.add(Duration(days: daysAhead)))) {
        return true; // found a date far enough ahead
      }
    }
    return false;
  }

}
