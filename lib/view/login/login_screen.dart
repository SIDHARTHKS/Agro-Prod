import 'dart:io';
import 'package:agro/helper/app_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/login_controller.dart';
import '../../gen/assets.gen.dart';
import '../../helper/app_string.dart';
import '../../helper/color_helper.dart';
import '../../helper/core/base/app_base_view.dart';
import '../../helper/navigation.dart';
import '../../helper/route.dart';
import '../../helper/sizer.dart';
import '../../service/auth_service.dart';
import '../widget/common_widget.dart';
import '../widget/animatedexpandcontainer/animated_expand_container.dart';
import '../widget/textformfield/app_textformfield_widget.dart';

class LoginScreen extends AppBaseView<LoginController> {
  final AuthService _authService = Get.find<AuthService>();
  LoginScreen({super.key});

  final GlobalKey _userFieldKey = GlobalKey();
  final GlobalKey _passFieldKey = GlobalKey();

  //
  //static const double headerInset = 130;
  static final RxBool showHeader = true.obs;

  @override
  Widget buildView() => _buildScaffold();

  Scaffold _buildScaffold() => appScaffold(
        topSafe: false,
        bottomSafe: false,
        resizeToAvoidBottomInset: true,
        body: appFutureBuilder<void>(
          () => controller.fetchInitData(),
          (context, snapshot) => _buildBody(),
        ),
      );

