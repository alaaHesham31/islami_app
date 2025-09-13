import 'package:flutter/material.dart';
import 'package:islami_app_demo/model/AzkarModel.dart';
import 'package:islami_app_demo/theme/app_colors.dart';
import 'package:islami_app_demo/theme/app_image.dart';

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
        padding: EdgeInsets.all(50),
        decoration: BoxDecoration(
          color: AppColors.blackColor,
          image: DecorationImage(
            image: AssetImage(AppImage.detailsScreenBackground),
            fit: BoxFit.fill,
          ),
        ),
        child: ListView.separated(
          itemCount: items.length,
          separatorBuilder: (context, index) => SizedBox(height: 16),
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.blackColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                    border: Border.all(color: AppColors.primaryColor, width: 2),
                  ),
                  child: Text(
                   items[index].content ?? '',
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          border: Border.all(
                            color: AppColors.brownColor,
                            width: 2,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          items[index].count ?? '0',
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      VerticalDivider(
                        color: AppColors.whiteColor,
                        width: 2,
                        endIndent: 6,
                      ),
                      Text(
                        'Count',
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
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
