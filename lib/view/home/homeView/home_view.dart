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

class HomeView extends AppBaseView<HomeController> {
  HomeView({super.key});

  @override
  Widget buildView() => _buildScaffold();

  // ✅ Sample Cards List
  final List<Widget> sampleSalesCards = const [
    SalesSummaryWidget(
      location: "Kochi",
      salesAmount: "₹ 12,26,300.00",
      totalSales: "527",
      totalWeight: "1,800 Kg",
      totalBills: "276",
    ),
    SalesSummaryWidget(
      location: "Vanddiperiyar",
      salesAmount: "₹ 17,52,350.00",
      totalSales: "789",
      totalWeight: "3,420 Kg",
      totalBills: "498",
    ),
    SalesSummaryWidget(
      location: "Trivandrum",
      salesAmount: "₹ 9,80,120.00",
      totalSales: "412",
      totalWeight: "1,250 Kg",
      totalBills: "198",
    ),
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

  // ✅ Rotates list based on active card index
  List<Widget> _getRotatedCards() {
    final index = controller.currentIndex.value;

    return [
      ...sampleSalesCards.sublist(index),
      ...sampleSalesCards.sublist(0, index),
    ];
  }

  Widget _buildBody() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            height(50),

            // ✅ Title
            appText(
              salesDepotOverview.tr,
              color: AppColorHelper().primaryTextColor,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),

            height(50),

            // ✅ Stacked Card Widget
            SizedBox(
              height: 420,
              width: double.infinity,
              child: Obx(() {
                return StackedListWidget(
                  listItems: _getRotatedCards(),

                  // ✅ Card Size
                  listItemWidth: Get.width * 0.82,

                  // ✅ Smooth Animation
                  animationDuration: const Duration(milliseconds: 450),

                  // ✅ Rounded Corners
                  borderRadius: BorderRadius.circular(18),

                  // ✅ No rotation
                  rotationAngle: 0,

                  // ✅ Depth offset
                  additionalTranslateOffsetBeyondScreen: 0.25,

                  // ✅ Tap Delay
                  longPressDelay: 200,

                  // ✅ On Tap → Next Card
                  onCenterCardClick: (index) {
                    appLog("Tapped Card: $index");

                    controller.nextCard(sampleSalesCards.length);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
