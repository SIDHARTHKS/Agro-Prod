import 'package:agro/helper/app_message.dart';
import 'package:flutter/material.dart';

class Util {
  static bool isStringNullOrEmpty(String? value) {
    return value == null || value.isEmpty;
  }

  static bool isNavigationBarVisible(BuildContext context) {
    double gap = MediaQuery.of(context).padding.bottom;
    appLog('isNavigationBarVisible gap: $gap');
    return gap > 28;
  }

  static Map<String, List<String>> getFinancialYears(
    DateTime startDate,
    DateTime latestProcessedDate,
  ) {
    List<String> allMonths = [
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
      'Jan',
      'Feb',
      'Mar'
    ];

    Map<String, List<String>> financialYears = {};

    DateTime now = DateTime.now();

    int currentMonth = now.month;
    int currentYear = now.year;

    // Decide anchor month (last included month in list)
    int anchorMonth;
    int anchorYear = currentYear;

    if (latestProcessedDate.month == (currentMonth - 1) &&
        latestProcessedDate.year == currentYear) {
      // Salary credited → generate till currentMonth - 1
      anchorMonth = currentMonth;
    } else {
      // Salary not credited → generate till currentMonth - 2
      anchorMonth = currentMonth - 2;
    }

    // Handle underflow (month <= 0 → wrap to previous year)
    if (anchorMonth <= 0) {
      anchorMonth += 12;
      anchorYear -= 1;
    }

    // Generate last six months ending at anchorMonth
    List<DateTime> lastSixMonths = List.generate(6, (i) {
      int month = anchorMonth - 5 + i;
      int year = anchorYear;
      if (month <= 0) {
        month += 12;
        year -= 1;
      }
      return DateTime(year, month, 1);
    });

    // Map months into financial years
    for (var date in lastSixMonths) {
      int fyStartYear = date.month >= 4 ? date.year : date.year - 1;
      int fyEndYear = fyStartYear + 1;
      String fyKey = "$fyStartYear-$fyEndYear";

      String monthStr = allMonths[(date.month - 4 + 12) % 12]; // Apr=0, Mar=11

      financialYears.putIfAbsent(fyKey, () => []);
      financialYears[fyKey]!.add(monthStr);
    }

    return financialYears;
  }
}
