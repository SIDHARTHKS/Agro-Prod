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
              return Obx(() => Stack(
                    children: [
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 5000),
                        curve: Curves.easeInOut,
                        top: _exitAnim.value ? -Get.height * 0.6 : 0,
                        left: _exitAnim.value ? Get.width * 0.25 : 0,
                        right: _exitAnim.value ? Get.width * 0.25 : 0,
                        bottom: _exitAnim.value ? null : 0,
                        child: _loaderWidget(),
                      ),
                    ],
                  ));
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

  Widget _loaderWidget() => buildSplashSurface(animateLogo: true);

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
    final loginPage = route.page!();

    entry = OverlayEntry(
      builder: (_) => TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 2200),
        tween: Tween(begin: 0.0, end: 1.0),
        curve: Curves.easeInOutQuart,
        builder: (context, t, child) {
          // Login header geometry
          const double headerInset = 130;
          const double headerVisibleHeight = 110; // 220 * 0.5

          // Animate height perfectly (no scale drift)
          final double bgHeight =
              lerpDouble(Get.height, headerVisibleHeight, t)!;

          // Animate width smoothly
          final double inset = lerpDouble(0.0, headerInset, t)!;

          // Logo path (moves, never scales)
          final double startLogoY = Get.height * 0.5 - 80;
          final double endLogoY = headerVisibleHeight / 2 - 80;

          return Stack(
            fit: StackFit.expand,
            children: [
              Container(color: AppColorHelper().backgroundColor),

              // Login sliding from bottom (no header yet)
              Transform.translate(
                offset: Offset(0, Get.height * (1 - t)),
                child: loginPage,
              ),

              // Splash background morphs into header
              Positioned(
                top: 0,
                left: inset,
                right: inset,
                height: bgHeight,
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

              // Logo moves upward, never scales
              Positioned(
                top: lerpDouble(startLogoY, endLogoY, t)!,
                left: 0,
                right: 0,
                child: Center(
                  child: Image.asset(
                    Assets.icons.agromisLogo.path,
                    width: 160,
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
      // Push Login (without header)
      onDone();

      // In the same frame: show Login header & remove overlay
      WidgetsBinding.instance.addPostFrameCallback((_) {
        LoginScreen.showHeader.value = true;
        entry.remove();
      });
    });
  }

  Widget buildSplashSurface({bool animateLogo = false}) {
    final logo = Image.asset(
      Assets.icons.agromisLogo.path,
      width: 160,
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          Assets.images.splashBg1.path,
          fit: BoxFit.cover,
        ),
        Center(
          child: animateLogo
              ? Obx(() => AnimatedOpacity(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOut,
                    opacity: _showLogo.value ? 1.0 : 0.0,
                    child: logo,
                  ))
              : logo, // static version (for overlay + login header)
        ),
      ],
    );
  }
}
