import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helper/core/base/app_base_controller.dart';
import 'dart:async';

class DelayedPayFilterController extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();

  /// AMOUNT RANGE
  final Rx<RangeValues> amountRange = const RangeValues(50000, 200000).obs;

  /// LATE DAYS RANGE
  final Rx<RangeValues> lateDaysRange = const RangeValues(20, 80).obs;

  /// DATES
  final Rx<DateTime?> billedFrom = Rx<DateTime?>(null);
  final Rx<DateTime?> billedTo = Rx<DateTime?>(null);

  final Rx<DateTime?> committedFrom = Rx<DateTime?>(null);
  final Rx<DateTime?> committedTo = Rx<DateTime?>(null);

  @override
  Future<void> onInit() async {
    // 🔑 This is what drives search

    await _setArguments();

    super.onInit();
  }

  Future<void> _setArguments() async {
    // keep your existing argument logic here if needed
  }

  /// AVAILABLE LOCATIONS
  final List<String> allLocations = [
    'Kochi',
    'Kottayam',
    'Vanddiperiyar',
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
