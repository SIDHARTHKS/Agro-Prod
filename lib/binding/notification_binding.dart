import 'package:get/get.dart';
import 'package:getx_base_classes/getx_base_classes.dart';
import '../controller/home_controller.dart';
import '../service/notification_services.dart';

class NotificationBinding extends BaseBinding {
  const NotificationBinding();
  @override
  void injectDependencies() {
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);

    Get.lazyPut<NotificationServices>(() => NotificationServices(),
        fenix: true);
  }
}
