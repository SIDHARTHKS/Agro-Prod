import 'package:agro/model/delayed_payments_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../helper/core/base/app_base_controller.dart';
import '../service/delayed_payment_service.dart';
import 'dart:async';
import '../helper/app_message.dart';
import '../helper/enum.dart';
import 'package:intl/intl.dart';

class DelayedPaymentController extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();

  /// Toggle Pending / Settled
  RxBool isPending = true.obs;

  /// Full API response holder
  final Rxn<DelayedPaymentsModel> delayedPayments = Rxn<DelayedPaymentsModel>();

  /// Inject service
  final DelayedPaymentService delayedPaymentService =
      Get.find<DelayedPaymentService>();

  final RxList<LocationDetailsListDtl> locationList =
      <LocationDetailsListDtl>[].obs;

  final RxList<DelayedPayListDtl> pendingStaticList = <DelayedPayListDtl>[].obs;
  final RxList<DelayedPayListDtl> settledStaticList = <DelayedPayListDtl>[].obs;

  final RxList<DelayedPayListDtl> pendingDisplayList =
      <DelayedPayListDtl>[].obs;
  final RxList<DelayedPayListDtl> settledDisplayList =
      <DelayedPayListDtl>[].obs;

  @override
  Future<void> onInit() async {
    // 🔑 This is what drives search
    searchController.addListener(rebuildDisplayLists);

    // 1. Try load cached data first
    final cachedJson =
        myApp.preferenceHelper!.getString('delayed_payments_cache');

    if (cachedJson.isNotEmpty) {
      try {
        final cachedData = delayedPaymentsModelFromJson(cachedJson);
        delayedPayments.value = cachedData;

        // L1 – Static
        pendingStaticList.assignAll(cachedData.delayedPayPendingListDtls ?? []);
        settledStaticList.assignAll(cachedData.delayedPaySettledListDtls ?? []);

        pendingDisplayList.assignAll(pendingStaticList);
        // Settled: only first 10 enter the pipeline
        final baseSettledWindow = settledStaticList.take(10).toList();
        settledDisplayList.assignAll(baseSettledWindow);

        locationList.assignAll(cachedData.locationDetailsListDtls ?? []);

        pendingVisibleCount.value = pendingPageSize;
        settledVisibleCount.value = 10;
      } catch (e) {
        appLog('Error parsing cached delayed payments: $e',
            logging: Logging.error);
      }
    }

    await _setArguments();
    await fetchInitData(); // this should repeat the same L1→L2→L3 assignment
    super.onInit();
  }

  void showPending() => isPending.value = true;
  void showSettled() => isPending.value = false;

  Future<void> _setArguments() async {
    // keep your existing argument logic here if needed
  }

  Future<bool> fetchInitData({
    String repToDate = "",
  }) async {
    try {
      DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      repToDate = formatter.format(now);
      const String companyCode = 'ttpl';
      const String branchCode = 'pce';

      final data = await delayedPaymentService
          .fetchDelayedPayments(DelayedPaymentsRequest(
        companyCode: companyCode,
        branchCode: branchCode,
        repToDate: repToDate,
      ));

      if (data != null) {
        delayedPayments.value = data;

        pendingStaticList.assignAll(data.delayedPayPendingListDtls ?? []);
        settledStaticList.assignAll(data.delayedPaySettledListDtls ?? []);

        pendingDisplayList.assignAll(pendingStaticList);
        settledDisplayList.assignAll(settledStaticList.take(10));

        pendingVisibleCount.value = pendingPageSize;
        settledVisibleCount.value = 10;

        locationList.assignAll(
          data.locationDetailsListDtls ?? [],
        );

        // Save JSON string to SharedPreferences
        await myApp.preferenceHelper!.setString(
          'delayed_payments_cache',
          delayedPaymentsModelToJson(data),
        );

        return true;
      }

      appLog('No delayed payment data received', logging: Logging.warning);
      return false;
    } catch (e) {
      appLog('Failed to fetch delayed payments: $e', logging: Logging.error);
      return false;
    }
  }

  double _toDouble(Object? value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  void applyFilters({
    List<String>? locations,
    RangeValues? amountRange,
    RangeValues? lateDaysRange,
    DateTime? billedFrom,
    DateTime? billedTo,
    DateTime? committedFrom,
    DateTime? committedTo,
  }) {
    selectedLocations.assignAll(locations ?? []);
    this.amountRange.value = amountRange;
    this.lateDaysRange.value = lateDaysRange;

    this.billedFrom.value = billedFrom;
    this.billedTo.value = billedTo;
    this.committedFrom.value = committedFrom;
    this.committedTo.value = committedTo;

    rebuildDisplayLists();
  }

  void applySearch(String _) {
    rebuildDisplayLists();
  }

  void clearFilters() {
    selectedLocations.clear();
    amountRange.value = null;
    lateDaysRange.value = null;
    billedFrom.value = null;
    billedTo.value = null;
    committedFrom.value = null;
    committedTo.value = null;

    rebuildDisplayLists();
  }

  final RxInt settledVisibleCount = 10.obs;
  final int settledPageSize = 50; // page size when unlocked

  /// Visible settled list only (from DISPLAY list)
  List<DelayedPayListDtl> get visibleSettledList {
    final total = settledDisplayList.length;
    final visible = settledVisibleCount.value;
    return settledDisplayList.take(visible.clamp(0, total)).toList();
  }

  /// Load more
  void loadMoreSettled() {
    if (settledVisibleCount.value < settledDisplayList.length) {
      settledVisibleCount.value += settledPageSize;
    }
  }

  /// Pending lazy load
  final RxInt pendingVisibleCount = 50.obs;
  final int pendingPageSize = 50;

  /// Visible pending list (from DISPLAY list)
  List<DelayedPayListDtl> get visiblePendingList {
    final total = pendingDisplayList.length;
    final visible = pendingVisibleCount.value;
    return pendingDisplayList.take(visible.clamp(0, total)).toList();
  }

  /// Load more pending
  void loadMorePending() {
    if (pendingVisibleCount.value < pendingDisplayList.length) {
      pendingVisibleCount.value += pendingPageSize;
    }
  }

  /// Pull-to-refresh
  Future<void> refreshPending() async {
    pendingVisibleCount.value = pendingPageSize;
    await fetchInitData();
  }

  Future<void> refreshSettled() async {
    /// Reset lazy load
    settledVisibleCount.value = settledPageSize;

    /// Re-fetch data
    await fetchInitData();
  }

  // telephone
  Future<void> openDialer(String phoneNumber) async {
    if (phoneNumber.trim().isEmpty) {
      showErrorSnackbar(message: "No number available!");
      return;
    }

    final Uri uri = Uri.parse("tel:$phoneNumber");

    try {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // 🔑 REQUIRED for iOS
      );
    } catch (e) {
      showErrorSnackbar(message: "Could not open dialer");
    }
  }

