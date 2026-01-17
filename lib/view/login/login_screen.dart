import 'dart:io';
import 'package:agro/helper/app_message.dart';
import 'package:agro/view/login/bottomsheet/forget_password_bottomsheet.dart';
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
                  height: 220,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      heightFactor: 0.5,
                      child: const SplashScreen()
                          .buildSplashSurface(), // static splash replica
                    ),
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
                      child: Padding(
                        padding: const EdgeInsets.only(top: 260),
                        child: _mobileView(),
                      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 20),
      child: Obx(() {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            height(20),
            appText(
              "HELLO",
              fontSize: 28,
              fontWeight: FontWeight.w400,
              color: AppColorHelper().primaryTextColor,
            ),
            height(10),
            appText(
              "LETS GET STARTED",
              textAlign: TextAlign.center,
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: AppColorHelper().primaryTextColor,
            ),
            //height(80),
            Form(
              key: controller.form,
              child: Column(
                children: [
                  _buildUsernameField(),
                  height(22),
                  _buildPasswordField(),
                  height(15),
                  _showPasswordContainer(),
                  height(Platform.isIOS ? 75 : 70),
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
                        // appText(
                        //   forgetPassworddialogue.tr,
                        //   fontSize: 12,
                        //   fontWeight: FontWeight.w400,
                        //   color: AppColorHelper().primaryTextColor,
                        // ),
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

  Row _showPasswordContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            controller.onShowPassChange();
          },
          child: SizedBox(
            child: Row(
              children: [
                _buildShowPassSwitch(() => controller.onShowPassChange()),
                width(7),
                SizedBox(
                  child: appText("SHOW PASSWORD",
                      color: AppColorHelper().primaryTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUsernameField() {
    final isFocused = controller.isUserFieldFocused.value;
    return Container(
      padding: EdgeInsets.only(
          top: isFocused ? 20.0 : 12.0,
          bottom: isFocused ? 2.0 : 10,
          left: 10,
          right: 10),
      decoration: BoxDecoration(
          color: AppColorHelper().cardColor,
          border: controller.isUsernameValid.value
              ? Border.all(color: AppColorHelper().transparentColor)
              : Border.all(color: AppColorHelper().errorBorderColor),
          borderRadius: BorderRadius.circular(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(left: 4),
          //   child: appText(
          //     username.tr,
          //     fontSize: 12,
          //     fontWeight: FontWeight.w400,
          //     color: AppColorHelper().primaryTextColor.withValues(alpha: 0.7),
          //   ),
          // ),
          TextFormWidget(
            height: 40,
            focusNode: controller.userFocusNode,
            controller: controller.userController,
            borderColor: AppColorHelper().transparentColor,
            textColor: AppColorHelper().primaryTextColor,
            label: username.tr,
            validator: (value) => value!.trim().isEmpty ? null : null,
            nextFocusNode: controller.passwordFocusNode,
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField() {
    final isFocused = controller.isPasswordFieldFocused.value;
    return Container(
        padding: EdgeInsets.only(
            top: isFocused ? 20.0 : 12.0,
            bottom: isFocused ? 2.0 : 10,
            left: 10,
            right: 10),
        decoration: BoxDecoration(
            color: AppColorHelper().cardColor,
            border: controller.isPasswordValid.value
                ? Border.all(color: AppColorHelper().transparentColor)
                : Border.all(color: AppColorHelper().errorBorderColor),
            borderRadius: BorderRadius.circular(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // appText(
            //   password.tr,
            //   fontSize: 12,
            //   fontWeight: FontWeight.w400,
            //   color: AppColorHelper().primaryTextColor.withValues(alpha: 0.7),
            // ),
            TextFormWidget(
              controller: controller.passwordController,
              focusNode: controller.passwordFocusNode,
              borderColor: AppColorHelper().transparentColor,
              label: password.tr,
              textColor: AppColorHelper().primaryTextColor,
              height: 40,
              validator: (value) => value!.trim().isEmpty ? null : null,
              rxObscureText: controller.rxhidePassword,
            ),
          ],
        ));
  }

  Widget _buildShowPassSwitch(VoidCallback ontap) => GestureDetector(
      onTap: ontap,
      child: Container(
          decoration: BoxDecoration(
              color: AppColorHelper().cardColor,
              borderRadius: BorderRadius.circular(4)),
          width: 20,
          height: 20, // match thumb size for better centering
          child: GestureDetector(
            onTap: ontap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: !controller.rxhidePassword.value
                    ? AppColorHelper().primaryColor
                    : AppColorHelper().transparentColor,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: AppColorHelper().borderColor.withValues(alpha: 0.6),
                  width: 1,
                ),
              ),
              child: !controller.rxhidePassword.value
                  ? Icon(
                      Icons.check,
                      color: AppColorHelper().textColor,
                      size: 18,
                    )
                  : null,
            ),
          )));
}
