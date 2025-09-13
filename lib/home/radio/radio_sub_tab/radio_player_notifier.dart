// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:islami_app_demo/home/radio/radio_sub_tab/radio_player_states.dart';
// import 'package:islami_app_demo/model/RadioResponseModel.dart';
//
// class RadioPlayerNotifier extends StateNotifier<RadioPlayerState> {
//   final AudioPlayer _player = AudioPlayer();
//
//   RadioPlayerNotifier() : super(RadioPlayerState());
//
//   Future<void> play(RadiosModel radio) async {
//     if (radio.url != null) {
//       await _player.play(UrlSource(radio.url!));
//       state = state.copyWith(currentRadio: radio, status: PlayerStatus.playing);
//     }
//   }
//
//   Future<void> pause() async {
//     await _player.pause();
//     state = state.copyWith(status: PlayerStatus.paused);
//   }
//
//   Future<void> stop() async {
//     await _player.stop();
//     state = state.copyWith(currentRadio: null, status: PlayerStatus.stopped);
//   }
//
//   Future<void> toggleMute(RadiosModel radio) async {
//     final url = radio.url!;
//     final currentMuted = state.isMuted(url);
//
//     if (currentMuted) {
//       await _player.setVolume(1);
//     } else {
//       await _player.setVolume(0);
//     }
//
//     final updatedMuteMap = Map<String, bool>.from(state.muteMap)
//       ..[url] = !currentMuted;
//
//     state = state.copyWith(muteMap: updatedMuteMap);
//   }
//
//   @override
//   void dispose() {
//     _player.dispose();
//     super.dispose();
//   }
// }
//
// final radioPlayerProvider =
//     StateNotifierProvider<RadioPlayerNotifier, RadioPlayerState>(
//       (ref) => RadioPlayerNotifier(),
//     );
