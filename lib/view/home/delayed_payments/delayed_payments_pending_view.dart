import 'package:agro/controller/delayed_payment_controller.dart';
import 'package:agro/gen/assets.gen.dart';
import 'package:agro/helper/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../helper/color_helper.dart';
import '../../../helper/sizer.dart';
import '../../widget/common_widget.dart';
import '../delayed_payments/widgets/delayed_payments_shared_widgets.dart';
import 'package:agro/model/delayed_payments_model.dart';
import 'package:agro/model/bill_summary_model.dart';

class DelayedPaymentsPendingView extends GetView<DelayedPaymentController> {
  const DelayedPaymentsPendingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.delayedPayments.value == null) {
        return const Center(child: CircularProgressIndicator());
      }

      final list = controller.visiblePendingList;

      return RefreshIndicator(
        color: AppColorHelper().primaryColor,
        onRefresh: controller.refreshPending,
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.pixels >=
                notification.metrics.maxScrollExtent - 200) {
              controller.loadMorePending();
            }
            return false;
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(
              bottom: 40 + kBottomNavigationBarHeight,
            ),
            children: [
              /// SUMMARY
              Center(child: _summarySection()),

              /// DASHED LINE
              Column(
                children: [
                  height(20),
                  DelayedPaymentSharedWidgets().dashedLine(Get.width),
                  height(25),
                ],
              ),

              /// LOCATION SUMMARY
              _locationSummaryCards(),

              /// OVERDUE TITLE
              Column(
                children: [
                  height(20),
                  Center(
                    child: DelayedPaymentSharedWidgets()
                        .heading("Overdue Details"),
                  ),
                  height(20),
                ],
              ),

              /// SEARCH BAR
              Column(
                children: [
                  DelayedPaymentSharedWidgets()
                      .searchBar(controller.searchController),
                  height(23),
                ],
              ),

              /// BILL CARDS
              ...list.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: _pendingBillCard(item),
                ),
              ),

              /// LOADING FOOTER
              if (controller.pendingVisibleCount.value <
                  controller.pendingDisplayList.length)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _summarySection() {
    final model = controller.delayedPayments.value;

    if (model == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          /// Total bills
          appText(
            "From ${model.totalBills ?? '--'} Bills",
            fontSize: 12,
            color: AppColorHelper().primaryTextColor.withAlpha(130),
            fontWeight: FontWeight.w500,
          ),

          height(4),

          /// Amount row
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Rupee icon
              Image.asset(
                Assets.icons.rupee.path,
                width: 21,
                height: 22,
                fit: BoxFit.contain,
              ),

              /// Amount text
              appText(
                DelayedPaymentSharedWidgets.indianCurrency(
                    model.totalAmount ?? "0"),
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: AppColorHelper().primaryTextColor,
              ),

              /// Growth icon (optional)
              Image.asset(
                Assets.icons.arrowupgreen.path,
                width: 10,
                height: 10,
                fit: BoxFit.contain,
              ),
            ],
          ),

          height(6),

          /// Bills for month
          appText(
            "${model.billsForMonth ?? '--'} Bills this month",
            fontSize: 13,
            color: AppColorHelper().primaryTextColor.withAlpha(130),
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget _locationSummaryCards() {
    final model = controller.delayedPayments.value;

    if (model == null ||
        model.locationDetailsListDtls == null ||
        model.locationDetailsListDtls!.isEmpty) {
      return const SizedBox.shrink();
    }

    final locations = model.locationDetailsListDtls!;

    return Padding(
      padding: const EdgeInsets.only(left: 25),
      child: SizedBox(
        height: 90,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: locations.length,
          itemBuilder: (_, index) {
            return _locationCard(locations[index]);
          },
        ),
      ),
    );
  }

  Widget _locationCard(LocationDetailsListDtl data) {
    return Container(
      width: 155,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColorHelper().cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          /// Location name
          appText(
            data.locationName ?? '',
            fontSize: 12,
            color: AppColorHelper().secondaryTextColor,
            fontWeight: FontWeight.w500,
            overflow: TextOverflow.ellipsis,
          ),

          height(3),

          /// Amount row (Rupee icon + value)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                Assets.icons.rupee.path,
                width: 10,
                height: 10,
                fit: BoxFit.contain,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: appText(
                  DelayedPaymentSharedWidgets.indianCurrency(
                      data.locTotAmt ?? '0'),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColorHelper().primaryTextColor,
                ),
              ),
            ],
          ),

          /// Bill count
          appText(
            '${data.locTotBillCnt ?? '0'} Bills',
            fontSize: 12,
            color: AppColorHelper().primaryTextColor.withAlpha(180),
          ),
        ],
      ),
    );
  }

  Widget _pendingBillCard(DelayedPayListDtl data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 1),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 215,
            decoration: BoxDecoration(
              color: AppColorHelper().cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 12,
                  spreadRadius: -6,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                /// 👇 Tap only on header
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    final request = BillSummaryRequest(
                      companyCode: data.compCode,
                      branchCode: data.branchCode,
                      syCode: data.syCode,
                      locationId: data.locationId,
                      invoiceId: data.invoiceId,
                    );

                    Get.toNamed(
                      billSummaryRoute,
                      arguments: {
                        'request': request,
                        'isSettled': false,
                      },
                    );
                  },
                  child: DelayedPaymentSharedWidgets().cardHeader(data, true),
                ),

                DelayedPaymentSharedWidgets().billInfoRow(data),
                height(9),
                _phoneTag(data),
                height(12),
                _billDateRow(data),
                height(12),
                __reminderButton(),
              ],
            ),
          ),
          DelayedPaymentSharedWidgets().lateTag(data),
        ],
      ),
    );
  }

  Widget _phoneTag(DelayedPayListDtl data) {
    const double boxHeight = 50;
    const double buttonSize = 50;

    return SizedBox(
      height: 52,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.only(right: buttonSize / 2),
                  color: AppColorHelper().secondaryBackgroundColor,
                  child: Row(
                    children: [
                      appText(
                        "Contact Number : ",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color:
                            AppColorHelper().primaryTextColor.withOpacity(0.6),
                      ),
                      appText(
                        data.phoneNo ?? '',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColorHelper().primaryTextColor,
                      ),
                    ],
                  ),
                ),
              ),

              // Right white area (only half button)
              Container(
                width: buttonSize / 2,
                color: Colors.white,
              ),
            ],
          ),

          // Call Button (floating)
          Positioned(
            right: 14,
            top: 0,
            bottom: 0,
            child: Center(
              child: InkWell(
                borderRadius: BorderRadius.circular(boxHeight),
                onTap: () async {
                  final String? phoneRaw = data.phoneNo;

                  await controller.openDialer(phoneRaw ?? "");
                },
                child: SizedBox(
                  width: boxHeight,
                  height: boxHeight,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // White outer
                      Container(
                        width: boxHeight,
                        height: boxHeight,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),

                      // Rings closer together
                      Container(
                        width: boxHeight * 0.92,
                        height: boxHeight * 0.92,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              AppColorHelper().primaryColor.withOpacity(0.12),
                        ),
                      ),

                      Container(
                        width: boxHeight * 0.78,
                        height: boxHeight * 0.78,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              AppColorHelper().primaryColor.withOpacity(0.25),
                        ),
                      ),

                      // Main button
                      Container(
                        width: boxHeight * 0.62,
                        height: boxHeight * 0.62,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColorHelper().primaryColor,
                        ),
                        child: Center(
                          child: Image.asset(
                            Assets.icons.callBtn.path,
                            width: boxHeight * 0.34,
                            height: boxHeight * 0.34,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _billDateRow(
    DelayedPayListDtl data,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 25,
      child: Row(
        children: [
          appText("Billed On : ",
              fontSize: 12,
              color: AppColorHelper().primaryTextColor.withOpacity(0.6),
              fontWeight: FontWeight.w400),
          appText(
            data.billedOn ?? '',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColorHelper().primaryTextColor,
          ),
          const Spacer(),
          appText("Committed On : ",
              fontSize: 12,
              color: AppColorHelper().primaryTextColor.withOpacity(0.6),
              fontWeight: FontWeight.w400),
          appText(
            data.committedOn ?? '',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColorHelper().primaryTextColor,
          ),
        ],
      ),
    );
  }

  Widget __reminderButton() {
    return Container(
        //padding: const EdgeInsets.symmetric(Hori: 8),
        //margin: const EdgeInsets.symmetric(vertical: 50),
        height: 45,
        decoration: BoxDecoration(
          color: AppColorHelper().cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: agroContainer(
            onPressed: () {},
            appText("Send Reminder", fontSize: 12, fontWeight: FontWeight.w500),
            leadingIcon: Image.asset(
              Assets.icons.bell.path,
              width: 14,
              height: 14,
            ),
            radius: 12));
  }
}
