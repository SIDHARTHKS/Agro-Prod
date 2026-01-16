import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../gen/assets.gen.dart';
import '../../../helper/color_helper.dart';
import '../../../helper/navigation.dart';
import '../../../helper/sizer.dart';
import '../common_widget.dart';
import 'mini_calander.dart';

class CustomDatePicker extends StatefulWidget {
  final String label;
  final bool isRequired;
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onDateChanged;
  final String? hintText;
  final double? widgetHeight;

  final ButtonStyle? okButtonStyle;
  final ButtonStyle? cancelButtonStyle;
  final TextStyle? dateTextStyle;
  final TextStyle? labelTextStyle;

  const CustomDatePicker({
    super.key,
    required this.label,
    required this.onDateChanged,
    this.selectedDate,
    this.isRequired = false,
    this.hintText,
    this.widgetHeight,
    this.okButtonStyle,
    this.cancelButtonStyle,
    this.dateTextStyle,
    this.labelTextStyle,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  bool _isOpen = false;
  late TextEditingController _controller;
  DateTime? _pickedDate;

  @override
  void initState() {
    super.initState();
    _pickedDate = widget.selectedDate;
    _controller = TextEditingController(
      text: _pickedDate != null
          ? DateFormat('dd/MM/yyyy').format(_pickedDate!)
          : '',
    );
  }

  Future<void> _openCalendarSheet(BuildContext context) async {
    setState(() => _isOpen = true);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        final colors = AppColorHelper();
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: colors.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- Header
              height(12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    appText(
                      "Choose Date",
                      color: colors.primaryTextColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColorHelper().primaryColor),
                      child: iconWidget(Icons.close,
                          color: AppColorHelper().textColor, onPressed: goBack),
                    ),
                  ],
                ),
              ),

              // --- Mini Calendar
              MiniCalander(
                initialDate: _pickedDate,
                primaryColor: colors.primaryColor,
                backgroundColor: colors.cardColor,
                textColor: colors.primaryTextColor,
                onDateSelected: (date) {
                  setState(() {
                    _pickedDate = date;
                    _controller.text =
                        DateFormat('dd/MM/yyyy').format(_pickedDate!);
                  });
                  widget.onDateChanged(date);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );

    setState(() => _isOpen = false);
  }

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
                color: colors.errorColor,
                fontSize: 18,
              ),
          ],
        ),
        height(2),

        // Date Box
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          height: widget.widgetHeight ?? 52,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: colors.cardColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: _isOpen
                  ? colors.primaryColor.withOpacity(0.8)
                  : colors.borderColor.withOpacity(0.4),
              width: _isOpen ? 1.2 : 1,
            ),
            boxShadow: _isOpen
                ? [
                    BoxShadow(
                      color: colors.primaryColor.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: InkWell(
            onTap: () => _openCalendarSheet(context),
            borderRadius: BorderRadius.circular(4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                appText(
                  _controller.text.isNotEmpty
                      ? _controller.text
                      : (widget.hintText ?? "Select ${widget.label}"),
                  color: _controller.text.isNotEmpty
                      ? colors.primaryTextColor
                      : Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
                AnimatedRotation(
                    turns: _isOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.grid_3x3)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
