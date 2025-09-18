import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../providers/quran_provider.dart';


import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_image.dart';
import '../../../../../utils/app_styles.dart';
import '../widgets/most_recently_widget.dart';
import '../widgets/surah_details_screen.dart';
import '../widgets/surah_list_widget.dart';

class QuranTab extends ConsumerWidget {
  static const String routeName = 'quranTab';

  const QuranTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahsAsync = ref.watch(surahsProvider);
    final searchText = ref.watch(quranSearchProvider);
    final recent = ref.watch(recentSurasProvider);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset(AppImage.quranBackground, fit: BoxFit.cover)),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(AppImage.logoHeader),
                    SizedBox(height: 12.h),

                    // Search Field
                    TextFormField(
                      onChanged: (text) {
                        ref.read(quranSearchProvider.notifier).state = text;
                      },
                      style: AppStyles.bold16White.copyWith(color: AppColors.whiteColor),
                      cursorColor: AppColors.whiteColor,
                      decoration: InputDecoration(
                        hintText: 'اسم السورة',
                        hintStyle: AppStyles.bold16White.copyWith(color: AppColors.whiteColor.withValues(alpha: 0.7)),
                        prefixIcon: ImageIcon(
                          AssetImage(AppImage.searchIcon),
                          color: AppColors.primaryColor,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide(color: AppColors.primaryColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide(color: AppColors.primaryColor),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    if (searchText.isEmpty) ...[
                      Text('المقروءة مؤخراً', style: AppStyles.bold16White),
                      SizedBox(height: 12.h),
                      if (recent.isEmpty)
                        Center(
                          child: Text('لا توجد سورة مقروءة بعد', style: AppStyles.bold16Primary),
                        )
                      else
                        SizedBox(
                          height: 180.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: recent.length,
                            itemBuilder: (context, index) {
                              final item = recent[index];
                              if (item.length != 3) return const SizedBox.shrink();
                              return MostRecentlyWidget(
                                suraEnName: item[0],
                                suraArName: item[1],
                                versesNum: item[2],
                              );
                            },
                          ),
                        ),
                      SizedBox(height: 20.h),
                    ],

                    Text('قائمة السور', style: AppStyles.bold16White),
                    SizedBox(height: 20.h),

                    surahsAsync.when(
                      data: (surahs) {
                        final filtered = surahs.where((s) {
                          final q = searchText.trim();
                          if (q.isEmpty) return true;
                          final arabicMatch = s.arabicName.contains(q);
                          final englishMatch = s.englishName.toLowerCase().contains(q.toLowerCase());
                          return arabicMatch || englishMatch;
                        }).toList();

                        return SizedBox(
                          height: 400.h,
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            itemCount: filtered.length,
                            separatorBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.all(8.r),
                                child: Divider(
                                  height: 2.h,
                                  indent: 30.w,
                                  endIndent: 30.w,
                                  color: AppColors.primaryColor,
                                ),
                              );
                            },
                            itemBuilder: (context, index) {
                              final sura = filtered[index];
                              return InkWell(
                                onTap: () {
                                  ref.read(recentSurasProvider.notifier).addRecent(sura);

                                  Navigator.pushNamed(
                                    context,
                                    SuraDetailsScreen.routeName,
                                    arguments: sura,
                                  );
                                },
                                child: SurasListWidget(surahModel: sura, index: index),
                              );
                            },
                          ),
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, st) => Center(child: Text('حدث خطأ عند تحميل السور')),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
