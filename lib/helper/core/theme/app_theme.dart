import 'package:flutter/material.dart';

import '../../enum.dart';

class AppTheme {
  final String name; // Client name or identifier
  final Color dashBoardContainerBgColor;
  final Color unreadNotification;
  final Color readNotification;
  final Color buttonContainerBgColor;
  final Color loaderColor;
  final Color loaderSecondaryColor;
  final Color toastMsgColor;
  final Color circleAvatarBgColor;
  final Color boxShadowColor;
  final Color pwdFormFieldBorderColor;
  final Color cardTextColor;
  final Color transparentColor;
  final Color primaryColor;
  final Color primaryColorLight;
  final Color primaryColorDark;
  final Color backgroundColor;
  final Color cardColor;
  final Color dialogBackgroundColor;
  final Color canvasColor;
  final Color buttonColor;
  final Color textColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final Color lightTextColor;
  final Color buttonTextColor;
  final Color disabledTextColor;
  final Color hintColor;
  final Color errorColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color enabledBorderColor;
  final Color disabledBorderColor;
  final Color errorBorderColor;
  final Color dividerColor;
  final Color iconColor;
  final Color selectedIconColor;
  final Color unselectedIconColor;

  final Color switchActiveColor;
  final Color switchInactiveColor;

  final Color checkColor;

  //
  final Color secondaryColor;
  final Color secondaryBackgroundColor;
  final Color warningRedColor;
  final Color warningYellowColor;
  final Color successGreenColor;
  final Color warningBackgroundRed;
  final Color warningBackgroundYellow;
  final Color successBackgroundGreen;
  final Color infoBackgroundYellow;
  final Color infoBorderYellow;
  final Color filterBackgroundColor;
  final Color filterInfoBackgroundColor;
  final Color filterInfoBorderColor;

  final String fontFamily;
  final String imagePath; // Path to client-specific images

  AppTheme({
    required this.name,
    required this.dashBoardContainerBgColor,
    required this.unreadNotification,
    required this.readNotification,
    required this.buttonContainerBgColor,
    required this.loaderColor,
    required this.loaderSecondaryColor,
    required this.toastMsgColor,
    required this.circleAvatarBgColor,
    required this.boxShadowColor,
    required this.pwdFormFieldBorderColor,
    required this.cardTextColor,
    required this.transparentColor,
    required this.primaryColor,
    required this.primaryColorLight,
    required this.primaryColorDark,
    required this.backgroundColor,
    required this.cardColor,
    required this.dialogBackgroundColor,
    required this.canvasColor,
    required this.buttonColor,
    required this.textColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.lightTextColor,
    required this.disabledTextColor,
    required this.buttonTextColor,
    required this.hintColor,
    required this.errorColor,
    required this.borderColor,
    required this.focusedBorderColor,
    required this.enabledBorderColor,
    required this.disabledBorderColor,
    required this.errorBorderColor,
    required this.dividerColor,
    required this.iconColor,
    required this.selectedIconColor,
    required this.unselectedIconColor,
    required this.fontFamily,
    required this.imagePath,
    required this.switchActiveColor,
    required this.switchInactiveColor,
    required this.checkColor,
    required this.secondaryColor,
    required this.secondaryBackgroundColor,
    required this.warningRedColor,
    required this.warningYellowColor,
    required this.successGreenColor,
    required this.warningBackgroundRed,
    required this.warningBackgroundYellow,
    required this.successBackgroundGreen,
    required this.infoBackgroundYellow,
    required this.infoBorderYellow,
    required this.filterBackgroundColor,
    required this.filterInfoBackgroundColor,
    required this.filterInfoBorderColor,
  });
}

final Map<AppClient, Map<ThemeModeType, AppTheme>> appThemes = {
  AppClient.agro: {
    ThemeModeType.light: _demoLightTheme(),
    ThemeModeType.dark: _demoDarkTheme(),
  },
};

