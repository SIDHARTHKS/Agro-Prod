import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../core/base/http_service.dart';
import '../core/base/app_base_service.dart';
import '../core/environment/env.dart';
import '../enum.dart';
import '../app_message.dart';
import '../single_app.dart';

class AppInit {
  Future<void> mainInit() async {
    WidgetsFlutterBinding.ensureInitialized();

    await _initSingletonClasses();
    // await _setUpFcm();
    _setDeviceType();
    _setUpScreenOrrientation();
  }

  Future<void> _initSingletonClasses() async {
    Get.put(MyApplication());
    await Get.find<MyApplication>().setUpSharedPreference();
    await Get.find<MyApplication>().setVersionNumber();
    Get.put(HttpService());
    Get.put(AppBaseService());
  }

  void _setDeviceType() {
    final MediaQueryData data = MediaQueryData.fromView(
        WidgetsBinding.instance.platformDispatcher.views.single);
    AppEnvironment.setDeviceType(data.size.shortestSide < 600
        ? UserDeviceType.phone
        : UserDeviceType.tablet);
    // DeviceType deviceType = SizerUtil.deviceType;
    appLog(
        '_setDeviceType $data deviceType: ${AppEnvironment.deviceType} ${AppEnvironment.config.platformType}');
  }

  Future<void> _setUpFcm() async {
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );
    // await NotificationService.instance.initialize();
  }
  // Future<void> _setUpFcm1() async {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //   await Future.delayed(const Duration(seconds: 1));
  //   String? token = AppEnvironment.config.platformType == PlatformType.android
  //       ? await messaging.getToken()
  //       : await messaging.getAPNSToken();
  //   final MyApplication misApp = Get.find<MyApplication>();
  //   if (misApp.preferenceHelper != null) {
  //     await misApp.preferenceHelper!.setString(fbEidKey, token ?? '');
  //   }
  //   // misApp.setFbEid(token ?? '');
  //   await FirebaseMessaging.instance
  //       .setForegroundNotificationPresentationOptions(
  //     alert: true,
  //     badge: true,
  //     sound: true,
  //   );
  // }

  void _setUpScreenOrrientation() {
    SystemChrome.setPreferredOrientations(
        AppEnvironment.deviceType == UserDeviceType.phone
            ? [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
            : [
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight
              ]);
  }
}
