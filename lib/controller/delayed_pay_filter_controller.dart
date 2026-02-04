import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helper/core/base/app_base_controller.dart';
import '../controller/delayed_payment_controller.dart';

class DelayedPayFilterController extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  /// LOCAL FILTER STATE (UI only)
  final RxList<String> selectedLocations = <String>[].obs;

  final Rx<RangeValues?> amountRange = Rx<RangeValues?>(null);
  final Rx<RangeValues?> lateDaysRange = Rx<RangeValues?>(null);

  final Rx<DateTime?> billedFrom = Rx<DateTime?>(null);
  final Rx<DateTime?> billedTo = Rx<DateTime?>(null);

  final Rx<DateTime?> committedFrom = Rx<DateTime?>(null);
  final Rx<DateTime?> committedTo = Rx<DateTime?>(null);

  final Rx<DateTime?> settledFrom = Rx<DateTime?>(null);
  final Rx<DateTime?> settledTo = Rx<DateTime?>(null);

  late final bool isPendingMode;

  /// AVAILABLE LOCATIONS (static)
  final List<String> allLocations = [
    'Kochi',
    'Kottayam',
    'Vandiperiyar',
  ];

  @override
  void onInit() {
    final main = Get.find<DelayedPaymentController>();

    // which screen opened the filter
    isPendingMode = main.isPending.value;

    // correct FilterState
    final filter = isPendingMode ? main.pendingFilters : main.settledFilters;

    // sync common filters
    selectedLocations.assignAll(filter.locations);
    amountRange.value = filter.amountRange.value;
    lateDaysRange.value = filter.lateDaysRange.value;

    billedFrom.value = filter.billedFrom.value;
    billedTo.value = filter.billedTo.value;

    committedFrom.value = filter.committedFrom.value;
    committedTo.value = filter.committedTo.value;

    // ✅ THIS WAS MISSING
    settledFrom.value = filter.settledFrom.value;
    settledTo.value = filter.settledTo.value;

    super.onInit();
  }

  /// APPLY → push values back to main controller
  void applyFilters() {
    final main = Get.find<DelayedPaymentController>();

    main.applyFilters(
      locations: selectedLocations,
      amountRange: amountRange.value,
      lateDaysRange: lateDaysRange.value,
      billedFrom: billedFrom.value,
      billedTo: billedTo.value,
      committedFrom: committedFrom.value,
      committedTo: committedTo.value,
      settledFrom: settledFrom.value,
      settledTo: settledTo.value,
    );
  }

  /// CLEAR UI ONLY (does NOT touch main controller yet)
  void clearFilters() {
    selectedLocations.clear();
    amountRange.value = null;
    lateDaysRange.value = null;
    billedFrom.value = null;
    billedTo.value = null;
    committedFrom.value = null;
    committedTo.value = null;
    settledFrom.value = null;
    settledTo.value = null;
  }
}
