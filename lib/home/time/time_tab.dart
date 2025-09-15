import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:islami_app_demo/home/time/azkar/azkar_list_section.dart';
import 'package:islami_app_demo/home/time/prayer_times/prayer_repository.dart';
import '../../services/location_helper.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_image.dart';
import '../../utils/app_styles.dart';

class TimeTab extends StatefulWidget {
  const TimeTab({super.key});

  @override
  State<TimeTab> createState() => _TimeTabState();
}

class _TimeTabState extends State<TimeTab> {
  Map<String, DateTime>? _prayerTimes;
  String? _nextPrayer;
  Duration? _timeRemaining;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_prayerTimes != null && _nextPrayer != null) {
        final keys = _prayerTimes!.keys.toList();
        final index = keys.indexOf(_nextPrayer!);
        if (index != -1) {
          _scrollController.animateTo(
            index * 120.0,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
          );
        }
      }
    });
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  Future<void> _loadPrayerTimes() async {
    try {
      final pos = await LocationService.getCurrentLocation();
      final repo = PrayerRepository();
      final times = await repo.getPrayerTimes(pos.latitude, pos.longitude);

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
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final gregorian = DateFormat('dd MMM, \nyyyy').format(DateTime.now());

    final hijri = HijriCalendar.now().toFormat("dd MMM, \nyyyy");
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
                                Text(gregorian, style: AppStyles.semi16White),
                                Text(
                                  'Pray Time\n${DateFormat('EEEE').format(DateTime.now())}',
                                  // Day name instead of "Today"
                                  style: AppStyles.semi20Brown,
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  hijri,
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
                                  return Align(
                                    alignment: Alignment.bottomCenter,
                                    child: buildPrayTimeCard(name, formatted),
                                  );
                                },
                                separatorBuilder:
                                    (_, __) => const SizedBox(width: 12),
                                itemCount: _prayerTimes!.length,
                              ),
                            ),
                            const SizedBox(height: 12),
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
                                        text:
                                            _nextPrayer != null
                                                ? '- $_nextPrayer in ${_formatDuration(_timeRemaining!)}'
                                                : ' - None',
                                        style: AppStyles.semi16Black,
                                      ),
                                    ],
                                  ),
                                ),
                                // const FaIcon(FontAwesomeIcons.volumeXmark),
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
    final isNext = name == _nextPrayer;

    // Parse incoming "HH:mm" (24h) and reformat
    final parsed = DateFormat("HH:mm").parse(time);
    final formatted = DateFormat("hh:mm").format(parsed); // 12h
    final amPm = DateFormat("a").format(parsed); // AM/PM

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isNext ? 170 : 120,
      width: isNext ? 120 : 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [AppColors.blackColor, AppColors.brownColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: isNext ? 22 : 20,
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          Column(
            children: [
              Text(
                formatted,
                style: TextStyle(
                  fontSize: isNext ? 32 : 28,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                amPm.toLowerCase(),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (isNext)
            Text(
              "Next Prayer",
              style: TextStyle(
                fontSize: 14,
                color: AppColors.whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}
