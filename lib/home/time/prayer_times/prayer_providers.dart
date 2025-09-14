// // lib/providers/prayer_providers.dart
// import 'package:flutter/foundation.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:islami_app_demo/home/time/prayer_times/prayer_repository.dart';
//
// final locationProvider = FutureProvider<Position>((ref) async {
//   final enabled = await Geolocator.isLocationServiceEnabled();
//   if (!enabled) throw Exception('Location services are disabled.');
//
//   LocationPermission permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       throw Exception('Location permission denied');
//     }
//   }
//   if (permission == LocationPermission.deniedForever) {
//     throw Exception('Location permission permanently denied');
//   }
//
//   // use high accuracy
//   return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
// });
//
// final prayerRepositoryProvider = Provider<PrayerRepository>((ref) {
//   return PrayerRepository();
// });
//
// final prayerTimesProvider = FutureProvider<Map<String, DateTime?>>((ref) async {
//   final repo = ref.read(prayerRepositoryProvider);
//   final today = DateTime.now();
//
//   // Try cached first
//   final cached = await repo.readCachedFor(today);
//   if (cached != null) {
//     debugPrint('Using cached prayer times for $today -> $cached');
//     return cached;
//   }
//
//   try {
//     final pos = await ref.watch(locationProvider.future);
//     final times = await repo.calculateAndApplyOffsets(
//       latitude: pos.latitude,
//       longitude: pos.longitude,
//       date: today,
//     );
//     await repo.saveCachedFor(today, times);
//     return times;
//   } catch (e) {
//     // fallback to Cairo coords if location fails
//     debugPrint('Location failed in provider: $e — falling back to Cairo coords');
//     final times = await repo.calculateAndApplyOffsets(
//         latitude: 30.0444, longitude: 31.2357, date: today);
//     await repo.saveCachedFor(today, times);
//     return times;
//   }
// });
