import 'package:flutter/foundation.dart';

enum PlayerStatus { idle, loading, playing, paused }

@immutable
class SurahPlayerState {
  final int? currentSurahId;
  final String? currentSurahName;
  final String? currentReciterName;
  final PlayerStatus status;
  final Duration duration; // total surah length

  const SurahPlayerState({
    this.currentSurahId,
    this.currentSurahName,
    this.currentReciterName,
    this.status = PlayerStatus.idle,
    this.duration = Duration.zero,
  });

  SurahPlayerState copyWith({
    int? currentSurahId,
    String? currentSurahName,
    String? currentReciterName,
    PlayerStatus? status,
    Duration? duration,
  }) {
    return SurahPlayerState(
      currentSurahId: currentSurahId ?? this.currentSurahId,
      currentSurahName: currentSurahName ?? this.currentSurahName,
      currentReciterName: currentReciterName ?? this.currentReciterName,
      status: status ?? this.status,
      duration: duration ?? this.duration,
    );
  }
}
