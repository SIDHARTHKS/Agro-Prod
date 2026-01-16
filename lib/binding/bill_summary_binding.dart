import 'package:agro/controller/bill_summary_controller.dart';
import 'package:get/get.dart';
import 'package:getx_base_classes/getx_base_classes.dart';
import '../service/bill_summary_service.dart';

class BillSummaryBinding extends BaseBinding {
  const BillSummaryBinding();

  @override
  void injectDependencies() {
    /// Controller
    Get.lazyPut<BillSummaryController>(
      () => BillSummaryController(),
      fenix: true,
    );

    /// Service (API layer)
    Get.lazyPut<BillSummaryService>(
      () => BillSummaryService(),
      fenix: true,
    );
  }
}
