import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/hive_service.dart';

class PreferencesViewModel extends StateNotifier<bool> {
  PreferencesViewModel() : super(HiveService.isDarkMode);

  void toggleTheme() {
    state = !state;
    HiveService.setPreferences(state, HiveService.sortOrder);
  }
}

final themeProvider = StateNotifierProvider<PreferencesViewModel, bool>((ref) {
  return PreferencesViewModel();
});
