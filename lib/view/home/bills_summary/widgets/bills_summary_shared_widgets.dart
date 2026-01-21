import 'package:agro/gen/assets.gen.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter/material.dart';
import '../../../../helper/color_helper.dart';
import 'package:agro/model/bill_summary_model.dart';
import 'package:intl/intl.dart';
import '../../../widget/common_widget.dart';
import 'package:dotted_border/dotted_border.dart';
import '/helper/sizer.dart';

class BillsSummarySharedWidgets {
  Widget heading(String title) {
    return SizedBox(
      height: 20,
      child: Row(
        children: [
          Flexible(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return dashedLine(constraints.maxWidth);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: appText(
              title,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColorHelper().primaryTextColor,
            ),
          ),
          Flexible(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return dashedLine(constraints.maxWidth);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget dashedLine(
    double maxWidth, {
    bool inset = true,
    Color? dashcolor,
  }) {
    const horizontalPadding = 25.0;

    final usableWidth = inset ? maxWidth - (horizontalPadding * 2) : maxWidth;

    return Padding(
      padding: inset
          ? const EdgeInsets.symmetric(horizontal: horizontalPadding)
          : EdgeInsets.zero,
      child: Dash(
        direction: Axis.horizontal,
        length: usableWidth > 0 ? usableWidth : 0,
        dashLength: 3,
        dashColor: dashcolor ?? AppColorHelper().primaryTextColor.withAlpha(30),
      ),
    );
  }

  Widget addressInfoRow(BillSummaryModel data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: appText(
              data.custAddress ?? '',
              color: AppColorHelper().primaryTextColor.withAlpha(128),
              fontSize: 13,
              fontWeight: FontWeight.w500,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget cardHeader(BillSummaryModel data, bool pending) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: SizedBox(
        height: 30,
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 20.0, right: 20.0),
          child: Row(
            children: [
              Expanded(
                // Reserve space so text never goes under lateTag
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 130), // width of lateTag area
                  child: appText(
                    data.custName ?? '',
                    color: AppColorHelper().primaryTextColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color lateBgColor(int days) {
    if (days <= 0) return AppColorHelper().successBackgroundGreen;
    if (days <= 10) return AppColorHelper().warningBackgroundYellow;
    return AppColorHelper().warningBackgroundRed;
  }

  Color lateTextColor(int days) {
    if (days <= 0) return AppColorHelper().successGreenColor;
    if (days <= 10) return AppColorHelper().warningYellowColor;
    return AppColorHelper().warningRedColor;
  }

  Widget lateTag(
    BillSummaryModel data,
  ) {
    final int lateDays = int.tryParse(
          data.lateDays.toString().split(" ").first,
        ) ??
        0;

    final lateDaysText = lateDays == 0 ? 'On Time' : '$lateDays Days Late';

    return Positioned(
      right: 16,
      top: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: lateBgColor(lateDays),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5),
          ),
        ),
        child: Row(
          children: [
            Image.asset(
              Assets.icons.clockIcon.path,
              width: 11,
              height: 11,
              fit: BoxFit.contain,
              color: lateTextColor(lateDays),
            ),
            const SizedBox(width: 4),
            appText(lateDaysText,
                color: lateTextColor(lateDays),
                fontSize: 12,
                fontWeight: FontWeight.w500),
          ],
        ),
      ),
    );
  }

  Widget pendingBillInfoRow(BillSummaryModel data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(
            height: 60,
            child: Row(
              children: [
                Expanded(child: _infoColumn("Bill No", data.billNo ?? '')),
                Expanded(child: _infoColumn("Billed On", data.billDate ?? '')),
                Expanded(child: _infoColumn("Location", data.location ?? '')),
              ],
            ),
          ),
          SizedBox(
            height: 60,
            child: Row(
              children: [
                Expanded(
                    child:
                        _infoColumn("Trans Type", data.transactionType ?? '')),
                Expanded(
                    child:
                        _infoColumn("Committed On", data.committedDate ?? '')),
                Expanded(
                    child:
                        _infoColumn("Amount", indianCurrency(data.totalAmt))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget settledBillInfoRow(BillSummaryModel data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(
            height: 60,
            child: Row(
              children: [
                Expanded(child: _infoColumn("Bill No", data.billNo ?? '')),
                Expanded(child: _infoColumn("Billed On", data.billDate ?? '')),
                Expanded(child: _infoColumn("Location", data.location ?? '')),
              ],
            ),
          ),
          SizedBox(
            height: 60,
            child: Row(
              children: [
                Expanded(
                    child:
                        _infoColumn("Trans Type", data.transactionType ?? '')),
                Expanded(
                    child: _infoColumn("Settled On", data.settledDate ?? '')),
                Expanded(
                    child:
                        _infoColumn("Amount", indianCurrency(data.totalAmt))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appText(title,
            fontSize: 13,
            color: AppColorHelper().primaryTextColor.withAlpha(140),
            fontWeight: FontWeight.w400),
        // height(1),
        appText(value,
            fontSize: 13,
            color: AppColorHelper().primaryTextColor,
            fontWeight: FontWeight.w500),
      ],
    );
  }

  static String indianCurrency(dynamic value, {int decimal = 2}) {
    final amount = double.tryParse(value.toString()) ?? 0;

    return NumberFormat.currency(
      locale: 'en_IN',
      symbol: '',
      decimalDigits: decimal,
    ).format(amount);
  }

  Widget invoiceSummary(BillSummaryModel data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: DottedBorder(
        borderType: BorderType.RRect,
        color: AppColorHelper().infoBorderYellow,
        radius: const Radius.circular(12),
        dashPattern: const [3, 3],
        strokeWidth: 0.5,
        padding: EdgeInsets.zero, // 👈 remove internal gap
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColorHelper().infoBackgroundYellow.withOpacity(0.1),
          ),
          child: Row(
            children: [
              Expanded(
                child: _invoiceSummaryItem("No. of Items", data.noOfItems ?? '',
                    iconPath: Assets.icons.shoppingcart.path),
              ),
              Expanded(
                child: _invoiceSummaryItem(
                    "No. of Packets", data.noOfPackets ?? '',
                    iconPath: Assets.icons.cartonbox.path),
              ),
              Expanded(
                child: _invoiceSummaryItem("Total Weight", data.totQty ?? '',
                    iconPath: Assets.icons.weighscale.path),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _invoiceSummaryItem(
    String title,
    String value, {
    required String iconPath,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appText(
          title,
          fontSize: 12,
          color: AppColorHelper().primaryTextColor.withAlpha(160),
          fontWeight: FontWeight.w400,
        ),
        height(4),
        Row(
          children: [
            Image.asset(
              iconPath,
              width: 17,
              height: 17,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 6),
            appText(
              value,
              fontSize: 13,
              color: AppColorHelper().primaryTextColor,
              fontWeight: FontWeight.w400,
            ),
          ],
        )
      ],
    );
  }

  Widget billDetailsSheet(BillSummaryModel data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: appText(
                    "Product Details",
                    fontSize: 14,
                    color: AppColorHelper().primaryTextColor.withAlpha(120),
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                appText(
                  "Amount",
                  fontSize: 14,
                  color: AppColorHelper().primaryTextColor.withAlpha(120),
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                ),
              ],
            ),
            height(12),

            ...List.generate(
              data.productDetailsListDtls!.length,
              (index) {
                final e = data.productDetailsListDtls![index];

                return Column(
                  children: [
                    _productLine(
                      code: e.bundleBarcode ?? '',
                      subtitle:
                          "${e.noOfPkts} Packets - ${e.qty} • ${e.productName}",
                      amount: e.prodTotalAmt ?? '',
                    ),

                    // dashed line after each row except the last
                    if (index != data.productDetailsListDtls!.length - 1) ...[
                      height(6),
                      fullWidthDashedLine(),
                      height(6),
                    ],
                  ],
                );
              },
            ),

            height(12),
            fullWidthDashedLine(color: AppColorHelper().primaryColor),

            height(12),
            _amountRow("Gross Amount", data.grossAmount ?? ''),
            _amountRow("Discount Amount", data.discountAmt ?? ''),
            _amountRow("Net Amount", data.netAmt ?? ''),
            _amountRow("Tax Amount", data.taxAmt ?? ''),
            _amountRow("Round Off", data.roundOff ?? ''),

            height(8),
            fullWidthDashedLine(),

            _amountRow(
              "Total Amount",
              data.totalAmt ?? '',
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _productLine({
    required String code,
    required String subtitle,
    required String amount,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First line: barcode only
          appText(
            code,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColorHelper().primaryTextColor,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 2),

          // Second line: product info + amount in the SAME ROW
          Row(
            children: [
              Expanded(
                child: appText(
                  subtitle,
                  fontSize: 14,
                  color: AppColorHelper().primaryTextColor.withAlpha(140),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              appText(
                amount,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColorHelper().primaryTextColor,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _amountRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: appText(
              label,
              fontSize: isBold ? 16 : 13,
              fontStyle: isBold ? FontStyle.normal : FontStyle.italic,
              color: isBold
                  ? AppColorHelper().primaryTextColor
                  : AppColorHelper().primaryTextColor.withAlpha(150),
              fontWeight: isBold ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
          appText(
            value,
            fontSize: isBold ? 16 : 13,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: AppColorHelper().primaryTextColor,
          ),
        ],
      ),
    );
  }

  Widget fullWidthDashedLine({Color? color}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return dashedLine(constraints.maxWidth,
            inset: false, // edge-to-edge
            dashcolor: color);
      },
    );
  }
}
