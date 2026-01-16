import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../helper/color_helper.dart';
import '../common_widget.dart';
import '../text/app_text.dart';

class Timefield extends StatelessWidget {
  final TextEditingController controller1;
  final TextEditingController controller2;

  const Timefield({
    super.key,
    required this.controller1,
    required this.controller2,
  });

  @override
  Widget build(BuildContext context) {
    final appColor = AppColorHelper();

    return SizedBox(
      width: 170,
      child: Row(
        children: [
          // Hours Field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColorHelper().cardColor,
                border: Border(
                  top: BorderSide(
                      color: appColor.borderColor.withValues(alpha: 0.5)),
                  left: BorderSide(
                      color: appColor.borderColor.withValues(alpha: 0.5)),
                  bottom: BorderSide(
                      color: appColor.borderColor.withValues(alpha: 0.5)),
                  right: BorderSide(
                      color: appColor.borderColor.withValues(alpha: 0.5)),
                ),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4)),
              ),
              child: TextField(
                controller: controller1,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: textStyle(
                    13, AppColorHelper().primaryTextColor, FontWeight.w500),
                decoration: InputDecoration(
                  hintText: "00",
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: appText(
                      "hrs",
                      fontSize: 13,
                      color: AppColorHelper()
                          .primaryTextColor
                          .withValues(alpha: 0.5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  suffixIconConstraints:
                      const BoxConstraints(minWidth: 0, minHeight: 0),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          // Minutes Field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColorHelper().cardColor,
                border: Border(
                  top: BorderSide(
                      color: appColor.borderColor.withValues(alpha: 0.5)),
                  bottom: BorderSide(
                      color: appColor.borderColor.withValues(alpha: 0.5)),
                  right: BorderSide(
                      color: appColor.borderColor.withValues(alpha: 0.5)),
                  left: BorderSide.none, // no border on left
                ),
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4)),
              ),
              child: TextField(
                controller: controller2,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: textStyle(
                    13, AppColorHelper().primaryTextColor, FontWeight.w500),
                decoration: InputDecoration(
                  hintText: "00",
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: appText(
                      "mins",
                      fontSize: 13,
                      color: AppColorHelper()
                          .primaryTextColor
                          .withValues(alpha: 0.5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 0,
                    minHeight: 0,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
