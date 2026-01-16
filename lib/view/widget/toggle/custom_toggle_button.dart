import 'package:flutter/material.dart';
import '../../../helper/color_helper.dart';
import '../../../helper/sizer.dart';
import '../common_widget.dart';

class CustomToggleButton extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeColor;
  final Color? inactiveColor;

  const CustomToggleButton({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final AppColorHelper colors = AppColorHelper();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => onChanged(!value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            width: 46, // toggle width
            height: 26, // toggle height
            padding: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: value
                  ? (activeColor ?? colors.cardColor)
                  : (inactiveColor ?? colors.cardColor),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: value
                    ? colors.primaryColor.withOpacity(0.9)
                    : colors.borderColor.withOpacity(0.5),
                width: 1.2,
              ),
            ),
            alignment: value
                ? Alignment.centerRight
                : Alignment.centerLeft, // thumb position
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              width: 21,
              height: 21,
              decoration: BoxDecoration(
                color: value
                    ? colors.primaryColor
                    : colors.primaryColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        width(4),
        appText(
          label,
          fontSize: 12,
          color: colors.primaryTextColor,
          fontWeight: FontWeight.w400,
          //style: FontStyle.italic,
          //fontStyle: FontStyle.normal
        ),
      ],
    );
  }
}
