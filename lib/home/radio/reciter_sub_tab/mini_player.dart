import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'surah_player_notifier.dart';
import 'surah_player_states.dart';
import 'package:islami_app_demo/theme/app_colors.dart';
import 'package:islami_app_demo/theme/app_styles.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(surahPlayerProvider);
    final surahPlayer = ref.read(surahPlayerProvider.notifier);
    final position = ref.watch(positionProvider).asData?.value ?? Duration.zero;

    if (playerState.currentSurahId == null) {
      return const SizedBox.shrink(); // hidden if nothing is playing
    }

    final durationSeconds =
    playerState.duration.inSeconds.toDouble().clamp(0.0, double.infinity);
    final positionSeconds =
    position.inSeconds.toDouble().clamp(0.0, durationSeconds);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.blackColor, // darker to differentiate
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 6,
            offset: const Offset(0, -2),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Surah + Reciter Info
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playerState.currentSurahName ?? '',
                      style: AppStyles.bold16Primary.copyWith(color: Colors.white),
                    ),
                    Text(
                      playerState.currentReciterName ?? '',
                      style: AppStyles.semi16White.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              if (playerState.status == PlayerStatus.loading)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              else
                IconButton(
                  onPressed: () {
                    if (playerState.status == PlayerStatus.playing) {
                      surahPlayer.pause();
                    } else {
                      surahPlayer.resume();
                    }
                  },
                  icon: FaIcon(
                    playerState.status == PlayerStatus.playing
                        ? FontAwesomeIcons.pause
                        : FontAwesomeIcons.play,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              IconButton(
                onPressed: () => surahPlayer.stop(),
                icon: const FaIcon(
                  FontAwesomeIcons.stop,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),

          // Progress bar + Time
          if (durationSeconds > 0)
            Row(
              children: [
                Text(
                  _formatDuration(position),
                  style: AppStyles.semi16Black.copyWith(color: Colors.white),
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 2,
                      thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 6),
                    ),
                    child: Slider(
                      min: 0,
                      max: durationSeconds,
                      value: positionSeconds,
                      onChanged: (v) {
                        final seekTo = Duration(seconds: v.toInt());
                        surahPlayer.seek(seekTo);
                      },
                      activeColor: AppColors.primaryColor,
                      inactiveColor: Colors.white24,
                    ),
                  ),
                ),
                Text(
                  _formatDuration(playerState.duration),
                  style: AppStyles.semi16Black.copyWith(color: Colors.white),
                ),
              ],
            ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');

    if (hours > 0) {
      return "$hours:$minutes:$seconds"; // e.g. 2:37:15
    } else {
      return "$minutes:$seconds"; // e.g. 05:32
    }
  }
}
