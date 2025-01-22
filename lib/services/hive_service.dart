import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const preferencesBox = 'preferencesBox';

  static Future<void> initHive() async {
    await Hive.initFlutter();
    await Hive.openBox(preferencesBox);
  }

  static Future<void> setPreferences(bool isDarkMode, String sortOrder) async {
    final box = Hive.box(preferencesBox);
    await box.put('isDarkMode', isDarkMode);
    await box.put('sortOrder', sortOrder);
  }

  static bool get isDarkMode =>
      Hive.box(preferencesBox).get('isDarkMode', defaultValue: false);
  static String get sortOrder =>
      Hive.box(preferencesBox).get('sortOrder', defaultValue: 'date');
}
