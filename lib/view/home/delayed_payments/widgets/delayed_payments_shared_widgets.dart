import 'package:agro/gen/assets.gen.dart';
import 'package:agro/view/widget/searchbar/custom_searchbar.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter/material.dart';
import '../../../../helper/color_helper.dart';
import 'package:agro/model/delayed_payments_model.dart';
import 'package:intl/intl.dart';
import '../../../../helper/sizer.dart';
import '../../../widget/common_widget.dart';
import '../../../../binding/delayed_pay_filter_binding.dart';
import 'package:get/get.dart';
import '../widgets/delayed_pay_filter_view.dart';

class DelayedPaymentSharedWidgets {
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
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: appText(
              title,
              fontSize: 14,
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

  Widget dashedLine(double maxWidth) {
    const horizontalPadding = 20.0;

    final usableWidth = maxWidth - (horizontalPadding * 2);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Dash(
        direction: Axis.horizontal,
        length: usableWidth > 0 ? usableWidth : 0,
        dashLength: 3,
        dashColor: AppColorHelper().primaryTextColor.withAlpha(30),
      ),
    );
  }

  Widget searchBar(TextEditingController controller) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          height: 45,
          child: CustomSearchBar(
            controller: controller,
            hintText: "Search for cust-omers, locations, bills",
            onFilterTap: () {
              const DelayedPayFilterBinding().injectDependencies();

              Get.bottomSheet(
                const DelayedPayFilterView(),
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
              );
            },
          ),
        ));
  }

  Widget billInfoRow(DelayedPayListDtl data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Bill No
                appText(data.billNo ?? '',
                    color: AppColorHelper().primaryTextColor.withAlpha(128),
                    overflow: TextOverflow.ellipsis,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),

                width(6),

                appText(
                  "•",
                  fontSize: 18, // bigger dot
                  fontWeight: FontWeight.bold,
                  color: AppColorHelper().primaryTextColor.withAlpha(150),
                ),

                width(6),

                /// Location
                Expanded(
                  child: appText(data.location ?? '',
                      color: AppColorHelper().primaryTextColor.withAlpha(128),
                      overflow: TextOverflow.ellipsis,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),

          /// Amount row
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Rupee icon
              Image.asset(
                Assets.icons.rupee.path,
                width: 12,
                height: 12,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 4),

              /// Amount
              appText(
                DelayedPaymentSharedWidgets.indianCurrency(data.billAmt ?? '0'),
                color: AppColorHelper().primaryTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget cardHeader(DelayedPayListDtl data, bool pending) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: SizedBox(
        height: 28,
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 20.0, right: 20.0),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  // this limits how far the name can grow
                  padding: const EdgeInsets.only(right: 120),
                  child: Row(
                    children: [
                      Flexible(
                        child: appText(
                          data.custName ?? '',
                          color: AppColorHelper().primaryTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (pending) ...[
                        const SizedBox(width: 6),
                        Image.asset(
                          Assets.icons.arrowright.path,
                          width: 12,
                          height: 12,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ],
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
    DelayedPayListDtl data,
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
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
            width(4),
            appText(lateDaysText,
                color: lateTextColor(lateDays),
                fontSize: 10,
                fontWeight: FontWeight.w500),
          ],
        ),
      ),
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
}
