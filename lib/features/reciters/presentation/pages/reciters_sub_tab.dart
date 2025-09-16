import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_styles.dart';
import '../providers/reciters_provider.dart';
import 'reciter_surah_list_screen.dart';

class RecitersSubTab extends ConsumerWidget {
  const RecitersSubTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncReciters = ref.watch(getAllRecitersProvider);

    return asyncReciters.when(
      data: (reciters) {
        if (reciters.isEmpty) {
          return Center(
            child: Text(
              "لا يوجد مقرئين متاحين حاليًا",
              style: AppStyles.bold16White,
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: reciters.length,
          separatorBuilder: (_, __) => Divider(color: AppColors.primaryColor, endIndent: 30.w, indent: 30.w,),
          itemBuilder: (context, index) {
            final reciter = reciters[index];
            return ListTile(
              title: Text(
                reciter.name ,
                style: AppStyles.bold16White,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.whiteColor,
                size: 18,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReciterSurahListScreen(reciter: reciter),
                  ),
                );
              },
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      ),
      error: (err, _) => Center(
        child: Text(
          "تعذر تحميل قائمة المقرئين\nيرجى التحقق من الاتصال بالإنترنت",
          textAlign: TextAlign.center,
          style: AppStyles.bold16White,
        ),
      ),
    );
  }
}