  Widget _buildBody() {
    return SizedBox.expand(
      child: Stack(
        children: [
          // 1️⃣ Static splash background – never moves
          Positioned.fill(
            child: Image.asset(
              Assets.images.splashBg1.path,
              fit: BoxFit.cover,
            ),
          ),

          // 2️⃣ Login background (behind everything)
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: 1.05, // >1 stretches vertically downward
                widthFactor: 1.0,
                child: Image.asset(
                  Assets.images.loginBg1.path,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1400),
            curve: Curves.easeOutCubic,
            tween: Tween(begin: -80.0, end: 0.0), // start 80px above
            builder: (context, dy, child) {
              return Transform.translate(
                offset: Offset(0, dy),
                child: Opacity(
                  opacity: 1 - (dy.abs() / 80).clamp(0, 1),
                  child: child,
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                appText(
                  "Let's Get Started",
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: AppColorHelper().primaryTextColor,
                ),
                const SizedBox(height: 10),
                FractionallySizedBox(
                  widthFactor: 0.90,
                  child: Center(
                    child: appText(
                      'Login to manage and track your business journey',
                      textAlign: TextAlign.center,
                      fontSize: 14,
                      color: AppColorHelper().primaryTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Obx(() {
            return AnimatedOpacity(
                duration: const Duration(
                    milliseconds: 1000), // controls how slow it disappears
                curve: Curves.easeOut,
                opacity: controller.isRibbonDone.value ? 0.0 : 1.0,
                child: IgnorePointer(
                    ignoring: controller.isRibbonDone.value,
                    child: AnimatedExpandContainer(
                      onComplete: () => controller.isRibbonDone.value = true,
                      delay: const Duration(milliseconds: 400),
                      duration: const Duration(milliseconds: 1400),
                      initialHeight: Get.height,
                      finalHeight: 220,
                      initialWidth: Get.width,
                      finalWidth: Get.width * 0.4,
                      alignment: Alignment.topCenter,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              Assets.images.splashBg4.path,
                              fit: BoxFit.cover,
                            ),

                            // 🔷 Logo animation
                            Center(
                              child: TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 2000),
                                curve: Curves.easeInOut,
                                tween: Tween<double>(
                                  begin: 1.0, // splash size
                                  end: 1.6, // final header size (tune this)
                                ),
                                builder: (context, scale, logoChild) {
                                  return TweenAnimationBuilder<Alignment>(
                                    duration:
                                        const Duration(milliseconds: 1200),
                                    curve: Curves.easeInOut,
                                    tween: AlignmentTween(
                                      begin: const Alignment(0, 1),
                                      end: const Alignment(0, 0.45),
                                    ),
                                    builder: (context, alignment, child) {
                                      return Align(
                                        alignment: alignment,
                                        child: Transform.scale(
                                          scale: scale,
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: logoChild,
                                  );
                                },
                                child: FractionallySizedBox(
                                  widthFactor: 0.35,
                                  child: Image.asset(
                                    Assets.images.agromisLogo.path,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )));
          }),
          // 4️⃣ Login content – slides up in sync
          AnimatedExpandContainer(
            delay: const Duration(milliseconds: 400),
            duration: const Duration(milliseconds: 1400),
            initialHeight: 0,
            finalHeight: Get.height,
            initialWidth: Get.width,
            finalWidth: Get.width,
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () => FocusScope.of(Get.context!).unfocus(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: controller.scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          // const SizedBox(height: 220), // space under ribbon
                          // Static header that replaces the ribbon
                          Obx(() => AnimatedOpacity(
                                duration: const Duration(milliseconds: 500),
                                opacity: controller.isRibbonDone.value ? 1 : 0,
                                child: SizedBox(
                                  height: 220,
                                  width: Get.width * 0.4,
                                  child: LoginScreen.buildHeaderSurface(),
                                ),
                              )),
                          _mobileView(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _mobileView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
      child: Obx(() {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            height(40),
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1400),
              curve: Curves.easeOutCubic,
              tween: Tween(begin: -80.0, end: 0.0),
              builder: (context, dy, child) {
                return Transform.translate(
                  offset: Offset(0, dy),
                  child: Opacity(
                    opacity: (1 - (dy.abs() / 80)).clamp(0.0, 1.0),
                    child: child,
                  ),
                );
              },
              child: Column(
                children: [
                  appText(
                    "Let's Get Started",
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: AppColorHelper().primaryTextColor,
                  ),
                  height(10),
                  FractionallySizedBox(
                    widthFactor: 0.90,
                    child: Center(
                      child: appText(
                        'Login to manage and track your business journey',
                        textAlign: TextAlign.center,
                        fontSize: 14,
                        color: AppColorHelper().primaryTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            height(100),
            Form(
              key: controller.form,
              child: Column(
                children: [
                  _buildUsernameField(),
                  height(22),
                  _buildPasswordField(),

                  // _showPasswordContainer(),
                  height(Platform.isIOS ? 50 : 45),
                  buttonContainer(
                    radius: 10,
                    height: 70,
                    color: AppColorHelper().primaryColor,
                    controller.rxIsLoading.value
                        ? buttonLoader()
                        : appText(
                            login.tr,
                            fontSize: 18,
                            color: AppColorHelper().textColor,
                            fontWeight: FontWeight.w500,
                          ),
                    //           onPressed: () {

                    // }
                    onPressed: () async {
                      if (controller.rxIsLoading.value) return;

                      await controller.signIn().then((success) {
                        if (success) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            navigateToAndRemoveAll(
                              homePageRoute,
                            );
                          });
                        } else {
                          showErrorSnackbar(
                              title: "Invalid Credentials",
                              message:
                                  "Login failed. Please check your username and password.");
                        }
                      });
                    },
                  ),
                  height(20),

                  GestureDetector(
                    onTap: () async {
                      // controller.handleForgotPassword().then((success) async {
                      //   if (success) {
                      //     await showModalBottomSheet(
                      //       context: Get.context!,
                      //       isScrollControlled: true,
                      //       backgroundColor: Colors.transparent,
                      //       builder: (context) {
                      //         return Padding(
                      //           // This padding pushes the sheet up when the keyboard appears
                      //           padding: EdgeInsets.only(
                      //             bottom:
                      //                 MediaQuery.of(context).viewInsets.bottom,
                      //           ),
                      //           child: ClipRRect(
                      //             borderRadius: const BorderRadius.only(
                      //               topLeft: Radius.circular(20),
                      //               topRight: Radius.circular(20),
                      //             ),
                      //             child: SizedBox(
                      //               height: Platform.isAndroid
                      //                   ? (Get.height * 0.52)
                      //                   : (Get.height * 0.58),
                      //               child: const ForgetPasswordBottomsheet(),
                      //             ),
                      //           ),
                      //         );
                      //       },
                      //     );
                      //   }
                      // });
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.centerLeft,
                      children: [
                        Text(
                          forgetPassworddialogue.tr,
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColorHelper().primaryTextColor,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Mona Sans'),
                        ),
                        // Positioned(
                        //   bottom:
                        //       -1, // 👈 increase this value to move the underline lower
                        //   child: Container(
                        //     height: 1,
                        //     width: forgetPassworddialogue.tr.length *
                        //         6.5, // adjusts underline width
                        //     color: AppColorHelper()
                        //         .primaryTextColor
                        //         .withValues(alpha: 0.5),
                        //   ),
                        // ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildUsernameField() {
    return Focus(
      child: Column(
        key: _userFieldKey,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 0, bottom: 10),
            child: appText(
              username,
              fontSize: 13,
              fontWeight: FontWeight.normal,
              color: AppColorHelper().primaryTextColor,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColorHelper().cardColor,
              border: Border.all(
                color: AppColorHelper().primaryTextColor.withValues(alpha: 0.2),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextFormWidget(
              controller: controller.userController,
              focusNode: controller.userFocusNode, // only here
              nextFocusNode: controller.passwordFocusNode,
              label: null,
              height: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField() {
    final isFocused = controller.isPasswordFieldFocused.value;

    return Focus(
      child: Column(
        key: _passFieldKey,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 0, bottom: 10),
            child: appText(
              password.tr,
              fontSize: 13,
              fontWeight: FontWeight.normal,
              color: AppColorHelper().primaryTextColor,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: isFocused ? 8.0 : 6.0,
              bottom: isFocused ? 8.0 : 6.0,
              left: 10,
              right: 3,
            ),
            decoration: BoxDecoration(
              color: AppColorHelper().cardColor,
              border: controller.isPasswordValid.value
                  ? Border.all(
                      color: AppColorHelper()
                          .primaryTextColor
                          .withValues(alpha: 0.2),
                    )
                  : Border.all(color: AppColorHelper().errorBorderColor),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextFormWidget(
              controller: controller.passwordController,
              focusNode: controller.passwordFocusNode, // only here
              borderColor: AppColorHelper().transparentColor,
              label: null,
              textColor: AppColorHelper().primaryTextColor,
              height: 40,
              validator: (value) => value!.trim().isEmpty ? null : null,
              rxObscureText: controller.rxhidePassword,
              enableObscureToggle: true,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildShowPassSwitch(VoidCallback ontap) => GestureDetector(
  //     onTap: ontap,
  //     child: Container(
  //         decoration: BoxDecoration(
  //             color: AppColorHelper().cardColor,
  //             borderRadius: BorderRadius.circular(4)),
  //         width: 20,
  //         height: 20, // match thumb size for better centering
  //         child: GestureDetector(
  //           onTap: ontap,
  //           child: AnimatedContainer(
  //             duration: const Duration(milliseconds: 200),
  //             decoration: BoxDecoration(
  //               color: !controller.rxhidePassword.value
  //                   ? AppColorHelper().primaryColor
  //                   : AppColorHelper().transparentColor,
  //               borderRadius: BorderRadius.circular(4),
  //               border: Border.all(
  //                 color: AppColorHelper().borderColor.withValues(alpha: 0.6),
  //                 width: 1,
  //               ),
  //             ),
  //             child: !controller.rxhidePassword.value
  //                 ? Icon(
  //                     Icons.check,
  //                     color: AppColorHelper().textColor,
  //                     size: 18,
  //                   )
  //                 : null,
  //           ),
  //         )));

  static Widget buildHeaderSurface() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background exactly like the ribbon’s final frame
          Image.asset(
            Assets.images.headerBg.path,
            fit: BoxFit.cover,
          ),

          // Final-position logo (no animation here)
          Align(
            alignment: const Alignment(0, 0.54), // same as ribbon end
            child: FractionallySizedBox(
              widthFactor: 0.56, // same visual size as ribbon end
              child: Image.asset(
                Assets.images.agromisLogo.path,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
