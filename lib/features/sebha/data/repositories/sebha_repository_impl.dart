import '../../domain/entities/zikr.dart';
import '../../domain/repositories/sebha_repository.dart';

class SebhaRepositoryImpl implements SebhaRepository {
  final List<String> _azkar = ['سبحان الله', 'الله أكبر', 'الحمد لله'];

  @override
  List<String> getAzkar() => _azkar;

  @override
  Zikr incrementTasbeeh(Zikr current) {
    int newCount = current.count + 1;
    String newText = current.text;

    if (newCount == 34) {
      newCount = 1;
      final currentIndex = _azkar.indexOf(current.text);
      final nextIndex = (currentIndex + 1) % _azkar.length;
      newText = _azkar[nextIndex];
    }

    return current.copyWith(text: newText, count: newCount);
  }
}
