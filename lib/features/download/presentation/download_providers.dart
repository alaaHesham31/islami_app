// lib/features/download/presentation/download_providers.dart
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/managers/download_progress_manager.dart'; // your project path
import '../data/datasources/download_local_datasource.dart';
import '../data/datasources/download_remote_datasource.dart';
import '../data/models/DownloadedSurahModel.dart';
import '../data/repositories/download_repository_impl.dart';
import '../data/services/download_service.dart';

final downloadDioProvider = Provider<Dio>((ref) => Dio());

final downloadLocalDataSourceProvider =
Provider<DownloadLocalDataSource>((ref) => DownloadLocalDataSource());

final downloadRemoteDataSourceProvider =
Provider<DownloadRemoteDataSource>((ref) {
  final dio = ref.read(downloadDioProvider);
  return DownloadRemoteDataSource(dio);
});

final downloadRepositoryProvider = Provider<DownloadRepositoryImpl>((ref) {
  final local = ref.read(downloadLocalDataSourceProvider);
  final remote = ref.read(downloadRemoteDataSourceProvider);
  return DownloadRepositoryImpl(local: local, remote: remote);
});

/// Public facade used by UI
final downloadServiceProvider = Provider<DownloadService>((ref) {
  final repo = ref.read(downloadRepositoryProvider);
  return DownloadService(repository: repo);
});

/// StreamProvider that bridges the DownloadProgressManager's ValueListenable -> Stream
final downloadProgressMapProvider =
StreamProvider<Map<String, double>>((ref) {
  final controller = StreamController<Map<String, double>>.broadcast();

  final listenable = DownloadProgressManager.instance.listenable;

  // Defensive: support ValueNotifier/ValueListenable
  if (listenable is ValueListenable<Map<String, double>>) {
    // push current value
    try {
      controller.add(listenable.value);
    } catch (_) {
      controller.add({});
    }
    void listener() {
      try {
        controller.add(listenable.value);
      } catch (_) {
        // ignore
      }
    }

    listenable.addListener(listener);

    ref.onDispose(() {
      try {
        listenable.removeListener(listener);
      } catch (_) {
        // ignore
      }
      controller.close();
    });

    return controller.stream;
  } else {
    // Fallback: empty map stream
    controller.add({});
    controller.close();
    return controller.stream;
  }
});

/// Per-key convenience provider returning the progress (double?).
final downloadProgressProvider =
Provider.family<double?, String>((ref, key) {
  final asyncMap = ref.watch(downloadProgressMapProvider);
  return asyncMap.when(
    data: (map) => map[key],
    loading: () => null,
    error: (_, __) => null,
  );
});

/// NEW: provider that returns persisted downloaded surahs from Hive
final downloadedSurahsProvider =
FutureProvider<Map<String, DownloadedSurahModel>>((ref) async {
  final local = ref.read(downloadLocalDataSourceProvider);
  return local.getAllDownloadedSurahs();
});
