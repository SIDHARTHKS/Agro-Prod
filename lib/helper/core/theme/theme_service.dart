import 'package:get/get.dart';

import '../../app_string.dart';
import '../../enum.dart';
import '../../single_app.dart';
import '../environment/env.dart';
import 'app_theme.dart';

class AppThemeService extends GetxService {
  final _currentClient = AppClient.agro.obs; // Initial client
  final _themeMode = ThemeModeType.light.obs; // Initial theme mode

  AppTheme get currentTheme =>
      appThemes[_currentClient.value]![_themeMode.value]!;
  ThemeModeType get themeMode => _themeMode.value;

  void switchClient(AppClient client) {
    _currentClient.value = client;
  }

  void switchThemeMode(ThemeModeType mode) {
    _themeMode.value = mode;
  }

  void setCompanyTheme() {
    final MyApplication misApp = Get.find<MyApplication>();
    bool isDarkMode = misApp.preferenceHelper!.getBool(darkModeKey);
    if (misApp.preferenceHelper != null) {
      isDarkMode = misApp.preferenceHelper!.getBool(darkModeKey);
    }
    switchClient(AppEnvironment.appClient);
    switchThemeMode(isDarkMode ? ThemeModeType.dark : ThemeModeType.light);
  }
}
