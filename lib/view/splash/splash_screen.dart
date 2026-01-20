import 'dart:io';
import 'dart:ui';
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
import '../login/login_screen.dart';
import '../../helper/sizer.dart';

class SplashScreen extends AppBaseView<SplashController> {
  const SplashScreen({super.key});

  static final RxBool _exitAnim = false.obs;
  static final RxBool _showLogo = false.obs;

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
              return Stack(
                children: [
                  _loaderWidget(), // static splash, never moves
                ],
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              // Perform navigation in a microtask after build
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                // Show logo after a short delay
                if (!_showLogo.value) {
                  await Future.delayed(const Duration(milliseconds: 600));
                  _showLogo.value = true;
                }

                // Keep splash visible a bit
                await Future.delayed(const Duration(milliseconds: 700));

                if (controller.rxUpdateRequired.value) {
                  _openAppUpdateDialog();
                } else {
                  final arguments = {
                    tasksDataKey: controller.rxTasksResponse,
                  };

                  if (snapshot.data == 1) {
                    navigateToAndRemoveAll(homePageRoute, arguments: arguments);
                  } else {
                    _exitAnim.value = true;
                    _playExitOverlay(context, () {
                      navigateToAndRemoveAll(loginPageRoute);
                    });
                  }
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
          Positioned.fill(
            child: Transform.translate(
              offset: const Offset(0, -4),
              child: Transform.scale(
                scale: 1.15,
                alignment: Alignment.topCenter,
                child: Image.asset(
                  Assets.images.splashBg1.path,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Obx(() => AnimatedAlign(
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeOutCubic,
                alignment: _showLogo.value
                    ? const Alignment(0, -0.05)
                    : const Alignment(0, 1.2),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 800),
                  opacity: _showLogo.value ? 1.0 : 0.0,
                  child: Image.asset(
                    Assets.icons.agromisLogo.path,
                    width: 160,
                  ),
                ),
              )),
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

  void _playExitOverlay(BuildContext context, VoidCallback onDone) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    final match = Get.routeTree.matchRoute(loginPageRoute);
    final route = match.route!;
    route.binding?.dependencies();
    final loginPage = route.page();

    LoginScreen.showHeader.value = false;

    entry = OverlayEntry(
      builder: (_) => TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 2000),
        tween: Tween(begin: 0.0, end: 1.0),
        curve: Curves.easeInOutQuart,
        builder: (context, t, child) {
          const double headerInset = 120;
          const double visibleHeaderHeight = 220; // your new taller header

          final double cardHeight =
              lerpDouble(Get.height, visibleHeaderHeight, t)!;
          final double inset = lerpDouble(0.0, headerInset, t)!;

          final double startLogoY = Get.height * 0.5 - 80;
          const double endLogoY = 110;

          return Stack(
            fit: StackFit.expand,
            children: [
              // 🔒 HARD MASK – hides the real SplashScreen completely
              Positioned.fill(
                child: Container(
                  color: AppColorHelper().backgroundColor,
                ),
              ),

              // 🔴 LOGIN PAGE SLIDES IN
              Opacity(
                opacity: t,
                child: Transform.translate(
                  offset: Offset(0, Get.height * (1 - t)),
                  child: loginPage,
                ),
              ),

              // 🟣 SHRINKING FOREGROUND CARD (ONLY PLACE WHERE SPLASH EXISTS)
              Positioned(
                top: 0,
                left: inset,
                right: inset,
                height: cardHeight,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Image.asset(
                    Assets.images.splashBg1.path,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // 🟡 LOGO RIDES WITH THE CARD
              Positioned(
                top: lerpDouble(startLogoY, endLogoY, t)!,
                left: 0,
                right: 0,
                child: Center(
                  child: Image.asset(
                    Assets.icons.agromisLogo.path,
                    width: lerpDouble(160, 95, t),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    overlay.insert(entry);

    Future.delayed(const Duration(milliseconds: 2200), () {
      onDone();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        LoginScreen.showHeader.value = true;
        entry.remove();
      });
    });
  }
}
