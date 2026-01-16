import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:get/get.dart';

import '../../../helper/color_helper.dart';
import '../../../helper/sizer.dart';
import '../common_widget.dart';

class CustomDropdown<T> extends StatefulWidget {
  final String label;
  final bool isRequired;
  final List<T> items;
  final T? selectedValue;
  final ValueChanged<T?> onChanged;
  final String Function(T) itemLabelBuilder;
  final String? hintText;
  final double? widgetHeight;
  final Color? selectionColor;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    required this.itemLabelBuilder,
    this.selectedValue,
    this.isRequired = false,
    this.hintText,
    this.widgetHeight,
    this.selectionColor,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorHelper();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            width(2),
            appText(
              widget.label,
              fontSize: 13,
              color: colors.lightTextColor,
              fontWeight: FontWeight.w400,
            ),
            if (widget.isRequired)
              appText(
                " *",
                color: AppColorHelper().errorColor,
                fontSize: 18,
              ),
          ],
        ),
        height(2),

        // Dropdown container
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: widget.widgetHeight ?? 48,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: colors.cardColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: _isOpen
                  ? colors.primaryColor.withOpacity(0.8)
                  : colors.borderColor.withOpacity(0.4),
              width: _isOpen ? 1.2 : 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<T>(
              isExpanded: true,
              value: widget.selectedValue,
              hint: appText(
                widget.hintText ?? "Select ${widget.label}",
                color: colors.lightTextColor,
                fontWeight: FontWeight.w400,
              ),
              selectedItemBuilder: (context) {
                return widget.items.map((item) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: appText(
                      widget.itemLabelBuilder(item),
                      color: colors.primaryTextColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }).toList();
              },
              iconStyleData: IconStyleData(
                icon: AnimatedRotation(
                  turns: _isOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 22,
                    color: colors.primaryTextColor,
                  ),
                ),
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 250,
                width: Get.width * 0.9,
                elevation: 0,
                offset: const Offset(-16, -8),
                decoration: BoxDecoration(
                  color: colors.cardColor,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: colors.borderColor.withOpacity(0.3),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              ),
              menuItemStyleData: MenuItemStyleData(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 0),
                overlayColor: WidgetStateProperty.all(
                  colors.primaryColor.withOpacity(0.05),
                ),
              ),

              /// 👇 Highlight selected item background (Hiver-style)
              items: widget.items.map((item) {
                final isSelected = item == widget.selectedValue;
                return DropdownMenuItem<T>(
                  alignment: Alignment.centerLeft,
                  value: item,
                  child: Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (widget.selectionColor ??
                              AppColorHelper()
                                  .primaryColor
                                  .withValues(alpha: 0.1)) // ✅ highlighted bg
                          : Colors.transparent,
                    ),
                    padding: const EdgeInsets.only(top: 10, bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: appText(
                        widget.itemLabelBuilder(item),
                        color: colors.primaryTextColor,
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w500 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),

              onChanged: (val) {
                widget.onChanged(val);
                setState(() => _isOpen = false);
              },
              onMenuStateChange: (isOpen) {
                setState(() => _isOpen = isOpen);
              },
            ),
          ),
        ),
      ],
    );
  }
}
