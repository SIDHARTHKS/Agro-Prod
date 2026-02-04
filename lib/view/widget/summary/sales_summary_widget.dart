import 'package:agro/helper/color_helper.dart';
import 'package:agro/helper/sizer.dart';
import 'package:flutter/material.dart';
import '../../widget/common_widget.dart';
import 'package:get/get.dart';

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
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.fromLTRB(18, 30, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            spreadRadius: 2,
            color: AppColorHelper().boxShadowColor.withValues(alpha: 0.08),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // MAIN CONTENT
          Column(
            children: [
              height(40),
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
              height(30),
              Flexible(child: LayoutBuilder(builder: (context, constraints) {
                return dashedLine(constraints.biggest.width);
              })),
              height(30),
              _infoRow(
                icon: Icons.bar_chart,
                title: "Total No. of Sales",
                value: totalSales,
              ),
              height(10),
              _infoRow(
                icon: Icons.monitor_weight_outlined,
                title: "Total Weight",
                value: totalWeight,
              ),
              height(10),
              _infoRow(
                icon: Icons.inventory_2_outlined,
                title: "Total Bills",
                value: totalBills,
              ),
            ],
          ),

          // 🔥 CENTERED LOCATION TAG
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: Transform.translate(
                offset: const Offset(0, -30), // controls overlap
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    location,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          // LEFT SIDE — takes remaining space
          Expanded(
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.green, size: 18),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // RIGHT SIDE — pinned to extreme right
          Text(
            value,
            textAlign: TextAlign.right,
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
