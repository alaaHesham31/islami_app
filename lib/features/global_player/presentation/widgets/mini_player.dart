// // lib/home/radio/global_player/mini_player.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//
// import '../../../../utils/app_colors.dart';
// import '../../../../utils/app_styles.dart';
// import '../../domain/entities/global_player_state.dart';
// import '../providers/global_player_provider.dart';
//
// class MiniPlayer extends ConsumerWidget {
//   const MiniPlayer({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // AsyncValue<GlobalPlayerState>
//     final playerStateAsync = ref.watch(globalPlayerProvider);
//
//     // Repository that exposes play/pause/stop/seek/toggleMute
//     final repo = ref.read(globalPlayerRepositoryProvider);
//
//     return playerStateAsync.when(
//       data: (state) {
//         // keep behavior same as original: hide if stopped or no url
//         if (state.status == PlayerStatus.stopped || state.url == null) {
//           return const SizedBox.shrink();
//         }
//
//         // durations & clamps
//         final duration = state.duration;
//         final position = state.position;
//         final durationSeconds = duration.inSeconds.toDouble().clamp(0.0, double.infinity);
//         final positionSeconds = position.inSeconds.toDouble().clamp(0.0, durationSeconds);
//
//         // error UI (same idea as original)
//         if (state.errorMessage != null) {
//           return Container(
//             padding: EdgeInsets.all(12.w),
//             color: Colors.redAccent,
//             child: Row(
//               children: [
//                 const Icon(Icons.error_outline, color: Colors.white),
//                 SizedBox(width: 8.w),
//                 Expanded(
//                   child: Text(
//                     state.errorMessage!,
//                     style: AppStyles.semi16White,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.close, color: Colors.white),
//                   onPressed: () {
//                     repo.stop();
//                   },
//                 ),
//               ],
//             ),
//           );
//         }
//
//         // normal mini player
//         return Container(
//           padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
//           decoration: BoxDecoration(
//             color: AppColors.blackColor,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(16.r),
//               topRight: Radius.circular(16.r),
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.25),
//                 blurRadius: 6.r,
//                 offset: const Offset(0, -2),
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // title + controls row
//               Row(
//                 children: [
//                   // title & subtitle
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           state.title ?? '',
//                           style: AppStyles.bold16Primary.copyWith(color: Colors.white),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         if (state.subtitle != null)
//                           Text(
//                             state.subtitle!,
//                             style: AppStyles.semi16White.copyWith(color: Colors.white70),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                       ],
//                     ),
//                   ),
//
//                   // loading indicator or play/pause
//                   if (state.status == PlayerStatus.loading)
//                     SizedBox(
//                       width: 24.w,
//                       height: 24.h,
//                       child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
//                     )
//                   else
//                     IconButton(
//                       onPressed: () {
//                         // toggle play/pause for the current loaded source
//                         if (state.status == PlayerStatus.playing) {
//                           repo.pause();
//                         } else {
//                           repo.resume();
//                         }
//                       },
//                       icon: FaIcon(
//                         state.status == PlayerStatus.playing ? FontAwesomeIcons.pause : FontAwesomeIcons.play,
//                         color: Colors.white,
//                         size: 20.sp,
//                       ),
//                     ),
//
//                   // stop button
//                   IconButton(
//                     onPressed: () => repo.stop(),
//                     icon: FaIcon(
//                       FontAwesomeIcons.stop,
//                       color: Colors.white,
//                       size: 20.sp,
//                     ),
//                   ),
//                 ],
//               ),
//
//               // progress slider for reciter playback only
//               if (state.sourceType == PlayerSourceType.reciter && durationSeconds > 0)
//                 Row(
//                   children: [
//                     Text(
//                       _formatDuration(position),
//                       style: AppStyles.semi16White.copyWith(color: Colors.white),
//                     ),
//                     SizedBox(width: 8.w),
//                     Expanded(
//                       child: SliderTheme(
//                         data: SliderTheme.of(context).copyWith(
//                           trackHeight: 2.h,
//                           thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
//                         ),
//                         child: Slider(
//                           min: 0,
//                           max: durationSeconds,
//                           value: positionSeconds,
//                           onChanged: (v) {
//                             repo.seek(Duration(seconds: v.toInt()));
//                           },
//                           activeColor: AppColors.primaryColor,
//                           inactiveColor: Colors.white24,
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 8.w),
//                     Text(
//                       _formatDuration(duration),
//                       style: AppStyles.semi16White.copyWith(color: Colors.white),
//                     ),
//                   ],
//                 ),
//             ],
//           ),
//         );
//       },
//       loading: () => const SizedBox.shrink(),
//       error: (err, _) {
//         // keep UI quiet on provider-level errors
//         return const SizedBox.shrink();
//       },
//     );
//   }
//
//   String _formatDuration(Duration d) {
//     final hours = d.inHours;
//     final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
//     final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
//     return hours > 0 ? "$hours:$minutes:$seconds" : "$minutes:$seconds";
//   }
// }
