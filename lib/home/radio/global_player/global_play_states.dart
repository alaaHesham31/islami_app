import 'package:flutter/foundation.dart';

enum PlayerSourceType { reciter, radio }
enum PlayerStatus { idle, loading, playing, paused, stopped }

@immutable
class GlobalPlayerState {
  final PlayerSourceType? sourceType;
  final String? title;     
  final String? subtitle; 
  final String? url;
  final PlayerStatus status;
  final Duration duration;
  final Duration position;
  final bool isMuted;
  final String? errorMessage;


  const GlobalPlayerState({
    this.sourceType,
    this.title,
    this.subtitle,
    this.url,
    this.status = PlayerStatus.idle,
    this.duration = Duration.zero,
    this.position = Duration.zero,
    this.isMuted = false,
    this.errorMessage,

  });

  GlobalPlayerState copyWith({
    PlayerSourceType? sourceType,
    String? title,
    String? subtitle,
    String? url,
    PlayerStatus? status,
    Duration? duration,
    Duration? position,
    bool? isMuted,
    String? errorMessage,
  }) {
    return GlobalPlayerState(
      sourceType: sourceType ?? this.sourceType,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      url: url ?? this.url,
      status: status ?? this.status,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      isMuted: isMuted ?? this.isMuted,
       errorMessage: errorMessage ?? this.errorMessage, 
    );
  }
}
