import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import '../../../gen/assets.gen.dart';
import '../../../helper/color_helper.dart';
import '../../../helper/core/environment/env.dart';
import '../../../helper/enum.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmit;
  final String hintText;
  final String? Function(String?)? validator;
  final Function(String)? action;
  final VoidCallback? onFilterTap;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.onSubmit,
    this.validator,
    this.action,
    this.onFilterTap,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  bool showClear = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateClearButton);
  }

  void _updateClearButton() {
    setState(() {
      showClear = widget.controller.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateClearButton);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = AppEnvironment.deviceType == UserDeviceType.tablet;
    return Row(children: [
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColorHelper().cardColor,
          ),
          child: TextFormField(
            textAlignVertical: TextAlignVertical.center,
            controller: widget.controller,
            textInputAction: TextInputAction.search,
            // keyboardType: TextInputType.number,
            // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onFieldSubmitted: widget.onSubmit,
            onChanged: widget.onChanged,
            validator: widget.validator,

            decoration: InputDecoration(
              fillColor: AppColorHelper().cardColor,
              hintText: widget.hintText.tr,

              hintStyle: TextStyle(
                letterSpacing: 0,
                fontSize: isTablet ? 16 : 14,
                color: AppColorHelper().primaryTextColor.withOpacity(0.6),
                fontWeight: FontWeight.w300,
              ),
              //  prefixIcon: Padding(
              //    padding: const EdgeInsets.only(left: 8.0),
              //    child: Image.asset(
              //      Assets.icons.search.path,
              //      scale: 3.8,
              //      color: AppColorHelper().primaryTextColor.withValues(alpha: 0.4),
              //    ),
              //  ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 30,
                minHeight: 30,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16, // reduce left/right padding
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  // showModalBottomSheet(
                  //   isScrollControlled: true,
                  //   context: context,
                  //   builder: (context) {
                  //     return Padding(
                  //       padding: EdgeInsets.only(
                  //         bottom: MediaQuery.of(context).viewInsets.bottom,
                  //       ),
                  //       child: const FilterBottomsheet(),
                  //     );
                  //   },
                  // );
                },
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 17.0, vertical: 17.0),
                    child: Image.asset(Assets.icons.searchIcon.path)),
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(
                  color: AppColorHelper().cardColor.withOpacity(0.4),
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3.0),
                borderSide: BorderSide(
                  color: AppColorHelper().cardColor.withOpacity(0.7),
                  width: 2.0,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3.0),
                borderSide: BorderSide(
                  color: AppColorHelper().cardColor.withOpacity(0.6),
                  width: 2.0,
                ),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(width: 10),
      GestureDetector(
          onTap: widget.onFilterTap,
          child: Container(
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColorHelper().cardColor,
            ),
            child: Center(
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Image.asset(Assets.icons.filterBtn.path)),
            ),
          )),
    ]);
  }
}
