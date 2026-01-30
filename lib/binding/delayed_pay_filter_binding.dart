import 'package:agro/controller/delayed_pay_filter_controller.dart';
import 'package:get/get.dart';
import 'package:getx_base_classes/getx_base_classes.dart';

class DelayedPayFilterBinding extends BaseBinding {
  const DelayedPayFilterBinding();

  @override
  void injectDependencies() {
    /// Controller
    Get.lazyPut<DelayedPayFilterController>(
      () => DelayedPayFilterController(),
      fenix: true,
    );
  }
}
