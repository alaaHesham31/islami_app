import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islami_app_demo/home/radio/reciter_sub_tab/reciter_provider.dart';
import 'package:islami_app_demo/home/radio/reciter_sub_tab/reciter_surah_list_screen.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_styles.dart';

class RecitersSubTab extends ConsumerWidget {
  const RecitersSubTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reciterAsync = ref.watch(recitersNamesListProvider);
    return reciterAsync.when(
      error: (error, stack) => Text('Error: $error', style: AppStyles.semi16White,),
      loading:
          () => Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          ),
      data: (reciters) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: reciters.length,
            separatorBuilder: (context, index) {
              return SizedBox(height: 16);
            },
            itemBuilder: (context, index) {
              final reciter = reciters[index];
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    ReciterSurahListScreen.routeName,
                    arguments: {"name" : reciter.name, "moshaf" : reciter.moshaf.first},
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(reciter.name, style: AppStyles.semi16Black),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.blackColor,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
