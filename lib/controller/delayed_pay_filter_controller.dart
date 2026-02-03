import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helper/core/base/app_base_controller.dart';
import '../controller/delayed_payment_controller.dart';
import 'dart:async';

class DelayedPayFilterController extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();

  final Rx<RangeValues?> amountRange = Rx<RangeValues?>(null);
  final Rx<RangeValues?> lateDaysRange = Rx<RangeValues?>(null);

  /// DATES
  final Rx<DateTime?> billedFrom = Rx<DateTime?>(null);
  final Rx<DateTime?> billedTo = Rx<DateTime?>(null);

  final Rx<DateTime?> committedFrom = Rx<DateTime?>(null);
  final Rx<DateTime?> committedTo = Rx<DateTime?>(null);

  final RxBool amountTouched = false.obs;
  final RxBool lateDaysTouched = false.obs;

  @override
  void onInit() {
    final main = Get.find<DelayedPaymentController>();

    amountRange.value = main.amountRange.value;
    lateDaysRange.value = main.lateDaysRange.value;

    billedFrom.value = main.billedFrom.value;
    billedTo.value = main.billedTo.value;

    committedFrom.value = main.committedFrom.value;
    committedTo.value = main.committedTo.value;

    selectedLocations.assignAll(main.selectedLocations);

    super.onInit();
  }

  Future<void> _setArguments() async {
    // keep your existing argument logic here if needed
  }

  /// AVAILABLE LOCATIONS
  final List<String> allLocations = [
    'Kochi',
    'Kottayam',
    'Vandiperiyar',
  ];

  final RxList<String> selectedLocations = <String>[].obs;

  /// CLEAR ALL
  void clearFilters() {
    selectedLocations.clear();
    amountRange.value = const RangeValues(50000, 200000);
    lateDaysRange.value = const RangeValues(20, 80);
    billedFrom.value = null;
    billedTo.value = null;
    committedFrom.value = null;
    committedTo.value = null;
  }
}
