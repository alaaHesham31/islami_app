import '../../domain/entities/radio.dart';
import '../../domain/repositories/radio_repository.dart';
import '../datasources/radio_local_datasource.dart';
import '../datasources/radio_remote_datasource.dart';

class RadioRepositoryImpl implements RadioRepository {
  final RadioLocalDataSource localDataSource;
  final RadioRemoteDataSource remoteDataSource;

  RadioRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<RadioEntity>> fetchRadios() async {
    final cached = await localDataSource.getCachedRadios();
    if (cached.isNotEmpty) {
      return cached;
    }
    final remote = await remoteDataSource.fetchRadios();
    await localDataSource.cacheRadios(remote);
    return remote;
  }
}
