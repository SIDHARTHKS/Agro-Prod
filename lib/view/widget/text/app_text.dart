import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../helper/core/theme/app_theme.dart';
import '../../../helper/core/theme/theme_service.dart';

TextStyle textStyle(
  double size,
  Color color,
  FontWeight fontweight, {
  double? height, // 👈 optional named parameter
}) {
  return TextStyle(
    fontSize: size,
    color: color,
    fontFamily: 'Mona Sans',
    fontWeight: fontweight,
    height: height, // 👈 applied only if provided
  );
}

Text appBarText(
  String text, {
  double size = 16,
  Color? color,
  TextAlign textAlign = TextAlign.start,
  String? family,
}) {
  AppTheme appTheme = Get.find<AppThemeService>().currentTheme;
  color ??= appTheme.textColor;
  family ??= appTheme.fontFamily;
  return Text(
    text,
    textAlign: textAlign,
    style: textStyle(size, color, FontWeight.w600),
  );
}

Text buttonText(
  String text, {
  double size = 16,
  Color? color,
  TextAlign textAlign = TextAlign.center,
  String? family,
}) {
  AppTheme appTheme = Get.find<AppThemeService>().currentTheme;
  color ??= appTheme.buttonTextColor;
  family ??= appTheme.fontFamily;
  return Text(
    text,
    textAlign: textAlign,
    style: textStyle(size, color, FontWeight.w700),
  );
}

Text bodyText(
  String text, {
  double size = 14,
  Color? color,
  TextAlign textAlign = TextAlign.start,
  String? family,
}) {
  AppTheme appTheme = Get.find<AppThemeService>().currentTheme;
  color ??= appTheme.textColor;
  family ??= appTheme.fontFamily;
  return Text(
    text,
    textAlign: textAlign,
    style: textStyle(size, color, FontWeight.w600),
  );
}

Text headlineText(
  String text, {
  double size = 22,
  Color? color,
  TextAlign textAlign = TextAlign.start,
  String? family,
}) {
  AppTheme appTheme = Get.find<AppThemeService>().currentTheme;
  color ??= appTheme.textColor;
  family ??= appTheme.fontFamily;
  return Text(
    text,
    textAlign: textAlign,
    style: textStyle(size, color, FontWeight.w600),
  );
}

Text subtitleText(
  String text, {
  double size = 16,
  Color? color,
  TextAlign textAlign = TextAlign.start,
  String? family,
}) {
  AppTheme appTheme = Get.find<AppThemeService>().currentTheme;
  color ??= appTheme.textColor;
  family ??= appTheme.fontFamily;
  return Text(
    text,
    textAlign: textAlign,
    style: textStyle(size, color, FontWeight.w600),
  );
}

Text captionText(
  String text, {
  double size = 12,
  Color? color,
  TextAlign textAlign = TextAlign.start,
  String? family,
}) {
  AppTheme appTheme = Get.find<AppThemeService>().currentTheme;
  color ??= appTheme.secondaryTextColor;
  family ??= appTheme.fontFamily;
  return Text(
    text,
    textAlign: textAlign,
    style: textStyle(size, color, FontWeight.w600),
  );
}

Text overlineText(
  String text, {
  double size = 10,
  Color? color,
  TextAlign textAlign = TextAlign.start,
  String? family,
}) {
  AppTheme appTheme = Get.find<AppThemeService>().currentTheme;
  color ??= appTheme.secondaryTextColor;
  family ??= appTheme.fontFamily;
  return Text(
    text,
    textAlign: textAlign,
    style: textStyle(size, color, FontWeight.w600),
  );
}

Text inputText(
  String text, {
  double size = 14,
  Color? color,
  TextAlign textAlign = TextAlign.start,
  String? family,
}) {
  AppTheme appTheme = Get.find<AppThemeService>().currentTheme;
  color ??= appTheme.textColor;
  family ??= appTheme.fontFamily;
  return Text(
    text,
    textAlign: textAlign,
    style: textStyle(size, color, FontWeight.w600),
  );
}

Text hintText(
  String text, {
  double size = 14,
  Color? color,
  TextAlign textAlign = TextAlign.start,
  String? family,
}) {
  AppTheme appTheme = Get.find<AppThemeService>().currentTheme;
  color ??= appTheme.secondaryTextColor;
  family ??= appTheme.fontFamily;
  return Text(
    text,
    textAlign: textAlign,
    style: textStyle(size, color, FontWeight.w600),
  );
}

Text labelText(
  String text, {
  double size = 14,
  Color? color,
  TextAlign textAlign = TextAlign.start,
  String? family,
}) {
  AppTheme appTheme = Get.find<AppThemeService>().currentTheme;
  color ??= appTheme.textColor;
  family ??= appTheme.fontFamily;
  return Text(
    text,
    textAlign: textAlign,
    style: textStyle(size, color, FontWeight.w600),
  );
}

Text tooltipText(
  String text, {
  double size = 14,
  Color? color,
  TextAlign textAlign = TextAlign.start,
  String? family,
}) {
  AppTheme appTheme = Get.find<AppThemeService>().currentTheme;
  color ??= appTheme.secondaryTextColor;
  family ??= appTheme.fontFamily;
  return Text(
    text,
    textAlign: textAlign,
    style: textStyle(size, color, FontWeight.w600),
  );
}

Text errorText(
  String text, {
  double size = 14,
  Color? color,
  TextAlign textAlign = TextAlign.start,
  String? family,
}) {
  AppTheme appTheme = Get.find<AppThemeService>().currentTheme;
  color ??= appTheme.errorColor;
  family ??= appTheme.fontFamily;
  return Text(
    text,
    textAlign: textAlign,
    style: textStyle(size, color, FontWeight.w600),
  );
}

