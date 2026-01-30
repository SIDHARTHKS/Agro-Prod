import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helper/core/base/app_base_controller.dart';
import 'dart:async';

class DelayedPayFilterController extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();

  /// Toggle Pending / Settled
  RxBool isPending = true.obs;

  @override
  Future<void> onInit() async {
    // 🔑 This is what drives search

    await _setArguments();

    super.onInit();
  }

  Future<void> _setArguments() async {
    // keep your existing argument logic here if needed
  }
}
