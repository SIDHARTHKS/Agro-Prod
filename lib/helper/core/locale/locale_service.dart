import 'package:get/get.dart';

import 'language/english_language.dart';
import 'language/malayalam_language.dart';

class LocaleService extends GetxService {
  var locale = 'en_US'.obs; // Default to English

  static LocaleService get to => Get.find();

  void changeLocale(String newLocale) {
    locale.value = newLocale;
  }

  String translate(String key) {
    switch (locale.value) {
      case 'en_US':
        return enUS[key] ?? key;
      case 'ml_IN':
        return mlIN[key] ?? key;
      default:
        return key;
    }
  }
}
