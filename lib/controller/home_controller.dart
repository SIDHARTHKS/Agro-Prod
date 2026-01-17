import 'package:agro/gen/assets.gen.dart';
import 'package:agro/view/home/delayed_payments/delayed_payments_pending_view.dart';
import 'package:agro/view/home/home_screen.dart';
import 'package:get/get.dart';
import '../helper/core/base/app_base_controller.dart';
import '../service/delayed_payment_service.dart';
import 'package:agro/model/delayed_payments_model.dart';
import 'package:agro/helper/route.dart';
import 'dart:async';
import '../helper/app_message.dart';
import '../helper/enum.dart';
import 'package:intl/intl.dart';
import '../helper/app_string.dart';

class HomeController extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  //
  final isInitCalled = false.obs;
  RxString rxUserName = ''.obs;
  RxString rxUserImg = ''.obs;
  RxString rxUserId = "".obs;

  final DelayedPaymentService delayedPaymentService =
      Get.find<DelayedPaymentService>();

  // navbar
  RxInt rxCurrentNavBarIndex = 0.obs;

  @override
  Future<void> onInit() async {
    await _setArguments();
    if (!isInitCalled.value) {
      isInitCalled.value = true;
      _preloadDelayedPayments();
    }
    super.onInit();
  }

  Future<void> _setArguments() async {
    // var arguments = Get.arguments;
    // var task = arguments[tasksDataKey];
    // if (arguments != null) {
    //   rxTasksResponse(task);
    // } else {
    //   showErrorSnackbar(
    //       message: "Unable To Fetch Task Details. Please Login Again");
    //   navigateToAndRemoveAll(loginPageRoute);
    // }
    // appLog("userid =${rxUserId.value}");
  }

  Future<void> _preloadDelayedPayments() async {
    try {
      DateTime now = DateTime.now();
      final formatter = DateFormat('dd/MM/yyyy');

      final response = await delayedPaymentService.fetchDelayedPayments(
        DelayedPaymentsRequest(
          companyCode: 'ttpl',
          branchCode: 'pce',
          repToDate: formatter.format(now),
        ),
      );

      if (response != null) {
        await myApp.preferenceHelper!.setString(
          'delayed_payments_cache',
          delayedPaymentsModelToJson(response),
        );

        appLog('Delayed payments cached successfully');
      }
    } catch (e) {
      appLog('Preload delayed payments failed: $e', logging: Logging.error);
    }
  }

  List bottomNavBarItems = [
    Assets.icons.home0.path,
    Assets.icons.delay0.path,
    Assets.icons.transit0.path,
    Assets.icons.settings0.path,
  ];

  List bottomNavBarScreens = [
    const HomeScreen(),
    const DelayedPaymentsPendingView(),
    const HomeScreen(),
    const HomeScreen(),
  ];

  List appBarTitles = [
    'Home',
    'Delayed payments',
    'Packet Dispatch',
    'Settings',
    'Bills Summary'
  ];

  Future<bool> fetchInitData() async {
    return true;
  }

  Future<void> logout() async {
    final pref = myApp.preferenceHelper;

    if (pref != null) {
      await pref.setBool(rememberMeKey, true);
      await pref.setString(userIdKey, "-1");
      await pref.remove(accessTokenKey);
      await pref.remove(loginPasswordKey);
    }

    Get.offAllNamed(loginPageRoute);
  }
}