Text dialogText(
  String text, {
  double size = 14,
  Color? color,
  TextAlign textAlign = TextAlign.start,
  String? family,
}) {
  AppTheme appTheme = Get.find<AppThemeService>().currentTheme;
  color ??= appTheme.textColor;
  family ??= appTheme.fontFamily;
  return Text(
    text,
    textAlign: textAlign,
    style: textStyle(size, color, FontWeight.w600),
  );
}

Text snackbarText(
  String text, {
  double size = 14,
  Color? color,
  TextAlign textAlign = TextAlign.start,
  String? family,
}) {
  AppTheme appTheme = Get.find<AppThemeService>().currentTheme;
  color ??= appTheme.textColor;
  family ??= appTheme.fontFamily;

  return Text(
    text,
    textAlign: textAlign,
    style: textStyle(size, color, FontWeight.w600),
  );
}

Text tabText(
  String text, {
  double size = 14,
  Color? color,
  TextAlign textAlign = TextAlign.center,
  String? family,
}) {
  AppTheme appTheme = Get.find<AppThemeService>().currentTheme;
  color ??= appTheme.primaryColor;
  family ??= appTheme.fontFamily;
  return Text(
    text,
    textAlign: textAlign,
    style: textStyle(size, color, FontWeight.w600),
  );
}

Text navigationDrawerText(
  String text, {
  double size = 14,
  Color? color,
  TextAlign textAlign = TextAlign.start,
  String? family,
}) {
  AppTheme appTheme = Get.find<AppThemeService>().currentTheme;
  color ??= appTheme.primaryColor;
  family ??= appTheme.fontFamily;
  return Text(
    text,
    textAlign: textAlign,
    style: textStyle(size, color, FontWeight.w600),
  );
}

Text listTileText(
  String text, {
  double size = 14,
  Color? color,
  TextAlign textAlign = TextAlign.start,
  String? family,
}) {
  AppTheme appTheme = Get.find<AppThemeService>().currentTheme;
  color ??= appTheme.textColor;
  family ??= appTheme.fontFamily;
  return Text(
    text,
    textAlign: textAlign,
    style: textStyle(size, color, FontWeight.w600),
  );
}

Text chipText(
  String text, {
  double size = 12,
  Color? color,
  TextAlign textAlign = TextAlign.center,
  String? family,
}) {
  AppTheme appTheme = Get.find<AppThemeService>().currentTheme;
  color ??= appTheme.textColor;
  family ??= appTheme.fontFamily;
  return Text(
    text,
    textAlign: textAlign,
    style: textStyle(size, color, FontWeight.w600),
  );
}

Text checkboxRadioText(
  String text, {
  double size = 14,
  Color? color,
  TextAlign textAlign = TextAlign.start,
  String? family,
}) {
  AppTheme appTheme = Get.find<AppThemeService>().currentTheme;
  color ??= appTheme.textColor;
  family ??= appTheme.fontFamily;
  return Text(
    text,
    textAlign: textAlign,
    style: textStyle(size, color, FontWeight.w600),
  );
}

Text menuText(
  String text, {
  double size = 14,
  Color? color,
  TextAlign textAlign = TextAlign.start,
  String? family,
}) {
  AppTheme appTheme = Get.find<AppThemeService>().currentTheme;
  color ??= appTheme.textColor;
  family ??= appTheme.fontFamily;
  return Text(
    text,
    textAlign: textAlign,
    style: textStyle(size, color, FontWeight.w600),
  );
}

Text cardBoldText(String text,
    {double size = 18,
    Color? color,
    TextAlign textAlign = TextAlign.start,
    String? family}) {
  AppTheme appTheme = Get.find<AppThemeService>().currentTheme;
  color ??= appTheme.textColor;
  family ??= appTheme.fontFamily;
  return Text(
    text,
    style: textStyle(size, color, FontWeight.w600),
  );
}

Text cardNormalText(
  String text, {
  double size = 12,
  Color? color,
  TextAlign textAlign = TextAlign.start,
  String? family,
}) {
  AppTheme appTheme = Get.find<AppThemeService>().currentTheme;
  color ??= appTheme.textColor;
  family ??= appTheme.fontFamily;
  return Text(
    text,
    textAlign: textAlign,
    style: textStyle(size, color, FontWeight.w600),
  );
}

Text cardAvatarText(String text,
    {double size = 60,
    Color? color,
    TextAlign textAlign = TextAlign.start,
    String? family}) {
  AppTheme appTheme = Get.find<AppThemeService>().currentTheme;
  color ??= appTheme.primaryColor;
  family ??= appTheme.fontFamily;
  return Text(
    text,
    textAlign: textAlign,
    style: textStyle(size, color, FontWeight.w600),
  );
}

Text boldLabelText(
  String text, {
  double size = 14,
  Color? color,
  TextAlign textAlign = TextAlign.start,
  String? family,
}) {
  AppTheme appTheme = Get.find<AppThemeService>().currentTheme;
  color ??= appTheme.textColor;
  family ??= appTheme.fontFamily;
  return Text(
    text,
    textAlign: textAlign,
    style: textStyle(size, color, FontWeight.w600),
  );
}

Text subtitleBoldText(
  String text, {
  double size = 16,
  Color? color,
  TextAlign textAlign = TextAlign.start,
  String? family,
}) {
  AppTheme appTheme = Get.find<AppThemeService>().currentTheme;
  color ??= appTheme.textColor;
  family ??= appTheme.fontFamily;
  return Text(
    text,
    textAlign: textAlign,
    style: textStyle(size, color, FontWeight.w600),
  );
}
