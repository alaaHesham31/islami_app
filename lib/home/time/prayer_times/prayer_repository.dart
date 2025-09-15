// lib/services/pray_times/prayer_repository.dart
import 'package:adhan/adhan.dart';
import 'package:flutter/foundation.dart';

import 'prayer_api_service.dart';
import 'prayer_cache.dart';

class PrayerRepository {
  final PrayerApiService _api = PrayerApiService();
  final PrayerCache _cache = PrayerCache();

  Future<Map<String, DateTime>> getPrayerTimes(
      double lat,
      double lng, {
        bool forceRefresh = false,
      }) async {
    final now = DateTime.now();
    final monthKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';

    // 1) Cached fast path
    final lastUpdateMonth = await _cache.getLastUpdateMonth();
    final cachedFinalTimes = await _cache.getFinalTimesForMonth(monthKey);

    if (!forceRefresh && lastUpdateMonth == monthKey && cachedFinalTimes != null) {
      if (kDebugMode) {
        debugPrint(
          '✅ PrayerRepository: Loaded cached finalTimes for $monthKey → $cachedFinalTimes',
        );
      }
      return cachedFinalTimes;
    }

    if (kDebugMode) {
      debugPrint('🔁 PrayerRepository: Cache miss (last=$lastUpdateMonth, now=$monthKey), computing…');
    }

    // 2) Compute local times (Adhan)
    final components = DateComponents.from(now);
    final coords = Coordinates(lat, lng);
    final params = CalculationMethod.muslim_world_league.getParameters();
    params.madhab = Madhab.shafi;
    final pt = PrayerTimes(coords, components, params);

    final localTimes = <String, DateTime>{
      'Fajr': pt.fajr,
      'Dhuhr': pt.dhuhr,
      'Asr': pt.asr,
      'Maghrib': pt.maghrib,
      'Isha': pt.isha,
    };
    if (kDebugMode) debugPrint('🧭 Local prayer times: $localTimes');

    // 3) Try API fetch
    Map<String, DateTime>? apiTimes;
    try {
      apiTimes = await _api.fetchPrayerTimes(lat, lng, now);
      if (kDebugMode) debugPrint('🌐 API prayer times: $apiTimes');
    } catch (e) {
      if (kDebugMode) debugPrint('⚠️ API fetch failed: $e');
    }

    // 4) Load cached offsets (if any)
    final cachedOffsets = await _cache.getOffsets();

    // 5) Merge logic (local + API + offsets)
    final newOffsets = <String, int>{};
    final result = <String, DateTime>{};

    for (final k in localTimes.keys) {
      final local = localTimes[k]!;
      int offsetMinutes = cachedOffsets[k] ?? 0;

      if (apiTimes != null && apiTimes.containsKey(k)) {
        final api = apiTimes[k]!;
        final diff = api.difference(local).inMinutes;
        if (diff != 0) {
          offsetMinutes = diff;
          newOffsets[k] = diff;
        }
      }

      final finalTime = local.add(Duration(minutes: offsetMinutes));
      result[k] = finalTime;

      if (kDebugMode) {
        debugPrint('🕒 $k → Local=$local | Offset=$offsetMinutes | Final=$finalTime');
      }
    }

    // 6) Save results
    if (newOffsets.isNotEmpty) {
      final merged = Map<String, int>.from(cachedOffsets)..addAll(newOffsets);
      await _cache.saveOffsets(merged);
    }
    await _cache.saveFinalTimes(result);
    await _cache.setLastUpdateMonth(monthKey);

    if (kDebugMode) {
      debugPrint('💾 Saved finalTimes & offsets for $monthKey');
    }

    return result;
  }
}
