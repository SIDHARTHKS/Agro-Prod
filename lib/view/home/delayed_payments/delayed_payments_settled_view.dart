import 'package:agro/controller/delayed_payment_controller.dart';
import 'package:agro/model/bill_summary_model.dart';
import 'package:agro/view/widget/common_widget.dart';
import 'package:agro/helper/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../helper/color_helper.dart';
import '../../../helper/sizer.dart';
import '../delayed_payments/widgets/delayed_payments_shared_widgets.dart';
import 'package:agro/model/delayed_payments_model.dart';

class DelayedPaymentsSettledView extends GetView<DelayedPaymentController> {
  const DelayedPaymentsSettledView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.delayedPayments.value == null) {
        return const Center(child: CircularProgressIndicator());
      }

      final list = controller.visibleSettledList;

      return RefreshIndicator(
          color: AppColorHelper().primaryColor,
          onRefresh: controller.refreshSettled,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent - 200) {
                controller.loadMoreSettled();
              }
              return false;
            },
            child: ListView(
              padding: const EdgeInsets.only(
                top: 25,
                bottom: 35 + kBottomNavigationBarHeight,
              ),
              children: [
                /// HEADER
                Center(
                  child:
                      DelayedPaymentSharedWidgets().heading("Cleared Details"),
                ),

                /// SEARCH BAR
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: DelayedPaymentSharedWidgets()
                      .searchBar(controller.searchController),
                ),

                /// BILL CARDS
                ...list.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: _settledBillCard(item),
                  ),
                ),

                /// LOADING FOOTER
                if (controller.settledVisibleCount.value <
                    controller.settledDisplayList.length)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ));
    });
  }

  Widget _settledBillCard(DelayedPayListDtl data) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 2),
              height: 183,
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
                  height(5),
                  DelayedPaymentSharedWidgets().cardHeader(data, false),
                  DelayedPaymentSharedWidgets().billInfoRow(data),
                  height(10),
                  Flexible(
                      child: LayoutBuilder(builder: (context, constraints) {
                    return DelayedPaymentSharedWidgets()
                        .dashedLine(constraints.biggest.width);
                  })),
                  height(13),
                  _settledBillInfoRow(data),
                  height(14),
                  _viewDetailsButton(data),
                ],
              ),
            ),
            DelayedPaymentSharedWidgets().lateTag(data),
          ],
        ));
  }

  Widget _settledBillInfoRow(DelayedPayListDtl data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _infoColumn("Billed On", data.billedOn ?? ''),
          _infoColumn("Settled On", data.settledOn ?? ''),
          _infoColumn("Payment Mode", data.paymentMode ?? ''),
        ],
      ),
    );
  }

  Widget _infoColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appText(title,
            fontSize: 12,
            color: AppColorHelper().primaryTextColor.withAlpha(140),
            fontWeight: FontWeight.w400),
        height(2),
        appText(value,
            fontSize: 12,
            color: AppColorHelper().primaryTextColor,
            fontWeight: FontWeight.w500),
      ],
    );
  }

  Widget _viewDetailsButton(DelayedPayListDtl data) {
    return SizedBox(
      width: double.infinity,
      height: 42, // slightly smaller
      child: ElevatedButton(
        onPressed: () {
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
              'isSettled': true,
            },
          );
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColorHelper().successGreenColor,
          backgroundColor: AppColorHelper().successBackgroundGreen,
          elevation: 0, // shadow already handled by parent card
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),

          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
        ),
        child: appText("View Details",
            color: AppColorHelper().secondaryTextColor,
            fontWeight: FontWeight.w400,
            fontSize: 13),
      ),
    );
  }
}
