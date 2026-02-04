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

class FilterState {
  final RxList<String> locations = <String>[].obs;
  final Rx<RangeValues?> amountRange = Rx<RangeValues?>(null);
  final Rx<RangeValues?> lateDaysRange = Rx<RangeValues?>(null);

  // 📄 Billed date (common / optional)
  final Rx<DateTime?> billedFrom = Rx<DateTime?>(null);
  final Rx<DateTime?> billedTo = Rx<DateTime?>(null);

  // ⏳ Pending screen
  final Rx<DateTime?> committedFrom = Rx<DateTime?>(null);
  final Rx<DateTime?> committedTo = Rx<DateTime?>(null);

  // ✅ Settled screen
  final Rx<DateTime?> settledFrom = Rx<DateTime?>(null);
  final Rx<DateTime?> settledTo = Rx<DateTime?>(null);

  void clear() {
    locations.clear();
    amountRange.value = null;
    lateDaysRange.value = null;

    billedFrom.value = null;
    billedTo.value = null;

    committedFrom.value = null;
    committedTo.value = null;

    settledFrom.value = null;
    settledTo.value = null;
  }

  int get count {
    int c = 0;
    if (locations.isNotEmpty) c++;
    if (amountRange.value != null) c++;
    if (lateDaysRange.value != null) c++;
    if (billedFrom.value != null && billedTo.value != null) c++;
    if (committedFrom.value != null && committedTo.value != null) c++;
    if (settledFrom.value != null && settledTo.value != null) c++;
    return c;
  }

  bool get hasFilters => count > 0;
}

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

  final FilterState pendingFilters = FilterState();
  final FilterState settledFilters = FilterState();

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

        // ✅ SORT STATIC LISTS ONCE
        _sortByBilledDateDesc(pendingStaticList);
        _sortByBilledDateDesc(settledStaticList);

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

  void showPending() {
    isPending.value = true;
    rebuildDisplayLists();
  }

  void showSettled() {
    isPending.value = false;
    rebuildDisplayLists();
  }

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

        _sortByBilledDateDesc(pendingStaticList);
        _sortByBilledDateDesc(settledStaticList);

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
    DateTime? settledFrom,
    DateTime? settledTo,
  }) {
    final f = _activeFilters;

    f.locations.assignAll(locations ?? []);
    f.amountRange.value = amountRange;
    f.lateDaysRange.value = lateDaysRange;

    f.billedFrom.value = billedFrom;
    f.billedTo.value = billedTo;
    f.committedFrom.value = committedFrom;
    f.committedTo.value = committedTo;
    // ✅ THIS WAS MISSING
    f.settledFrom.value = settledFrom;
    f.settledTo.value = settledTo;

    rebuildDisplayLists();
  }

  void applySearch(String _) {
    rebuildDisplayLists();
  }

  void clearFilters() {
    final f = _activeFilters;
    f.clear();

    if (isPending.value) {
      // Pending → full rebuild
      pendingDisplayList.assignAll(pendingStaticList);
      pendingVisibleCount.value = pendingPageSize;
    } else {
      // ✅ Settled → reset to default 10
      settledDisplayList.assignAll(settledStaticList.take(10));
      settledVisibleCount.value = 10;
    }
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

  void _sortByBilledDateDesc(List<DelayedPayListDtl> list) {
    list.sort(
      (a, b) => _parseBilledDateOrMin(b.billedOn)
          .compareTo(_parseBilledDateOrMin(a.billedOn)),
    );
  }

  bool _matches(DelayedPayListDtl e) {
    final f = _activeFilters;
    final key = searchController.text.trim().toLowerCase();

    // SEARCH
    if (key.isNotEmpty &&
        !(e.custName ?? '').toLowerCase().contains(key) &&
        !(e.location ?? '').toLowerCase().contains(key) &&
        !(e.billNo ?? '').toLowerCase().contains(key)) {
      return false;
    }

    // LOCATION
    if (f.locations.isNotEmpty && !f.locations.contains(e.location)) {
      return false;
    }

    // AMOUNT
    final range = f.amountRange.value;
    if (range != null) {
      final amount = _toDouble(e.billAmt);
      if (amount < range.start || amount > range.end) return false;
    }

    if (_isLateDaysActive(f)) {
      final lateRange = f.lateDaysRange.value!;
      final days = _parseLateDays(e.lateDays);

      // ❌ no lateDays → do NOT match
      if (days == null) return false;

      if (days < lateRange.start || days > lateRange.end) {
        return false;
      }
    }

    final df = DateFormat('dd MMM yyyy');

    // 🔹 BILLED DATE (COMMON FOR BOTH)
    if (f.billedFrom.value != null && f.billedTo.value != null) {
      final d = df.tryParse(e.billedOn ?? '');
      if (d == null ||
          d.isBefore(f.billedFrom.value!) ||
          d.isAfter(f.billedTo.value!)) {
        return false;
      }
    }

    if (isPending.value) {
      // 🔹 Pending → committedOn
      if (f.committedFrom.value != null && f.committedTo.value != null) {
        final d = df.tryParse(e.committedOn ?? '');
        if (d == null ||
            d.isBefore(f.committedFrom.value!) ||
            d.isAfter(f.committedTo.value!)) {
          return false;
        }
      }
    } else {
      // 🔹 Settled → settledOn
      if (f.settledFrom.value != null && f.settledTo.value != null) {
        final d = df.tryParse(e.settledOn ?? '');
        if (d == null ||
            d.isBefore(f.settledFrom.value!) ||
            d.isAfter(f.settledTo.value!)) {
          return false;
        }
      }
    }

    return true;
  }

  DateTime _parseBilledDateOrMin(String? value) {
    if (value == null || value.trim().isEmpty) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }

    try {
      // API format: "28 May 2025"
      return DateFormat('dd MMM yyyy').parse(value);
    } catch (_) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }

  void rebuildDisplayLists() {
    // ---------------- Pending
    final pendingMatched = pendingStaticList.where(_matches).toList()
      ..sort((a, b) => _parseBilledDateOrMin(b.billedOn)
          .compareTo(_parseBilledDateOrMin(a.billedOn)));

    pendingDisplayList.assignAll(pendingMatched);
    pendingVisibleCount.value = pendingPageSize;

    // ---------------- Settled
    final settledMatched = settledStaticList.where(_matches).toList()
      ..sort((a, b) => _parseBilledDateOrMin(b.billedOn)
          .compareTo(_parseBilledDateOrMin(a.billedOn)));

    final hasActiveFilter = _activeFilters.hasFilters;
    final hasSearch = searchController.text.trim().isNotEmpty;

    if (!hasActiveFilter && !hasSearch) {
      // ✅ Default settled → only 10 (but sorted)
      settledDisplayList.assignAll(settledMatched.take(10));
      settledVisibleCount.value = 10;
    } else {
      // ✅ Filtered/search → full sorted list
      settledDisplayList.assignAll(settledMatched);
      settledVisibleCount.value = settledMatched.length;
    }
  }

  int get appliedFilterCount => _activeFilters.count;

  bool get hasActiveFilters => _activeFilters.hasFilters;
  FilterState get _activeFilters =>
      isPending.value ? pendingFilters : settledFilters;

  bool _isLateDaysActive(FilterState f) {
    final r = f.lateDaysRange.value;
    if (r == null) return false;

    // default range = NOT a filter
    return !(r.start == 20 && r.end == 80);
  }

  double? _parseLateDays(Object? value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String && value.trim().isNotEmpty) {
      return double.tryParse(value);
    }
    return null;
  }
}
