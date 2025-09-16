import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/reciter.dart';
import '../../domain/entities/surah.dart';
import '../../domain/usecases/get_all_reciters.dart';
import '../../domain/usecases/get_surahs_names.dart';
import '../../data/repositories/reciters_repository_impl.dart';
import '../../data/datasources/reciters_local_data_source.dart';
import '../../data/datasources/reciters_remote_data_source.dart';

final recitersRepositoryProvider = Provider((ref) {
  return RecitersRepositoryImpl(
    localDataSource: RecitersLocalDataSource(),
    remoteDataSource: RecitersRemoteDataSource(),
  );
});

final getAllRecitersProvider = FutureProvider<List<Reciter>>((ref) async {
  final repo = ref.read(recitersRepositoryProvider);
  return GetAllReciters(repo).call();
});

final getSurahsNamesProvider = FutureProvider<List<Surah>>((ref) async {
  final repo = ref.read(recitersRepositoryProvider);
  return GetSurahsNames(repo).call();
});
