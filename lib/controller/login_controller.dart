import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helper/app_message.dart';
import '../helper/app_string.dart';
import '../helper/core/base/app_base_controller.dart';
import '../helper/core/environment/env.dart';
import '../helper/deviceInfo.dart';
import '../helper/enum.dart';
import '../model/login_model.dart';
import '../service/auth_service.dart';

class LoginController extends AppBaseController {
  final AuthService _authService = Get.find<AuthService>();

  // fields
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var isUserFieldFocused = false.obs;
  var isPasswordFieldFocused = false.obs;
  RxBool isUsernameValid = true.obs;
  RxBool isPasswordValid = true.obs;
  late GlobalKey<FormState> form;
  final FocusNode userFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  //new pass fields
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  final FocusNode newpasswordFocusNode = FocusNode();
  final FocusNode confirmpasswordFocusNode = FocusNode();
  RxBool isSixChar = false.obs;
  RxBool isCaps = false.obs;
  RxBool isSpecial = false.obs;
  RxBool isdigits = false.obs;

  RxBool newPassVisible = false.obs;
  RxBool confirmNewPassVisible = false.obs;

  //

  // otp
  TextEditingController otpcontroller1 = TextEditingController();
  TextEditingController otpcontroller2 = TextEditingController();
  TextEditingController otpcontroller3 = TextEditingController();
  TextEditingController otpcontroller4 = TextEditingController();
  RxString enteredOtp = ''.obs;
  //

  RxBool rxRememberMe = true.obs;
  RxBool rxhidePassword = true.obs;

  //response
  Rxn<LoginResponse> rxLoginData = Rxn<LoginResponse>();
  Rxn<LoginResponse> rxLoginResponse = Rxn<LoginResponse>();
  Rxn<UserLoginResponse> rxUserLoginResponse = Rxn<UserLoginResponse>();
  // forget
  Rxn<EmailResponse> rxMailResponse = Rxn<EmailResponse>();
  Rxn<OtpResponse> rxOtpResponse = Rxn<OtpResponse>();

  final ScrollController scrollController = ScrollController();
  final RxDouble headerHeight = 211.0.obs; // max height

  @override
  Future<void> onInit() async {
    form = GlobalKey<FormState>();

    userFocusNode.addListener(() {
      isUserFieldFocused.value =
          (userFocusNode.hasFocus || userController.text.isNotEmpty);
    });

    passwordFocusNode.addListener(() {
      isPasswordFieldFocused.value =
          (passwordFocusNode.hasFocus || passwordController.text.isNotEmpty);
    });

    scrollController.addListener(() {
      final offset = scrollController.offset;

      // 211 = max, 110 = min
      final h = (211 - offset).clamp(110.0, 211.0);
      headerHeight.value = h;
    });

    super.onInit();
  }

  void _devEnvSetup() {
    if (AppEnvironment.isDevMode()) {
      // userController.text = 'sidharthshibu@muziris.co.in';
      // passwordController.text = '123';
    }
  }

  Future<void> _loadStartup() async {
    var preference = myApp.preferenceHelper;

    String? deviceId = await DeviceUtil.getDeviceId();
    if (preference != null) {
      await preference.setString(deviceIdKey, deviceId ?? '');
      if (rxRememberMe.value) {
        userController.text = preference.getString(emailKey);
        passwordController.text = preference.getString(loginPasswordKey);
      }
    }
  }

  void onShowPassChange() async {
    rxhidePassword.value = !rxhidePassword.value;
  }

  Future<bool> signIn() async {
    hideKeyboard();
    if (isValidCredentials()) {
      bool status = await _callSignInService();

      return status;
    }

    return false;
  }

  bool isValidCredentials() {
    String email = userController.text.trim();
    String password = passwordController.text.trim();

    // username validation
    if (isStringNullOrEmpty(email)) {
      isUsernameValid(false);
    } else {
      isUsernameValid(true);
    }

    // // password validation
    if (isStringNullOrEmpty(password)) {
      isPasswordValid(false);
    } else {
      isPasswordValid(true);
    }

    // //Temporary Use Only
    // isUsernameValid(true);
    // isPasswordValid(true);

    // return true only if both are valid
    if (isUsernameValid.value && isPasswordValid.value) {
      return true;
    }
    return false;
  }

  String gfPwdConvert(String chrText) {
    String pwd = '';
    try {
      // Encrypt
      String trimmed = chrText.trim();
      for (int i = 0; i < trimmed.length; i++) {
        int code = trimmed.codeUnitAt(i) + 100;
        pwd += String.fromCharCode(code);
      }
    } catch (e) {
      // handle/log error if needed
    }
    return pwd;
  }

