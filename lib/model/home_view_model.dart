class HomeViewModel {
  final TotalSalesDetails totalSalesDetails;
  final List<SalesDepotOverview> salesDepotOverview;
  final List<DelayedPayDetails> delayedPayDetails;
  final List<SalesTrendGraph> salesTrendGraph;

  HomeViewModel({
    required this.totalSalesDetails,
    required this.salesDepotOverview,
    required this.delayedPayDetails,
    required this.salesTrendGraph,
  });
}

class TotalSalesDetails {
  final double totalAmt;
  final int totalQty;
  final int totalBills;
  final int totalCustomers;

  TotalSalesDetails({
    required this.totalAmt,
    required this.totalQty,
    required this.totalBills,
    required this.totalCustomers,
  });
}

class SalesDepotOverview {
  final String location;
  final int noOfSales;
  final double totalQty;
  final int totalBills;

  SalesDepotOverview({
    required this.location,
    required this.noOfSales,
    required this.totalQty,
    required this.totalBills,
  });
}

class DelayedPayDetails {
  final String location;
  final double amount;
  final int totalCustomers;
  final int lessThan50Days;
  final int moreThan50Days;

  DelayedPayDetails({
    required this.location,
    required this.amount,
    required this.totalCustomers,
    required this.lessThan50Days,
    required this.moreThan50Days,
  });
}

class SalesTrendGraph {
  final String location;
  final List<double> weekly;
  final List<double> monthly;
  final List<double> yearly;

  SalesTrendGraph({
    required this.location,
    required this.weekly,
    required this.monthly,
    required this.yearly,
  });
}
