// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../../utils/app_colors.dart';
// import '../../../../utils/app_styles.dart';
// import '../../domain/entities/azkar_entity.dart';
// import '../providers/azkar_provider.dart';
//
// class AzkarDetailsScreen extends ConsumerStatefulWidget {
//   static const String routeName = 'azkar-details';
//
//   const AzkarDetailsScreen({super.key});
//
//   @override
//   ConsumerState<AzkarDetailsScreen> createState() => _AzkarDetailsPageState();
// }
//
// class _AzkarDetailsPageState extends ConsumerState<AzkarDetailsScreen> {
//   late List<AzkarEntity> items;
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final args =
//     ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//     items = args["items"];
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(azkarCountsProvider.notifier).initCounts(items);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final counts = ref.watch(azkarCountsProvider);
//
//     if (counts.isEmpty) {
//       Future.delayed(const Duration(milliseconds: 400), () {
//         Navigator.pop(context);
//       });
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text("الأذكار", style: TextStyle(color: AppColors.primaryColor)),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.w),
//         child: ListView.builder(
//           itemCount: items.length,
//           itemBuilder: (context, index) {
//             if (!counts.containsKey(index)) {
//               return const SizedBox.shrink();
//             }
//
//             return AnimatedSlide(
//               duration: const Duration(milliseconds: 400),
//               offset: counts[index] == 0 ? const Offset(1, 0) : Offset.zero,
//               child: GestureDetector(
//                 onTap: () {
//                   ref.read(azkarCountsProvider.notifier).decrement(index);
//                 },
//                 child: Container(
//                   margin: EdgeInsets.only(bottom: 24.h),
//                   padding: EdgeInsets.all(16.w),
//                   decoration: BoxDecoration(
//                     color: AppColors.blackColor,
//                     borderRadius: BorderRadius.circular(12.r),
//                     border: Border.all(color: AppColors.primaryColor),
//                   ),
//                   child: Column(
//                     children: [
//                       Text(
//                         items[index].content ?? "",
//                         style: AppStyles.bold18White,
//                         textAlign: TextAlign.end,
//                       ),
//                       SizedBox(height: 12.h),
//                       Container(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 16.w, vertical: 6.h),
//                         decoration: BoxDecoration(
//                           color: AppColors.primaryColor,
//                           borderRadius: BorderRadius.circular(8.r),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Container(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 14.w, vertical: 6.h),
//                               decoration: BoxDecoration(
//                                 color: AppColors.whiteColor,
//                                 borderRadius: BorderRadius.circular(20.r),
//                               ),
//                               child: Text(
//                                 "${counts[index]}",
//                                 style: TextStyle(
//                                   color: AppColors.primaryColor,
//                                   fontSize: 16.sp,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             Text("التكرار", style: AppStyles.semi18White),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
