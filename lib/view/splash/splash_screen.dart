import 'dart:io';
import 'package:agro/helper/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controller/splash_controller.dart';
import '../../gen/assets.gen.dart';
import '../../helper/app_message.dart';
import '../../helper/app_string.dart';
import '../../helper/color_helper.dart';
import '../../helper/core/base/app_base_view.dart';
import '../../helper/core/environment/env.dart';
import '../../helper/navigation.dart';
import '../../helper/route.dart';
import '../widget/common_widget.dart';

class SplashScreen extends AppBaseView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget buildView() => _widgetView();

  Scaffold _widgetView() => appScaffold(
        topSafe: false,
        bottomNavigationBar: SafeArea(
          child: appText("VERSION ${AppEnvironment.config.version}",
              fontWeight: FontWeight.w500,
              fontSize: 12,
              textAlign: TextAlign.center,
              color: AppColorHelper().textColor.withValues(alpha: 0.5)),
        ),
        body: appFutureBuilder<int>(
          () => controller.fetchUserProfile(),
          (context, snapshot) {
            appLog('return ${snapshot.data}');
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While loading, show loader
              return _loaderWidget();
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              // Perform navigation in a microtask after build
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (controller.rxUpdateRequired.value) {
                  _openAppUpdateDialog();
                } else {
                  Map<String, dynamic> arguments = {
                    tasksDataKey: controller.rxTasksResponse
                  };
                  if (snapshot.data == 1) {}
                  navigateToAndRemoveAll(
                    snapshot.data == 1 ? homePageRoute : loginPageRoute,
                    arguments: arguments,
                  );
                }
              });
              // Show loader while navigating
              return _loaderWidget();
            }

            return _loaderWidget();
          },
          loaderWidget: _loaderWidget(),
        ),
      );

  Widget _loaderWidget() => Stack(
        fit: StackFit.expand,
        children: [
          //first image
          Image.asset(
            Assets.images.splashBg1.path,
            fit: BoxFit.cover,
          ),

          // second image fade
          // AnimatedOpacity(
          //   duration: const Duration(milliseconds: 1000),
          //   curve: Curves.easeInOut,
          //   opacity: controller.rxShowSecondImage.value ? 1.0 : 0.0,
          //   child: Image.asset(
          //     Assets.images.splashBg2.path,
          //     fit: BoxFit.cover,
          //   ),
          // ),

          // Align(
          //   alignment: const Alignment(0, -0.1),
          //   child: AnimatedOpacity(
          //     duration: const Duration(milliseconds: 1000),
          //     curve: Curves.easeInOut,
          //     opacity: controller.rxShowSecondImage.value ? 1.0 : 0.0,
          //     child: muzirisLogo(),
          //   ),
          // ),

          // Align(
          //   alignment: const Alignment(0, 1),
          //   child: SizedBox(
          //     height: Get.height * 0.48,
          //     child: SlideTransition(
          //       position: controller.textSlide,
          //       child: Column(
          //         mainAxisSize: MainAxisSize.max,
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         children: [
          //           appText(
          //             "Initializing your workspace",
          //             fontWeight: FontWeight.w500,
          //             fontSize: 14,
          //             textAlign: TextAlign.center,
          //           ),
          //           height(4),
          //           appText(
          //             "Please wait...",
          //             fontWeight: FontWeight.w800,
          //             fontSize: 16,
          //             textAlign: TextAlign.center,
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      );

  void _openAppUpdateDialog() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Widget okButton = TextButton(
          child: Text(ok.tr),
          onPressed: () {
            if (AppEnvironment.isAndroid()) {
              SystemNavigator.pop();
            } else if (AppEnvironment.isIos()) {
              exit(0);
            }
          },
        );
        return AlertDialog(
          title: Text(unSupportedAppVersionTitle.tr),
          content: Text(updateAppDialogMsg.tr),
          actions: [
            okButton,
          ],
        );
      },
    );
  }
}
