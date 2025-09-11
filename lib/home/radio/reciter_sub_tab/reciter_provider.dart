 import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islami_app_demo/home/radio/reciter_sub_tab/reciter_repository.dart';
import 'package:islami_app_demo/model/ReciterModel.dart';
import 'package:islami_app_demo/model/SuraModel.dart';

 final surahNamesListProvider = FutureProvider<List<SuraModel>>((ref) async{
   return ReciterRepository.loadSurahsNames();
 });

 final recitersNamesListProvider = FutureProvider<List<ReciterModel>>((ref) async{
   return ReciterRepository.loadAllRecitersNames();
 });