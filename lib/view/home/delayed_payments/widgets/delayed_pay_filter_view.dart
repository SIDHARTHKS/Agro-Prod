import 'package:agro/controller/delayed_pay_filter_controller.dart';
import 'package:agro/controller/delayed_payment_controller.dart';
import 'package:agro/helper/core/base/app_base_view.dart';
import 'package:flutter/material.dart';
import '../../../widget/common_widget.dart';
import '../../../../helper/color_helper.dart';
import '../../../../view/widget/datepicker/custom_daterangepicker.dart';
import 'package:get/get.dart';
import 'package:agro/helper/sizer.dart';
import 'package:agro/view/widget/slider/custom_range_slider.dart';
import '../widgets/delayed_payments_shared_widgets.dart';
import 'package:agro/gen/assets.gen.dart';
import 'package:intl/intl.dart';

class DelayedPayFilterView extends AppBaseView<DelayedPayFilterController> {
  const DelayedPayFilterView({super.key});

  @override
  Widget buildView() {
    return _buildBottomSheet();
  }

  Widget _buildBottomSheet() {
    return Container(
      height: 760, // ✅ FIXED HEIGHT
      decoration: BoxDecoration(
        color: AppColorHelper().filterBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(28), // ✅ ROUNDER TOP
        ),
      ),
      child: Column(
        children: [
          _dragHandle(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _dragHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 12),
      child: Container(
        width: 50,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child:

          /// 🔹 Actual content (UNCHANGED layout)
          Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          height(5),
          LayoutBuilder(
            builder: (context, constraints) {
              return DelayedPaymentSharedWidgets()
                  .dashedLine(constraints.maxWidth);
            },
          ),
          height(25),
          _locationSection(),
          height(10),
          LayoutBuilder(
            builder: (context, constraints) {
              return DelayedPaymentSharedWidgets()
                  .dashedLine(constraints.maxWidth);
            },
          ),
          height(20),
          _amountRangeSection(),
          height(20),
          LayoutBuilder(
            builder: (context, constraints) {
              return DelayedPaymentSharedWidgets()
                  .dashedLine(constraints.maxWidth);
            },
          ),
          height(20),
          _billedDateSection(),
          height(20),
          LayoutBuilder(
            builder: (context, constraints) {
              return DelayedPaymentSharedWidgets()
                  .dashedLine(constraints.maxWidth);
            },
          ),
          height(20),
          _committedDateSection(),
          height(20),
          LayoutBuilder(
            builder: (context, constraints) {
              return DelayedPaymentSharedWidgets()
                  .dashedLine(constraints.maxWidth);
            },
          ),
          height(20),
          _lateDaysSection(),
          height(20),
          _footerButtons(),
        ],
      ),
    );
  }

