import 'package:agro/controller/delayed_pay_filter_controller.dart';
import 'package:agro/gen/assets.gen.dart';
import 'package:agro/helper/core/base/app_base_view.dart';
import 'package:flutter/material.dart';
import '../../../widget/common_widget.dart';
import '../../../../helper/color_helper.dart';
import '../../../../view/widget/datepicker/custom_daterangepicker.dart';
import 'package:get/get.dart';
import 'package:agro/helper/sizer.dart';
import 'package:agro/view/widget/slider/custom_range_slider.dart';

class DelayedPayFilterView extends AppBaseView<DelayedPayFilterController> {
  const DelayedPayFilterView({super.key});

  @override
  Widget buildView() {
    return _buildBottomSheet();
  }

  Widget _buildBottomSheet() {
    return Container(
      height: 650, // ✅ FIXED HEIGHT
      decoration: BoxDecoration(
        color: AppColorHelper().backgroundColor,
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
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          height(10),
          _locationSection(),
          height(10),
          _amountRangeSection(),
          height(10),
          _billedDateSection(),
          height(10),
          _committedDateSection(),
          height(10),
          _lateDaysSection(),
          height(20),
          _footerButtons(),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        appText(
          'Filter',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColorHelper().primaryTextColor,
        ),
        IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _locationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appText(
          'Location',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColorHelper().primaryTextColor,
        ),
        height(10),
        ...controller.allLocations.map((location) {
          return Obx(() {
            final isSelected = controller.selectedLocations.contains(location);

            return CheckboxListTile(
              value: isSelected,
              onChanged: (value) {
                if (value == true) {
                  controller.selectedLocations.add(location);
                } else {
                  controller.selectedLocations.remove(location);
                }
              },
              title: Text(location),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            );
          });
        }).toList(),
      ],
    );
  }

  Widget _amountRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title + value text
        Obx(() {
          final range = controller.amountRange.value;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              appText(
                "Amount Range",
                fontSize: 16,
                color: AppColorHelper().primaryTextColor,
              ),
              appText(
                "₹ ${range.start.toInt()} - ${range.end.toInt()}",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColorHelper().primaryTextColor,
              ),
            ],
          );
        }),

        /// Custom reusable range slider
        Obx(() {
          return CustomRangeSlider(
            min: 0,
            max: 500000,
            divisions: 50, // optional – remove if you want smooth sliding
            values: controller.amountRange.value,
            onChanged: (value) {
              controller.amountRange.value = value;
            },
            activeColor: AppColorHelper().primaryColor,
            inactiveColor: AppColorHelper().primaryTextColor.withOpacity(0.1),
            thumbColor: AppColorHelper().primaryColor,
          );
        }),
      ],
    );
  }

  Widget _billedDateSection() {
    return Obx(() {
      final from = controller.billedFrom.value;
      final to = controller.billedTo.value;

      final text = (from == null || to == null)
          ? "Select date range"
          : "${from.day}/${from.month}/${from.year} - ${to.day}/${to.month}/${to.year}";

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          appText(
            "Billed Date Range",
            color: AppColorHelper().primaryTextColor,
            fontSize: 16,
          ),
          height(8),
          InkWell(
            onTap: () => _pickCustomDateRange(
              from: controller.billedFrom,
              to: controller.billedTo,
            ),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 10),
                  appText(text, color: AppColorHelper().primaryTextColor),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _committedDateSection() {
    return Obx(() {
      final from = controller.committedFrom.value;
      final to = controller.committedTo.value;

      final text = (from == null || to == null)
          ? "Select date range"
          : "${from.day}/${from.month}/${from.year} - ${to.day}/${to.month}/${to.year}";

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          appText(
            "Committed Date Range",
            fontSize: 16,
            color: AppColorHelper().primaryTextColor,
          ),
          height(8),
          InkWell(
            onTap: () => _pickCustomDateRange(
              from: controller.committedFrom,
              to: controller.committedTo,
            ),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 10),
                  appText(text, color: AppColorHelper().primaryTextColor),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _lateDaysSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title + value
        Obx(() {
          final range = controller.lateDaysRange.value;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              appText(
                "Late Days Range",
                fontSize: 16,
                color: AppColorHelper().primaryTextColor,
              ),
              appText(
                "${range.start.toInt()} - ${range.end.toInt()} days",
                color: AppColorHelper().primaryTextColor,
              ),
            ],
          );
        }),

        /// Custom range slider
        Obx(() {
          return CustomRangeSlider(
            min: 0,
            max: 180,
            divisions: 36, // 5-day steps (optional)
            values: controller.lateDaysRange.value,
            onChanged: (value) {
              controller.lateDaysRange.value = value;
            },
            activeColor: AppColorHelper().primaryColor,
            inactiveColor: AppColorHelper().primaryTextColor.withOpacity(0.1),
            thumbColor: AppColorHelper().primaryColor,
          );
        }),
      ],
    );
  }

  Widget _footerButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: controller.clearFilters,
            child: appText("Clear All Filters",
                color: AppColorHelper().primaryTextColor),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Get.back(result: true); // apply
            },
            child: appText("Apply Filters",
                color: AppColorHelper().primaryTextColor),
          ),
        ),
      ],
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
