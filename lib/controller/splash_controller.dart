import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helper/app_string.dart';
import '../helper/core/base/app_base_controller.dart';
import '../helper/shared_pref.dart';
import '../model/task_model.dart';

class SplashController extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  SharedPreferenceHelper? _preference;
  var rxUpdateRequired = false.obs;

  // animation
  // animation
  late AnimationController _textController;
  late Animation<Offset> logoSlide;
  RxBool rxShowSecondImage = false.obs;

  late Animation<double> logoFade;

  // tasks
  RxList<TaskResponse> rxTasksResponse = <TaskResponse>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    initTextAnimation();
    _textController.forward();

    //await _textController.forward().orCancel;

    // Hold the logo at center for ~1 second
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<int> fetchUserProfile() async {
    // Ensure splash lives at least 3 seconds
    await Future.delayed(const Duration(milliseconds: 2500));

    var preference = myApp.preferenceHelper;
    if (preference != null) {
      final rememberMe = preference.getBool(rememberMeKey);
      final userId = preference.getString(userIdKey);
      final token = preference.getString(accessTokenKey);

      if (rememberMe && userId != "-1" && token.isNotEmpty) {
        return 1;
      }
    }

    return 2;
  }

  Future<void> resetPref() async {
    _preference?.remove(accessTokenKey);
    _preference?.remove(loginPasswordKey);
  }

  void initTextAnimation() {
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    logoSlide = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0, 1.6), end: const Offset(0, 0))
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: ConstantTween(const Offset(0, 0)),
        weight: 30,
      ),
    ]).animate(_textController);

    logoFade = TweenSequence<double>([
      // stay invisible for a short moment
      TweenSequenceItem(
        tween: ConstantTween(0.0),
        weight: 20,
      ),

      // smooth fade-in
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 80,
      ),
    ]).animate(_textController);
  }

  @override
  void onClose() {
    _textController.dispose();
    super.onClose();
  }
}