// FILTER STATE (persisted)
  final Rx<RangeValues?> amountRange = Rx<RangeValues?>(null);
  final Rx<RangeValues?> lateDaysRange = Rx<RangeValues?>(null);

  final Rx<DateTime?> billedFrom = Rx<DateTime?>(null);
  final Rx<DateTime?> billedTo = Rx<DateTime?>(null);

  final Rx<DateTime?> committedFrom = Rx<DateTime?>(null);
  final Rx<DateTime?> committedTo = Rx<DateTime?>(null);

  final RxList<String> selectedLocations = <String>[].obs;

  bool _matches(DelayedPayListDtl e) {
    final key = searchController.text.trim().toLowerCase();

    // 🔍 SEARCH
    if (key.isNotEmpty &&
        !(e.custName ?? '').toLowerCase().contains(key) &&
        !(e.location ?? '').toLowerCase().contains(key) &&
        !(e.billNo ?? '').toLowerCase().contains(key)) {
      return false;
    }

    // 📍 LOCATION
    if (selectedLocations.isNotEmpty &&
        !selectedLocations.contains(e.location)) {
      return false;
    }

    // 💰 AMOUNT
    final range = amountRange.value;
    if (range != null) {
      final amount = _toDouble(e.billAmt);
      if (amount < range.start || amount > range.end) {
        return false;
      }
    }

    // ⏱️ LATE DAYS
    final lateRange = lateDaysRange.value;
    if (lateRange != null) {
      final days = _toDouble(e.lateDays);
      if (days < lateRange.start || days > lateRange.end) {
        return false;
      }
    }

    final df = DateFormat('dd/MM/yyyy');

    // 📅 BILLED DATE
    if (billedFrom.value != null && billedTo.value != null) {
      if (e.billedOn == null) return false;
      final d = df.tryParse(e.billedOn!);
      if (d == null ||
          d.isBefore(billedFrom.value!) ||
          d.isAfter(billedTo.value!)) {
        return false;
      }
    }

    // 📅 COMMITTED DATE
    if (committedFrom.value != null && committedTo.value != null) {
      if (e.committedOn == null) return false;
      final d = df.tryParse(e.committedOn!);
      if (d == null ||
          d.isBefore(committedFrom.value!) ||
          d.isAfter(committedTo.value!)) {
        return false;
      }
    }

    return true;
  }

  void rebuildDisplayLists() {
    pendingDisplayList.assignAll(
      pendingStaticList.where(_matches),
    );

    settledDisplayList.assignAll(
      settledStaticList.where(_matches),
    );

    pendingVisibleCount.value = pendingPageSize;
    settledVisibleCount.value =
        searchController.text.isEmpty ? 10 : settledDisplayList.length;
  }
}