AppTheme _demoDarkTheme() => AppTheme(
      name: 'Agro',

      cardTextColor: Colors.white,
      readNotification: const Color.fromARGB(255, 255, 254, 254),
      unreadNotification: const Color.fromRGBO(29, 180, 106, 1),
      dashBoardContainerBgColor: const Color(0xFFD9D9EB).withOpacity(.12),
      buttonContainerBgColor: const Color(0xFF464544),
      loaderColor: Colors.white.withOpacity(0.5),
      loaderSecondaryColor: Colors.white.withOpacity(0.5),
      circleAvatarBgColor: Colors.white,
      toastMsgColor: const Color(0xff323030),
      boxShadowColor: Colors.black.withOpacity(.1),
      pwdFormFieldBorderColor: Colors.black54,
      transparentColor: Colors.transparent,
      primaryColor: const Color.fromRGBO(0, 182, 86, 1)!,
      primaryColorLight: const Color.fromARGB(255, 173, 255, 211)!,
      primaryColorDark: const Color.fromARGB(255, 2, 95, 45)!,
      backgroundColor: Colors.black,
      cardColor: Colors.grey[850]!,
      dialogBackgroundColor: Colors.grey[800]!,
      canvasColor: Colors.grey[900]!,
      buttonColor: const Color.fromRGBO(0, 182, 86, 1),
      textColor: Colors.white,
      primaryTextColor: Colors.white,
      secondaryTextColor: const Color.fromRGBO(0, 182, 86, 1),
      lightTextColor: const Color.fromARGB(255, 224, 224, 224),
      disabledTextColor: Colors.grey[600]!,
      buttonTextColor: Colors.white,
      hintColor: Colors.grey[500]!,
      errorColor: const Color.fromARGB(255, 248, 18, 18),
      borderColor: const Color.fromARGB(255, 218, 212, 251)!,
      focusedBorderColor: Colors.lightBlueAccent,
      enabledBorderColor: Colors.grey[700]!,
      disabledBorderColor: Colors.grey[800]!,
      errorBorderColor: Colors.redAccent,
      dividerColor: Colors.white,
      iconColor: const Color.fromARGB(255, 223, 223, 223),
      selectedIconColor: Colors.lightBlue,
      unselectedIconColor: Colors.grey[600]!,

      //

      switchActiveColor: const Color.fromRGBO(180, 29, 141, 1),
      switchInactiveColor: const Color.fromARGB(255, 142, 131, 192),

      checkColor: const Color.fromRGBO(102, 206, 16, 1),

      // custom
      secondaryColor: const Color.fromRGBO(102, 206, 16, 1),

      secondaryBackgroundColor: const Color.fromARGB(26, 179, 179, 179),
      warningRedColor: const Color.fromARGB(255, 255, 203, 203),
      warningYellowColor: const Color.fromARGB(255, 255, 222, 207),
      successGreenColor: const Color.fromARGB(255, 0, 182, 86),
      warningBackgroundRed: const Color.fromARGB(255, 160, 14, 14),
      warningBackgroundYellow: const Color.fromARGB(255, 212, 71, 5),
      successBackgroundGreen: const Color.fromARGB(255, 229, 248, 238),
      infoBackgroundYellow: const Color.fromARGB(255, 255, 225, 106),
      infoBorderYellow: const Color.fromARGB(255, 201, 161, 0),
      filterBackgroundColor: const Color.fromARGB(255, 239, 246, 244),
      filterInfoBackgroundColor: const Color.fromARGB(255, 255, 251, 226),
      filterInfoBorderColor: const Color.fromARGB(255, 246, 239, 199),

      fontFamily: 'Mona Sans',
      imagePath: 'assets/images/demo.png',
    );
