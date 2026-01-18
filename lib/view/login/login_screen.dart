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
import '../splash/splash_screen.dart';
import '../widget/textformfield/app_textformfield_widget.dart';

class LoginScreen extends AppBaseView<LoginController> {
  final AuthService _authService = Get.find<AuthService>();
  LoginScreen({super.key});

  static final RxBool _headerArrived = false.obs;
  static final GlobalKey headerKey = GlobalKey();
  static const double headerInset = 130;
  static final RxBool showHeader = false.obs;

  @override
  Widget buildView() => _buildScaffold();

  Scaffold _buildScaffold() => appScaffold(
        topSafe: false,
        resizeToAvoidBottomInset: false, // prevent BG reshape
        body: appFutureBuilder<void>(
          () => controller.fetchInitData(),
          (context, snapshot) => _buildBody(),
        ),
      );

  Widget _buildBody() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_headerArrived.value) {
        _headerArrived.value = true;
      }
    });

    return SizedBox.expand(
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              Assets.images.loginBg1.path,
              fit: BoxFit.cover,
            ),
          ),

          Obx(() => showHeader.value
              ? Positioned(
                  top: 0,
                  left: headerInset,
                  right: headerInset,
                  height: controller.headerHeight.value,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: LoginScreen.buildHeaderSurface(),
                  ),
                )
              : const SizedBox()),

          // Login content
          SafeArea(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(Get.context!).unfocus();
              },
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    controller: controller.scrollController,
                    reverse: true,
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.only(
                      left: 12,
                      right: 12,
                      top: 20,
                      bottom: MediaQuery.of(context).viewInsets.bottom * 0.5,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight -
                            MediaQuery.of(context).viewInsets.bottom * 0.5,
                      ),
                      child: Obx(() => Padding(
                            padding: EdgeInsets.only(
                                top: controller.headerHeight.value),
                            child: _mobileView(),
                          )),
                    ),
                  );
                },
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
            height(50),
            appText(
              "Let's Get Started",
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: AppColorHelper().primaryTextColor,
            ),
            height(10),
            const FractionallySizedBox(
              widthFactor: 0.80, // Takes up 80% of any screen width
              child: Text(
                'Login to manage and track your business journey',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
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
                  height(Platform.isIOS ? 55 : 50),
                  buttonContainer(
                    height: 50,
                    color: AppColorHelper().primaryColor,
                    controller.rxIsLoading.value
                        ? buttonLoader()
                        : appText(
                            login.tr,
                            fontSize: 16,
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
                  height(30),
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
                              fontSize: 13,
                              color: AppColorHelper().primaryTextColor,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Mona Sans'),
                        ),
                        Positioned(
                          bottom:
                              -1, // 👈 increase this value to move the underline lower
                          child: Container(
                            height: 1,
                            width: forgetPassworddialogue.tr.length *
                                6.5, // adjusts underline width
                            color: AppColorHelper()
                                .primaryTextColor
                                .withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            height(30),
          ],
        );
      }),
    );
  }

  Widget _buildUsernameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0, bottom: 6),
          child: appText(
            username.tr,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColorHelper().primaryTextColor,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColorHelper().cardColor,
            border: Border.all(
                color:
                    AppColorHelper().primaryTextColor.withValues(alpha: 0.2)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormWidget(
            controller: controller.userController,
            focusNode: controller.userFocusNode,
            nextFocusNode: controller.passwordFocusNode,
            label: null, // ⬅ no inside label
            height: 40,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    final isFocused = controller.isPasswordFieldFocused.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: appText(
            password.tr,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColorHelper().primaryTextColor,
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            top: isFocused ? 8.0 : 6.0,
            bottom: isFocused ? 8.0 : 6.0,
            left: 10,
            right: 10,
          ),
          decoration: BoxDecoration(
            color: AppColorHelper().cardColor,
            border: controller.isPasswordValid.value
                ? Border.all(
                    color: AppColorHelper()
                        .primaryTextColor
                        .withValues(alpha: 0.2))
                : Border.all(color: AppColorHelper().errorBorderColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormWidget(
            controller: controller.passwordController,
            focusNode: controller.passwordFocusNode,
            borderColor: AppColorHelper().transparentColor,
            label: null, // ⬅ no inside label
            textColor: AppColorHelper().primaryTextColor,
            height: 40,
            validator: (value) => value!.trim().isEmpty ? null : null,
            rxObscureText: controller.rxhidePassword,
            enableObscureToggle: true,
          ),
        ),
      ],
    );
  }

  static Widget buildHeaderSurface({
    bool animateLogo = false,
    RxBool? showLogo,
  }) {
    final logo = Image.asset(
      Assets.icons.agromisLogo.path,
      width: 93.12,
      height: 61.92,
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          color: AppColorHelper().secondaryTextColor,
          child: Image.asset(
            Assets.images.loginTeaBg.path,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 90,
          bottom: 17,
          left: 35,
          right: 35,
          child: animateLogo && showLogo != null
              ? Obx(() => AnimatedOpacity(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOut,
                    opacity: showLogo.value ? 1.0 : 0.0,
                    child: logo,
                  ))
              : logo,
        ),
      ],
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
}
