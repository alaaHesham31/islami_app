import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import '../../../../../services/notifications_services/location_helper.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_image.dart';
import '../../../../../utils/app_styles.dart';
import '../../../azkar/azkar_list_section.dart';
import '../providers/prayer_times_notifier.dart';

class TimeTab extends ConsumerStatefulWidget {
  const TimeTab({super.key});

  @override
  ConsumerState<TimeTab> createState() => _TimeTabState();
}

class _TimeTabState extends ConsumerState<TimeTab>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  static const Map<String, String> _prayerNameAr = {
    'Fajr': 'الفجر',
    'Dhuhr': 'الظهر',
    'Asr': 'العصر',
    'Maghrib': 'المغرب',
    'Isha': 'العشاء',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final state = ref.read(prayerTimesNotifierProvider);
        if (state.times == null || state.times!.isEmpty) {
          final pos = await LocationService.getCurrentLocation();
          await ref
              .read(prayerTimesNotifierProvider.notifier)
              .load(pos.latitude, pos.longitude);
        }
      } catch (e) {
        if (kDebugMode) debugPrint('TimeTab init load error: $e');
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes % 60;
    if (hours > 0) {
      return '${hours}س ${minutes}د';
    } else {
      return '${minutes}د';
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ScreenUtil.init(context);

    final state = ref.watch(prayerTimesNotifierProvider);

    ref.listen<PrayerTimesState>(prayerTimesNotifierProvider, (previous, next) {
      final prevNext = previous?.nextPrayer;
      final newNext = next.nextPrayer;
      if (newNext != null && newNext != prevNext) {
        final keys = next.times?.keys.toList() ?? [];
        final index = keys.indexOf(newNext);
        if (index != -1 && _scrollController.hasClients) {
          _scrollController.animateTo(
            index * 120.0,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
          );
        }
      }
    });

    final gregorian = DateFormat('dd MMM, \nyyyy', 'ar').format(DateTime.now());
    final hijri = HijriCalendar.now().toFormat("dd MMM, \nyyyy");

    if (state.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.times == null || state.times!.isEmpty) {
      return Center(
        child: Text('فشل في تحميل مواقيت الصلاة', style: AppStyles.semi16White),
      );
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImage.timeBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              Image.asset(AppImage.logoHeader),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 280.h,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.brownColor,
                          borderRadius: BorderRadius.circular(40.r),
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
                                  'مواقيت الصلاة\n${DateFormat('EEEE', 'ar').format(DateTime.now())}',
                                  style: AppStyles.semi20Brown,
                                  textAlign: TextAlign.center,
                                ),
                                Text(hijri,
                                    style: AppStyles.semi16White,
                                    textAlign: TextAlign.end),
                              ],
                            ),
                            SizedBox(height: 24.h),
                            SizedBox(
                              height: 140.h,
                              child: ListView.separated(
                                controller: _scrollController,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final keys = state.times!.keys.toList();
                                  final name = keys[index];
                                  final time = state.times![name]!;
                                  final formatted =
                                      "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
                                  return Align(
                                    alignment: Alignment.bottomCenter,
                                    child: _buildPrayTimeCard(
                                        name, formatted, state.nextPrayer),
                                  );
                                },
                                separatorBuilder: (_, __) => SizedBox(width: 12.w),
                                itemCount: state.times!.length,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: 'الصلاة التالية ',
                                    style: AppStyles.semi16Brown,
                                    children: [
                                      TextSpan(
                                        text: state.nextPrayer != null
                                            ? '- ${_prayerNameAr[state.nextPrayer!] ?? state.nextPrayer} بعد ${_formatDuration(state.timeRemaining!)}'
                                            : ' - لا يوجد',
                                        style: AppStyles.semi16Black,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
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

  Widget _buildPrayTimeCard(String name, String time, String? nextPrayer) {
    final isNext = name == nextPrayer;
    final parsed = DateFormat("HH:mm").parse(time);
    final formatted = DateFormat("hh:mm", 'ar').format(parsed);
    final amPm = DateFormat("a", 'ar').format(parsed).toLowerCase();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isNext ? 170.h : 120.h,
      width: isNext ? 120.w : 90.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: LinearGradient(
          colors: [AppColors.blackColor, AppColors.brownColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(_prayerNameAr[name] ?? name,
              style: isNext ? AppStyles.bold22White : AppStyles.bold20White),
          Column(
            children: [
              Text(formatted,
                  style: isNext ? AppStyles.bold32White : AppStyles.bold28White),
              Text(amPm, style: AppStyles.small14White70),
            ],
          ),
          if (isNext) Text('الصلاة القادمة', style: AppStyles.bold14White),
        ],
      ),
    );
  }
}
