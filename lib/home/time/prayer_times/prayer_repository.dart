// lib/services/pray_times/prayer_repository.dart
import 'package:adhan/adhan.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../../services/pray_times/prayer_api_service.dart';
import '../../../services/pray_times/prayer_cache.dart';



class PrayerRepository {
  final PrayerApiService _api = PrayerApiService();
  final PrayerCache _cache = PrayerCache();

  /// Returns final times in local timezone.
  /// Strategy:
  /// - if cached finalTimes exist and last_update_month == this month -> return cached
  /// - otherwise compute local times (Adhan), try API, compute offsets, save finalTimes & offsets & last_update_month
  Future<Map<String, DateTime>> getPrayerTimes(double lat, double lng, {bool forceRefresh = false}) async {
    final now = DateTime.now();
    final monthKey = DateFormat('yyyy-MM').format(now);

    // 1) cached fast path
    if (!forceRefresh) {
      final last = await _cache.getLastUpdateMonth();
      final cached = await _cache.getCachedFinalTimes();
      if (cached != null && last == monthKey) {
        if (kDebugMode) debugPrint('✅ PrayerRepository: Loaded cached finalTimes for $monthKey');
        return cached;
      }
    }

    if (kDebugMode) debugPrint('🌐 PrayerRepository: computing times and trying API sync (forceRefresh=$forceRefresh)');

    // 2) compute local times (Adhan)
    final components = DateComponents.from(DateTime.now());
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
    if (kDebugMode) debugPrint('🧭 PrayerRepository: localCalc $localTimes');

    // 3) Try API
    Map<String, DateTime>? apiTimes;
    try {
      apiTimes = await _api.fetchPrayerTimes(lat, lng, DateTime.now());
      if (kDebugMode) debugPrint('🌐 PrayerRepository: apiTimes $apiTimes');
    } catch (e) {
      if (kDebugMode) debugPrint('⚠️ PrayerRepository: API fetch failed: $e');
    }

    // 4) Get cached offsets (if any)
    final cachedOffsets = await _cache.getOffsets();

    // 5) Compute finalTimes + offsets
    final newOffsets = <String, int>{};
    final result = <String, DateTime>{};

    for (final k in localTimes.keys) {
      final local = localTimes[k]!;
      int offsetMinutes = cachedOffsets[k] ?? 0; // default to cached offset or 0

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
      if (kDebugMode) debugPrint('🕒 Comparing $k → Local: $local | Offset: $offsetMinutes | Final: $finalTime');
    }

    // 6) Persist offsets (if new) and finalTimes and lastUpdateMonth
    if (newOffsets.isNotEmpty) {
      // merge newOffsets into cachedOffsets then save
      final merged = Map<String, int>.from(cachedOffsets);
      merged.addAll(newOffsets);
      await _cache.saveOffsets(merged);
    }
    await _cache.saveFinalTimes(result);
    await _cache.setLastUpdateMonth(monthKey);

    if (kDebugMode) debugPrint('💾 PrayerRepository: saved finalTimes & offsets for $monthKey');

    return result;
  }
}
