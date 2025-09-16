import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/zikr.dart';
import '../domain/usecases/increment_tasbeeh_usecase.dart';
import '../data/repositories/sebha_repository_impl.dart';

class SebhaNotifier extends StateNotifier<Zikr> {
  final IncrementTasbeehUseCase incrementTasbeeh;

  SebhaNotifier(this.incrementTasbeeh)
      : super(const Zikr(text: 'سبحان الله', count: 0));

  void onTasbeehClick() {
    state = incrementTasbeeh(state);
  }
}

final sebhaProvider = StateNotifierProvider<SebhaNotifier, Zikr>((ref) {
  final repo = SebhaRepositoryImpl();
  final useCase = IncrementTasbeehUseCase(repo);
  return SebhaNotifier(useCase);
});
