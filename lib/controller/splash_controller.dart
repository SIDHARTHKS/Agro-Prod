import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helper/app_message.dart';
import '../helper/app_string.dart';
import '../helper/core/base/app_base_controller.dart';
import '../helper/date_helper.dart';
import '../helper/enum.dart';
import '../helper/shared_pref.dart';
import '../model/app_model.dart';
import '../model/task_model.dart';

class SplashController extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  SharedPreferenceHelper? _preference;
  var rxUpdateRequired = false.obs;

  // animation
  late AnimationController _textController;
  late Animation<Offset> textSlide;
  RxBool rxShowSecondImage = false.obs;

  // tasks
  RxList<TaskResponse> rxTasksResponse = <TaskResponse>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    // initTextAnimation();
    // await startBackgroundAnimation();
    // _textController.forward();
  }

  Future<int> fetchUserProfile() async {
    await Future.delayed(const Duration(
        seconds: 1)); // required for completing the anmtn----------
    var preference = myApp.preferenceHelper;
    if (preference != null) {
      final rememberMe = preference.getBool(rememberMeKey);
      final userId = preference.getString(employeeIdKey);
      final token = preference.getString(accessTokenKey);

      if (rememberMe && userId != "-1" && token.isNotEmpty) {
        return 1;
      }
    }

    return 2; // fallback for all other cases
  }

  Future<void> resetPref() async {
    _preference?.remove(accessTokenKey);
    _preference?.remove(loginPasswordKey);
  }

  // void initTextAnimation() {
  //   _textController = AnimationController(
  //     vsync: this,
  //     duration: const Duration(milliseconds: 2000),
  //   );

  //   textSlide = TweenSequence<Offset>([
  //     TweenSequenceItem(
  //       tween: Tween(begin: const Offset(0, 1.5), end: const Offset(0, 0))
  //           .chain(CurveTween(curve: Curves.easeOutCubic)),
  //       weight: 60,
  //     ),
  //     TweenSequenceItem(
  //       tween: Tween(begin: const Offset(0, 0), end: const Offset(0, 0.05))
  //           .chain(CurveTween(curve: Curves.easeInOut)),
  //       weight: 40,
  //     ),
  //   ]).animate(_textController);
  // }

  /// Background fade transition
  Future<void> startBackgroundAnimation() async {
    await Future.delayed(const Duration(milliseconds: 600));
    rxShowSecondImage(true);

    // Optional: wait extra time for fade to look smooth
    await Future.delayed(const Duration(milliseconds: 150));
  }

  @override
  void onClose() {
    // _textController.dispose();
    super.onClose();
  }
}
