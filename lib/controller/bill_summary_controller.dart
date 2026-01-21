import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helper/core/base/app_base_controller.dart';
import '../model/bill_summary_model.dart';
import '../service/bill_summary_service.dart';
import 'dart:async';
import '../helper/app_message.dart';
import '../helper/enum.dart';

class BillSummaryController extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();

  RxBool isSettled = false.obs;
  final Rxn<BillSummaryModel> billSummary = Rxn<BillSummaryModel>();

  List<ProductDetailsListDtl> get productList =>
      billSummary.value?.productDetailsListDtls ?? [];

  final BillSummaryService _service = BillSummaryService();

  @override
  Future<void> onInit() async {
    super.onInit();
    await _setArguments();
  }

  Future<void> _setArguments() async {
    final args = Get.arguments;

    if (args is Map) {
      final request = args['request'];
      final settled = args['isSettled'];

      if (settled is bool) {
        isSettled.value = settled;
      }

      if (request is BillSummaryRequest) {
        await _loadFromApi(request);
      } else {
        appLog(
          'BillSummary opened without BillSummaryRequest',
          logging: Logging.warning,
        );
      }
    } else if (args is BillSummaryRequest) {
      // backward compatibility (if any old navigation still uses this)
      await _loadFromApi(args);
    } else {
      appLog(
        'BillSummary opened with invalid arguments',
        logging: Logging.warning,
      );
    }
  }

  Future<void> _loadFromApi(BillSummaryRequest request) async {
    billSummary.value = null; // triggers loader

    try {
      final result = await _service.fetchDelayedPayBillSummary(request);

      if (result != null) {
        billSummary.value = result;
      } else {
        showErrorSnackbar(
          title: "No Bill Details",
          message: "No bill details found for this invoice.",
        );

        Future.delayed(const Duration(milliseconds: 300), () {
          Get.back();
        });
      }
    } catch (e) {
      showErrorSnackbar(
        title: "Error",
        message: "Failed to load bill details. Please try again.",
      );

      Future.delayed(const Duration(milliseconds: 300), () {
        Get.back();
      });
    }
  }
}
