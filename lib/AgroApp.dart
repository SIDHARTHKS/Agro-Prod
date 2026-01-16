import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'helper/app_string.dart';
import 'helper/color_helper.dart';
import 'helper/core/locale/app_translation.dart';
import 'helper/core/theme/theme_service.dart';
import 'helper/enum.dart';
import 'helper/route.dart';
import 'helper/single_app.dart';

class AgroApp extends StatelessWidget {
  const AgroApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor:
          Colors.transparent, // Makes the navbar transparent
      systemNavigationBarIconBrightness:
          Brightness.dark, // Icon color (light/dark)
      systemNavigationBarDividerColor: Colors.transparent,
    ));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    final MyApplication myApplication = Get.find<MyApplication>();
    final AppThemeService appThemeService = Get.put(AppThemeService());
    appThemeService.setCompanyTheme();
    bool isLoggedIn =
        myApplication.preferenceHelper?.getBool(loginKey) ?? false;
    return Sizer(
      builder: (context, orientation, deviceType) => GetMaterialApp(
        // popGesture: false,

        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColorHelper().secondaryTextColor,
          ),
          useMaterial3: true,
        ),
        locale: AppTranslations().getLocale(Language.english),
        translations: AppTranslations(),
        getPages: routes,
        initialRoute: splashPageRoute,
      ),
    );
  }
}
