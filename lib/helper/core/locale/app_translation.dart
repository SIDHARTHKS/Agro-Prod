import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/internacionalization.dart';

import '../../enum.dart';
import 'language/english_language.dart';
import 'language/malayalam_language.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
        'ml_IN': mlIN,
      };

  Locale getLocale(Language language) {
    switch (language) {
      case Language.english:
        return const Locale('en', 'US');
      case Language.malayalam:
        return const Locale('ml', 'IN');
    }
  }
}
