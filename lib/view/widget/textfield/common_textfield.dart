import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../helper/color_helper.dart';
import '../text/app_text.dart'; // 👈 add this

class CommonTextfield extends StatelessWidget {
  final String label;
  final bool isRequired;
  final TextEditingController controller;
  final String? hintText;
  final int maxLines;
  final TextInputType inputType;
  final bool readOnly;
  final Function(String)? onChanged;
  final String? suffixText;

  // optional: allow custom formatters, but we’ll also set a default for numbers
  final List<TextInputFormatter>? inputFormatters;

  const CommonTextfield({
    super.key,
    required this.label,
    required this.controller,
    this.isRequired = false,
    this.hintText,
    this.maxLines = 1,
    this.inputType = TextInputType.text,
    this.readOnly = false,
    this.onChanged,
    this.suffixText,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    final appColor = AppColorHelper();

    // if inputType is number and no custom formatter is given,
    // automatically restrict to digits only
    final effectiveFormatters = inputFormatters ??
        (inputType == TextInputType.number || inputType == TextInputType.phone
            ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
            : null);

    return TextField(
      controller: controller,
      keyboardType: inputType,
      readOnly: readOnly,
      maxLines: maxLines,
      onChanged: onChanged,
      inputFormatters: effectiveFormatters,
      style: textStyle(13, AppColorHelper().primaryTextColor, FontWeight.w500),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: textStyle(
          13,
          AppColorHelper().primaryTextColor.withValues(alpha: 0.5),
          FontWeight.w500,
        ),
        filled: true,
        fillColor: AppColorHelper().cardColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),

        // 👈 Use suffix here, not suffixIcon
        suffix: suffixText == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  suffixText!,
                  style: textStyle(
                    13,
                    AppColorHelper().primaryTextColor.withValues(alpha: 0.5),
                    FontWeight.w400,
                  ),
                ),
              ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: appColor.borderColor.withValues(alpha: 0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: appColor.borderColor.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
