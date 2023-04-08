import 'dart:ui';

import 'package:expense_tracker/database/daos/expense_dao.dart';
import 'package:expense_tracker/database/daos/label_dao.dart';
import 'package:expense_tracker/database/daos/ledger_dao.dart';
import 'package:expense_tracker/database/daos/preferences_dao.dart';
import 'package:expense_tracker/database/database.dart';
import 'package:expense_tracker/pages/pages.dart';
import 'package:flutter/material.dart';
import 'dart:ffi';
import 'dart:io';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3/open.dart';
import 'package:dynamic_color/dynamic_color.dart';

import 'package:get/get.dart';

import 'database/daos/person_dao.dart';

void main() async {
  open.overrideFor(OperatingSystem.windows, _openForWindows);

  final db = sqlite3.openInMemory();
  db.dispose();

  WidgetsFlutterBinding.ensureInitialized();
  MainDatabase mainDbInstance = MainDatabase();
  Get.put(mainDbInstance);

  final prefDao = PreferencesDao(mainDbInstance);
  final defaultCurrency = await prefDao.getDefaultCurrency();

  late Widget homePage;
  if (defaultCurrency == null) {
    homePage = const OnboardingPage();
  } else {
    homePage = const HomePage();
  }

  runApp(MyApp(homePage: homePage,));
}

DynamicLibrary _openForWindows() {
  final library = File('D:\\Projects\\expense_tracker\\lib\\sqlite3.dll');
  return DynamicLibrary.open(library.path);
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.homePage}) {
    final mainDB = Get.find<MainDatabase>();
    Get.put(PersonDao(mainDB));
    Get.put(ExpenseDao(mainDB));
    Get.put(LedgerDao(mainDB));
    Get.put(LabelDao(mainDB));
    Get.put(PreferencesDao(mainDB));
  }

  final Widget homePage;

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return GetMaterialApp(
          title: 'Flutter Demo',
          themeMode: ThemeMode.dark,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: lightDynamic,
            fontFamily: "Metropolis",
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkDynamic,
            fontFamily: "Metropolis",
            useMaterial3: true,
            textTheme: const TextTheme(
              titleLarge: TextStyle(fontFamily: "HelveticaNow"),
              displayLarge: TextStyle(fontFamily: "HelveticaNow"),
              headlineLarge: TextStyle(fontFamily: "HelveticaNow"),
              bodyMedium: TextStyle(
                fontFamily: "Manrope",
                fontVariations: [
                  FontVariation('wght', 500),
                ],
              ),
            ),
          ),
          home: homePage,
        );
      },
    );
  }
}
