import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/radio.dart';
import '../domain/usecases/fetch_radios_usecase.dart';
import '../data/datasources/radio_local_datasource.dart';
import '../data/datasources/radio_remote_datasource.dart';
import '../data/repositories/radio_repository_impl.dart';

final radioListProvider = FutureProvider<List<RadioEntity>>((ref) async {
  final repo = RadioRepositoryImpl(
    localDataSource: RadioLocalDataSource(),
    remoteDataSource: RadioRemoteDataSource(),
  );
  final useCase = FetchRadiosUseCase(repo);
  return await useCase();
});
