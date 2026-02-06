import 'package:get/get.dart';

enum SalesRange {
  week,
  month,
  year,
}

class SalesTrendController extends GetxController {
  final Rx<SalesRange> range = SalesRange.year.obs;

  void changeRange(SalesRange? value) {
    if (value != null) range.value = value;
  }

  bool get isScrollable => range.value == SalesRange.year;
}
