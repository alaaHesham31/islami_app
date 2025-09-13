import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:islami_app_demo/home/hadeath/hadeath_details_screen.dart';
import 'package:islami_app_demo/home/home_screen.dart';
import 'package:islami_app_demo/home/onboarding_screen.dart';
import 'package:islami_app_demo/home/quran/sura_details_screen.dart';
import 'package:islami_app_demo/model/ReciterModel.dart';
import 'package:islami_app_demo/theme/app_theme.dart';

import 'home/radio/reciter_sub_tab/reciter_surah_list_screen.dart';
import 'home/time/azkar/azkar_details_screen.dart' show AzkarDetailsScreen;

// Helper: extract legacy reciters (maps / lists) BEFORE opening typed box
Future<List<ReciterModel>> _extractLegacyRecitersIfAny() async {
  const boxName = 'recitersBox';

  // open raw (untyped) box to inspect legacy data
  final rawBox = await Hive.openBox(boxName);

  final List<ReciterModel> extracted = [];

  if (rawBox.isEmpty) {
    await rawBox.close();
    return extracted;
  }

  // If the legacy code used a single key 'reciters' storing a list of maps:
  if (rawBox.containsKey('reciters')) {
    final val = rawBox.get('reciters');
    if (val is List) {
      for (final item in val) {
        if (item == null) continue;
        if (item is ReciterModel) {
          extracted.add(item);
        } else if (item is Map) {
          extracted.add(ReciterModel.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }
  } else {
    // Otherwise iterate all values and try to convert maps/lists to models
    for (final v in rawBox.values) {
      if (v == null) continue;
      if (v is ReciterModel) {
        extracted.add(v);
      } else if (v is Map) {
        extracted.add(ReciterModel.fromJson(Map<String, dynamic>.from(v)));
      } else if (v is List) {
        for (final item in v) {
          if (item == null) continue;
          if (item is Map) {
            extracted.add(ReciterModel.fromJson(Map<String, dynamic>.from(item)));
          } else if (item is ReciterModel) {
            extracted.add(item);
          }
        }
      }
    }
  }

  // Clear the raw data (we will save typed models below)
  await rawBox.clear();
  await rawBox.close();
  return extracted;
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // ✅ Register adapters first
  Hive.registerAdapter(ReciterModelAdapter());
  Hive.registerAdapter(MoshafModelAdapter());

  // 🚨 Clear corrupted box once (then remove this after first run)
  // await Hive.deleteBoxFromDisk('recitersBox');

  // ✅ Open typed box safely
  final box = await Hive.openBox<ReciterModel>('recitersBox');

  runApp(const ProviderScope(child: MyApp()));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomeScreen.routeName,
      routes: {
        OnboardingScreen.routeName: (context) => OnboardingScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        SuraDetailsScreen.routeName: (context) => SuraDetailsScreen(),
        HadeathDetailsScreen.routeName: (context) => HadeathDetailsScreen(),
        AzkarDetailsScreen.routeName: (context) => AzkarDetailsScreen(),
        ReciterSurahListScreen.routeName: (context) => ReciterSurahListScreen(),

      },
      theme: MyThemeData.myTheme,
    );
  }
}
