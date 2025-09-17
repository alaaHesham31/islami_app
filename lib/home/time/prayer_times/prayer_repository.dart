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
        DateTime? date,
        bool forceRefresh = false,
      }) async {
    final target = date ?? DateTime.now();
    final dateKey = '${target.year}-${target.month.toString().padLeft(2, '0')}-${target.day.toString().padLeft(2, '0')}';
    final monthKey = '${target.year}-${target.month.toString().padLeft(2, '0')}';

    // 1) Cached fast path (per-date)
    if (!forceRefresh) {
      final perDay = await _cache.getFinalTimesForDateKey(dateKey);
      if (perDay != null) {
        if (kDebugMode) debugPrint('✅ PrayerRepository: Loaded cached finalTimes for $dateKey → $perDay');
        return perDay;
      }
    }

    if (kDebugMode) {
      debugPrint('🔁 PrayerRepository: cache miss for $dateKey (month=$monthKey), computing…');
    }

    // 2) Compute local times (Adhan) for the target date
    final components = DateComponents.from(target);
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
    if (kDebugMode) debugPrint('🧭 Local prayer times for $dateKey: $localTimes');

    // 3) Try API fetch for that date
    Map<String, DateTime>? apiTimes;
    try {
      apiTimes = await _api.fetchPrayerTimes(lat, lng, target);
      if (kDebugMode) debugPrint('🌐 API prayer times for $dateKey: $apiTimes');
    } catch (e) {
      if (kDebugMode) debugPrint('⚠️ API fetch failed for $dateKey: $e');
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

    // 6) Save results per-date
    await _cache.saveFinalTimesForDates({dateKey: result});

    // 7) Save offsets (merge)
    if (newOffsets.isNotEmpty) {
      final merged = Map<String, int>.from(cachedOffsets)..addAll(newOffsets);
      await _cache.saveOffsets(merged);
    }
    await _cache.setLastUpdateMonth(monthKey);

    if (kDebugMode) {
      debugPrint('💾 Saved finalTimes for $dateKey & offsets if any');
    }

    return result;
  }
}
