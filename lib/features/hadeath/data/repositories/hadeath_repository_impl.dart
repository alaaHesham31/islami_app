import '../../domain/entities/hadeath.dart';
import '../../domain/repositories/hadeath_repository.dart';
import '../datasources/hadeath_local_data_source.dart';

class HadeathRepositoryImpl implements HadeathRepository {
  final HadeathLocalDataSource localDataSource;

  HadeathRepositoryImpl(this.localDataSource);

  @override
  Future<List<Hadeath>> getAllAhadeeth() async {
    final models = await localDataSource.loadAhadeeth();
    return models.map((m) => Hadeath(title: m.title, content: m.content)).toList();
  }
}
