import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islami_app_demo/features/time/prayer_times/presentation/providers/prayer_times_notifier.dart';

class TestPrayersWidget extends ConsumerWidget {
  const TestPrayersWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(prayerTimesNotifierProvider);
    if (state.loading) return const CircularProgressIndicator();
    if (state.times == null || state.times!.isEmpty) return const Text('no-times');
    return Column(
      children: state.times!.entries.map((e) => Text('${e.key} - ${e.value.hour.toString().padLeft(2,'0')}:${e.value.minute.toString().padLeft(2,'0')}')).toList(),
    );
  }
}

void main() {
  testWidgets('TestPrayersWidget shows prayer names from provider state', (tester) async {
    final now = DateTime.now();
    final fakeState = PrayerTimesState(
      times: {
        'Fajr': now.add(const Duration(minutes: 10)),
        'Dhuhr': now.add(const Duration(minutes: 120)),
      },
      nextPrayer: 'Fajr',
      timeRemaining: const Duration(minutes: 10),
      loading: false,
    );

    final container = ProviderContainer(overrides: [
      // override provider with a StateNotifier pre-initialized to fakeState
      prayerTimesNotifierProvider.overrideWith((ref) {
        final n = PrayerTimesNotifier(ref.read(getPrayerTimesUsecaseProvider));
        n.state = fakeState;
        return n;
      })
    ]);

    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: TestPrayersWidget())),
      ),

    );

    await tester.pumpAndSettle();

    expect(find.textContaining('Fajr'), findsOneWidget);
    expect(find.textContaining('Dhuhr'), findsOneWidget);
  });
}
