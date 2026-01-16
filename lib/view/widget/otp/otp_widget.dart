import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../helper/color_helper.dart';
import '../text/app_text.dart';

class OTPField extends StatefulWidget {
  final int otpLength;
  final List<TextEditingController>? controllers;
  final Function(String)? onCompleted;
  final String? Function(String?)? validator;

  const OTPField({
    super.key,
    this.otpLength = 4,
    this.controllers,
    this.onCompleted,
    this.validator,
  });

  @override
  _OTPFieldState createState() => _OTPFieldState();
}

class _OTPFieldState extends State<OTPField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  String otpValue = "";

  @override
  void initState() {
    super.initState();
    _controllers = widget.controllers ??
        List.generate(widget.otpLength, (index) => TextEditingController());
    _focusNodes = List.generate(widget.otpLength, (index) => FocusNode());

    // Auto-focus the first field after UI is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    if (widget.controllers == null) {
      for (var controller in _controllers) {
        controller.dispose();
      }
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  /// Function to get OTP value and validate
  void _storeOTPValue() {
    setState(() {
      otpValue = _controllers.map((controller) => controller.text).join();
    });

    if (widget.onCompleted != null) {
      widget.onCompleted!(otpValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.otpLength, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: _buildOTPTextField(index),
          );
        }),
      ),
    );
  }

  Widget _buildOTPTextField(int index) {
    return SizedBox(
      width: Get.width * 0.135,
      height: Get.height * 0.062,
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (event) {
          if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace &&
              _controllers[index].text.isEmpty) {
            if (index > 0) {
              _focusNodes[index - 1].requestFocus();
            }
          }
        },
        child: TextFormField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          showCursor: false,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          validator: (value) {
            if (widget.validator != null) {
              return widget.validator!(value);
            }
            return null;
          },
          onChanged: (value) {
            if (value.length == 1) {
              if (index < widget.otpLength - 1) {
                _focusNodes[index + 1].requestFocus();
              } else {
                _focusNodes[index].unfocus();
                _storeOTPValue();
              }
            }
          },
          decoration: _normalFieldDecoration(),
        ),
      ),
    );
  }

  InputDecoration _normalFieldDecoration() => InputDecoration(
      border: _border(color: AppColorHelper().pwdFormFieldBorderColor),
      labelStyle: textStyle(
        22,
        AppColorHelper().primaryTextColor.withValues(alpha: 0.4),
        FontWeight.w900,
      ),
      counterText: '',
      enabledBorder:
          _border(color: AppColorHelper().borderColor.withValues(alpha: 0.5)),
      errorBorder: _border(color: AppColorHelper().errorBorderColor),
      focusedBorder: _border(color: AppColorHelper().focusedBorderColor),
      errorStyle:
          textStyle(12, AppColorHelper().errorBorderColor, FontWeight.w400),
      hintText: '0',
      hintStyle: textStyle(
        18,
        AppColorHelper().primaryTextColor.withValues(alpha: 0.9),
        FontWeight.w400,
      ));

  OutlineInputBorder _border({required Color color}) => OutlineInputBorder(
        borderSide: BorderSide(color: color),
        borderRadius: BorderRadius.circular(5),
      );
}
