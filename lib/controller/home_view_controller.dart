import 'package:get/get.dart';
import '../helper/core/base/app_base_controller.dart';
import '../model/home_view_model.dart';

class HomeViewController extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  // existing
  RxInt currentIndex = 0.obs;
  RxInt rxCurrentNavBarIndex = 0.obs;

  // 🔥 NEW: home screen data (ONE object)
  late HomeViewModel homeData;

  @override
  void onInit() {
    super.onInit();
    _loadDummyData(); // simulate API
  }

  // STEP 2.1 — Dummy data (this will become API later)
  void _loadDummyData() {
    homeData = HomeViewModel(
      totalSalesDetails: TotalSalesDetails(
        totalAmt: 1226300,
        totalQty: 1800,
        totalBills: 276,
        totalCustomers: 30,
      ),
      salesDepotOverview: [
        SalesDepotOverview(
          location: "Kochi",
          noOfSales: 527,
          totalQty: 1800,
          totalBills: 276,
        ),
        SalesDepotOverview(
          location: "Vandiperiyar",
          noOfSales: 789,
          totalQty: 3420,
          totalBills: 498,
        ),
        SalesDepotOverview(
          location: "Trivandrum",
          noOfSales: 412,
          totalQty: 1250,
          totalBills: 198,
        ),
      ],
      delayedPayDetails: [
        DelayedPayDetails(
          location: "Kochi",
          amount: 526300,
          totalCustomers: 15,
          lessThan50Days: 5,
          moreThan50Days: 10,
        ),
        DelayedPayDetails(
          location: "Vandiperiyar",
          amount: 710800,
          totalCustomers: 22,
          lessThan50Days: 9,
          moreThan50Days: 13,
        ),
        DelayedPayDetails(
          location: "Trivandrum",
          amount: 340500,
          totalCustomers: 8,
          lessThan50Days: 3,
          moreThan50Days: 5,
        ),
      ],
      salesTrendGraph: [
        SalesTrendGraph(
          location: "Kochi",
          weekly: [5, 22, 15, 30, 17, 45, 38],
          monthly: [120, 180, 150, 220],
          yearly: [80, 95, 70, 85, 90, 110, 105, 120, 115, 130, 125, 140],
        ),
        SalesTrendGraph(
          location: "Vandiperiyar",
          weekly: [8, 12, 10, 18, 14, 20, 25],
          monthly: [100, 140, 130, 190],
          yearly: [60, 70, 65, 72, 78, 90, 88, 95, 98, 102, 110, 115],
        ),
        SalesTrendGraph(
          location: "Trivandrum",
          weekly: [4, 8, 6, 12, 10, 15, 18],
          monthly: [90, 110, 105, 130],
          yearly: [55, 60, 58, 65, 70, 75, 78, 82, 85, 88, 92, 95],
        ),
      ],
    );
  }

  // 🔥 STEP 2.2 — selected data (VERY IMPORTANT)

  SalesDepotOverview get selectedDepot =>
      homeData.salesDepotOverview[currentIndex.value];

  DelayedPayDetails get selectedDelayedPay =>
      homeData.delayedPayDetails[currentIndex.value];

  SalesTrendGraph get selectedSalesTrend =>
      homeData.salesTrendGraph[currentIndex.value];

  // existing
  void nextCard(int totalCards) {
    currentIndex.value = (currentIndex.value + 1) % totalCards;
  }
}
