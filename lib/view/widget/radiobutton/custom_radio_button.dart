import 'package:flutter/material.dart';

import '../../../helper/color_helper.dart';
import '../../../helper/sizer.dart';
import '../common_widget.dart';

class CustomRadioButton<T> extends StatelessWidget {
  final String label;
  final bool isRequired;
  final List<T> items;
  final T? selectedValue;
  final ValueChanged<T?> onChanged;
  final String Function(T) itemLabelBuilder;
  final String? Function(T)?
      itemIdBuilder; // Added for ID comparison (like mccId)
  final double? widgetHeight;
  final double? widgetWidth;
  final Color? bgColor;
  final Color? textColor;
  final Color? borderColor;

  const CustomRadioButton({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    required this.itemLabelBuilder,
    this.itemIdBuilder,
    this.selectedValue,
    this.isRequired = false,
    this.widgetHeight,
    this.widgetWidth,
    this.bgColor,
    this.textColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final appColor = AppColorHelper();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            width(2),
            appText(
              label,
              fontSize: 13,
              color: appColor.lightTextColor,
              fontWeight: FontWeight.w400,
            ),
            if (isRequired)
              appText(
                " *",
                color: Colors.red,
                fontSize: 18,
              ),
          ],
        ),
        height(2),
        SizedBox(
          height: widgetHeight ?? 42,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              // Compare IDs if provided, else compare objects directly
              final bool isSelected = itemIdBuilder != null
                  ? itemIdBuilder!(item) == itemIdBuilder!(selectedValue as T)
                  : item == selectedValue;
              final Color activeColor = bgColor ?? appColor.primaryColor;
              final Color inactiveColor = appColor.cardColor;

              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: buttonContainer(
                  paddingVertical: 2,
                  onPressed: () => onChanged(item),
                  width: widgetWidth ?? 117,
                  borderColor: isSelected
                      ? (borderColor ?? appColor.primaryColor)
                      : appColor.borderColor.withValues(alpha: 0.5),
                  color: isSelected ? activeColor : inactiveColor,
                  Center(
                    child: appText(
                      itemLabelBuilder(item),
                      color: isSelected
                          ? (textColor ?? appColor.primaryColor)
                          : appColor.primaryTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