AppTheme _demoLightTheme() => AppTheme(
      name: 'Agro',

      cardTextColor: Colors.black,
      dashBoardContainerBgColor: const Color(0xff767680).withOpacity(.12),
      readNotification: const Color.fromARGB(255, 255, 254, 254),
      unreadNotification: const Color.fromRGBO(29, 180, 106, 1),
      buttonContainerBgColor: const Color(0xffF3F1EE),
      loaderColor: const Color.fromARGB(255, 255, 255, 255),
      loaderSecondaryColor: const Color.fromARGB(255, 255, 255, 255),
      circleAvatarBgColor: const Color.fromRGBO(233, 230, 245, 1),
      toastMsgColor: const Color(0xff323030),
      pwdFormFieldBorderColor: const Color.fromRGBO(67, 23, 159, 1),
      boxShadowColor: Colors.black.withValues(alpha: 0.1),
      transparentColor: Colors.transparent,
      primaryColor: const Color.fromRGBO(0, 182, 86, 1),
      primaryColorLight: const Color.fromARGB(255, 173, 255, 211),
      primaryColorDark: const Color.fromARGB(255, 2, 95, 45),
      backgroundColor: const Color.fromARGB(255, 240, 247, 243),
      cardColor: Colors.white,
      dialogBackgroundColor: Colors.white,
      canvasColor: const Color.fromARGB(255, 245, 243, 248),
      buttonColor: const Color.fromRGBO(0, 182, 86, 1),
      textColor: const Color.fromRGBO(255, 255, 255, 1),
      primaryTextColor: const Color.fromARGB(255, 0, 0, 0),
      secondaryTextColor: const Color.fromRGBO(0, 182, 86, 1),
      lightTextColor: const Color.fromRGBO(108, 103, 119, 1),
      disabledTextColor: Colors.grey[400]!,
      buttonTextColor: Colors.white,
      hintColor: const Color.fromARGB(255, 77, 76, 76),
      errorColor: const Color.fromARGB(255, 248, 18, 18),
      borderColor: const Color.fromARGB(255, 218, 212, 251),
      focusedBorderColor: const Color.fromRGBO(0, 182, 86, 1),
      enabledBorderColor: const Color.fromRGBO(0, 182, 86, 1),
      disabledBorderColor: const Color.fromARGB(255, 237, 237, 237)!,
      errorBorderColor: const Color.fromRGBO(217, 75, 77, 1),
      dividerColor: Colors.white,
      iconColor: const Color.fromARGB(255, 223, 223, 223),
      selectedIconColor: const Color.fromRGBO(180, 29, 141, 1)!,
      unselectedIconColor: Colors.grey,

      //
      switchActiveColor: const Color.fromRGBO(180, 29, 141, 1),
      switchInactiveColor: const Color.fromARGB(255, 142, 131, 192),

      checkColor: const Color.fromRGBO(102, 206, 16, 1),

      // custom
      secondaryColor: const Color.fromRGBO(102, 206, 16, 1),
      secondaryBackgroundColor: const Color.fromARGB(26, 179, 179, 179),
      warningRedColor: const Color.fromARGB(255, 160, 14, 14),
      warningYellowColor: const Color.fromARGB(255, 212, 71, 5),
      successGreenColor: const Color.fromARGB(255, 0, 182, 86),
      warningBackgroundRed: const Color.fromARGB(255, 255, 203, 203),
      warningBackgroundYellow: const Color.fromARGB(255, 255, 222, 207),
      successBackgroundGreen: const Color.fromARGB(255, 229, 248, 238),
      infoBackgroundYellow: const Color.fromARGB(255, 255, 225, 106),
      infoBorderYellow: const Color.fromARGB(255, 201, 161, 0),
      filterBackgroundColor: const Color.fromARGB(255, 239, 246, 244),
      filterInfoBackgroundColor: const Color.fromARGB(255, 255, 251, 226),
      filterInfoBorderColor: const Color.fromARGB(255, 246, 239, 199),

      fontFamily: 'Mona Sans',
      imagePath: 'assets/images/demo.png',
    );
