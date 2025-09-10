import 'package:flutter_riverpod/flutter_riverpod.dart' show FutureProvider;
import 'package:islami_app_demo/home/radio/radio_sub_tab/radio_repository.dart';
import 'package:islami_app_demo/model/RadioResponseModel.dart';


final radioListProvider = FutureProvider<List<RadiosModel>> ((ref) async{
  return RadioRepository.fetchRadios();
} ) ;