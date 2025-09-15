import 'package:flutter/material.dart';
import 'package:islami_app_demo/model/AzkarModel.dart';

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
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.blackColor,
        ),
        child: ListView.separated(
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 40),
          itemBuilder: (context, index) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                // Main Azkar container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20 , bottom: 32),
                  decoration: BoxDecoration(
                    color: AppColors.blackColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primaryColor, width: 1),
                  ),
                  child: Text(
                    items[index].content ?? '',
                    style: AppStyles.bold18White,
                    textAlign: TextAlign.end,
                  ),
                ),

                // Positioned repetition container
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
                         Text(
                          'التكرار',
                          style: AppStyles.semi18White,
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
