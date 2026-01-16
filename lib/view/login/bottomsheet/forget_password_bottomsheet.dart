import 'package:agro/view/widget/otp/otp_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/login_controller.dart';
import '../../../helper/app_string.dart';
import '../../../helper/color_helper.dart';
import '../../../helper/core/base/app_base_view.dart';
import '../../../helper/navigation.dart';
import '../../../helper/sizer.dart';
import '../../widget/common_widget.dart';

class ForgetPasswordBottomsheet extends AppBaseView<LoginController> {
  // final ScrollController? scrollController;
  const ForgetPasswordBottomsheet({super.key});

  @override
  Widget buildView() => _widgetView();

  Widget _widgetView() {
    return appScaffold(body: _buildBody());
  }

  Widget _buildBody() => Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                appText(forgetPassword.tr,
                    color: AppColorHelper().primaryTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 17),
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColorHelper().primaryColor,
                  ),
                  child: iconWidget(Icons.close,
                      color: AppColorHelper().textColor, onPressed: goBack),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: divider(
                  color: AppColorHelper().borderColor.withValues(alpha: 0.4)),
            ),
            height(12),
            Center(
              child: appText("SEND VERIFICATION CODE",
                  textAlign: TextAlign.center,
                  color: AppColorHelper().primaryTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
            height(25),
            Center(
              child: controller.rxMailResponse.value == null
                  ? SizedBox(height: 15, child: textLoader())
                  : appText(controller.rxMailResponse.value?.emailId ?? '',
                      color: AppColorHelper().primaryTextColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
            ),
            height(43),
            Center(
              child: appText("OTP",
                  color:
                      AppColorHelper().primaryTextColor.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
            height(20),
            OTPField(
              controllers: [
                controller.otpcontroller1,
                controller.otpcontroller2,
                controller.otpcontroller3,
                controller.otpcontroller4
              ],
            ),
            height(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                appText(didntRecieve.tr,
                    color: AppColorHelper()
                        .primaryTextColor
                        .withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                    fontSize: 13),
                width(2),
                GestureDetector(
                  onTap: () {},
                  child: appText("RESEND",
                      color: AppColorHelper().primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 13),
                ),
              ],
            ),
            height(40),
            SafeArea(
              child: buttonContainer(
                onPressed: () {
                  // controller.verifyVerificationCode().then((success) {
                  //   if (success) {
                  //     // navigateToAndRemoveAll(createPasswordPageRoute);
                  //   } else {
                  //     goBack();
                  //   }
                  // });
                },
                color: AppColorHelper().primaryColor,
                controller.rxIsLoading.value
                    ? buttonLoader()
                    : appText("VERIFY OTP",
                        color: AppColorHelper().textColor,
                        fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      );
}
