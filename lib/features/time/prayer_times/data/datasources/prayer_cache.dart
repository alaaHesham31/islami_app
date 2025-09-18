import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';


class PrayerCache {
  static const String boxName = 'prayer_cache';
  static const String keyFinalTimes = 'final_times_by_date';
  static const String keyOffsets = 'offsets';
  static const String keyLastUpdateMonth = 'last_update_month';


  Future<Box> _openBox() async => await Hive.openBox(boxName);


  Future<Map<String, Map<String, DateTime>>?> getCachedFinalTimesForMonth(
      String monthKey) async {
    final box = await _openBox();
    final raw = box.get(keyFinalTimes);
    if (raw == null) return null;
    final Map<String, dynamic> out = Map<String, dynamic>.from(raw);
    final Map<String, Map<String, DateTime>> result = {};
    out.forEach((dateStr, innerRaw) {
      final inner = Map<String, dynamic>.from(innerRaw);
      final Map<String, DateTime> innerMap = {};
      inner.forEach((k, v) {
        innerMap[k] = DateTime.fromMillisecondsSinceEpoch(v as int);
      });
      result[dateStr] = innerMap;
    });
    return result;
  }


  Future<Map<String, DateTime>?> getFinalTimesForDateKey(String dateKey) async {
    final box = await _openBox();
    final raw = box.get(keyFinalTimes);
    if (raw == null) return null;
    final Map<String, dynamic> outer = Map<String, dynamic>.from(raw);
    if (!outer.containsKey(dateKey)) return null;
    final inner = Map<String, dynamic>.from(outer[dateKey]);
    final Map<String, DateTime> innerMap = {};
    inner.forEach((k, v) {
      innerMap[k] = DateTime.fromMillisecondsSinceEpoch(v as int);
    });
    return innerMap;
  }


  Future<void> saveFinalTimesForDates(
      Map<String, Map<String, DateTime>> data) async {
    final box = await _openBox();
    final raw = box.get(keyFinalTimes) as Map<String, dynamic>? ?? {};
    final merged = Map<String, dynamic>.from(raw);
    data.forEach((dateKey, inner) {
      final outInner = <String, int>{};
      inner.forEach((k, v) =>
      outInner[k] = v
          .toUtc()
          .millisecondsSinceEpoch);
      merged[dateKey] = outInner;
    });
    await box.put(keyFinalTimes, merged);
    if (kDebugMode) debugPrint(
        '💾 PrayerCache: saved finalTimes for dates=${data.keys.toList()}');
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
    if (kDebugMode) debugPrint(
        '💾 PrayerCache: set last_update_month=$monthKey');
  }
}