import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:islami_app_demo/home/radio/reciter_sub_tab/mini_player.dart';
import 'package:islami_app_demo/home/radio/reciter_sub_tab/reciter_provider.dart';
import 'package:islami_app_demo/home/radio/reciter_sub_tab/surah_player_notifier.dart';
import 'package:islami_app_demo/theme/app_colors.dart' show AppColors;
import 'package:islami_app_demo/theme/app_image.dart';
import 'package:islami_app_demo/theme/app_styles.dart';
import 'package:islami_app_demo/model/ReciterModel.dart';

import '../radio_sub_tab/radio_player_states.dart';

class ReciterSurahListScreen extends ConsumerWidget {
  static const String routeName = 'reciter-surah-list_screen';

  const ReciterSurahListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var suraNamesAsync = ref.watch(surahNamesListProvider);
    // final currentPlayingId = ref.watch(surahPlayerProvider);
    final playerState = ref.watch(surahPlayerProvider);
    final surahPlayer = ref.read(surahPlayerProvider.notifier);

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final reciterName = args['name'] as String;
    final moshaf = args['moshaf'] as MoshafModel;

    return suraNamesAsync.when(
      error: (error, stack) => Text('Error: $error'),
      loading:
          () => Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          ),
      data: (sura) {
        return Scaffold(
          appBar: AppBar(
            title: Text(reciterName, style: AppStyles.bold16Primary),
            centerTitle: true,
          ),
          body: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.blackColor),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: sura.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final suraItem = sura[index];
                      final isThisPlaying = playerState.currentSurahId == suraItem.id && playerState.status == PlayerStatus.playing;

                      return Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Text(
                              suraItem.arabicName ?? '',
                              style: AppStyles.semi16Black,
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: Image(
                                image: AssetImage(AppImage.downloadIcon),
                                height: 20,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                final surahNumber = suraItem.id.toString().padLeft(3, '0');
                                final url = "${moshaf.server}$surahNumber.mp3";

                                if (isThisPlaying) {
                                  surahPlayer.pause();
                                } else {
                                  surahPlayer.play(url, suraItem.id?.toInt() ?? 0, suraItem.arabicName ?? '', reciterName);
                                }
                              },
                              icon: isThisPlaying
                                  ? FaIcon(FontAwesomeIcons.pause, color: AppColors.blackColor, size: 20)
                                  : FaIcon(FontAwesomeIcons.play, color: AppColors.blackColor, size: 20),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const MiniPlayer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
