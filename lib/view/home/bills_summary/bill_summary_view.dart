import 'package:agro/controller/bill_summary_controller.dart';
import 'package:agro/gen/assets.gen.dart';
import 'package:agro/helper/core/base/app_base_view.dart';
import 'package:agro/view/home/bills_summary/widgets/bills_summary_shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../helper/color_helper.dart';
import '../../widget/common_widget.dart';
import '../../../helper/sizer.dart';
import 'package:agro/model/bill_summary_model.dart';
import 'package:url_launcher/url_launcher.dart';

class BillSummaryView extends AppBaseView<BillSummaryController> {
  const BillSummaryView({super.key});

  @override
  Widget buildView() {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: customAppBar("Bills Summary"),
      body: Stack(
        children: [
          // 🔹 Background for both AppBar + Body
          Positioned.fill(
            child: Image.asset(
              Assets.images.loginBg.path,
              fit: BoxFit.cover,
            ),
          ),

          // 🔹 Content that starts *below* AppBar
          Column(
            children: [
              SizedBox(
                  height: kToolbarHeight +
                      MediaQuery.of(Get.context!).padding.top +
                      15),
              Expanded(child: _buildBody()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      final data = controller.billSummary.value;

      if (data == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return SingleChildScrollView(
        child: Column(
          children: [
            controller.isSettled.value
                ? _settledBillCard(data)
                : _pendingBillCard(data),
            height(20),
            BillsSummarySharedWidgets().heading("Invoice Details"),
            height(20),
            BillsSummarySharedWidgets().invoiceSummary(data),
            height(30),
            BillsSummarySharedWidgets().billDetailsSheet(data),
            height(40),
          ],
        ),
      );
    });
  }

  Widget _pendingBillCard(BillSummaryModel data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 8),
            height: 320,
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

                /// 👇 Tap only on header

                BillsSummarySharedWidgets().cardHeader(data, true),

                BillsSummarySharedWidgets().addressInfoRow(data),

                height(9),
                _phoneTag(data),
                height(9),
                BillsSummarySharedWidgets().pendingBillInfoRow(data),
                // _billDateRow(data),
                height(9),
                __reminderButton(),
              ],
            ),
          ),
          BillsSummarySharedWidgets().lateTag(data),
        ],
      ),
    );
  }

  Widget _settledBillCard(BillSummaryModel data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 8),
            height: 221,
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
                //height(5),

                /// 👇 Tap only on header

                BillsSummarySharedWidgets().cardHeader(data, true),

                BillsSummarySharedWidgets().addressInfoRow(data),
                height(18),
                Flexible(child: LayoutBuilder(builder: (context, constraints) {
                  return BillsSummarySharedWidgets()
                      .dashedLine(constraints.biggest.width);
                })),
                height(15),

                BillsSummarySharedWidgets().settledBillInfoRow(data),
                // _billDateRow(data),
                // height(9),
              ],
            ),
          ),
          BillsSummarySharedWidgets().lateTag(data),
        ],
      ),
    );
  }

  Widget _phoneTag(BillSummaryModel data) {
    const double boxHeight = 50;
    const double buttonSize = 50;

    return SizedBox(
      height: 60,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.only(right: buttonSize / 2),
                  color: AppColorHelper().secondaryBackgroundColor,
                  child: Row(
                    children: [
                      appText(
                        "Contact Number : ",
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color:
                            AppColorHelper().primaryTextColor.withOpacity(0.6),
                      ),
                      appText(
                        data.phoneNo ?? '',
                        fontSize: 13,
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

                  if (phoneRaw == null || phoneRaw.trim().isEmpty) return;

                  final Uri uri = Uri(scheme: 'tel', path: phoneRaw.trim());

                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    debugPrint('Could not launch dialer');
                  }
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
            appText("Send Reminder"),
            leadingIcon: Image.asset(
              Assets.icons.bell.path,
              width: 14,
              height: 14,
            ),
            radius: 12));
  }
}
