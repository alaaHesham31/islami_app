// import 'dart:async';
// import 'package:flutter/foundation.dart';
// import 'package:just_audio/just_audio.dart';
// import '../../domain/entities/global_player_state.dart';
// import '../../domain/repositories/global_player_repository.dart';
// import '../datasources/global_player_local_datasource.dart';
//
// class GlobalPlayerRepositoryImpl implements GlobalPlayerRepository {
//   final GlobalPlayerLocalDataSource dataSource;
//   GlobalPlayerRepositoryImpl(this.dataSource);
//
//   final _controller = StreamController<GlobalPlayerState>.broadcast();
//   GlobalPlayerState _state = const GlobalPlayerState();
//
//   AudioPlayer get _player => dataSource.player;
//   int _playRequestId = 0;
//
//   @override
//   Stream<GlobalPlayerState> get playerStateStream => _controller.stream;
//
//   void _emit(GlobalPlayerState newState) {
//     _state = newState;
//     _controller.add(_state);
//   }
//
//   @override
//   Future<void> playReciter(String url, String surahName, String reciterName, {bool isLocal = false}) async {
//     final int reqId = ++_playRequestId;
//     try {
//       await _player.stop();
//       _emit(_state.copyWith(
//         sourceType: PlayerSourceType.reciter,
//         title: surahName,
//         subtitle: reciterName,
//         url: url,
//         status: PlayerStatus.loading,
//         position: Duration.zero,
//         duration: Duration.zero,
//         isLocal: isLocal,
//       ));
//
//       if (isLocal) {
//         await _player.setFilePath(url);
//       } else {
//         await _player.setUrl(url);
//       }
//
//       if (reqId != _playRequestId) return;
//       await _player.play();
//       _emit(_state.copyWith(status: PlayerStatus.playing));
//     } catch (e) {
//       _emit(_state.copyWith(
//         status: PlayerStatus.stopped,
//         errorMessage: "تعذر تشغيل الملف الصوتي. تحقق من اتصال الإنترنت أو الملف المحلي.",
//       ));
//       debugPrint("Error playing reciter: $e");
//     }
//   }
//
//   @override
//   Future<void> playRadio(String url, String radioName) async {
//     final int reqId = ++_playRequestId;
//     try {
//       await _player.stop();
//       _emit(_state.copyWith(
//         sourceType: PlayerSourceType.radio,
//         title: radioName,
//         subtitle: "إذاعة القرآن الكريم",
//         url: url,
//         status: PlayerStatus.loading,
//       ));
//
//       await _player.setUrl(url);
//       if (reqId != _playRequestId) return;
//       await _player.play();
//       _emit(_state.copyWith(status: PlayerStatus.playing));
//     } catch (e) {
//       _emit(_state.copyWith(
//         status: PlayerStatus.stopped,
//         errorMessage: "تعذر تشغيل الإذاعة. تحقق من الاتصال بالإنترنت.",
//       ));
//       debugPrint("Error playing radio: $e");
//     }
//   }
//
//   @override
//   Future<void> pause() async {
//     await _player.pause();
//     _emit(_state.copyWith(status: PlayerStatus.paused));
//   }
//
//   @override
//   Future<void> resume() async {
//     await _player.play();
//     _emit(_state.copyWith(status: PlayerStatus.playing));
//   }
//
//   @override
//   Future<void> stop() async {
//     await _player.stop();
//     _emit(const GlobalPlayerState());
//   }
//
//   @override
//   Future<void> seek(Duration pos) async {
//     await _player.seek(pos);
//     _emit(_state.copyWith(position: pos));
//   }
//
//   double _lastVolume = 1.0;
//   @override
//   Future<void> toggleMute() async {
//     final newMuted = !_state.isMuted;
//     if (newMuted) {
//       try {
//         _lastVolume = await _player.volume;
//       } catch (_) {
//         _lastVolume = 1.0;
//       }
//       await _player.setVolume(0.0);
//     } else {
//       await _player.setVolume(_lastVolume);
//     }
//     _emit(_state.copyWith(isMuted: newMuted));
//   }
// }
