import 'package:adhan/adhan.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:islami_app_demo/features/time/prayer_times/data/datasources/prayer_api_service.dart';
import 'package:islami_app_demo/features/time/prayer_times/data/datasources/prayer_cache.dart';
import 'package:islami_app_demo/features/time/prayer_times/data/repositories/prayer_repository_impl.dart';

class MockApi extends Mock implements PrayerApiService {}
class MockCache extends Mock implements PrayerCache {}

void main() {
  setUpAll(() {
    // If mocktail needs fallback values for types used in any stubbing/calls.
    registerFallbackValue(DateTime(2000));
  });

  test('computes offsets when API returns different times and saves them', () async {
    final api = MockApi();
    final cache = MockCache();
    final repo = PrayerRepositoryImpl(api: api, cache: cache);

    final date = DateTime(2025, 9, 27);
    final lat = 30.0444;
    final lng = 31.2357;

    // compute local times using adhan exactly like repository does
    final comps = DateComponents.from(date);
    final coords = Coordinates(lat, lng);
    final params = CalculationMethod.muslim_world_league.getParameters()
      ..madhab = Madhab.shafi;
    final pt = PrayerTimes(coords, comps, params);

    final localTimes = {
      'Fajr': pt.fajr,
      'Dhuhr': pt.dhuhr,
      'Asr': pt.asr,
      'Maghrib': pt.maghrib,
      'Isha': pt.isha,
    };

    // Build apiTimes with a +3 minute drift for each prayer
    final apiTimes = <String, DateTime>{};
    localTimes.forEach((k, v) {
      apiTimes[k] = v.add(const Duration(minutes: 3));
    });

    when(() => cache.getFinalTimesForDateKey(any())).thenAnswer((_) async => null);
    when(() => cache.getOffsets()).thenAnswer((_) async => {});
    when(() => api.fetchPrayerTimes(lat, lng, date)).thenAnswer((_) async => apiTimes);
    when(() => cache.saveFinalTimesForDates(any())).thenAnswer((_) async {});
    when(() => cache.saveOffsets(any())).thenAnswer((_) async {});
    when(() => cache.setLastUpdateMonth(any())).thenAnswer((_) async {});

    final res = await repo.getPrayerTimes(lat, lng, date: date);

    // finalTime should be local + 3 minutes
    expect(res['Fajr']!.difference(localTimes['Fajr']!).inMinutes, 3);
    expect(res['Dhuhr']!.difference(localTimes['Dhuhr']!).inMinutes, 3);

    verify(() => cache.saveFinalTimesForDates(any())).called(1);
    verify(() => cache.saveOffsets(any())).called(1);
    verify(() => cache.setLastUpdateMonth(any())).called(1);
  });
}
