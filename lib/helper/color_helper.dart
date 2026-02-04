import 'dart:ui';

import 'package:get/get.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_service.dart';

class AppColorHelper {
  AppTheme get _currentTheme => Get.find<AppThemeService>().currentTheme;

  Color get primaryColor => _currentTheme.primaryColor;
  Color get primaryColorLight => _currentTheme.primaryColorLight;
  Color get primaryColorDark => _currentTheme.primaryColorDark;
  Color get backgroundColor => _currentTheme.backgroundColor;
  Color get cardColor => _currentTheme.cardColor;
  Color get dialogBackgroundColor => _currentTheme.dialogBackgroundColor;
  Color get canvasColor => _currentTheme.canvasColor;
  Color get buttonColor => _currentTheme.buttonColor;
  Color get textColor => _currentTheme.textColor;
  Color get primaryTextColor => _currentTheme.primaryTextColor;
  Color get secondaryTextColor => _currentTheme.secondaryTextColor;
  Color get lightTextColor => _currentTheme.lightTextColor;
  Color get buttonTextColor => _currentTheme.buttonTextColor;
  Color get disabledTextColor => _currentTheme.disabledTextColor;
  Color get hintColor => _currentTheme.hintColor;
  Color get errorColor => _currentTheme.errorColor;
  Color get borderColor => _currentTheme.borderColor;
  Color get focusedBorderColor => _currentTheme.focusedBorderColor;
  Color get enabledBorderColor => _currentTheme.enabledBorderColor;
  Color get disabledBorderColor => _currentTheme.disabledBorderColor;
  Color get errorBorderColor => _currentTheme.errorBorderColor;
  Color get dividerColor => _currentTheme.dividerColor;
  Color get iconColor => _currentTheme.iconColor;
  Color get selectedIconColor => _currentTheme.selectedIconColor;
  Color get unselectedIconColor => _currentTheme.unselectedIconColor;
  Color get cardTextColor => _currentTheme.cardTextColor;
  Color get transparentColor => _currentTheme.transparentColor;
  Color get pwdFormFieldBorderColor => _currentTheme.pwdFormFieldBorderColor;
  Color get boxShadowColor => _currentTheme.boxShadowColor;
  Color get circleAvatarBgColor => _currentTheme.circleAvatarBgColor;
  Color get toastMsgColor => _currentTheme.toastMsgColor;
  Color get loaderColor => _currentTheme.loaderColor;
  Color get loaderSecondaryColor => _currentTheme.loaderSecondaryColor;
  Color get buttonContainerBgColor => _currentTheme.buttonContainerBgColor;
  Color get readNotification => _currentTheme.readNotification;
  Color get unreadNotification => _currentTheme.unreadNotification;
  Color get dashBoardContainerBgColor =>
      _currentTheme.dashBoardContainerBgColor;

  Color get switchActiveColor => _currentTheme.switchActiveColor;
  Color get switchInactiveColor => _currentTheme.switchInactiveColor;

  // custom
  Color get secondaryColor => _currentTheme.secondaryColor;
  Color get secondaryBackgroundColor => _currentTheme.secondaryBackgroundColor;
  Color get warningRedColor => _currentTheme.warningRedColor;
  Color get warningYellowColor => _currentTheme.warningYellowColor;
  Color get successGreenColor => _currentTheme.successGreenColor;
  Color get warningBackgroundRed => _currentTheme.warningBackgroundRed;
  Color get warningBackgroundYellow => _currentTheme.warningBackgroundYellow;
  Color get successBackgroundGreen => _currentTheme.successBackgroundGreen;
  Color get infoBackgroundYellow => _currentTheme.infoBackgroundYellow;
  Color get infoBorderYellow => _currentTheme.infoBorderYellow;
  Color get filterBackgroundColor => _currentTheme.filterBackgroundColor;
  Color get filterInfoBackgroundColor =>
      _currentTheme.filterInfoBackgroundColor;
  Color get filterInfoBorderColor => _currentTheme.filterInfoBorderColor;
}
