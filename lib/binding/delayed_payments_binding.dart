import 'package:agro/controller/delayed_payment_controller.dart';
import 'package:get/get.dart';
import 'package:getx_base_classes/getx_base_classes.dart';
import '../service/delayed_payment_service.dart';

class DelayedPaymentBinding extends BaseBinding {
  const DelayedPaymentBinding();

  @override
  void injectDependencies() {
    /// Controller
    Get.lazyPut<DelayedPaymentController>(
      () => DelayedPaymentController(),
      fenix: true,
    );

    /// Service (API layer)
    Get.lazyPut<DelayedPaymentService>(
      () => DelayedPaymentService(),
      fenix: true,
    );
  }
}
