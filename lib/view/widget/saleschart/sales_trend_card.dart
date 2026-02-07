import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import '../../../controller/sales_trend_controller.dart';

class SalesTrendCard extends StatelessWidget {
  final String location;
  final List<double> weekly;
  final List<double> monthly;
  final List<double> yearly;
  final ScrollController _scrollController = ScrollController();

  SalesTrendCard({
    super.key,
    required this.location,
    required this.weekly,
    required this.monthly,
    required this.yearly,
  });

  static const double _pointSpacing = 60;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SalesTrendController());

    return Obx(() {
      final values = _values(controller);
      final labels = _xLabels(controller);
      final maxY = _maxY(values);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(controller),
          const SizedBox(height: 12),
          _graphContainer(
            controller: controller,
            values: values,
            labels: labels,
            maxY: maxY,
          ),
        ],
      );
    });
  }

  // ---------- HEADER ----------

  Widget _header(SalesTrendController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Sales Trend – $location",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        DropdownButton<SalesRange>(
          value: controller.range.value,
          underline: const SizedBox(),
          items: const [
            DropdownMenuItem(value: SalesRange.week, child: Text("This week")),
            DropdownMenuItem(
                value: SalesRange.month, child: Text("This month")),
            DropdownMenuItem(value: SalesRange.year, child: Text("This year")),
          ],
          onChanged: controller.changeRange,
        ),
      ],
    );
  }

  // ---------- GRAPH CONTAINER ----------

  Widget _graphContainer({
    required SalesTrendController controller,
    required List<double> values,
    required List<String> labels,
    required double maxY,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fixedYAxis(maxY), // ✅ fixed
          const SizedBox(width: 8),
          Expanded(
            // ✅ viewport
            child: _scrollableChart(
              controller: controller,
              values: values,
              labels: labels,
              maxY: maxY,
            ),
          ),
        ],
      ),
    );
  }

  // ---------- FIXED Y AXIS ----------

  Widget _fixedYAxis(double maxY) {
    return SizedBox(
      width: 48,
      height: 220,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: maxY,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          extraLinesData: const ExtraLinesData(extraLinesOnTop: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false, reservedSize: 0),
            ),
            bottomTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false, reservedSize: 0),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false, reservedSize: 0),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 48,
                interval: maxY / 4,
                getTitlesWidget: (value, _) {
                  if (value == 0) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(
                      value >= 1000
                          ? "₹${value ~/ 1000}k"
                          : "₹${value.toInt()}",
                      style: const TextStyle(fontSize: 11),
                      textAlign: TextAlign.right,
                    ),
                  );
                },
              ),
            ),
          ),
          lineBarsData: const [],
        ),
      ),
    );
  }

  // ---------- SCROLLABLE CHART ----------

  Widget _scrollableChart({
    required SalesTrendController controller,
    required List<double> values,
    required List<String> labels,
    required double maxY,
  }) {
    final double minWidth = Get.width - 80; // viewport minus Y-axis & padding

    final double chartWidth = controller.range.value == SalesRange.year
        ? labels.length * _pointSpacing
        : minWidth; // 🔥 stretch week & month

    if (controller.range.value == SalesRange.year) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(
            _scrollController.position.maxScrollExtent,
          );
        }
      });
    }

    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: controller.isScrollable
          ? const BouncingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      child: SizedBox(
        width: chartWidth, // ✅ finite, always
        height: 220,
        child: LineChart(
          LineChartData(
            minX: -0.3,
            maxX: labels.length - 1 + 0.3,
            minY: 0,
            maxY: maxY,
            gridData: const FlGridData(
              show: true,
              drawVerticalLine: false,
            ),
            titlesData: FlTitlesData(
              leftTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 22,
                  getTitlesWidget: (value, _) {
                    // 🔥 Only show labels for whole numbers
                    if (value % 1 != 0) {
                      return const SizedBox.shrink();
                    }

                    final i = value.toInt();

                    if (i < 0 || i >= labels.length) {
                      return const SizedBox.shrink();
                    }

                    return SizedBox(
                      width: _pointSpacing,
                      child: Center(
                        child: Text(
                          labels[i],
                          style: const TextStyle(fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                isCurved: true,
                barWidth: 3,
                dotData: const FlDotData(show: true),
                spots: List.generate(
                  values.length,
                  (i) => FlSpot(i.toDouble(), values[i]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- DATA HELPERS ----------

  List<double> _values(SalesTrendController c) {
    switch (c.range.value) {
      case SalesRange.week:
        return weekly;
      case SalesRange.month:
        return monthly;
      case SalesRange.year:
        return yearly;
    }
  }

  List<String> _xLabels(SalesTrendController c) {
    switch (c.range.value) {
      case SalesRange.week:
        return _currentWeekLabels();
      case SalesRange.month:
        return ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
      case SalesRange.year:
        return _lastMonths(12);
    }
  }

  double _maxY(List<double> values) {
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    return maxValue * 1.15;
  }

  // ---------- LABEL HELPERS ----------

  List<String> _currentWeekLabels() {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final d = now.subtract(Duration(days: now.weekday - 1 - i));
      return "${d.day}/${d.month}";
    });
  }

  List<String> _lastMonths(int count) {
    final now = DateTime.now();
    return List.generate(count, (i) {
      final d = DateTime(now.year, now.month - (count - 1 - i));
      return _monthName(d.month);
    });
  }

  String _monthName(int m) => const [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ][m - 1];
}
