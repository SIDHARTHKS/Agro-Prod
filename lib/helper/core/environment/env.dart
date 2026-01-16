import 'package:getx_base_classes/getx_base_classes.dart';

import '../../enum.dart';
import 'env_config.dart';
import 'stage/dev_env.dart';
import 'stage/prod_env.dart';
import 'stage/uat_env.dart';

abstract class AppEnvironment {
  static late EnvironmentConfig config;
  static late Environment environment;
  static late UserDeviceType deviceType;
  static late AppClient appClient;
  static late ThemeModeType themeModeType;

  static void setEnv(Environment env) {
    environment = env;
    switch (env) {
      case Environment.DEV:
        config = DevEnvironment();
        break;
      case Environment.PROD:
        config = ProdEnvironment();
        break;
      case Environment.UAT:
        config = UatEnvironment();
    }
  }

  static void setDeviceType(UserDeviceType type) {
    deviceType = type;
  }

  static void setClient(AppClient client) {
    appClient = client;
  }

  static void setThemeMode(ThemeModeType type) {
    themeModeType = type;
  }

  static bool isDarkMode() => themeModeType == ThemeModeType.dark;
  static bool isDevMode() => environment == Environment.DEV;
  static bool isProdMode() => environment == Environment.PROD;
  static bool isUatMode() => environment == Environment.UAT;

  static bool isAndroid() => config.platformType == PlatformType.android;
  static bool isIos() => config.platformType == PlatformType.ios;
}
