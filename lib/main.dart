import 'package:deta/screens/AllUsers.dart';
import 'package:deta/utils/LocalStorage.dart';
import 'package:deta/utils/themeNotifier.dart';
import 'package:deta/assets/themeColors.dart';
import 'package:deta/utils/updateChecker.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'assets/Constants.dart';


Future main() async {
  // print("start");
  WidgetsFlutterBinding.ensureInitialized();

  // print("loading hive");
  await Hive.initFlutter('./hiveCache');
  // print("loading ls");
  final secureStorage = LocalStorage();
  // print("loading theme");
  int theme_num = await secureStorage.getNum(KEYNAME_THEME);
  activeTheme = THEME_ARR[theme_num];
  // versionChecker();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>ThemeNotifier(activeTheme))
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      theme: themeNotifier.getTheme,
      debugShowCheckedModeBanner: false,
      home: const AllUsers(),
    );
  }
}
