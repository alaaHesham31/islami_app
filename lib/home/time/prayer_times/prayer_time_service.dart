// // lib/home/time/prayer_times/prayer_time_service.dart
// import 'dart:math';
// import 'package:flutter/foundation.dart';
// import 'package:islami_app_demo/home/time/prayer_times/prayer_repository.dart';
// import 'package:islami_app_demo/services/notification_service.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class PrayerTimeService {
//   final PrayerRepository _repo;
//   PrayerTimeService([PrayerRepository? repo]) : _repo = repo ?? PrayerRepository();
//
//
//
//   Future<Position?> _getPositionOrNull() async {
//     try {
//       final enabled = await Geolocator.isLocationServiceEnabled();
//       if (!enabled) {
//         debugPrint('Location service disabled -> using fallback');
//         return null;
//       }
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           debugPrint('Location permission denied -> fallback');
//           return null;
//         }
//       }
//       if (permission == LocationPermission.deniedForever) {
//         debugPrint('Location permission deniedForever -> fallback');
//         return null;
//       }
//       return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     } catch (e) {
//       debugPrint('getPosition error: $e');
//       return null;
//     }
//   }
//
//   Future<void> generateCacheAndScheduleMonth({
//     int days = 30,
//     double? fallbackLat = 30.0444,
//     double? fallbackLng = 31.2357,
//   }) async {
//     final pos = await _getPositionOrNull();
//     final lat = pos?.latitude ?? fallbackLat!;
//     final lng = pos?.longitude ?? fallbackLng!;
//     debugPrint('generateCacheAndScheduleMonth using coords: $lat,$lng');
//
//     await NotificationService.cancelAll();
//
//     final now = DateTime.now();
//     final List<DateTime> daysList = List.generate(days, (i) => DateTime(now.year, now.month, now.day).add(Duration(days: i)));
//
//     for (final date in daysList) {
//       final finalTimes = await _repo.calculateAndApplyOffsets(latitude: lat, longitude: lng, date: date);
//
//       await _repo.saveCachedFor(date, finalTimes);
//
//       final prayerOrder = ['fajr', 'sunrise', 'dhuhr', 'asr', 'maghrib', 'isha'];
//       for (int i = 0; i < prayerOrder.length; i++) {
//         final key = prayerOrder[i];
//         final dt = finalTimes[key];
//         if (dt == null) continue;
//         final scheduled = dt.subtract(const Duration(minutes: 10));
//         if (scheduled.isBefore(DateTime.now())) continue;
//
//         final id = _makeIdFor(date, i);
//         final title = '${_titleForKey(key)} Prayer';
//         final body = 'Time for ${_titleForKey(key)} prayer at ${_formatTime(dt)}';
//         await NotificationService.scheduleZoned(id: id, title: title, body: body, localDateTime: scheduled);
//       }
//
//       debugPrint('Processed date $date');
//     }
//
//     debugPrint('generateCacheAndScheduleMonth done for $days days');
//   }
//
//   int _makeIdFor(DateTime date, int index) {
//     final y = date.year;
//     final m = date.month;
//     final d = date.day;
//     return y * 100000 + m * 1000 + d * 10 + index;
//   }
//
//   String _formatTime(DateTime dt) {
//     final h = dt.hour.toString().padLeft(2, '0');
//     final min = dt.minute.toString().padLeft(2, '0');
//     return '$h:$min';
//   }
//
//   String _titleForKey(String key) {
//     final map = {
//       'fajr': 'Fajr',
//       'sunrise': 'Sunrise',
//       'dhuhr': 'Dhuhr',
//       'asr': 'Asr',
//       'maghrib': 'Maghrib',
//       'isha': 'Isha'
//     };
//     return map[key] ?? key;
//   }
//
//   Future<Map<String, DateTime?>?> getTodayPrayerTimes() async {
//     final today = DateTime.now();
//     return await _repo.readCachedFor(today);
//   }
//
//   Future<void> clearCachedDays(int days) async {
//     final prefs = await SharedPreferences.getInstance();
//     final start = DateTime.now();
//     for (int i = 0; i < days; i++) {
//       final d = DateTime(start.year, start.month, start.day).add(Duration(days: i));
//       await prefs.remove('prayer_times_${d.year.toString().padLeft(4,'0')}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}');
//     }
//   }
// }
