import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



import '../../../../utils/app_colors.dart';
import '../../../../utils/app_image.dart';
import '../../../../utils/app_styles.dart';
import '../../domain/entities/surah.dart';
import '../providers/quran_provider.dart';

class SuraDetailsScreen extends ConsumerWidget {
  static const String routeName = 'suraDetailsScreen';

  const SuraDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == null || args is! Sura) {
      return const Scaffold(
        body: Center(child: Text('بيانات السورة غير متوفرة')),
      );
    }
    final Sura sura = args;

    final versesAsync = ref.watch(suraVersesProvider(sura.id));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          sura.arabicName,
          style: AppStyles.bold16Primary,
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(top: 30.h),
            decoration: BoxDecoration(
              color: AppColors.blackColor,
              image: DecorationImage(
                image: AssetImage(AppImage.detailsScreenBackground),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: 20.h),
              Text(
                sura.arabicName,
                style: AppStyles.bold22Primary,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: versesAsync.when(
                  data: (verses) {
                    if (verses.isEmpty) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: verses.length,
                      itemBuilder: (context, index) {
                        final verse = verses[index].trim();
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 32.w),
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(color: AppColors.primaryColor),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: Text(
                                ' ${verse} [${index + 1}]',
                                style: AppStyles.bold16Primary.copyWith(fontSize: 20.sp),
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, st) => Center(child: Text('حدث خطأ عند تحميل الآيات')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
