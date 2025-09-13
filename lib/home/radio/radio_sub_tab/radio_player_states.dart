// import '../../../model/RadioResponseModel.dart';
//
// enum PlayerStatus { stopped, playing, paused }
//
// class RadioPlayerState {
//   final RadiosModel? currentRadio;
//   final PlayerStatus status;
//   final Map<String, bool> muteMap;
//
//   RadioPlayerState({
//     this.currentRadio,
//     this.status = PlayerStatus.stopped,
//     Map<String, bool>? muteMap,
//   }) : muteMap = muteMap ?? {};
//
//   RadioPlayerState copyWith({
//     RadiosModel? currentRadio,
//     PlayerStatus? status,
//     Map<String, bool>? muteMap,
//   }) {
//     return RadioPlayerState(
//       currentRadio: currentRadio ?? this.currentRadio,
//       status: status ?? this.status,
//       muteMap: muteMap ?? this.muteMap,
//     );
//   }
//
//   bool isMuted(String url) => muteMap[url] ?? false;
// }
