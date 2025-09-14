import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:islami_app_demo/home/time/azkar/azkar_list_section.dart';
import 'package:islami_app_demo/home/time/prayer_times/prayer_repository.dart';
import 'package:islami_app_demo/theme/app_image.dart';
import 'package:islami_app_demo/theme/app_styles.dart';
import '../../services/location_helper.dart';
import '../../theme/app_colors.dart' show AppColors;

class TimeTab extends StatefulWidget {
  const TimeTab({super.key});

  @override
  State<TimeTab> createState() => _TimeTabState();
}

class _TimeTabState extends State<TimeTab> {
  Map<String, DateTime>? _prayerTimes;
  String? _nextPrayer;
  Duration? _timeRemaining;

  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();
  }

  Future<void> _loadPrayerTimes() async {
    try {
      final pos = await LocationService.getCurrentLocation();
      final repo = PrayerRepository();
      final times = await repo.getPrayerTimes(pos.latitude, pos.longitude);

      // Find next prayer
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

      if (mounted) {
        setState(() {
          _prayerTimes = times;
          _nextPrayer = next;
          _timeRemaining = remain;
        });
      }
    } catch (e) {
      debugPrint("❌ Error loading prayer times: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_prayerTimes == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(AppImage.timeBackground)),
      ),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.asset(AppImage.logoHeader),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 280,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.brownColor,
                          borderRadius: BorderRadius.circular(40),
                          image: DecorationImage(
                            image: AssetImage(AppImage.prayerTimesBg),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${DateTime.now().day} ${DateTime.now().month}\n${DateTime.now().year}',
                                  style: AppStyles.semi16White,
                                ),
                                Text(
                                  'Pray Time\nToday',
                                  style: AppStyles.semi20Brown,
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  '', // You can add Hijri date later
                                  style: AppStyles.semi16White,
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 140,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final keys = _prayerTimes!.keys.toList();
                                  final name = keys[index];
                                  final time = _prayerTimes![name]!;
                                  final formatted =
                                      "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
                                  return buildPrayTimeCard(name, formatted);
                                },
                                separatorBuilder: (_, __) => const SizedBox(width: 12),
                                itemCount: _prayerTimes!.length,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: 'Next Pray ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.brownColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: _nextPrayer != null
                                            ? '- $_nextPrayer in ${_timeRemaining?.inMinutes ?? 0}m'
                                            : ' - None',
                                        style: AppStyles.semi16Black,
                                      ),
                                    ],
                                  ),
                                ),
                                const FaIcon(FontAwesomeIcons.volumeXmark),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      AzkarListSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPrayTimeCard(String name, String time) {
    return Container(
      height: 120,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.blackColor, AppColors.brownColor],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(name,
              style: const TextStyle(
                  fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700)),
          Text(time,
              style: const TextStyle(
                  fontSize: 32, color: Colors.white, fontWeight: FontWeight.w700)),
          Text("",
              style: const TextStyle(
                  fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