  Future<bool> _callSignInService() async {
    try {
      showLoader();
      await Future.delayed(const Duration(milliseconds: 150));
      String username = userController.text.trim();
      String password = gfPwdConvert(passwordController.text.trim());

      LoginResponse? response = await _authService.login(LoginRequest(
        userCode: user,
        password: pass,
      ));
      if (response != null) {
        rxLoginResponse.value = response;
        myApp.preferenceHelper!
            .setString(accessTokenKey, rxLoginResponse.value!.data ?? '');

        bool setProfile = await _callUserSignIn(username, password);
        //bool setProfile = true;
        return setProfile;
      }
    } catch (e) {
      appLog('$exceptionMsg $e', logging: Logging.error);
    } finally {
      hideLoader();
    }
    return false;
  }

  Future<bool> _callUserSignIn(String name, String pass) async {
    try {
      showLoader();
      // var userLoginRequestList = [
      //   CommonRequest(attribute: "UserCode", value: name),
      //   CommonRequest(attribute: "UserPassword", value: pass),
      // ];
      UserLoginResponse? response =
          await _authService.userLogin(UserLoginRequest(
        userCode: name,
        password: pass,
      ));
      if (response != null) {
        rxUserLoginResponse.value = response;
        await _saveLoginDataToPref();

        userController.clear();
        passwordController.clear();

        return true;
      }
    } catch (e) {
      appLog('$exceptionMsg $e', logging: Logging.error);
    } finally {
      hideLoader();
    }
    return false;
  }

  Future<void> _saveLoginDataToPref() async {
    if (myApp.preferenceHelper != null) {
      inspect(rxLoginResponse.value);

      //username & pass
      myApp.preferenceHelper!
          .setString(loginNameKey, userController.text.trim());
      myApp.preferenceHelper!
          .setString(loginPasswordKey, passwordController.text.trim());

      //user details
      myApp.preferenceHelper!
          .setString(userNameKey, rxUserLoginResponse.value!.userName ?? '');
      myApp.preferenceHelper!.setString(
          userIdKey, (rxUserLoginResponse.value!.userId ?? "").toString());

      myApp.preferenceHelper!.setString(
          defaultCompCodeKey, rxUserLoginResponse.value!.defaultCompCode ?? '');

      myApp.preferenceHelper!.setString(defaultBranchCodeKey,
          rxUserLoginResponse.value!.defaultBranchCode ?? '');

      myApp.preferenceHelper!.setString(defaultLocationIDKey,
          (rxUserLoginResponse.value!.defaultLocationId ?? "").toString());

      // token
      myApp.preferenceHelper!
          .setString(accessTokenKey, rxLoginResponse.value!.data ?? '');

      //remember me
      myApp.preferenceHelper!.setBool(rememberMeKey, rxRememberMe.value);
    }
  }

  // Future<bool> handleForgotPassword() async {
  //   if (userController.text.isEmpty) {
  //     showErrorSnackbar(
  //         message: 'Unable to proceed due to an error. Enter your usercode');
  //     return false;
  //   }

  //   await getMail().then((success) async {
  //     if (success) {
  //       await _sendVerification();
  //     }
  //     return true;
  //   });
  //   return false;
  // }

  // Future<bool> getMail() async {
  //   try {
  //     showLoader();
  //     String username = userController.text.trim();
  //     if (!username.endsWith("@MUZIRIS")) {
  //       username += "@MUZIRIS";
  //     }
  //     var mailRequestList = [
  //       CommonRequest(attribute: "transType", value: "LIST"),
  //       CommonRequest(attribute: "transSubType", value: "GET_EMAIL"),
  //       CommonRequest(attribute: "userCode", value: username),
  //     ];
  //     EmailResponse? response = await _authService.getMail(mailRequestList);
  //     if (response != null) {
  //       rxMailResponse.value = response;
  //       return true;
  //     }
  //   } catch (e) {
  //     appLog('$exceptionMsg $e', logging: Logging.error);
  //   } finally {
  //     hideLoader();
  //   }
  //   return false;
  // }

  // Future<bool> _sendVerification() async {
  //   try {
  //     showLoader();

