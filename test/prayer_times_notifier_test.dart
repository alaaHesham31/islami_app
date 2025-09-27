import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islami_app_demo/features/time/prayer_times/domain/usecases/get_prayer_times.dart';
import 'package:islami_app_demo/features/time/prayer_times/presentation/providers/prayer_times_notifier.dart';
import 'package:islami_app_demo/features/time/prayer_times/domain/repositories/prayer_repository.dart';

class FakeRepo implements PrayerRepository {
  final Map<String, DateTime> times;
  FakeRepo(this.times);
  @override
  Future<Map<String, DateTime>> getPrayerTimes(double lat, double lng, {DateTime? date, bool forceRefresh = false}) async {
    return times;
  }
}

void main() {
  test('PrayerTimesNotifier.load sets times and nextPrayer correctly', () async {
    final now = DateTime.now();
    final times = {
      'Fajr': now.add(const Duration(minutes: -60)),
      'Dhuhr': now.add(const Duration(minutes: 120)),
      'Asr': now.add(const Duration(minutes: 240)),
      'Maghrib': now.add(const Duration(minutes: 360)),
      'Isha': now.add(const Duration(minutes: 480)),
    };

    final container = ProviderContainer(overrides: [
      // override the usecase provider with one that uses our fake repo
      getPrayerTimesUsecaseProvider.overrideWithValue(GetPrayerTimes(FakeRepo(times))),
    ]);

    addTearDown(container.dispose);

    final notifier = container.read(prayerTimesNotifierProvider.notifier);
    await notifier.load(0.0, 0.0);

    final state = container.read(prayerTimesNotifierProvider);

    expect(state.times, isNotNull);
    expect(state.nextPrayer, 'Dhuhr'); // first future prayer in times map order
    expect(state.timeRemaining, isNotNull);
    expect(state.loading, false);
  });
}
