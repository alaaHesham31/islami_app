import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islami_app_demo/home/time/azkar/azkar_repository.dart';
import 'package:islami_app_demo/model/AzkarModel.dart';

final azkarListProvider = FutureProvider<Map<String, List<AzkarModel>>>((
  ref,
) async {
  return AzkarRepository.loadAzkarFiles();
});