  //     String username = userController.text.trim();
  //     if (!username.endsWith("@MUZIRIS")) {
  //       username += "@MUZIRIS";
  //     }
  //     var otpRequestList = [
  //       CommonRequest(attribute: "transType", value: "LIST"),
  //       CommonRequest(
  //           attribute: "transSubType", value: "VERIFICATION_CODE_GNRTE"),
  //       CommonRequest(attribute: "userCode", value: username),
  //       CommonRequest(attribute: "usepasswordrCode", value: ""),
  //       CommonRequest(
  //           attribute: "email", value: rxMailResponse.value!.emailId ?? ''),
  //       CommonRequest(attribute: "verificationCode", value: ""),
  //       CommonRequest(attribute: "flag", value: "UPDATE_PASSWORD"),
  //     ];
  //     OtpResponse? response = await _authService.getOtp(otpRequestList);
  //     if (response != null) {
  //       rxOtpResponse.value = response;

  //       return true;
  //     }
  //   } catch (e) {
  //     appLog('$exceptionMsg $e', logging: Logging.error);
  //   } finally {
  //     hideLoader();
  //   }
  //   return false;
  // }

  // Future<bool> verifyVerificationCode() async {
  //   try {
  //     showLoader();

  //     String username = userController.text.trim();
  //     if (!username.endsWith("@MUZIRIS")) {
  //       username += "@MUZIRIS";
  //     }
  //     String otp = await combineOTP();
  //     var otpVerificationList = [
  //       CommonRequest(attribute: "transType", value: "LIST"),
  //       CommonRequest(
  //           attribute: "transSubType", value: "VERIFY_VERIFICATIONCODE"),
  //       CommonRequest(attribute: "userCode", value: ""),
  //       CommonRequest(attribute: "password", value: ""),
  //       CommonRequest(attribute: "email", value: ""),
  //       CommonRequest(attribute: "verificationCode", value: otp),
  //     ];
  //     bool response = await _authService.verifyOtp(otpVerificationList);
  //     return response;
  //   } catch (e) {
  //     appLog('$exceptionMsg $e', logging: Logging.error);
  //     return false;
  //   } finally {
  //     hideLoader();
  //   }
  // }

  Future<String> combineOTP() async {
    String value1 = otpcontroller1.text;
    String value2 = otpcontroller2.text;
    String value3 = otpcontroller3.text;
    String value4 = otpcontroller4.text;
    enteredOtp.value = '$value1$value2$value3$value4';
    appLog('ENTEREDOTP:${enteredOtp.value} ');
    otpcontroller1.clear();
    otpcontroller2.clear();
    otpcontroller3.clear();
    otpcontroller4.clear();
    return enteredOtp.value;
  }

  void isValidPass(String value) {
    final pass = value.trim();

    // ✅ Must have at least 6 characters
    isSixChar(pass.length >= 6);

    // ✅ Must have both uppercase and lowercase letters
    final hasUpper = pass.contains(RegExp(r'[A-Z]'));
    final hasLower = pass.contains(RegExp(r'[a-z]'));
    isCaps(hasUpper && hasLower);

    // ✅ Must have at least one digit
    isdigits(pass.contains(RegExp(r'[0-9]')));

    // ✅ Must have at least one special character
    isSpecial(pass.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]')));
  }

  void resetValidation() {
    isSixChar(false);
    isCaps(false);
    isdigits(false);
    isSpecial(false);
  }

  void toggleVisibility() {
    newPassVisible.value = !newPassVisible.value;
  }

  // Future<bool> callChangePassword() async {
  //   await showModalBottomSheet(
  //     context: Get.context!,
  //     isScrollControlled: true,
  //     isDismissible: false,
  //     backgroundColor: Colors.transparent, // Prevents the default white shade
  //     barrierColor: Colors.black.withOpacity(0.2),
  //     builder: (context) {
  //       return Padding(
  //         // This padding pushes the sheet up when the keyboard appears
  //         padding: EdgeInsets.only(
  //           bottom: MediaQuery.of(context).viewInsets.bottom,
  //         ),
  //         child: ClipRRect(
  //           borderRadius: const BorderRadius.only(
  //             topLeft: Radius.circular(20),
  //             topRight: Radius.circular(20),
  //           ),
  //           child: SizedBox(
  //             height: Platform.isAndroid
  //                 ? (Get.height * 0.82)
  //                 : (Get.height * 0.82), // e.g., 75% of screen height
  //             child: const ChangePasswordBottomsheet(),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  //   return true;
  // }

  Future<bool> fetchInitData() async {
    await _loadStartup();
    _devEnvSetup();

    return true;
  }
}
