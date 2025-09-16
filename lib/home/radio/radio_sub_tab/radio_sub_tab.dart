// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:islami_app_demo/home/radio/global_player/global_play_states.dart';
// import 'package:islami_app_demo/home/radio/global_player/global_player_notifier.dart';
// import 'package:islami_app_demo/home/radio/radio_sub_tab/radio_provider.dart';
// import '../../../utils/app_colors.dart';
// import '../../../utils/app_image.dart';
//
// class RadioSubTabContent extends ConsumerWidget {
//   const RadioSubTabContent({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final radiosAsync = ref.watch(radioListProvider);
//     final playerState = ref.watch(globalPlayerProvider);
//     final player = ref.read(globalPlayerProvider.notifier);
//
//
//     return radiosAsync.when(
//       loading: () =>
//       const Center(child: CircularProgressIndicator(color: AppColors.primaryColor)),
//       error: (err, stack) => Center(child: Text("Error: $err")),
//       data: (radios) {
//         return ListView.separated(
//           padding: const EdgeInsets.only(bottom: 100),
//           separatorBuilder: (_, __) => const SizedBox(height: 16),
//           itemCount: radios.length,
//           itemBuilder: (context, index) {
//             final radio = radios[index];
//             final isThisRadio = playerState.url == radio.url;
//             final isPlayingThis =
//                 isThisRadio && playerState.status == PlayerStatus.playing;
//
//             return Container(
//               height: 120,
//               decoration: BoxDecoration(
//                 color: AppColors.primaryColor,
//                 borderRadius: BorderRadius.circular(20),
//                 image: DecorationImage(
//                   image: AssetImage(
//                     isPlayingThis ? AppImage.soundWaveImage : AppImage.mosqueImage,
//                   ),
//                   fit: BoxFit.contain,
//                   alignment: Alignment.bottomCenter,
//                 ),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   children: [
//                     AutoSizeText(
//                       radio.name ?? '',
//                       style: const TextStyle(
//                         color: AppColors.blackColor,
//                         fontSize: 20,
//                         fontWeight: FontWeight.w500,
//                       ),
//                       minFontSize: 18,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         IconButton(
//                           onPressed: () {
//                             if (isPlayingThis) {
//                               player.pause();
//                             } else {
//                               player.playOrToggleRadio(radio.url ?? '', radio.name ?? '');
//                             }
//                           },
//                           icon: FaIcon(
//                             isPlayingThis
//                                 ? FontAwesomeIcons.pause
//                                 : FontAwesomeIcons.play,
//                             color: AppColors.blackColor,
//                             size: 24,
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: player.toggleMute,
//                           icon: FaIcon(
//                             playerState.isMuted
//                                 ? FontAwesomeIcons.volumeXmark
//                                 : FontAwesomeIcons.volumeHigh,
//                             color: AppColors.blackColor,
//                             size: 20,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
