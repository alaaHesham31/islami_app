import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islami_app_demo/features/time/azkar/AzkarModel.dart';

import 'azkar_repository.dart';

final azkarListProvider = FutureProvider<Map<String, List<AzkarModel>>>((
  ref,
) async {
  return AzkarRepository.loadAzkarFiles();
});
