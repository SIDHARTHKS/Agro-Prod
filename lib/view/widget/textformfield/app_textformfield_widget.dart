// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import '../../../helper/color_helper.dart';
import '../common_widget.dart';
import '../text/app_text.dart';

class TextFormWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final FocusNode? nextFocusNode;
  final VoidCallback? onFieldSubmitted;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final bool optional;
  final FocusNode? focusNode;
  final Function(String)? onTextChanged;
  final void Function(String)? onChanged;
  final IconData? prefixIcon;
  final String? prefixText;
  final Color? prefixIconColor;
  final IconData? suffixIcon;
  final String? suffixText;
  final VoidCallback? suffixIconPressed;
  final bool readOnly;
  final TextAlign textAlign;
  final Color? textColor;
  final RxBool? rxEnabled;
  final RxBool? rxObscureText;
  final double? height;
  final bool digitsOnly;
  final VoidCallback? ontap;
  final Color? borderColor;
  final Widget? prefixIconWidget;
  final List<TextInputFormatter>? inputFormatters;
  final bool showcursor;
  final FloatingLabelBehavior? floatType;
  final TextInputAction? textInputAction;

  /// ✅ NEW: Optional toggle for show/hide password
  final bool enableObscureToggle;
  final bool localObscure;

  const TextFormWidget({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.nextFocusNode,
    this.onFieldSubmitted,
    this.maxLength,
    this.minLines,
    this.maxLines = 1,
    this.optional = false,
    this.focusNode,
    this.onTextChanged,
    this.onChanged,
    this.prefixIcon,
    this.prefixIconColor,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
    this.suffixIconPressed,
    this.readOnly = false,
    this.textAlign = TextAlign.start,
    this.textColor,
    this.height,
    this.digitsOnly = false,
    this.rxEnabled,
    this.rxObscureText,
    this.ontap,
    this.borderColor,
    this.prefixIconWidget,
    this.inputFormatters,
    this.showcursor = true,
    this.floatType,
    this.textInputAction,
    this.enableObscureToggle = false, // ✅ Default false
    this.localObscure = false,
  });

  @override
  Widget build(BuildContext context) {
    final Debouncer debouncer =
        Debouncer(delay: const Duration(milliseconds: 500));

    // ✅ Local Rx if toggle enabled and no external rxObscureText provided
    final RxBool localObscure = (rxObscureText ?? false.obs);

    return Obx(() {
      final bool isEnabled = rxEnabled?.value ?? true;
      final bool obscure = enableObscureToggle
          ? !localObscure.value
          : (rxObscureText?.value ?? false);

      return SizedBox(
        height: height,
        child: TextFormField(
          showCursor: showcursor,
          obscureText: obscure,
          enabled: isEnabled,
          readOnly: readOnly,
          focusNode: focusNode,
          controller: controller,
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          decoration: _normalFieldDecoration(localObscure),
          validator: validator,
          textAlign: textAlign,
          style:
              textStyle(14, AppColorHelper().primaryTextColor, FontWeight.w500),
          textInputAction: textInputAction ??
              (nextFocusNode != null
                  ? TextInputAction.next
                  : TextInputAction.done),
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          onFieldSubmitted: (_) {
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            }
            onFieldSubmitted?.call();
          },
        ),
      );
    });
  }

  InputDecoration _normalFieldDecoration(RxBool localObscure) =>
      InputDecoration(
        labelText: label,
        labelStyle: textStyle(
          15,
          AppColorHelper().primaryTextColor.withValues(alpha: 0.7),
          FontWeight.w400,
        ),
        floatingLabelBehavior: floatType ?? FloatingLabelBehavior.auto,
        border:
            _border(color: borderColor ?? AppColorHelper().transparentColor),
        enabledBorder:
            _border(color: borderColor ?? AppColorHelper().transparentColor),
        focusedBorder: _border(color: AppColorHelper().transparentColor),
        contentPadding: EdgeInsets.zero,
        counterText: '',
        prefixIcon: _getPrefixIcon(),
        suffixIcon: enableObscureToggle
            ? _getObscureToggleIcon(localObscure)
            : _getSuffixIcon(),
      );

  /// ✅ Password toggle eye icon
  Widget _getObscureToggleIcon(RxBool localObscure) {
    return Obx(() {
      return IconButton(
        icon: Icon(
          localObscure.value ? Icons.visibility : Icons.visibility_off,
          color: AppColorHelper().primaryTextColor.withValues(alpha: 0.6),
          size: 20,
        ),
        onPressed: () {
          localObscure.value = !localObscure.value;
        },
      );
    });
  }

  Widget? _getSuffixIcon() {
    if (suffixText != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 15.0, right: 20),
        child: GestureDetector(
          onTap: ontap,
          child: appText(
            suffixText!,
            color: AppColorHelper().textColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    }
    return suffixIcon != null
        ? IconButton(
            icon: Icon(suffixIcon, color: AppColorHelper().iconColor),
            onPressed: suffixIconPressed,
          )
        : null;
  }

  Widget? _getPrefixIcon() {
    if (prefixIconWidget != null) {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox(height: 10, width: 10, child: prefixIconWidget),
      );
    }

    if (prefixText != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 15.0, right: 20),
        child: appText(prefixText!,
            color: AppColorHelper().primaryTextColor,
            fontSize: 14,
            fontWeight: FontWeight.w500),
      );
    }

    return prefixIcon != null
        ? Icon(prefixIcon, color: prefixIconColor ?? AppColorHelper().iconColor)
        : null;
  }

  OutlineInputBorder _border({required Color color}) => OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 1.2),
        borderRadius: BorderRadius.circular(8),
      );
}
