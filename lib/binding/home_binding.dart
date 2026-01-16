import 'package:agro/controller/delayed_payment_controller.dart';
import 'package:get/get.dart';
import 'package:getx_base_classes/getx_base_classes.dart';
import '../controller/home_controller.dart';
import '../service/home_service.dart';
import '../service/notification_services.dart';
import '../service/delayed_payment_service.dart';

class HomeBinding extends BaseBinding {
  const HomeBinding();
  @override
  void injectDependencies() {
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<DelayedPaymentController>(() => DelayedPaymentController(),
        fenix: true);

    Get.lazyPut<HomeService>(() => HomeService(), fenix: true);
    Get.lazyPut<NotificationServices>(() => NotificationServices(),
        fenix: true);
    Get.lazyPut<DelayedPaymentService>(() => DelayedPaymentService(),
        fenix: true);
  }
}
