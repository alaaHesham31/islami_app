import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/prayer_repository_impl.dart';
import '../../domain/repositories/prayer_repository.dart';
import '../../domain/usecases/get_prayer_times.dart';


final prayerRepositoryProvider = Provider<PrayerRepository>((ref) {
  return PrayerRepositoryImpl();
});

final getPrayerTimesUsecaseProvider = Provider<GetPrayerTimes>((ref) {
  final repo = ref.read(prayerRepositoryProvider);
  return GetPrayerTimes(repo);
});

class PrayerTimesState {
  final Map<String, DateTime>? times;
  final String? nextPrayer;
  final Duration? timeRemaining;
  final bool loading;
  final String? error;

  PrayerTimesState({
    this.times,
    this.nextPrayer,
    this.timeRemaining,
    this.loading = false,
    this.error,
  });

  PrayerTimesState copyWith({
    Map<String, DateTime>? times,
    String? nextPrayer,
    Duration? timeRemaining,
    bool? loading,
    String? error,
  }) {
    return PrayerTimesState(
      times: times ?? this.times,
      nextPrayer: nextPrayer ?? this.nextPrayer,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }
}

class PrayerTimesNotifier extends StateNotifier<PrayerTimesState> {
  final GetPrayerTimes _getPrayerTimes;
  PrayerTimesNotifier(this._getPrayerTimes)
      : super(PrayerTimesState(loading: true));

  Future<void> load(double lat, double lng, {DateTime? date}) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final times =
      await _getPrayerTimes.call(lat, lng, date: date, forceRefresh: false);
      final now = DateTime.now();
      String? next;
      Duration? remain;
      for (final entry in times.entries) {
        if (entry.value.isAfter(now)) {
          next = entry.key;
          remain = entry.value.difference(now);
          break;
        }
      }
      state = state.copyWith(
        times: times,
        nextPrayer: next,
        timeRemaining: remain,
        loading: false,
      );
    } catch (e, st) {
      if (kDebugMode) debugPrint('❌ Error loading prayer times: $e $st');
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }
}

final prayerTimesNotifierProvider =
StateNotifierProvider<PrayerTimesNotifier, PrayerTimesState>((ref) {
  final usecase = ref.read(getPrayerTimesUsecaseProvider);
  return PrayerTimesNotifier(usecase);
});
