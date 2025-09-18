import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_image.dart';
import '../../../utils/app_styles.dart';
import 'azkar_details_screen.dart';
import 'azkar_provider.dart';

class AzkarListSection extends ConsumerWidget {
  AzkarListSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var azkarAsync = ref.watch(azkarListProvider);

    return azkarAsync.when(
      error: (error, stack) => Center(child: Text('Error: $error')),
      loading:
          () => Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          ),
      data: (azkar) {
        final categories = azkar.keys.toList();

        return GridView.builder(
          itemCount: categories.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 8,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            final items = azkar[category];
            return InkWell(
              onTap: () async {
                Navigator.pushNamed(
                  context,
                  AzkarDetailsScreen.routeName,
                  arguments: {"category": category, "items": items},
                );
              },
              child: buildAzkarItem(categories[index], index),
            );
          },
        );
      },
    );
  }

  List<String> images = [
    AppImage.azkar1,
    AppImage.azkar2,
    AppImage.azkar3,
    AppImage.azkar4,
    AppImage.azkar5,
    AppImage.azkar6,
    AppImage.azkar7,
    AppImage.azkar8,
  ];

  buildAzkarItem(String title, int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.blackColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryColor, width: 2),
      ),
      child: Column(
        children: [
          Image.asset(images[index]),
          SizedBox(height: 8),
          Text(
            title,
            style: AppStyles.bold16White,
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }
}
