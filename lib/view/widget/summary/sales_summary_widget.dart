import 'package:agro/helper/color_helper.dart';
import 'package:agro/helper/sizer.dart';
import 'package:flutter/material.dart';

class SalesSummaryWidget extends StatelessWidget {
  final String location;
  final String salesAmount;
  final String totalSales;
  final String totalWeight;
  final String totalBills;

  const SalesSummaryWidget({
    super.key,
    required this.location,
    required this.salesAmount,
    required this.totalSales,
    required this.totalWeight,
    required this.totalBills,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            spreadRadius: 2,
            color: AppColorHelper().boxShadowColor.withValues(alpha: 0.08),
          )
        ],
      ),
      child: Column(
        children: [
          // ✅ Location Tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              location,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ✅ Overall Sales
          const Text(
            "Overall Sales",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),

          height(4),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                salesAmount,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.arrow_upward, color: Colors.green, size: 18),
            ],
          ),

          height(10),

          Divider(color: Colors.grey.withOpacity(0.3)),

          height(8),

          // ✅ Stats Rows
          _infoRow(
            icon: Icons.bar_chart,
            title: "Total No. of Sales",
            value: totalSales,
          ),
          _infoRow(
            icon: Icons.monitor_weight_outlined,
            title: "Total Weight",
            value: totalWeight,
          ),
          _infoRow(
            icon: Icons.inventory_2_outlined,
            title: "Total Bills",
            value: totalBills,
          ),
        ],
      ),
    );
  }

  // ✅ FIXED Row Widget
  Widget _infoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min, // ✅ Important fix
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.green),
          ),

          const SizedBox(width: 14),

          // ✅ FIX: Flexible instead of Expanded
          Flexible(
            fit: FlexFit.loose,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(width: 10),

          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
