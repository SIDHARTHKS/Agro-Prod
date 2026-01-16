import 'package:get/get.dart';
import 'package:getx_base_classes/getx_base_classes.dart';
import '../controller/splash_controller.dart';
import '../service/auth_service.dart';

class SplashBinding extends BaseBinding {
  const SplashBinding();

  @override
  void injectDependencies() {
    Get.lazyPut<SplashController>(() => SplashController(), fenix: true);
    Get.lazyPut<AuthService>(() => AuthService(), fenix: true);
  }
}
