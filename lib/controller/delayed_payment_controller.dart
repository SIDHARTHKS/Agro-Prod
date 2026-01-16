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

  final RxList<DelayedPayListDtl> pendingList = <DelayedPayListDtl>[].obs;

  final RxList<DelayedPayListDtl> settledList = <DelayedPayListDtl>[].obs;

  final RxList<LocationDetailsListDtl> locationList =
      <LocationDetailsListDtl>[].obs;

  /// L1 – Static (API result, never touched by search/filter)
  final RxList<DelayedPayListDtl> pendingStaticList = <DelayedPayListDtl>[].obs;
  final RxList<DelayedPayListDtl> settledStaticList = <DelayedPayListDtl>[].obs;

  /// L2 – After search
  final RxList<DelayedPayListDtl> pendingSearchList = <DelayedPayListDtl>[].obs;
  final RxList<DelayedPayListDtl> settledSearchList = <DelayedPayListDtl>[].obs;

  /// L3 – Final display (after filters)
  final RxList<DelayedPayListDtl> pendingDisplayList =
      <DelayedPayListDtl>[].obs;
  final RxList<DelayedPayListDtl> settledDisplayList =
      <DelayedPayListDtl>[].obs;

  @override
  Future<void> onInit() async {
    // 🔑 This is what drives search
    searchController.addListener(() {
      applySearch(searchController.text);
    });

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

        locationList.assignAll(cachedData.locationDetailsListDtls ?? []);

        // Pending behaves normally
        pendingDisplayList.assignAll(pendingStaticList);

        // Settled: only first 10 enter the pipeline
        final baseSettledWindow = settledStaticList.take(10).toList();
        settledDisplayList.assignAll(baseSettledWindow);

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

        // L2
        pendingSearchList.assignAll(pendingStaticList);
        settledSearchList.assignAll(settledStaticList);

        // L3
        pendingDisplayList.assignAll(pendingSearchList);

        // Settled shows only 10 initially
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

  void applyFilters() {
    final hasSearch = searchController.text.trim().isNotEmpty;

    pendingDisplayList.assignAll(pendingSearchList);

    if (hasSearch) {
      // After search → allow full filtered data
      settledDisplayList.assignAll(settledSearchList);
      settledVisibleCount.value = settledPageSize;
    } else {
      // No search → show only 10
      settledDisplayList.assignAll(settledSearchList.take(10));
      settledVisibleCount.value = 10;
    }

    pendingVisibleCount.value = pendingPageSize;
  }

  void applySearch(String query) {
    final key = query.trim().toLowerCase();

    // Pending – normal full search
    if (key.isEmpty) {
      pendingDisplayList.assignAll(pendingStaticList);
    } else {
      pendingDisplayList.assignAll(
        pendingStaticList.where((e) =>
            (e.custName ?? '').toLowerCase().contains(key) ||
            (e.location ?? '').toLowerCase().contains(key) ||
            (e.billNo ?? '').toLowerCase().contains(key)),
      );
    }

    // Settled – search ONLY inside first 10
    final baseSettledWindow = settledStaticList.take(10);

    if (key.isEmpty) {
      settledDisplayList.assignAll(baseSettledWindow);
    } else {
      settledDisplayList.assignAll(
        baseSettledWindow.where((e) =>
            (e.custName ?? '').toLowerCase().contains(key) ||
            (e.location ?? '').toLowerCase().contains(key) ||
            (e.billNo ?? '').toLowerCase().contains(key)),
      );
    }

    pendingVisibleCount.value = pendingPageSize;
    settledVisibleCount.value = settledDisplayList.length;
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
}
