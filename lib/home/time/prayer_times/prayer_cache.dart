import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class PrayerCache {
  static const String boxName = 'prayer_cache';
  static const String keyFinalTimes = 'final_times'; // Map<String,int(ms)>
  static const String keyOffsets = 'offsets'; // Map<String,int(minutes)>
  static const String keyLastUpdateMonth = 'last_update_month'; // 'YYYY-MM'

  Future<Box> _openBox() async => await Hive.openBox(boxName);

  Future<Map<String, DateTime>?> getCachedFinalTimes() async {
    final box = await _openBox();
    final raw = box.get(keyFinalTimes);
    if (raw == null) return null;
    // raw is Map<String,int>
    return Map<String, int>.from(raw).map((k, v) => MapEntry(k, DateTime.fromMillisecondsSinceEpoch(v, isUtc: true).toLocal()));
  }

  Future<void> saveFinalTimes(Map<String, DateTime> times) async {
    final box = await _openBox();
    final out = <String, int>{};
    times.forEach((k, v) => out[k] = v.toUtc().millisecondsSinceEpoch);
    await box.put(keyFinalTimes, out);
    if (kDebugMode) debugPrint('💾 PrayerCache: saved finalTimes keys=${out.keys}');
  }

  Future<Map<String, int>> getOffsets() async {
    final box = await _openBox();
    final raw = box.get(keyOffsets);
    if (raw == null) return {};
    return Map<String, int>.from(raw);
  }

  Future<void> saveOffsets(Map<String, int> offsets) async {
    final box = await _openBox();
    await box.put(keyOffsets, offsets);
    if (kDebugMode) debugPrint('💾 PrayerCache: saved offsets $offsets');
  }

  Future<String?> getLastUpdateMonth() async {
    final box = await _openBox();
    return box.get(keyLastUpdateMonth) as String?;
  }

  Future<void> setLastUpdateMonth(String monthKey) async {
    final box = await _openBox();
    await box.put(keyLastUpdateMonth, monthKey);
    if (kDebugMode) debugPrint('💾 PrayerCache: set last_update_month=$monthKey');
  }

  Future<Map<String, DateTime>?> getFinalTimesForMonth(String monthKey) async {
    final last = await getLastUpdateMonth();
    if (last != monthKey) return null;
    return await getCachedFinalTimes();
  }
}
