import 'package:agro/controller/home_controller.dart';
import 'package:agro/helper/app_message.dart';
import 'package:agro/helper/app_string.dart';
import 'package:agro/helper/color_helper.dart';
import 'package:agro/helper/core/base/app_base_view.dart';
import 'package:agro/helper/sizer.dart';
import 'package:agro/view/widget/summary/sales_summary_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked_animated_list/ui/stacked_list_widget.dart';
import '../../widget/common_widget.dart';
import 'package:agro/gen/assets.gen.dart';

class HomeView extends AppBaseView<HomeController> {
  HomeView({super.key});

  @override
  Widget buildView() => _buildScaffold();

  final List<Map<String, String>> salesData = [
    {
      "id": "kochi",
      "location": "Kochi",
      "salesAmount": "₹ 12,26,300.00",
      "totalSales": "527",
      "totalWeight": "1,800 Kg",
      "totalBills": "276",
    },
    {
      "id": "vandiperiyar",
      "location": "Vanddiperiyar",
      "salesAmount": "₹ 17,52,350.00",
      "totalSales": "789",
      "totalWeight": "3,420 Kg",
      "totalBills": "498",
    },
    {
      "id": "trivandrum",
      "location": "Trivandrum",
      "salesAmount": "₹ 9,80,120.00",
      "totalSales": "412",
      "totalWeight": "1,250 Kg",
      "totalBills": "198",
    },
  ];

  Scaffold _buildScaffold() => appScaffold(
        bgcolor: AppColorHelper().backgroundColor.withValues(alpha: 0.2),
        canpop: true,
        extendBodyBehindAppBar: false,
        resizeToAvoidBottomInset: false,
        topSafe: true,
        body: Obx(() {
          return _buildBody();
        }),
      );

  List<Widget> _getRotatedCards() {
    final index = controller.currentIndex.value;

    appLog("Rotating cards → index: $index");

    final rotated = [
      ...salesData.sublist(index),
      ...salesData.sublist(0, index),
    ];

    return rotated.map((e) {
      return SalesSummaryWidget(
        key: ValueKey(e["id"]),
        location: e["location"]!,
        salesAmount: e["salesAmount"]!,
        totalSales: e["totalSales"]!,
        totalWeight: e["totalWeight"]!,
        totalBills: e["totalBills"]!,
      );
    }).toList();
  }

  Widget _buildBody() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20), // 🔥 overflow killer
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              height(50),

              salesSummaryCard(
                amount: "₹ 12,26,300.00",
                weight: "200 Kg",
                bills: "50",
                customers: "30",
              ),

              height(20),

              // ✅ Title
              appText(
                salesDepotOverview.tr,
                color: AppColorHelper().primaryTextColor,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),

              height(20),

              // ✅ Stacked Card Widget (fixed height = safe)
              SizedBox(
                height: 420,
                width: double.infinity,
                child: Obx(() {
                  return StackedListWidget(
                    key: ValueKey(controller.currentIndex.value),
                    listItems: _getRotatedCards(),
                    listItemWidth: Get.width,
                    animationDuration: const Duration(milliseconds: 450),
                    borderRadius: BorderRadius.circular(18),
                    rotationAngle: 0,
                    additionalTranslateOffsetBeyondScreen: 0.25,
                    longPressDelay: 200,
                    onCenterCardClick: (index) {
                      appLog("Tapped Cards: $index");
                      controller.nextCard(salesData.length);
                    },
                  );
                }),
              ),

              height(20),

              delayedPaymentsSummary(
                amount: "₹ 5,26,300.00",
                noOfCustomers: "15",
              ),

              height(10),
            ],
          ),
        ),
      ),
    );
  }

  Widget salesSummaryCard({
    required String amount,
    required String weight,
    required String bills,
    required String customers,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 🔲 ICON BOX
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: SizedBox(
                height: 40, // 🔥 control icon size here
                width: 40,
                child: Image.asset(
                  Assets.icons.salesSumIcon.path,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          const SizedBox(width: 20),

          // 📊 CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Total Sales",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      amount,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_upward,
                      size: 18,
                      color: Colors.green,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  "$weight Kg  |  $bills Bills  |  $customers Customers",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget delayedPaymentsSummary({
    required String amount,
    required String noOfCustomers,
  }) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 📊 CONTENT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "OutStanding Amount",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        amount,
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "$noOfCustomers Customers with pending dues",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                // 🔲 ICON BOX
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: AppColorHelper().primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: SizedBox(
                      height: 20, // 🔥 control icon size here
                      width: 20,
                      child: Image.asset(
                        Assets.icons.bell.path,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            height(20),
            LayoutBuilder(builder: (context, constraints) {
              return dashedLine(constraints.biggest.width);
            }),
            height(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                            AppColorHelper().warningBackgroundYellow,
                        side: BorderSide(
                          color: AppColorHelper().warningBackgroundYellow,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: appText(
                        "Clear All Filters",
                        fontWeight: FontWeight.w500,
                        color: AppColorHelper().warningYellowColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                /// Apply Filters
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColorHelper().warningBackgroundRed,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: appText(
                        "Apply Filters",
                        fontWeight: FontWeight.w500,
                        color: AppColorHelper().warningRedColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