  Widget _header() {
    return Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            appText(
              'Filters',
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: AppColorHelper().primaryTextColor,
            ),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => Get.back(),
              icon: const Icon(Icons.close),
            ),
          ],
        ));
  }

  Widget _locationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          appText(
            'Location',
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: AppColorHelper().primaryTextColor.withValues(alpha: 0.6),
          ),
          height(5),
          ...controller.allLocations.map((location) {
            return Obx(() {
              final isSelected =
                  controller.selectedLocations.contains(location);

              return GestureDetector(
                onTap: () {
                  if (isSelected) {
                    controller.selectedLocations.remove(location);
                  } else {
                    controller.selectedLocations.add(location);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// Custom checkbox box
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColorHelper().primaryColor
                              : AppColorHelper().cardColor,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: isSelected
                                ? AppColorHelper().primaryColor
                                : AppColorHelper()
                                    .primaryTextColor
                                    .withValues(alpha: 0.4),
                          ),
                        ),
                        child: isSelected
                            ? Transform.scale(
                                scale: 0.6, // 👈 shrink icon
                                child: Image.asset(
                                  Assets.icons.check.path,
                                ),
                              )
                            : null,
                      ),

                      width(12),

                      /// Location text (perfectly aligned)
                      Expanded(
                        child: appText(
                          location,
                          color: AppColorHelper().primaryTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
          }).toList(),
        ],
      ),
    );
  }

  Widget _amountRangeSection() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title + value text
            Obx(() {
              final range = controller.amountRange.value ??
                  const RangeValues(50000, 200000);
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  appText(
                    "Amount Range",
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: AppColorHelper()
                        .primaryTextColor
                        .withValues(alpha: 0.6),
                  ),
                  appText(
                    "₹ ${range.start.toInt()} - ${range.end.toInt()}",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColorHelper().primaryTextColor,
                  ),
                ],
              );
            }),
            height(10),

            /// Custom reusable range slider
            Obx(() {
              return CustomRangeSlider(
                min: 0,
                max: 500000,
                divisions: 50, // optional – remove if you want smooth sliding
                values: controller.amountRange.value ??
                    const RangeValues(50000, 200000),
                onChanged: (value) {
                  controller.amountTouched.value = true;
                  controller.amountRange.value = value;
                },
                activeColor: AppColorHelper().primaryColor,
                inactiveColor:
                    AppColorHelper().primaryTextColor.withOpacity(0.1),
                thumbColor: AppColorHelper().primaryColor,
              );
            }),
          ],
        ));
  }

  Widget _billedDateSection() {
    return Obx(() {
      final formatter = DateFormat('dd MMMM yyyy');

      final from = controller.billedFrom.value;
      final to = controller.billedTo.value;

      final text = (from == null || to == null)
          ? "Select date range"
          : "${formatter.format(from)} - ${formatter.format(to)}";

      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appText(
                "Billed Date Range",
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: AppColorHelper().primaryTextColor.withValues(alpha: 0.6),
              ),
              height(8),
              InkWell(
                onTap: () => _pickCustomDateRange(
                  from: controller.billedFrom,
                  to: controller.billedTo,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  height: 55,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                    color: AppColorHelper().cardColor,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        Assets.icons.calender.path,
                        width: 18,
                        height: 18,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 10),
                      appText(
                        text,
                        color: AppColorHelper().primaryTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ));
    });
  }

  Widget _committedDateSection() {
    return Obx(() {
      final from = controller.committedFrom.value;
      final to = controller.committedTo.value;
      final formatter = DateFormat('dd MMMM yyyy');

      final text = (from == null || to == null)
          ? "Select date range"
          : "${formatter.format(from)} - ${formatter.format(to)}";

      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appText(
                "Committed Date Range",
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: AppColorHelper().primaryTextColor.withValues(alpha: 0.6),
              ),
              height(8),
              InkWell(
                onTap: () => _pickCustomDateRange(
                  from: controller.committedFrom,
                  to: controller.committedTo,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  height: 55,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                    color: AppColorHelper().cardColor,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        Assets.icons.calender.path,
                        width: 18,
                        height: 18,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 10),
                      appText(
                        text,
                        color: AppColorHelper().primaryTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ));
    });
  }

  Widget _lateDaysSection() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title + value
            Obx(() {
              final range =
                  controller.lateDaysRange.value ?? const RangeValues(20, 80);
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  appText(
                    "Late Days Range",
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: AppColorHelper()
                        .primaryTextColor
                        .withValues(alpha: 0.6),
                  ),
                  appText(
                    "${range.start.toInt()} days - ${range.end.toInt()} days",
                    color: AppColorHelper().primaryTextColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ],
              );
            }),
            height(10),

            /// Custom range slider
            Obx(() {
              return CustomRangeSlider(
                min: 0,
                max: 180,
                divisions: 36, // 5-day steps (optional)
                values:
                    controller.lateDaysRange.value ?? const RangeValues(20, 80),
                onChanged: (value) {
                  controller.lateDaysRange.value = value;
                  controller.lateDaysTouched.value = true;
                },
                activeColor: AppColorHelper().primaryColor,
                inactiveColor:
                    AppColorHelper().primaryTextColor.withOpacity(0.1),
                thumbColor: AppColorHelper().primaryColor,
              );
            }),
          ],
        ));
  }

  Widget _footerButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          /// Clear All Filters
          Expanded(
            child: SizedBox(
              height: 45,
              child: OutlinedButton(
                onPressed: controller.clearFilters,
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColorHelper().cardColor,
                  side: BorderSide(
                    color: AppColorHelper().cardColor,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: appText(
                  "Clear All Filters",
                  fontWeight: FontWeight.w500,
                  color: AppColorHelper().primaryTextColor,
                  fontSize: 14,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          /// Apply Filters
          Expanded(
            child: SizedBox(
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  final main = Get.find<DelayedPaymentController>();

                  // save filter state
                  main.amountRange.value = controller.amountRange.value;
                  main.lateDaysRange.value = controller.lateDaysRange.value;
                  main.billedFrom.value = controller.billedFrom.value;
                  main.billedTo.value = controller.billedTo.value;
                  main.committedFrom.value = controller.committedFrom.value;
                  main.committedTo.value = controller.committedTo.value;
                  main.selectedLocations
                      .assignAll(controller.selectedLocations);

                  main.applyFilters(
                    locations: controller.selectedLocations,
                    amountRange: controller.amountTouched.value
                        ? controller.amountRange.value
                        : null,
                    lateDaysRange: controller.lateDaysTouched.value
                        ? controller.lateDaysRange.value
                        : null,
                    billedFrom: controller.billedFrom.value,
                    billedTo: controller.billedTo.value,
                    committedFrom: controller.committedFrom.value,
                    committedTo: controller.committedTo.value,
                  );

                  Get.back(result: true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColorHelper().primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: appText(
                  "Apply Filters",
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickCustomDateRange({
    required Rx<DateTime?> from,
    required Rx<DateTime?> to,
  }) async {
    final result = await showCustomDateRangePicker(
      Get.context!,
      primaryColor: AppColorHelper().primaryColor,
      backgroundColor: AppColorHelper().cardColor,
      textColor: AppColorHelper().primaryTextColor,
      initialRange: (from.value != null && to.value != null)
          ? DateTimeRange(start: from.value!, end: to.value!)
          : null,
    );

    if (result != null) {
      from.value = result.start;
      to.value = result.end;
    }
  }
}
