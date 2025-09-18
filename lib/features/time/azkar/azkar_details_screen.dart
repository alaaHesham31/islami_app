import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami_app_demo/features/time/azkar/AzkarModel.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_styles.dart';

class AzkarDetailsScreen extends StatelessWidget {
  static const String routeName = 'azkar-details';

  const AzkarDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final String category = args["category"];
    final List<AzkarModel> items = args["items"];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(category, style: TextStyle(color: AppColors.primaryColor)),
      ),
      body: Container(
        padding:  EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.blackColor,
        ),
        child: ListView.separated(
          itemCount: items.length,
          separatorBuilder: (context, index) =>  SizedBox(height: 40.h),
          itemBuilder: (context, index) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  padding:  EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w , bottom: 32.h),
                  decoration: BoxDecoration(
                    color: AppColors.blackColor,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.primaryColor, width: 1),
                  ),
                  child: Text(
                    items[index].content ?? '',
                    style: AppStyles.bold18White,
                    textAlign: TextAlign.start,
                  ),
                ),

                Positioned(
                  bottom: -20,
                  left: 0,
                  right: 0,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'التكرار',
                          style: AppStyles.semi18White,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            items[index].count ?? '0',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
