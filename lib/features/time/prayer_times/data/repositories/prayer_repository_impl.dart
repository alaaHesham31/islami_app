import 'package:adhan/adhan.dart';
import 'package:flutter/foundation.dart';
import '../../domain/repositories/prayer_repository.dart';
import '../datasources/prayer_api_service.dart';
import '../datasources/prayer_cache.dart';

class PrayerRepositoryImpl implements PrayerRepository {
  final PrayerApiService _api;
  final PrayerCache _cache;


  PrayerRepositoryImpl({PrayerApiService? api, PrayerCache? cache})
      : _api = api ?? PrayerApiService(),
        _cache = cache ?? PrayerCache();


  @override
  Future<Map<String, DateTime>> getPrayerTimes(
      double lat, double lng,
      {DateTime? date, bool forceRefresh = false}) async {
    final target = date ?? DateTime.now();
    final dateKey =
        '${target.year}-${target.month.toString().padLeft(2, '0')}-${target.day.toString().padLeft(2, '0')}';
    final monthKey = '${target.year}-${target.month.toString().padLeft(2, '0')}';


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


    Map<String, DateTime>? apiTimes;
    try {
      apiTimes = await _api.fetchPrayerTimes(lat, lng, target);
      if (kDebugMode) debugPrint('🌐 API prayer times for $dateKey: $apiTimes');
    } catch (e) {
      if (kDebugMode) debugPrint('⚠️ API fetch failed for $dateKey: $e');
    }


    final cachedOffsets = await _cache.getOffsets();


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


    await _cache.saveFinalTimesForDates({dateKey: result});


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